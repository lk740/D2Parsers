# File: dofus.py
# description : a Scapy dissector for Dofus protocol
# Installation on Linux/Windows : copy the file into the scapy contrib folder
# Requirement : you need to have the protocol_scapy.json file
# Author : lk740

from scapy.compat import Optional, Tuple
from scapy.packet import Packet, bind_layers

from scapy.fields import (
    Field,
    BitField,
    BitEnumField,
    StrLenField,
    StrField,
    MultipleTypeField,
    PacketLenField,
    FieldListField,
    ShortField,
    FieldLenField,
    ByteEnumField,
    IntField,
    ByteField,
)

from scapy.layers.inet import TCP
from scapy.all import conf

import struct
import json

conf.debug_dissector = True

#############################################
#                                           #
#             Functions import              #
#                                           #
#############################################

DOFUS_FUNCTION_CODE = {}

with open( __file__[:-8] + "protocol_scapy.json", "r") as protofile:
    cache = json.load(protofile)
    for element in cache:
        # Format dict
        DOFUS_FUNCTION_CODE[int(element)] = cache[element] 
    protofile.close()


#############################################
#                                           #
#              Custom Fields                #
#                                           #
#############################################

class XStrLenField(StrLenField):

    def i2repr(self, pkt, x):
        ## type: (Optional[Packet], I) -> str
        """Convert internal value to a nice representation"""
        return self.str2int(StrLenField.i2m(self, pkt, x))

    def str2int(self, string):
        """Convert string value to integer"""
        return int.from_bytes(string, "big")

class XStrField(StrField):

    def i2repr(self, pkt, x):
        ## type: (Optional[Packet], I) -> str
        """Convert internal value to a nice representation"""
        return self.str2int(StrLenField.i2m(self, pkt, x))

    def str2int(self, string):
        """Convert string value to integer"""
        return int.from_bytes(string, "big")

class VariableFieldLenField(Field):
    __slots__ = ["length_of", "count_of", "adjust", "length_from"]
    
    def __init__(
            self,
            name,
            default,
            length_of=None,
            count_of=None,
            adjust=lambda pkt, x: x,
            length_from=None
    ):
        Field.__init__(self, name, default, fmt="B")
        self.length_of = length_of
        self.count_of = count_of
        self.adjust = adjust
        self.length_from = length_from

    def i2m(self, pkt: Packet, x: int) -> int:
        if x is None and pkt is not None:
            if self.length_of is not None:
                fld, fval = pkt.getfield_and_val(self.length_of)
                f = fld.i2len(pkt, fval)
            elif self.count_of is not None:
                fld, fval = pkt.getfield_and_val(self.count_of)
                f = fld.i2count(pkt, fval)
            else:
                raise ValueError(
                    "Field should have either length_of or count_of"
                )
            x = self.adjust(pkt, f)
        elif x is None:
            x = 0
        return x
    
    def i2repr(self, pkt: Packet, x:bytes) -> int:
        if x is not None:
            return int.from_bytes(x, "big")
        else:
            return super().i2repr(pkt, x)
    
    
    def addfield(self, pkt: Packet, s: bytes, val) -> bytes:
        len_pkt = self.length_from(pkt)
        t = self.i2m(pkt, val).to_bytes(len_pkt, "big")
        return s+struct.pack("%is"%len_pkt,t)

    def getfield(self, pkt: Packet, s: bytes):
        len_pkt = self.length_from(pkt)
        return s[len_pkt:], self.m2i(pkt,s[:len_pkt])
    

class readVarLong(Field):

    def __init__(self, name, default, sz):
        Field.__init__(self, name, default, ">" + str(sz) + "s")

    def i2repr(self, pkt, x):
        ans = 0
        pos = 0
        for i in range(0, 64, 7):
            b = int.from_bytes(x[pos:pos+1], "big")
            ans += (b & 0b01111111) << i
            if not b & 0b10000000:
                return ans
            pos += 1
        raise Exception("Too much data")

    def h2i(self, pkt, x):
        a=b''
        if x is not None:
            assert x.bit_length() <= 64
            while x:
                b = x & 0b01111111
                x >>= 7
                if x:
                    b |= 0b10000000
                a+= b.to_bytes(1, "big")
            return a
        return x

class readVarInt(Field):

    def __init__(self, name, default, sz):
        Field.__init__(self, name, default, ">" + str(sz) + "s")

    def i2repr(self, pkt, x):
        ans = 0
        pos = 0
        for i in range(0, 32, 7):
            b = int.from_bytes(x[pos:pos+1], "big")
            ans += (b & 0b01111111) << i
            if not b & 0b10000000:
                return ans
            pos += 1
        raise Exception("Too much data")
    
    def h2i(self, pkt, x):
        a=b''
        if x is not None:
            assert x.bit_length() <= 32
            while x:
                b = x & 0b01111111
                x >>= 7
                if x:
                    b |= 0b10000000
                a+= b.to_bytes(self.sz, "big")
            return a
        return x

class readVarShort(Field):

    def __init__(self, name, default, sz):
        self.sz = sz
        Field.__init__(self, name, default, ">" + str(sz) + "s")

    def i2repr(self, pkt, x):
        ans = 0
        pos = 0
        for i in range(0, 16, 7):
            b = int.from_bytes(x[pos:pos+1], "big", signed=True)
            ans += (b & 0b01111111) << i
            if not b & 0b10000000:
                return ans
            pos += 1
        raise Exception("Too much data")
    
    def h2i(self, pkt, x):
        a=b''
        if x is not None:
            assert x.bit_length() <= 16
            while x:
                b = x & 0b01111111
                x >>= 7
                if x:
                    b |= 0b10000000
                a+= b.to_bytes(self.sz, "big")
            return a
        return x
    
class readDouble(Field):
    def __init__(self, name, default):
        Field.__init__(self, name, default, "!d")



#############################################
#                                           #
#              Dofus Functions              #
#                                           #
#############################################

class KamasUpdateMessage(Packet):
    name = "KamasUpdateMessage"
    fields_desc = [
        readVarLong("kamasTotal", 1, 2)
    ]

class CharacterLevelUpMessage(Packet):
    name = "CharacterLevelUpMessage"
    fields_desc = [
        readVarShort("newLevel", None, 1)
    ]

class CharacterLevelUpInformationMessage(Packet):
    name = "CharacterLevelUpInformationMessage"
    fields_desc = [
        readVarShort("newLevel", None, 1),
        FieldLenField("lenName", None, length_of="Name"),
        StrLenField("Name", None, length_from=lambda pkt: pkt.lenName),
        readVarLong("CharacterId", None, 6)
    ]

class BasicAckMessage(Packet):
    name = "BasicAckMessage"
    fields_desc = [
        readVarInt("Seq", None, 1),
        readVarShort("lastPacketID", None,2)
    ]

class ProtocolRequired(Packet):
    name = "ProtocolRequired"
    fields_desc = [
        FieldLenField("lenVers", None, length_of="version"),
        StrLenField("version", None, length_from=lambda pkt: pkt.lenVers)
        ]
    
    # def post_build(self, pkt, pay):
    #     pkt += pay
    #     tmp_len = self.lenVers
    #     if tmp_len is None:
    #         pkt = struct.pack("!H", len(self.version) + pkt[2:])
    #         self.lenVers = len(self.version)
    #     return pkt

DOFUS_CHANNEL_TYPES = {
    0: "CHANNEL_GLOBAL",
    1: "CHANNEL_TEAM",
    2: "CHANNEL_GUILD",
    3: "CHANNEL_ALLIANCE",
    4: "CHANNEL_PARTY",
    5: "CHANNEL_SALED",
    6: "CHANNEL_SEEK",
    7: "CHANNEL_NOOB",
    8: "CHANNEL_ADMIN",
    9: "PSEUDO_CHANNEL_PRIVATE",
    10: "PSEUDO_CHANNEL_INFO",
    11: "PSEUDO_CHANNEl_FIGHT_LOG",
    12: "CHANNEL_ADS",
    13: "CHANNEL_ARENA",
    14: "CHANNEL_COMMUNITY"
}

class ChatClientMultiMessage(Packet):
    name = "ChatClientMultiMessage"
    fields_desc = [
        FieldLenField("content_len", None, length_of="content"),
        StrLenField("content", "", length_from=lambda pkt: pkt.content_len),
        ByteEnumField("channel", 0, DOFUS_CHANNEL_TYPES),
    ]

class ChangeMapMessage(Packet):
    name = "ChangeMapMessage"
    fields_desc = [
        readDouble("mapId", 0),
        ByteField("autopilot", 0),
    ]

class ExchangePlayerRequestMessage(Packet):
    name = "ExchangePlayerRequestMessage"
    fields_desc = [
        XStrField("target", 0),
    ]

class ExchangeKamaModifiedMessage(Packet):
    name = "ExchangeKamaModifiedMessage"
    fields_desc = [
        readVarLong("quantity", 0,2)
    ]

class ClientKeyMessage(Packet):
    name = "ClientKeyMessage"
    fields_desc = [
        FieldLenField("key_len", None, length_of="key"),
        StrLenField("key", "client_key", length_from=lambda pkt: pkt.key_len)
    ]

class SelectedServerDataMessage(Packet):
    name = "SelectedServerDataMessage"
    fields_desc = [
        readVarShort("serverID", 0, 2),
        FieldLenField("addr_len", None, length_of="address"),
        StrLenField("address", "dofus2-ga-hellmina.ankama-games.com", length_from=lambda pkt: pkt.addr_len),
        ShortField("nb_ports", 2),
        FieldListField("port_list", [], ShortField("port", 5555), count_from=lambda pkt: pkt.nb_ports), # Wrong Field. Should be readVarShort !
        ByteField("can_create_new_character", 1),
        ByteField("tickets_nb", 0),
        FieldListField("ticket", [], ByteField("ticket", 1), count_from=lambda pkt: pkt.tickets_nb)
    ]

#############################################
#                                           #
#              Request Header               #
#                                           #
#############################################
    
class DofusRequest(Packet):
    name = "Dofus - Request"
    fields_desc = [
        BitEnumField("protocolID", 8426, 14, DOFUS_FUNCTION_CODE),
        BitField("lengthType", 1, 2),
        IntField("sequenceID", 0),
        VariableFieldLenField("length", None, length_of="function", length_from=lambda pkt: pkt.lengthType),
        MultipleTypeField(
            [
                (
                    PacketLenField(
                        "function",
                        KamasUpdateMessage(),
                        KamasUpdateMessage,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "KamasUpdateMessage", 
                ),
                (
                    PacketLenField(
                        "function",
                        ChatClientMultiMessage(),
                        ChatClientMultiMessage,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "ChatClientMultiMessage", 
                ),
                (
                    PacketLenField(
                        "function",
                        ChangeMapMessage(),
                        ChangeMapMessage,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "ChangeMapMessage", 
                ),
                (
                    PacketLenField(
                        "function",
                        ExchangePlayerRequestMessage(),
                        ExchangePlayerRequestMessage,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "ExchangePlayerRequestMessage", 
                ),
                (
                    PacketLenField(
                        "function",
                        ClientKeyMessage(),
                        ClientKeyMessage,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "ClientKeyMessage", 
                ),
            ],
            StrLenField(
                "function", 
                "not implemented", 
                length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
            ),
        ),
    ]    

    
#############################################
#                                           #
#              Response Header              #
#                                           #
#############################################

class DofusResponse(Packet):
    name = "Dofus - Response"

    fields_desc = [
        BitEnumField("protocolID", 7461, 14, DOFUS_FUNCTION_CODE),
        BitField("lengthType", 1, 2),
        VariableFieldLenField("length", None, length_of="function", length_from=lambda pkt: pkt.lengthType),
        MultipleTypeField(
            [
                (
                    PacketLenField(
                        "function",
                        KamasUpdateMessage(),
                        KamasUpdateMessage,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "KamasUpdateMessage", 
                ),
                (
                    PacketLenField(
                        "function",
                        BasicAckMessage(),
                        BasicAckMessage,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "BasicAckMessage", 
                ),
                (
                    PacketLenField(
                        "function",
                        CharacterLevelUpMessage(),
                        CharacterLevelUpMessage,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "CharacterLevelUpMessage", 
                ),
                (
                    PacketLenField(
                        "function",
                        CharacterLevelUpInformationMessage(),
                        CharacterLevelUpInformationMessage,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "CharacterLevelUpInformationMessage", 
                ),
                (
                    PacketLenField(
                        "function",
                        ProtocolRequired(),
                        ProtocolRequired,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "ProtocolRequired", 
                ),
                (
                    PacketLenField(
                        "function",
                        ExchangeKamaModifiedMessage(),
                        ExchangeKamaModifiedMessage,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "ExchangeKamaModifiedMessage", 
                ),
                (
                    PacketLenField(
                        "function",
                        SelectedServerDataMessage(),
                        SelectedServerDataMessage,
                        length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
                    ),
                    lambda pkt: DOFUS_FUNCTION_CODE[pkt.protocolID] == "SelectedServerDataMessage", 
                ),

            ],
            StrLenField(
                "function", 
                "not implemented", 
                length_from=lambda pkt: int.from_bytes(pkt.length, "big"),
            ),
        ),
    ]

    @classmethod
    def tcp_reassemble(cls, data, metadata, session):
        offset = 0
        bytes_consumed = 0
        DOFUS_RESPONSE_MSG_HDR_LEN = 2

        while bytes_consumed < len(data):
    
            if len(data[bytes_consumed:]) < DOFUS_RESPONSE_MSG_HDR_LEN:
                return None

            ## Get size of the len field
            lengthType = int.from_bytes(data[offset:offset+2], "big") & 0b0000011

            ## Check if payload contains data
            if lengthType != 0:
                
                ## If we need more bytes for the header
                if len(data[bytes_consumed:]) < DOFUS_RESPONSE_MSG_HDR_LEN + lengthType:
                    return None

                ## Get packet length 
                length = int.from_bytes(data[offset+2:offset+2+lengthType], "big") + DOFUS_RESPONSE_MSG_HDR_LEN + lengthType

                if length == len(data):
                    bytes_consumed += length
                    return DofusResponse(data)
      
                ## Need more data
                elif length > len(data) :
                    return None

                ## If there are several dofus data in the packet
                elif length < len(data):
                    ## Add more bytes for the reassambled fragment
                    if length > len(data[bytes_consumed:]):
                        return None
                    bytes_consumed += length
                    bind_layers(DofusResponse, DofusResponse) ## Build a new layer
                   
                else:
                    raise NotImplementedError("Unsupported data length")

            else:
                ## For no apdu functions
                bytes_consumed += 2
                bind_layers(DofusResponse, DofusResponse)

            offset = bytes_consumed
        ## Return the dissected packet when there are several Dofus layer
        return DofusResponse(data[:bytes_consumed])

bind_layers(TCP, DofusRequest, dport=5555)
bind_layers(TCP, DofusResponse, sport=5555)