-- File: dofus.lua
-- description : a Lua Wireshark dissector for Dofus protocol
-- Installation on Linux : cp dofus.lua /usr/lib/x86_64-linux-gnu/wireshark/plugins/3.2/epan/dofus.lua
-- Installation on Windows : copy the file into C:/Program Files/Wireshark/plugins/4.0/epan/
-- Author : lk740

DOFUS_MESSAGE_TYPES = {[7461] = "BasicPingMessage", [9631] = "AbstractGameActionMessage", [5172] = "AbstractGameActionFightTargetedAbilityMessage", [2405] = "GameActionFightCloseCombatMessage", [1547] = "GameActionFightReduceDamagesMessage", [6590] = "GameActionFightLifePointsGainMessage", [9731] = "GameActionFightModifyEffectsDurationMessage", [7285] = "GameActionFightInvisibleDetectedMessage", [9152] = "GameActionFightDispellMessage", [8550] = "GameActionFightDispellEffectMessage", [1243] = "GameFightTurnListMessage", [7231] = "SequenceStartMessage", [5071] = "GameActionFightVanishMessage", [8549] = "GameActionFightMultipleSummonMessage", [7006] = "GameActionFightSlideMessage", [6293] = "GameActionFightKillMessage", [766] = "GameActionFightSpellCooldownVariationMessage", [4354] = "FighterStatsListMessage", [6493] = "GameMapMovementMessage", [8009] = "GameActionFightDropCharacterMessage", [6199] = "GameActionFightTriggerGlyphTrapMessage", [8927] = "GameActionFightPointsVariationMessage", [2356] = "GameActionFightReflectSpellMessage", [9724] = "GameActionFightDeathMessage", [5706] = "GameActionFightActivateGlyphTrapMessage", [8985] = "GameFightSynchronizeMessage", [2679] = "GameActionFightSpellCastMessage", [8838] = "GameActionFightTriggerEffectMessage", [3805] = "GameActionFightTackledMessage", [2495] = "GameActionFightInvisibilityMessage", [5747] = "GameFightShowFighterMessage", [7583] = "GameFightShowFighterRandomStaticPoseMessage", [9922] = "GameActionFightTeleportOnSameMapMessage", [4714] = "GameActionFightDispellSpellMessage", [1629] = "GameActionFightChangeLookMessage", [7515] = "GameActionFightDodgePointLossMessage", [276] = "GameActionFightSpellImmunityMessage", [2710] = "RefreshCharacterStatsMessage", [3071] = "GameActionFightDispellableEffectMessage", [8659] = "GameActionFightThrowCharacterMessage", [3786] = "GameFightRefreshFighterMessage", [432] = "GameActionFightMarkCellsMessage", [7363] = "GameActionFightSummonMessage", [6352] = "GameActionFightStealKamaMessage", [1586] = "SequenceEndMessage", [6444] = "GameActionFightLifePointsLostMessage", [5703] = "GameActionFightLifeAndShieldPointsLostMessage", [5771] = "GameActionFightCarryCharacterMessage", [9827] = "GameActionFightUnmarkCellsMessage", [7259] = "GameActionFightReflectDamagesMessage", [8976] = "GameActionFightExchangePositionsMessage", [9792] = "MapComplementaryInformationsDataMessage", [7688] = "MapComplementaryInformationsAnomalyMessage", [3874] = "GameFightUpdateTeamMessage", [9218] = "GameDataPaddockObjectRemoveMessage", [3407] = "ObjectGroundRemovedMultipleMessage", [7301] = "GameFightRemoveTeamMemberMessage", [1124] = "AnomalyOpenedMessage", [7754] = "EmotePlayRequestMessage", [1751] = "UpdateMapPlayersAgressableStatusMessage", [6071] = "PaddockMoveItemRequestMessage", [7785] = "ObjectGroundListAddedMessage", [5808] = "UpdateSelfAgressableStatusMessage", [5198] = "MapComplementaryInformationsWithCoordsMessage", [7865] = "GameContextRefreshEntityLookMessage", [5023] = "ListMapNpcsQuestStatusUpdateMessage", [2021] = "MapComplementaryInformationsDataInHavenBagMessage", [6746] = "BreachExitResponseMessage", [2191] = "PaddockRemoveItemRequestMessage", [8741] = "GameMapChangeOrientationMessage", [3774] = "ObjectGroundAddedMessage", [9138] = "BreachEnterMessage", [1818] = "GameRolePlayShowActorMessage", [8213] = "GameDataPlayFarmObjectAnimationMessage", [7254] = "GameRolePlayShowChallengeMessage", [3370] = "GameRolePlayRemoveChallengeMessage", [9879] = "GameRolePlayMonsterAngryAtPlayerMessage", [652] = "GameDataPaddockObjectAddMessage", [1071] = "MapComplementaryInformationsDataInHouseMessage", [2054] = "StatedMapUpdateMessage", [3256] = "GameMapChangeOrientationsMessage", [9194] = "ShowCellMessage", [3385] = "HousePropertiesMessage", [5585] = "GameRolePlayMonsterNotAngryAtPlayerMessage", [1178] = "BreachTeleportResponseMessage", [1678] = "SubareaRewardRateMessage", [5405] = "GameContextRemoveMultipleElementsMessage", [323] = "GameRolePlayShowMultipleActorsMessage", [5855] = "ObjectGroundRemovedMessage", [9121] = "GameDataPaddockObjectListAddMessage", [9316] = "AnomalyStateMessage", [2408] = "MapInformationsRequestMessage", [3900] = "InteractiveUsedMessage", [2838] = "MapFightCountMessage", [9493] = "InteractiveMapUpdateMessage", [3496] = "GameContextRemoveElementMessage", [3172] = "GameFightOptionStateUpdateMessage", [2317] = "BreachTeleportRequestMessage", [4428] = "MapComplementaryInformationsBreachMessage", [7948] = "GameEntitiesDispositionMessage", [4927] = "ShowCellSpectatorMessage", [5606] = "GameFightPlacementSwapPositionsMessage", [4] = "GameEntityDispositionMessage", [109] = "GameFightHumanReadyStateMessage", [3675] = "PlayerStatusUpdateMessage", [4926] = "ChallengeBonusChoiceSelectedMessage", [2386] = "GameFightEndMessage", [9314] = "BreachGameFightEndMessage", [6318] = "GameFightSpectateMessage", [2675] = "GameFightResumeMessage", [5652] = "GameFightResumeWithSlavesMessage", [4436] = "ChallengeListMessage", [393] = "GameActionFightNoSpellCastMessage", [7991] = "CurrentMapMessage", [4455] = "ChallengeModSelectMessage", [8830] = "ChallengeProposalMessage", [9237] = "GameContextReadyMessage", [2779] = "ChallengeNumberMessage", [5894] = "ChallengeResultMessage", [2450] = "ChallengeTargetsRequestMessage", [9097] = "ChallengeTargetsMessage", [6974] = "GameFightLeaveMessage", [5476] = "CurrentMapInstanceMessage", [8563] = "ChallengeAddMessage", [6131] = "GameFightStartingMessage", [8166] = "GameFightJoinMessage", [5920] = "ChallengeSelectionMessage", [1701] = "ArenaFighterIdleMessage", [4667] = "ChallengeModSelectedMessage", [8427] = "ChallengeValidateMessage", [9783] = "GameFightStartMessage", [1821] = "GameContextDestroyMessage", [3924] = "GameFightSpectatorJoinMessage", [75] = "MapObstacleUpdateMessage", [3724] = "ArenaFighterLeaveMessage", [2271] = "ChallengeBonusChoiceMessage", [8045] = "ChallengeSelectedMessage", [4448] = "GameFightNewWaveMessage", [1045] = "GameFightPauseMessage", [217] = "GameFightTurnStartMessage", [379] = "GameFightTurnReadyRequestMessage", [7900] = "GameFightTurnEndMessage", [8261] = "GameFightNewRoundMessage", [974] = "SlaveSwitchContextMessage", [3867] = "GameFightTurnStartPlayingMessage", [194] = "RemoveSpellModifierMessage", [1268] = "SlaveNoLongerControledMessage", [4395] = "CharacterStatsListMessage", [5751] = "GameActionAcknowledgementMessage", [7389] = "GameFightTurnResumeMessage", [9655] = "GameFightTurnReadyMessage", [1373] = "ApplySpellModifierMessage", [6014] = "GameActionUpdateEffectTriggerCountMessage", [9219] = "HaapiApiKeyRequestMessage", [3737] = "DebugClearHighlightCellsMessage", [9357] = "DebugHighlightCellsMessage", [2370] = "DumpedEntityStatsMessage", [6256] = "DebugInClientMessage", [9262] = "IdentificationMessage", [9375] = "BasicAckMessage", [2887] = "BasicNoOperationMessage", [7628] = "CredentialsAcknowledgementMessage", [999] = "OnConnectionEventMessage", [5441] = "ObjectJobAddedMessage", [5726] = "LivingObjectMessageRequestMessage", [6104] = "IdentificationSuccessMessage", [6253] = "RawDataMessage", [3339] = "TrustStatusMessage", [9500] = "ServersListMessage", [4877] = "BasicPongMessage", [6273] = "BasicLatencyStatsRequestMessage", [7194] = "BasicLatencyStatsMessage", [7220] = "CheckIntegrityMessage", [9773] = "AdminCommandMessage", [7923] = "ConsoleMessage", [8282] = "AdminQuietCommandMessage", [3323] = "QuestListMessage", [1736] = "QuestValidatedMessage", [5979] = "CharacterCreationResultMessage", [4482] = "NicknameRefusedMessage", [8083] = "NicknameAcceptedMessage", [563] = "AlterationsUpdatedMessage", [7505] = "AuthenticationTicketAcceptedMessage", [3970] = "ExchangeTaxCollectorGetMessage", [1770] = "ChatAbstractServerMessage", [6772] = "ChatServerMessage", [942] = "ChatKolizeumServerMessage", [4003] = "GuildInvitedMessage", [4299] = "CharacterSelectedSuccessMessage", [7869] = "ExchangeCraftResultMessage", [4819] = "ExchangeCraftResultWithObjectDescMessage", [1668] = "GameRolePlayPlayerFightFriendlyAnsweredMessage", [3884] = "NotificationByServerMessage", [8750] = "GuildMemberOnlineStatusMessage", [9608] = "ExchangeMountsPaddockRemoveMessage", [4859] = "SocialNoticeMessage", [8135] = "EmotePlayAbstractMessage", [9883] = "OrnamentGainedMessage", [9295] = "ExchangeBidHouseUnsoldItemsMessage", [1628] = "TreasureHuntAvailableRetryCountUpdateMessage", [6905] = "DungeonPartyFinderListenErrorMessage", [3411] = "ExchangeObjectMessage", [8928] = "ExchangeObjectsRemovedMessage", [3766] = "TextInformationMessage", [2039] = "AbstractPartyMessage", [83] = "PartyLeaveMessage", [8426] = "ExchangeObjectAddedMessage", [3238] = "PauseDialogMessage", [1486] = "BreachBranchesMessage", [8782] = "GuildApplicationDeletedMessage", [5970] = "CheckFileRequestMessage", [5826] = "GameRolePlayFightRequestCanceledMessage", [3114] = "GameRolePlayArenaFighterStatusMessage", [8617] = "ChatServerCopyMessage", [4751] = "GameRolePlayArenaSwitchToFightServerMessage", [4745] = "GuildPlayerApplicationAbstractMessage", [656] = "GuildPlayerApplicationInformationMessage", [1947] = "AllianceFightFinishedMessage", [7843] = "MountReleasedMessage", [3985] = "DecraftResultMessage", [9437] = "MapFightStartPositionsUpdateMessage", [2799] = "OrnamentLostMessage", [8361] = "SpouseStatusMessage", [8244] = "SubscriptionLimitationMessage", [4274] = "ExchangeBidPriceMessage", [7209] = "ExchangeBidPriceForSellerMessage", [9268] = "LockableShowCodeDialogMessage", [1395] = "UpdateLifePointsMessage", [3893] = "TopTaxCollectorListMessage", [455] = "TitleGainedMessage", [8090] = "ExchangeObjectRemovedMessage", [6015] = "LivingObjectMessageMessage", [605] = "CharacterLoadingCompleteMessage", [4377] = "ExchangeIsReadyMessage", [1205] = "AchievementAlmostFinishedDetailedListMessage", [2897] = "InteractiveUseEndedMessage", [5219] = "ObjectsDeletedMessage", [4650] = "PaddockPropertiesMessage", [1167] = "GameContextRemoveMultipleElementsWithEventsMessage", [5378] = "ExchangeStartOkMulticraftCustomerMessage", [6130] = "ExchangeStartOkNpcShopMessage", [5451] = "AbstractPartyEventMessage", [5707] = "PartyUpdateMessage", [4529] = "PartyNewMemberMessage", [6551] = "AllianceInvitationStateRecruterMessage", [6083] = "SurrenderVoteEndMessage", [2584] = "ExchangeCrafterJobLevelupMessage", [7186] = "IgnoredAddFailureMessage", [9278] = "ExchangeStartedBidSellerMessage", [1886] = "EmotePlayMassiveMessage", [7090] = "HaapiValidationMessage", [7020] = "ChatSmileyMessage", [5697] = "ExchangeObjectPutInBagMessage", [779] = "GameCautiousMapMovementMessage", [1474] = "AchievementFinishedMessage", [1898] = "AchievementFinishedInformationMessage", [4280] = "ExchangeStartedBidBuyerMessage", [9678] = "ObtainedItemMessage", [7133] = "ObtainedItemWithBonusMessage", [7427] = "SpellListMessage", [3266] = "GuildLeftMessage", [1724] = "PartyRefuseInvitationNotificationMessage", [5348] = "CharacterDeletionPrepareMessage", [2613] = "ExchangeBidHouseBuyResultMessage", [7160] = "ExchangePodsModifiedMessage", [3347] = "ExchangeBidHouseGenericItemRemovedMessage", [8385] = "ServerOptionalFeaturesMessage", [7028] = "BreachRoomUnlockResultMessage", [5056] = "DungeonPartyFinderRoomContentUpdateMessage", [6059] = "OpponentSurrenderMessage", [4373] = "QuestStepValidatedMessage", [9328] = "JobCrafterDirectoryAddMessage", [6501] = "ShortcutBarSwapErrorMessage", [729] = "PartyInvitationMessage", [3539] = "PartyInvitationDungeonMessage", [1737] = "JobAllowMultiCraftRequestMessage", [8902] = "JobMultiCraftAvailableSkillsMessage", [3185] = "FriendAddedMessage", [7345] = "AccountHouseMessage", [2291] = "AcquaintanceSearchErrorMessage", [1067] = "ExchangeStartOkRecycleTradeMessage", [3065] = "StatsUpgradeResultMessage", [8225] = "MapRunningFightListMessage", [594] = "SequenceNumberRequestMessage", [8607] = "PartyInvitationDetailsMessage", [2367] = "PartyInvitationDungeonDetailsMessage", [6572] = "ExchangeTypesExchangerDescriptionForUserMessage", [9206] = "JobCrafterDirectorySettingsMessage", [2215] = "MoodSmileyUpdateMessage", [953] = "GameRolePlayArenaInvitationCandidatesAnswerMessage", [3198] = "EmotePlayMessage", [7196] = "SymbioticObjectAssociatedMessage", [7499] = "BasicDateMessage", [9743] = "ExchangeMountsStableAddMessage", [2861] = "ExchangeMountsStableBornAddMessage", [8856] = "DebtsUpdateMessage", [4545] = "AccountInformationsUpdateMessage", [3567] = "TreasureHuntDigRequestAnswerMessage", [2459] = "TreasureHuntDigRequestAnswerFailedMessage", [2619] = "GameEntityDispositionErrorMessage", [2112] = "EmoteAddMessage", [6439] = "PartyLeaderUpdateMessage", [2080] = "ChatAdminServerMessage", [8673] = "BasicWhoIsMessage", [6866] = "ObjectAddedMessage", [116] = "GameActionNoopMessage", [4672] = "PrismRemoveMessage", [1024] = "PopupWarningMessage", [386] = "JobLevelUpMessage", [506] = "KothEndMessage", [9001] = "ExchangeBidHouseInListAddedMessage", [6556] = "BreachCharactersMessage", [2089] = "ObjectErrorMessage", [2086] = "SymbioticObjectErrorMessage", [3920] = "MimicryObjectErrorMessage", [1036] = "KohUpdateMessage", [2454] = "TeleportBuddiesRequestedMessage", [3100] = "SocialNoticeSetErrorMessage", [6006] = "AllianceMotdSetErrorMessage", [4524] = "EmoteRemoveMessage", [6422] = "GuildMotdSetErrorMessage", [4925] = "ContactLookMessage", [6763] = "GameRolePlayArenaSwitchToGameServerMessage", [9553] = "AllianceListMessage", [4178] = "AlliancePartialListMessage", [2005] = "MapRunningFightDetailsMessage", [8895] = "MapRunningFightDetailsExtendedMessage", [8632] = "AcquaintanceServerListMessage", [6038] = "EmoteListMessage", [3749] = "TitlesAndOrnamentsListMessage", [5031] = "HaapiConfirmationMessage", [8036] = "ListenersOfSynchronizedStorageMessage", [4351] = "CharacterDeletionErrorMessage", [135] = "HavenBagFurnituresMessage", [9791] = "ExchangeStartedTaxCollectorShopMessage", [3] = "HaapiBufferListMessage", [6668] = "ObjectDeletedMessage", [7328] = "PartyMemberRemoveMessage", [9438] = "PartyMemberEjectedMessage", [2483] = "MountDataErrorMessage", [1001] = "InvalidPresetsMessage", [7630] = "PresetSaveErrorMessage", [6708] = "GuildInformationsMemberUpdateMessage", [3043] = "ExchangeStartedMessage", [2977] = "ExchangeStartedWithStorageMessage", [3245] = "JobCrafterDirectoryRemoveMessage", [7078] = "ExchangeObjectModifiedMessage", [9235] = "AnomalySubareaInformationResponseMessage", [4597] = "BulletinMessage", [1996] = "GuildBulletinMessage", [4231] = "PartyUpdateLightMessage", [6325] = "GameFightPlacementSwapPositionsErrorMessage", [799] = "PresetUseResultMessage", [5207] = "GuildHousesInformationMessage", [4632] = "DisplayNumericalValuePaddockMessage", [9802] = "ConsoleEndMessage", [7246] = "GuildMemberLeavingMessage", [41] = "ForgettableSpellEquipmentSlotsMessage", [5408] = "GuildLevelUpMessage", [99] = "SurrenderInfoResponseMessage", [5220] = "AllianceJoinedMessage", [1625] = "ConfirmationOfListeningTaxCollectorUpdatesMessage", [2693] = "NumericWhoIsMessage", [8956] = "ExchangeBidSearchOkMessage", [100] = "PurchasableDialogMessage", [4661] = "AllianceMotdMessage", [7599] = "GameRolePlayArenaLeagueRewardsMessage", [349] = "HaapiAuthErrorMessage", [8038] = "PartyDeletedMessage", [5943] = "SystemMessageDisplayMessage", [9240] = "ExchangeBidHouseInListUpdatedMessage", [8542] = "GameRolePlayArenaRegistrationWarningMessage", [3055] = "ExchangeMountsTakenFromPaddockMessage", [4627] = "HaapiTokenMessage", [9599] = "CurrentServerStatusUpdateMessage", [2343] = "GuildInvitationStateRecruterMessage", [8123] = "IgnoredListMessage", [9652] = "AchievementListMessage", [1590] = "GuildHouseUpdateInformationMessage", [9885] = "GuildApplicationPresenceMessage", [3289] = "NpcDialogCreationMessage", [6302] = "PortalDialogCreationMessage", [110] = "MountSetMessage", [49] = "ExchangeSellOkMessage", [2255] = "MimicryObjectPreviewMessage", [7443] = "NotificationListMessage", [2670] = "StorageObjectUpdateMessage", [8710] = "JobCrafterDirectoryListMessage", [7859] = "StatedElementUpdatedMessage", [223] = "GameContextCreateErrorMessage", [7293] = "FriendUpdateMessage", [5922] = "AuthenticationTicketRefusedMessage", [3125] = "AlliancePrismDialogQuestionMessage", [1232] = "ExchangeStartOkMountWithOutPaddockMessage", [7235] = "TreasureHuntMessage", [9676] = "AllianceFightStartedMessage", [5667] = "GameRolePlayArenaFightPropositionMessage", [1039] = "ClientUIOpenedMessage", [399] = "ChatServerWithObjectMessage", [2274] = "ExchangeStartOkMountMessage", [9246] = "DocumentReadingBeginMessage", [753] = "GuildChestTabContributionsMessage", [4910] = "ExchangeKamaModifiedMessage", [4358] = "GameRolePlayDelayedActionMessage", [3110] = "GameRolePlayDelayedObjectUseMessage", [5838] = "PaddockBuyResultMessage", [7302] = "AllianceCreationResultMessage", [6938] = "AbstractPartyMemberInFightMessage", [2380] = "PartyMemberInBreachFightMessage", [8722] = "HouseGuildRightsMessage", [6490] = "AllianceLeftMessage", [6203] = "ExchangeStartOkCraftMessage", [4096] = "ExchangeStartOkCraftWithInformationMessage", [8582] = "MountUnSetMessage", [107] = "LockableStateUpdateAbstractMessage", [8763] = "JobExperienceMultiUpdateMessage", [1630] = "ExchangeWeightMessage", [5586] = "HelloConnectMessage", [7676] = "HouseGuildNoneMessage", [3880] = "MountRidingMessage", [7739] = "ChannelEnablingChangeMessage", [8317] = "HouseToSellListMessage", [1686] = "AllianceApplicationReceivedMessage", [7376] = "GuildLogbookInformationMessage", [1596] = "CharacterSelectedErrorMessage", [1060] = "AchievementRewardSuccessMessage", [2491] = "MigratedServerListMessage", [5602] = "ExchangeObjectRemovedFromBagMessage", [8042] = "InventoryContentMessage", [8887] = "WatchInventoryContentMessage", [8968] = "StorageKamasUpdateMessage", [6800] = "HouseSellingUpdateMessage", [4844] = "AllianceApplicationIsAnsweredMessage", [1423] = "ExchangeCraftResultWithObjectIdMessage", [1448] = "HaapiBuyValidationMessage", [4759] = "TitleLostMessage", [889] = "PresetSavedMessage", [1662] = "ExchangeStartOkRunesTradeMessage", [6041] = "GameActionItemListMessage", [6669] = "TeleportOnSameMapMessage", [6961] = "GuildPlayerNoApplicationInformationMessage", [8368] = "TreasureHuntShowLegendaryUIMessage", [3973] = "ChatSmileyExtraPackListMessage", [7642] = "AlignmentWarEffortDonatePreviewMessage", [1521] = "GoldAddedMessage", [6319] = "PresetDeleteResultMessage", [5298] = "ExchangeItemAutoCraftStopedMessage", [9232] = "ExchangeErrorMessage", [7356] = "MultiTabStorageMessage", [154] = "ServerSettingsMessage", [3443] = "AchievementsPioneerRanksMessage", [8450] = "StorageObjectRemoveMessage", [6589] = "FollowedQuestsMessage", [8056] = "DungeonPartyFinderAvailableDungeonsMessage", [1468] = "PaginationAnswerAbstractMessage", [2436] = "AllianceSummaryMessage", [6322] = "GameMapNoMovementMessage", [8372] = "QuestStartedMessage", [2688] = "MountRenamedMessage", [5626] = "GuildFactsMessage", [7707] = "GuestLimitationMessage", [1313] = "ExchangeRequestedMessage", [5103] = "ExchangeRequestedTradeMessage", [523] = "AllianceRecruitmentInvalidateMessage", [1627] = "ShortcutBarAddErrorMessage", [4930] = "FriendDeleteResultMessage", [8873] = "PresetsMessage", [2310] = "TaxCollectorRemovedMessage", [3508] = "QuestObjectiveValidatedMessage", [6235] = "GameRolePlayAggressionMessage", [6362] = "GuildInformationsMembersMessage", [5214] = "NuggetsInformationMessage", [9701] = "CharacterExperienceGainMessage", [4769] = "FinishMoveListMessage", [6154] = "SurrenderVoteUpdateMessage", [2879] = "PartyRestrictedMessage", [948] = "GuildListApplicationAnswerMessage", [4626] = "GameRolePlayPlayerFightFriendlyRequestedMessage", [1346] = "UpdateMountCharacteristicsMessage", [7733] = "PrismsListMessage", [1595] = "GameContextCreateMessage", [1579] = "GameFightPlacementSwapPositionsCancelledMessage", [9461] = "AreaFightModificatorUpdateMessage", [5352] = "ForceAccountErrorMessage", [1653] = "TitleSelectedMessage", [1587] = "AbstractGameActionWithAckMessage", [7251] = "OrnamentSelectedMessage", [156] = "GuildSummaryMessage", [8751] = "AllianceBulletinMessage", [6401] = "OrnamentSelectErrorMessage", [5362] = "GameContextMoveElementMessage", [2738] = "ExchangeTypesItemsExchangerDescriptionForUserMessage", [4172] = "FriendsListMessage", [3076] = "GroupTeleportPlayerOfferMessage", [830] = "QuestStepInfoMessage", [141] = "WatchQuestStepInfoMessage", [4276] = "ExchangeWaitingResultMessage", [3637] = "GuildApplicationIsAnsweredMessage", [3137] = "AlreadyConnectedMessage", [2628] = "TaxCollectorPresetSpellUpdatedMessage", [2916] = "CharacterAlignmentWarEffortProgressionMessage", [2033] = "ArenaFightAnswerAcknowledgementMessage", [5424] = "AtlasPointInformationsMessage", [8016] = "CharactersListMessage", [5810] = "GuestModeMessage", [2814] = "GuildJoinedMessage", [7615] = "TeleportDestinationsMessage", [9132] = "ZaapDestinationsMessage", [4068] = "PartyFollowStatusUpdateMessage", [7368] = "GameContextMoveMultipleElementsMessage", [6815] = "ItemForPresetUpdateMessage", [4958] = "PartyKickedByMessage", [3547] = "AllianceMembershipMessage", [3696] = "ExchangeBidHouseGenericItemAddedMessage", [5019] = "AlignmentRankUpdateMessage", [4050] = "CharacterSelectedForceMessage", [708] = "HelloGameMessage", [7863] = "GuildFactsErrorMessage", [2020] = "AchievementDetailedListMessage", [9851] = "GuildInvitationStateRecrutedMessage", [5336] = "AccountSubscriptionElapsedDurationMessage", [5253] = "KnownZaapListMessage", [2451] = "TaxCollectorEquipmentUpdateMessage", [654] = "KamasUpdateMessage", [5323] = "StorageObjectsUpdateMessage", [8138] = "ReportResponseMessage", [5717] = "ActivitySuggestionsMessage", [9158] = "ShortcutBarContentMessage", [1527] = "ObjectsAddedMessage", [2991] = "InteractiveUseErrorMessage", [4629] = "BasicWhoIsNoMatchMessage", [3824] = "GameRolePlayGameOverMessage", [4378] = "TeleportPlayerCloseMessage", [1173] = "GameRolePlaySpellAnimMessage", [3704] = "TaxCollectorHarvestedMessage", [1127] = "MimicryObjectAssociatedMessage", [3098] = "LoginQueueStatusMessage", [1327] = "PartyCancelInvitationNotificationMessage", [5243] = "WarnOnPermaDeathStateMessage", [2524] = "ExchangeOfflineSoldItemsMessage", [4838] = "QueueStatusMessage", [9965] = "LifePointsRegenBeginMessage", [6155] = "ForgettableSpellListUpdateMessage", [9633] = "CharactersListWithRemodelingMessage", [8912] = "InteractiveElementUpdatedMessage", [9777] = "TeleportPlayerOfferMessage", [21] = "BreachSavedMessage", [8509] = "GameActionItemAddMessage", [4765] = "HaapiApiKeyMessage", [3908] = "GuildRanksMessage", [4833] = "TaxCollectorMovementsOfflineMessage", [8626] = "LocalizedChatSmileyMessage", [1939] = "ProtocolRequired", [872] = "CompassUpdateMessage", [3997] = "GameRefreshMonsterBoostsMessage", [9509] = "DungeonPartyFinderRegisterSuccessMessage", [7767] = "SpellVariantActivationMessage", [1673] = "StorageObjectsRemoveMessage", [1193] = "AllianceFightPhaseUpdateMessage", [2] = "NetworkDataContainerMessage", [4625] = "GuildPaddockBoughtMessage", [8285] = "PartyMemberInStandardFightMessage", [683] = "GuildChestTabLastContributionMessage", [4969] = "AlliancePlayerApplicationAbstractMessage", [9706] = "AlliancePlayerApplicationInformationMessage", [2673] = "ReloginTokenStatusMessage", [6526] = "StorageInventoryContentMessage", [7470] = "TreasureHuntRequestAnswerMessage", [1302] = "GameRolePlayArenaPlayerBehavioursMessage", [6871] = "TreasureHuntFlagRequestAnswerMessage", [4135] = "ExchangeStartedWithMultiTabStorageMessage", [4210] = "AllianceFactsErrorMessage", [9032] = "AllianceInvitedMessage", [8066] = "PartyLocateMembersMessage", [91] = "RemoveListenerOnSynchronizedStorageMessage", [8324] = "GuildBulletinSetErrorMessage", [1503] = "AccessoryPreviewMessage", [949] = "InviteInHavenBagMessage", [2365] = "IgnoredDeleteResultMessage", [9981] = "CompassUpdatePartyMemberMessage", [1171] = "EntityTalkMessage", [569] = "LockableStateUpdateStorageMessage", [2116] = "JobCrafterDirectoryEntryMessage", [1415] = "GuildPaddockRemovedMessage", [9260] = "BreachInvitationResponseMessage", [9417] = "EditHavenBagStartMessage", [5371] = "CharacterNameSuggestionFailureMessage", [277] = "SelectedServerRefusedMessage", [9284] = "AlterationRemovedMessage", [5839] = "ChatCommunityChannelCommunityMessage", [7721] = "AlterationsMessage", [4778] = "CompassUpdatePvpSeekMessage", [9269] = "AllianceFactsMessage", [9989] = "BreachBudgetMessage", [5386] = "AllianceFightInfoMessage", [5877] = "NpcGenericActionFailureMessage", [7317] = "CharacterCanBeCreatedResultMessage", [8801] = "AllianceApplicationDeletedMessage", [4944] = "SelectedServerDataMessage", [7269] = "SelectedServerDataExtendedMessage", [584] = "FriendWarnOnConnectionStateMessage", [9524] = "DungeonPartyFinderRoomContentMessage", [8148] = "GuildApplicationReceivedMessage", [7142] = "AlliancePlayerNoApplicationInformationMessage", [9539] = "JobDescriptionMessage", [2295] = "AccountLoggingKickedMessage", [9367] = "ExchangeObjectModifiedInBagMessage", [4018] = "GuildCreationResultMessage", [3610] = "AllianceListApplicationAnswerMessage", [3673] = "ExchangeStoppedMessage", [8844] = "AlterationAddedMessage", [3338] = "TitleSelectErrorMessage", [8908] = "AccountCapabilitiesMessage", [6177] = "SurrenderVoteStartMessage", [4318] = "GuildMotdMessage", [9430] = "MountSterilizedMessage", [9970] = "OpenGuideBookMessage", [7168] = "GuildInformationsPaddocksMessage", [6979] = "JobExperienceUpdateMessage", [4567] = "IdentificationFailedMessage", [4124] = "IdentificationFailedForBadVersionMessage", [6115] = "ExchangeStartedMountStockMessage", [1934] = "HaapiShopApiKeyMessage", [2467] = "ClientUIOpenedByObjectMessage", [9395] = "ExchangeStartOkEvolutiveObjectRecycleTradeMessage", [2319] = "ExchangeCraftPaymentModifiedMessage", [3877] = "AllianceMemberInformationUpdateMessage", [6689] = "LeaveDialogMessage", [384] = "ExchangeLeaveMessage", [8241] = "BreachRoomLockedMessage", [3693] = "AllianceModificationResultMessage", [3226] = "DungeonPartyFinderRegisterErrorMessage", [5037] = "InviteInHavenBagOfferMessage", [9897] = "HavenBagPackListMessage", [5647] = "AcquaintancesListMessage", [4888] = "GuildHouseRemoveMessage", [1937] = "TreasureHuntFinishedMessage", [3871] = "WrapperObjectAssociatedMessage", [6129] = "ExchangeMountsStableRemoveMessage", [6534] = "AllianceCreationStartedMessage", [9677] = "InventoryWeightMessage", [6145] = "ExchangeMoneyMovementInformationMessage", [9315] = "ZaapRespawnUpdatedMessage", [4154] = "ExchangeMultiCraftCrafterCanUseHisRessourcesMessage", [8541] = "PrismAttackResultMessage", [5744] = "TaxCollectorStateUpdateMessage", [5491] = "TeleportToBuddyOfferMessage", [5384] = "PartyLoyaltyStatusMessage", [2757] = "PopupWarningClosedMessage", [7224] = "GuildListApplicationModifiedMessage", [6674] = "FriendAddFailureMessage", [1525] = "PrismAddOrUpdateMessage", [5461] = "HavenBagRoomUpdateMessage", [5842] = "BreachInvitationOfferMessage", [2644] = "GuildMembershipMessage", [9293] = "ExchangeStartedTaxCollectorEquipmentMessage", [8183] = "SubscriptionZoneMessage", [2716] = "GroupTeleportPlayerCloseMessage", [2186] = "TaxCollectorErrorMessage", [8668] = "IdentificationFailedBannedMessage", [1741] = "BreachRewardsMessage", [2729] = "ObjectAveragePricesMessage", [5171] = "MountEquipedErrorMessage", [3079] = "AchievementRewardErrorMessage", [2072] = "ChallengeFightJoinRefusedMessage", [9805] = "GameActionSpamMessage", [7795] = "PaddockToSellListMessage", [9352] = "HavenBagDailyLoteryMessage", [5184] = "GuildRecruitmentInvalidateMessage", [1517] = "AlignmentWarEffortDonationResultMessage", [5] = "GameRolePlayShowActorWithEventMessage", [4284] = "HouseBuyResultMessage", [977] = "AllianceRecruitmentInformationMessage", [2149] = "AllianceModificationStartedMessage", [4137] = "RecycleResultMessage", [6016] = "PartyCannotJoinErrorMessage", [3797] = "IgnoredAddedMessage", [6850] = "EntityInformationMessage", [2045] = "AlignmentWarEffortProgressionMessage", [137] = "MountDataMessage", [7618] = "PartyInvitationCancelledForGuestMessage", [7440] = "ExchangeCraftCountModifiedMessage", [5711] = "GuildCreationStartedMessage", [944] = "AllianceFightFighterRemovedMessage", [7643] = "CharactersListErrorMessage", [2362] = "EditHavenBagFinishedMessage", [3498] = "ClientYouAreDrunkMessage", [204] = "ObjectQuantityMessage", [5797] = "CharacterLevelUpMessage", [3031] = "CharacterLevelUpInformationMessage", [7957] = "HavenBagPermissionsUpdateMessage", [2058] = "AchievementDetailsMessage", [5028] = "ExchangeStartedWithPodsMessage", [25] = "ForceAccountStatusMessage", [2498] = "ItemNoMoreAvailableMessage", [5637] = "EvolutiveObjectRecycleResultMessage", [1383] = "MoodSmileyResultMessage", [4199] = "HaapiSessionMessage", [626] = "AllianceMemberLeavingMessage", [9259] = "ServerExperienceModificatorMessage", [9900] = "TaxCollectorPresetsMessage", [3224] = "IdentificationSuccessWithLoginTokenMessage", [3451] = "CharacterCapabilitiesMessage", [9591] = "PartyNameUpdateMessage", [8322] = "ExchangeStartOkNpcTradeMessage", [6135] = "ChatErrorMessage", [6944] = "SurrenderStateMessage", [6518] = "DungeonKeyRingUpdateMessage", [7264] = "AllianceInvitationStateRecrutedMessage", [9050] = "MountXpRatioMessage", [3938] = "AlmanachCalendarDateMessage", [6346] = "ContactLookErrorMessage", [7821] = "ObjectModifiedMessage", [7060] = "PartyNewGuestMessage", [8565] = "FriendStatusShareStateMessage", [8059] = "ChatServerCopyWithObjectMessage", [4981] = "ShortcutBarRemoveErrorMessage", [7989] = "PartyNameSetErrorMessage", [3500] = "TaxCollectorDialogQuestionBasicMessage", [8713] = "TaxCollectorDialogQuestionExtendedMessage", [775] = "GuildModificationResultMessage", [5124] = "GameFightPlacementSwapPositionsOfferMessage", [4562] = "AllianceInsiderInfoMessage", [560] = "BreachRewardBoughtMessage", [4615] = "ExchangeMountFreeFromPaddockMessage", [1826] = "AddListenerOnSynchronizedStorageMessage", [2625] = "EnabledChannelsMessage", [991] = "CinematicMessage", [1248] = "ExchangeStartOkJobIndexMessage", [282] = "GameFightPlacementPossiblePositionsMessage", [5361] = "TaxCollectorAttackedMessage", [590] = "AccountLinkRequiredMessage", [5999] = "CompassResetMessage", [6577] = "PartyJoinMessage", [125] = "ShortcutBarReplacedMessage", [6723] = "JobBookSubscriptionMessage", [8050] = "GuildChestTabContributionMessage", [5018] = "BreachKickResponseMessage", [7779] = "SpouseInformationsMessage", [5972] = "ShortcutBarRefreshMessage", [6819] = "DungeonKeyRingMessage", [5310] = "AllianceFightFighterAddedMessage", [4424] = "ServerStatusUpdateMessage", [9554] = "TeleportBuddiesMessage", [2158] = "FriendWarnOnLevelGainStateMessage", [669] = "GuildListMessage", [8248] = "RecruitmentInformationMessage", [1665] = "GameRolePlayArenaUpdatePlayerInfosMessage", [7996] = "ExchangeMountSterilizeFromPaddockMessage", [2270] = "AcquaintanceAddedMessage", [9337] = "ServerSessionConstantsMessage", [2208] = "CharacterNameSuggestionSuccessMessage", [3490] = "MountEmoteIconUsedOkMessage", [9703] = "ExchangeObjectsAddedMessage", [7326] = "ExchangeObjectsModifiedMessage", [5215] = "WrapperObjectErrorMessage", [5664] = "ObjectsQuantityMessage", [7483] = "SetUpdateMessage", [8350] = "ExchangeMountsPaddockAddMessage", [48] = "PrismAttackedMessage", [266] = "EntitiesInformationMessage", [2363] = "PartyModifiableStatusMessage", [515] = "GuildModificationStartedMessage", [1331] = "JobExperienceOtherPlayerUpdateMessage", [8886] = "AllianceApplicationPresenceMessage", [8872] = "NicknameRegistrationMessage", [7775] = "GameContextRemoveElementWithEventMessage", [8757] = "ShortcutBarRemovedMessage", [9839] = "ExchangeBuyOkMessage", [5525] = "GameActionItemConsumedMessage", [6833] = "LifePointsRegenEndMessage", [3860] = "PlayerStatusUpdateErrorMessage", [869] = "ConsoleCommandsListMessage", [4180] = "ExchangeBidHouseInListRemovedMessage", [8685] = "AllianceBulletinSetErrorMessage", [4353] = "ForgettableSpellDeleteMessage", [4427] = "AllianceRanksMessage", [7828] = "DebtsDeleteMessage", [95] = "ExchangeCraftResultMagicWithObjectDescMessage", [5529] = "AllianceMemberOnlineStatusMessage", [8101] = "ExchangeBidHouseItemRemoveOkMessage", [5644] = "WatchQuestListMessage", [5074] = "ObjectAveragePricesErrorMessage", [5059] = "PresetUseResultWithMissingIdsMessage", [4787] = "TaxCollectorAttackedResultMessage", [8693] = "GameRolePlayPlayerLifeStatusMessage", [1328] = "FriendGuildWarnOnAchievementCompleteStateMessage", [6049] = "BreachInvitationCloseMessage", [7692] = "LockableStateUpdateHouseDoorMessage", [7370] = "TaxCollectorAddedMessage", [4196] = "PaddockSellBuyDialogMessage", [4122] = "ExchangeOkMultiCraftMessage", [5481] = "NpcDialogQuestionMessage", [7853] = "EmotePlayErrorMessage", [7896] = "GameRolePlayDelayedActionFinishedMessage", [2506] = "ContactAddFailureMessage", [4510] = "ObjectMovementMessage", [7522] = "LockableCodeResultMessage", [5267] = "ExchangeMountStableErrorMessage", [8989] = "BreachStateMessage", [4406] = "GuildInformationsGeneralMessage", [427] = "BreachBonusMessage", [4968] = "TeleportToBuddyCloseMessage", [7458] = "ExchangeStartOkMulticraftCrafterMessage", [4945] = "BasicTimeMessage", [1557] = "ExchangeBidHouseItemAddOkMessage", [2046] = "PartyEntityUpdateLightMessage", [4586] = "GameRolePlayArenaRegistrationStatusMessage", [1324] = "SetCharacterRestrictionsMessage", [2945] = "QuestStepStartedMessage", [8001] = "InviteInHavenBagClosedMessage", [3470] = "AllianceListApplicationModifiedMessage", [2428] = "TaxCollectorOrderedSpellUpdatedMessage", [9621] = "AccessoryPreviewErrorMessage", [6650] = "GuildFactsRequestMessage", [3259] = "ReleaseAccountMessage", [7975] = "ClientKeyMessage", [5654] = "ForceAccountMessage", [4608] = "NicknameChoiceRequestMessage", [593] = "AllianceFactsRequestMessage", [8587] = "TeleportHavenBagRequestMessage", [1190] = "GameMapChangeOrientationRequestMessage", [1216] = "ExchangeRequestOnTaxCollectorMessage", [4582] = "ExchangeBuyMessage", [4036] = "EnterHavenBagRequestMessage", [8967] = "ErrorMapNotFoundMessage", [2919] = "ExchangeRequestMessage", [9371] = "ExchangePlayerRequestMessage", [6628] = "GameRolePlayPlayerFightRequestMessage", [2028] = "ExchangePlayerMultiCraftRequestMessage", [5939] = "ExchangeObjectMoveMessage", [3566] = "ExchangeObjectMovePricedMessage", [6790] = "PortalUseRequestMessage", [4616] = "ExchangeSellMessage", [3818] = "GameRolePlayFreeSoulRequestMessage", [9643] = "LeaveDialogRequestMessage", [9340] = "TeleportHavenBagAnswerMessage", [878] = "StartExchangeTaxCollectorEquipmentMessage", [3554] = "KickHavenBagRequestMessage", [6670] = "NpcGenericActionRequestMessage", [1704] = "GameRolePlayPlayerFightFriendlyAnswerMessage", [1944] = "GameRolePlayTaxCollectorFightRequestMessage", [3189] = "HouseTeleportRequestMessage", [5530] = "FriendJoinRequestMessage", [3707] = "AllianceMemberStartWarningOnConnectionMessage", [1965] = "UpdateAllGuildRankRequestMessage", [3784] = "FriendSpouseFollowWithCompassRequestMessage", [5381] = "GuildRanksRequestMessage", [3682] = "SocialNoticeSetRequestMessage", [5517] = "GuildBulletinSetRequestMessage", [5387] = "AllianceUpdateRecruitmentInformationMessage", [4578] = "AllianceKickRequestMessage", [5991] = "GuildSpellUpgradeRequestMessage", [237] = "GuildCharacsUpgradeRequestMessage", [9594] = "SpouseGetInformationsMessage", [4732] = "WarnOnPermaDeathMessage", [592] = "GuildGetInformationsMessage", [9846] = "UpdateGuildRankRequestMessage", [7385] = "FriendSetWarnOnConnectionMessage", [1620] = "AllianceAllRanksUpdateRequestMessage", [1740] = "CreateGuildRankRequestMessage", [6633] = "PaginationRequestAbstractMessage", [7241] = "AllianceListApplicationRequestMessage", [8068] = "IgnoredGetListMessage", [5885] = "AllianceSubmitApplicationMessage", [695] = "GuildListApplicationRequestMessage", [3388] = "GuildMotdSetRequestMessage", [7051] = "GuildUpdateNoteMessage", [3927] = "GuildApplicationAnswerMessage", [8505] = "AllianceIsThereAnyApplicationMessage", [4007] = "AllianceSummaryRequestMessage", [1134] = "AllianceMemberStopWarningOnConnectionMessage", [9892] = "StartListenGuildChestStructureMessage", [5995] = "AllianceBulletinSetRequestMessage", [7645] = "IgnoredDeleteRequestMessage", [1951] = "GuildChangeMemberParametersMessage", [8909] = "AllianceApplicationListenMessage", [691] = "UpdateRecruitmentInformationMessage", [8299] = "AllianceUpdateApplicationMessage", [9081] = "FriendDeleteRequestMessage", [7562] = "ContactLookRequestMessage", [6048] = "ContactLookRequestByIdMessage", [9486] = "AllianceRankCreateRequestMessage", [5154] = "AllianceRightsUpdateMessage", [5713] = "FriendAddRequestMessage", [4213] = "PlayerStatusUpdateRequestMessage", [8533] = "GuildPaddockTeleportRequestMessage", [5112] = "IgnoredAddRequestMessage", [3428] = "AllianceRankRemoveRequestMessage", [7132] = "GuildDeleteApplicationRequestMessage", [7570] = "GuildUpdateApplicationMessage", [5816] = "FriendSetStatusShareMessage", [9738] = "GuildKickRequestMessage", [5367] = "GuildApplicationListenMessage", [7629] = "AllianceRanksRequestMessage", [2737] = "GuildJoinAutomaticallyRequestMessage", [64] = "AllianceRankUpdateRequestMessage", [468] = "AllianceJoinAutomaticallyRequestMessage", [6027] = "AllianceDeleteApplicationRequestMessage", [6143] = "GuildMemberStartWarnOnConnectionMessage", [2747] = "FriendGuildSetWarnOnAchievementCompleteMessage", [1892] = "AllianceChangeMemberRankMessage", [5524] = "RemoveGuildRankRequestMessage", [1163] = "GuildSummaryRequestMessage", [319] = "GuildLogbookInformationRequestMessage", [5069] = "GuildIsThereAnyApplicationMessage", [8788] = "GuildInvitationMessage", [5398] = "GuildGetPlayerApplicationMessage", [3631] = "AllianceGetPlayerApplicationMessage", [1212] = "AllianceGetRecruitmentInformationMessage", [4481] = "AcquaintancesGetListMessage", [2260] = "FriendSpouseJoinRequestMessage", [3081] = "StopListenGuildChestStructureMessage", [5437] = "FriendSetWarnOnLevelGainMessage", [2378] = "GuildSubmitApplicationMessage", [1488] = "AllianceMotdSetRequestMessage", [14] = "FriendsGetListMessage", [3888] = "UpdateGuildRightsMessage", [2763] = "AllianceInsiderInfoRequestMessage", [9692] = "AllianceApplicationAnswerMessage", [8625] = "GuildMemberStopWarnOnConnectionMessage", [5856] = "AllianceInvitationMessage", [663] = "PopupWarningCloseRequestMessage", [6914] = "ChatAbstractClientMessage", [7053] = "ChatClientPrivateMessage", [9502] = "ChatClientPrivateWithObjectMessage", [6420] = "MoodSmileyRequestMessage", [9020] = "ChatSmileyRequestMessage", [2893] = "ChatCommunityChannelSetCommunityRequestMessage", [6759] = "BasicWhoIsRequestMessage", [3932] = "ChatClientMultiMessage", [5473] = "ChatClientMultiWithObjectMessage", [4965] = "ChannelEnablingMessage", [2359] = "NumericWhoIsRequestMessage", [7730] = "PartyPledgeLoyaltyRequestMessage", [7118] = "PartyFollowMemberRequestMessage", [327] = "PartyFollowThisMemberRequestMessage", [9426] = "DungeonPartyFinderAvailableDungeonsRequestMessage", [9721] = "PartyRefuseInvitationMessage", [9125] = "PartyNameSetRequestMessage", [4870] = "SwitchArenaXpRewardsModeMessage", [6779] = "PartyLeaveRequestMessage", [3588] = "TeleportToBuddyAnswerMessage", [7230] = "GameRolePlayArenaFightAnswerMessage", [7804] = "PartyAbdicateThroneMessage", [2262] = "BreachInvitationAnswerMessage", [2855] = "GameRolePlayArenaRegisterMessage", [1816] = "GroupTeleportPlayerAnswerMessage", [7920] = "PartyInvitationRequestMessage", [2774] = "PartyInvitationArenaRequestMessage", [9359] = "DungeonPartyFinderListenRequestMessage", [8629] = "PartyInvitationDetailsRequestMessage", [425] = "PartyCancelInvitationMessage", [5145] = "PartyInvitationDungeonRequestMessage", [7102] = "DungeonPartyFinderRegisterRequestMessage", [326] = "GameRolePlayArenaUnregisterMessage", [4342] = "PartyAcceptInvitationMessage", [8393] = "PartyStopFollowRequestMessage", [7926] = "PartyKickRequestMessage", [4804] = "ShowCellRequestMessage", [3915] = "GameFightTurnFinishMessage", [4548] = "GameMapMovementRequestMessage", [6910] = "GameActionFightCastOnTargetRequestMessage", [6438] = "GameActionFightCastRequestMessage", [6930] = "FinishMoveSetRequestMessage", [2859] = "FinishMoveListRequestMessage", [1715] = "SpellVariantActivationRequestMessage", [4314] = "GameContextQuitMessage", [5483] = "BreachRoomUnlockRequestMessage", [3872] = "BreachRewardBuyMessage", [6366] = "BreachExitRequestMessage", [4588] = "BreachKickRequestMessage", [4414] = "BreachInvitationRequestMessage", [6707] = "EditHavenBagRequestMessage", [980] = "ChangeHavenBagRoomRequestMessage", [8480] = "EditHavenBagCancelRequestMessage", [5127] = "HavenBagFurnituresRequestMessage", [958] = "HavenBagPermissionsUpdateRequestMessage", [7398] = "OpenHavenBagFurnitureSequenceRequestMessage", [6165] = "CloseHavenBagFurnitureSequenceRequestMessage", [4899] = "ChangeThemeRequestMessage", [1472] = "ExitHavenBagRequestMessage", [299] = "PrismRecycleTradeRequestMessage", [7355] = "PrismTeleportationRequestMessage", [6564] = "AddTaxCollectorPresetSpellMessage", [995] = "SocialFightLeaveRequestMessage", [335] = "SocialFightJoinRequestMessage", [6339] = "StopListenAllianceFightMessage", [7755] = "SocialFightTakePlaceRequestMessage", [3876] = "StartListenTaxCollectorPresetsUpdatesMessage", [4043] = "StopListenTaxCollectorPresetsUpdatesMessage", [3417] = "NuggetsDistributionMessage", [6548] = "MoveTaxCollectorPresetSpellMessage", [4818] = "StopListenNuggetsMessage", [659] = "StartListenTaxCollectorUpdatesMessage", [4576] = "StopListenTaxCollectorUpdatesMessage", [448] = "StartListenAllianceFightMessage", [9951] = "RemoveTaxCollectorOrderedSpellMessage", [6858] = "SetEnableAVARequestMessage", [4559] = "StartListenNuggetsMessage", [8298] = "AddTaxCollectorOrderedSpellMessage", [6412] = "PrismAttackRequestMessage", [1588] = "PrismExchangeRequestMessage", [8918] = "MoveTaxCollectorOrderedSpellMessage", [5781] = "RemoveTaxCollectorPresetSpellMessage", [7043] = "GameFightPlacementPositionRequestMessage", [501] = "GameFightPlacementSwapPositionsRequestMessage", [2032] = "GameContextKickMessage", [9700] = "ChallengeReadyMessage", [5173] = "GameFightPlacementSwapPositionsCancelMessage", [4840] = "GameFightReadyMessage", [870] = "GameFightPlacementSwapPositionsAcceptMessage", [4209] = "SurrenderVoteCastMessage", [4015] = "SurrenderInfoRequestMessage", [4503] = "NotificationResetMessage", [5778] = "QuestStepInfoRequestMessage", [4330] = "WatchQuestStepInfoRequestMessage", [2136] = "UnfollowQuestObjectiveRequestMessage", [2928] = "TreasureHuntFlagRemoveRequestMessage", [6775] = "TreasureHuntFlagRequestMessage", [625] = "GuidedModeReturnRequestMessage", [7183] = "TreasureHuntLegendaryRequestMessage", [6433] = "GuidedModeQuitRequestMessage", [143] = "TreasureHuntGiveUpRequestMessage", [7114] = "QuestListRequestMessage", [518] = "AchievementsPioneerRanksRequestMessage", [2913] = "FollowQuestObjectiveRequestMessage", [1789] = "AchievementRewardRequestMessage", [8455] = "NotificationUpdateFlagMessage", [4654] = "QuestObjectiveValidationMessage", [7495] = "AchievementDetailsRequestMessage", [3965] = "RefreshFollowedQuestsOrderRequestMessage", [8398] = "QuestStartRequestMessage", [7960] = "AchievementDetailedListRequestMessage", [9909] = "AchievementAlmostFinishedDetailedListRequestMessage", [6696] = "TreasureHuntDigRequestMessage", [6808] = "AuthenticationTicketMessage", [6792] = "CharacterSelectionMessage", [3540] = "CharacterSelectionWithRemodelMessage", [2000] = "CharacterNameSuggestionRequestMessage", [2113] = "ConsumeGameActionItemMessage", [4057] = "CharacterSelectedForceReadyMessage", [2412] = "CharactersListRequestMessage", [491] = "CharacterCreationRequestMessage", [4275] = "CharacterCanBeCreatedRequestMessage", [8786] = "CharacterReplayRequestMessage", [338] = "CharacterReplayWithRemodelRequestMessage", [7638] = "CharacterFirstSelectionMessage", [5527] = "GameContextCreateRequestMessage", [1489] = "CharacterDeletionRequestMessage", [3120] = "ConsumeAllGameActionItemMessage", [1642] = "AcquaintanceSearchMessage", [4134] = "ServerSelectionMessage", [8254] = "ReportRequestMessage", [5396] = "CheckFileMessage", [7045] = "ResetCharacterStatsRequestMessage", [5002] = "StatsUpgradeRequestMessage", [101] = "PaddockToSellListRequestMessage", [3852] = "PaddockToSellFilterMessage", [6950] = "HouseToSellListRequestMessage", [9188] = "HouseToSellFilterMessage", [3251] = "SetEnablePVPRequestMessage", [946] = "CharacterAlignmentWarEffortProgressionRequestMessage", [5431] = "AlignmentWarEffortDonateRequestMessage", [4321] = "AlignmentWarEffortProgressionRequestMessage", [2730] = "ObjectAveragePricesGetMessage", [7722] = "ReloginTokenRequestMessage", [7452] = "AnomalySubareaInformationRequestMessage", [3373] = "ZaapRespawnSaveRequestMessage", [9439] = "TeleportRequestMessage", [5859] = "JobCrafterDirectoryDefineSettingsMessage", [7221] = "JobBookSubscribeRequestMessage", [5876] = "JobCrafterDirectoryListRequestMessage", [8008] = "ExchangeObjectUseInWorkshopMessage", [2953] = "ExchangeReplayStopMessage", [7189] = "ExchangeCraftCountRequestMessage", [7279] = "ExchangeMultiCraftSetCrafterCanUseHisRessourcesMessage", [2392] = "ExchangeCraftPaymentModificationRequestMessage", [3981] = "ExchangeSetCraftRecipeMessage", [4347] = "MountSetXpRatioRequestMessage", [7150] = "MountHarnessDissociateRequestMessage", [7545] = "MountInformationInPaddockRequestMessage", [1227] = "MountReleaseRequestMessage", [4391] = "MountHarnessColorsUpdateRequestMessage", [4115] = "MountRenameRequestMessage", [3038] = "MountFeedRequestMessage", [3319] = "ExchangeHandleMountsMessage", [5627] = "ExchangeRequestOnMountStockMessage", [826] = "MountInformationRequestMessage", [1106] = "MountToggleRidingRequestMessage", [658] = "MountSterilizeRequestMessage", [5369] = "HouseGuildShareRequestMessage", [7559] = "HouseKickRequestMessage", [1606] = "HouseSellRequestMessage", [9751] = "LockableChangeCodeMessage", [9529] = "HouseLockFromInsideRequestMessage", [5849] = "HouseBuyRequestMessage", [6061] = "HouseSellFromInsideRequestMessage", [9956] = "HouseGuildRightsViewMessage", [732] = "OrnamentSelectRequestMessage", [483] = "TitlesAndOrnamentsListRequestMessage", [5375] = "TitleSelectRequestMessage", [7052] = "PresetDeleteRequestMessage", [1372] = "ObjectUseMessage", [1310] = "ObjectUseMultipleMessage", [2531] = "ObjectDropMessage", [6591] = "IconPresetSaveRequestMessage", [6922] = "IconNamedPresetSaveRequestMessage", [5997] = "ObjectDeleteMessage", [375] = "AccessoryPreviewRequestMessage", [2126] = "ShortcutBarRemoveRequestMessage", [2165] = "ObjectUseOnCharacterMessage", [45] = "ShortcutBarSwapRequestMessage", [4046] = "ObjectUseOnCellMessage", [6013] = "ShortcutBarAddRequestMessage", [7506] = "PresetUseRequestMessage", [5569] = "ObjectSetPositionMessage", [6464] = "GuildUpdateChestTabRequestMessage", [3820] = "ExchangeBidHouseBuyMessage", [1454] = "ExchangeBidHousePriceMessage", [5862] = "ExchangeBidHouseSearchMessage", [6171] = "ExchangeBidHouseListMessage", [8802] = "ExchangeBidHouseTypeMessage", [1058] = "ExchangeObjectModifyPricedMessage", [4010] = "GameFightJoinRequestMessage", [3109] = "StopToListenRunningFightRequestMessage", [8994] = "GameFightSpectatePlayerRequestMessage", [337] = "MapRunningFightDetailsRequestMessage", [1925] = "MapRunningFightListRequestMessage", [804] = "ExchangeAcceptMessage", [9547] = "ExchangeReadyMessage", [885] = "FocusedExchangeReadyMessage", [2486] = "GameMapMovementCancelMessage", [5242] = "ChangeMapMessage", [920] = "GameCautiousMapMovementRequestMessage", [1424] = "InteractiveUseRequestMessage", [4603] = "TeleportPlayerAnswerMessage", [8117] = "InteractiveUseWithParamRequestMessage", [9329] = "GameRolePlayAttackMonsterRequestMessage", [3317] = "GameMapMovementConfirmMessage", [7773] = "ExchangeObjectMoveKamaMessage", [3544] = "ExchangeObjectTransfertExistingToInvMessage", [7537] = "ExchangeObjectTransfertListFromInvMessage", [9862] = "StartGuildChestContributionMessage", [1002] = "ExchangeObjectMoveToTabMessage", [4357] = "ExchangeObjectTransfertAllToInvMessage", [8793] = "ExchangeObjectTransfertListToInvMessage", [166] = "ExchangeObjectTransfertListWithQuantityToInvMessage", [1053] = "StopGuildChestContributionMessage", [1681] = "ExchangeObjectTransfertAllFromInvMessage", [5518] = "GuildGetChestTabContributionsRequestMessage", [7367] = "GuildSelectChestTabRequestMessage", [9675] = "ExchangeObjectTransfertExistingFromInvMessage", [4752] = "NpcDialogReplyMessage", [1669] = "PaddockBuyRequestMessage", [6528] = "PaddockSellRequestMessage", [3535] = "CharacterDeletionPrepareRequestMessage", [3558] = "AllianceInvitationAnswerMessage", [6811] = "AllianceModificationNameAndTagValidMessage", [5413] = "AllianceCreationValidMessage", [4239] = "AllianceModificationValidMessage", [5179] = "AllianceModificationEmblemValidMessage", [5328] = "GuildInvitationAnswerMessage", [4735] = "GuildModificationEmblemValidMessage", [4686] = "GuildModificationValidMessage", [5733] = "GuildModificationNameValidMessage", [1720] = "GuildCreationValidMessage", [8901] = "DiceRollRequestMessage", [368] = "TeleportBuddiesAnswerMessage", [5459] = "ForgettableSpellClientActionMessage", [5903] = "ActivityHideRequestMessage", [5447] = "ActivitySuggestionsRequestMessage", [5738] = "ActivityLockRequestMessage", [4581] = "HaapiBufferListRequestMessage", [7674] = "HaapiConfirmationRequestMessage", [6447] = "HaapiCancelBidRequestMessage", [9104] = "HaapiShopApiKeyRequestMessage", [2930] = "HaapiValidationRequestMessage", [5934] = "HaapiTokenRequestMessage", [2127] = "HaapiConsumeBufferRequestMessage", [1188] = "SequenceNumberMessage", [2511] = "LivingObjectChangeSkinRequestMessage", [9614] = "SymbioticObjectAssociateRequestMessage", [3754] = "MimicryObjectFeedAndAssociateRequestMessage", [5244] = "WrapperObjectDissociateRequestMessage", [7124] = "MimicryObjectEraseRequestMessage", [8437] = "LivingObjectDissociateMessage", [8727] = "ObjectFeedMessage", [5955] = "GameFightOptionToggleMessage", [3147] = "LockableUseCodeMessage", [390] = "BasicWhoAmIRequestMessage", [2233] = "BasicStatMessage", [6918] = "BasicStatWithDataMessage", [4987] = "PartyLocateMembersRequestMessage", [2776] = "ContactLookRequestByNameMessage", [1749] = "JobCrafterDirectoryEntryRequestMessage"}


GameServerTypeEnum = {
    [-1] = "Undefined",
    [0] = "Classical",
    [1] = "Hardcore",
    [2] = "Kolizeum",
    [3] = "Tournament",
    [4] = "Temporis"
}

ChatChannelsMultiEnum = {
    [0] = "CHANNEL_GLOBAL",
    [1] = "CHANNEL_TEAM",
    [2] = "CHANNEL_GUILD",
    [3] = "CHANNEL_ALLIANCE",
    [4] = "CHANNEL_PARTY",
    [5] = "CHANNEL_SALED",
    [6] = "CHANNEL_SEEK",
    [7] = "CHANNEL_NOOB",
    [8] = "CHANNEL_ADMIN",
    [9] = "PSEUDO_CHANNEL_PRIVATE",
    [10] = "PSEUDO_CHANNEL_INFO",
    [11] = "PSEUDO_CHANNEl_FIGHT_LOG",
    [12] = "CHANNEL_ADS",
    [13] = "CHANNEL_ARENA",
    [14] = "CHANNEL_COMMUNITY"
}
-- Custom Ankama's funtions to read data -- 

function readDate(bytes)
    local time = bytes:float()
    local secs = math.ceil(math.floor(time)/1e3)
    local nsecs = math.fmod(time, 1) * 1e9
    local nstime = NSTime.new(secs, nsecs)
    return nstime
end

function readVarInt(bytes)
    ans = 0
    d=0
    for i=0, 32, 7 do
        b = bytes:bytes():get_index(d)
        ans = ans + (bit.lshift(bit.band(b,0x7f),i))
        d = d+1
        if bit.band(b,0x80) == 0 then
            return ans
        end
    end
end

function readVarShort(bytes)
    ans = 0
    d=0
    for i=0, 16, 7 do
        b = bytes:bytes():get_index(d)
        ans = ans + (bit.lshift(bit.band(b,0x7f),i))
        d = d+1
        if bit.band(b,0x80) == 0 then
            return ans
        end
    end
end

function readVarLong(bytes)
    ans = 0
    d=0
    for i=0,64,7 do
        b = bytes:bytes():get_index(d)
        ans = ans + (bit.lshift(bit.band(b,0x7f),i))
        d = d+1
        if bit.band(b,0x80) == 0 then
            return ans
        end
    end   
end


local default_settings =
{
    enabled      = true, -- whether this dissector is enabled or not
    port         = 5555,
    max_msg_len  = 64000,
    desegment    = true, -- whether to TCP desegement or not
}

-- Proto Object
dofus_proto = Proto("dofus", "DOFUS")

----------------------------------------
-- a table of all of our Protocol's fields
dofus_proto.fields.protocolID = ProtoField.uint16("dofus.protocolID", "ProtocolID", base.DEC, DOFUS_MESSAGE_TYPES, 0xfffc)
dofus_proto.fields.lengthType = ProtoField.uint16("dofus.lengthType", "LengthType", base.DEC, nil, 0x3)
dofus_proto.fields.length = ProtoField.uint24("dofus.length", "Length", base.DEC)
dofus_proto.fields.seqID = ProtoField.uint32("dofus.seqID", "SequenceID", base.DEC)
dofus_proto.fields.data = ProtoField.bytes("dofus.data", "Data", base.NONE)

-- ProtocolRequired Field
dofus_proto.fields.protoVersion = ProtoField.string("dofus.protoVersion", "Version", base.ASCII)

-- ClientKeyMessage
dofus_proto.fields.key = ProtoField.string("dofus.key", "Key", base.ASCII)

-- IdentificationSuccessMessage Fields
dofus_proto.fields.login = ProtoField.string("dofus.login", "Login", base.ASCII)
dofus_proto.fields.accountTag = ProtoField.string("dofus.accountTag", "AccountTag", base.ASCII)
dofus_proto.fields.accountID = ProtoField.string("dofus.accountID", "AccountID", base.ASCII)
dofus_proto.fields.communityID = ProtoField.uint32("dofus.communityID", "CommunityID", base.DEC)
dofus_proto.fields.accountFlags = ProtoField.uint8("dofus.accountFlags", "Flags") 
dofus_proto.fields.hasRights = ProtoField.uint8("dofus.accountFlags.hasRigths", "HasRights", base.DEC, nil, 0x1)
dofus_proto.fields.hasForceRights = ProtoField.uint8("dofus.accountFlags.hasForceRigths", "HasForceRights", base.DEC, nil, 0x2)
dofus_proto.fields.wasAlreadyConnected = ProtoField.uint8("dofus.accountFlags.wasAlreadyConnected", "WasAlreadyConnected", base.DEC, nil, 0x4)
dofus_proto.fields.accountCreation = ProtoField.absolute_time("dofus.accountCreation" ,"AccountCreation", base.UTC)
dofus_proto.fields.subscriptionEndDate = ProtoField.absolute_time("dofus.subscriptionEndDate", "SubscriptionEndDate", base.UTC)
dofus_proto.fields.havenbagAvailableRoom = ProtoField.uint8("dofus.havenbagAvailableRoom", "HavenbagAvailableRoom", base.DEC)

-- ServersListMessage & GameServerInformations
dofus_proto.fields.serversLength = ProtoField.uint16("dofus.serversLength", "ServersLength", base.DEC)
dofus_proto.fields.serverFlags = ProtoField.uint8("dofus.serverFlags", "Flags")
dofus_proto.fields.isMonoAccount = ProtoField.uint8("dofus.isMonoAccount", "IsMonoAccount", base.DEC, nil, 0x1)
dofus_proto.fields.isSelectable = ProtoField.uint8("dofus.isSelectable" , "IsSelectable", base.DEC, nil, 0x2)
dofus_proto.fields.serverID = ProtoField.uint16("dofus.serverID", "ServerID", base.DEC)
dofus_proto.fields.serverType = ProtoField.uint8("dofus.serverType", "ServerType", base.DEC, GameServerTypeEnum)
dofus_proto.fields.serverStatus = ProtoField.uint8("dofus.serverStatus", "ServerStatus", base.DEC)
dofus_proto.fields.serverCompletion = ProtoField.uint8("dofus.serverCompletion", "ServerCompletion", base.DEC)
dofus_proto.fields.charactersCount = ProtoField.uint8("dofus.charactersCount", "CharactersCount", base.DEC)
dofus_proto.fields.charactersSlots = ProtoField.uint8("dofus.charactersSlots", "CharactersSlots", base.DEC)
dofus_proto.fields.serverDate = ProtoField.absolute_time("dofus.serverDate", "ServerDate", base.UTC)

-- SelectedServerDataMessage
dofus_proto.fields.serverAddress = ProtoField.string("dofus.serverAddress", "Address", base.ASCII)
dofus_proto.fields.numberOfPorts = ProtoField.uint16("dofus.numberOfPorts", "NumberOfPorts", base.DEC)
dofus_proto.fields.serverPorts = ProtoField.uint16("dofus.serverPorts", "Port", base.DEC)
dofus_proto.fields.canCreateNewCharacter = ProtoField.uint8("dofus.canCreateNewCharacter", "CanCreateNewCharacter", base.BOOL)
dofus_proto.fields.numberOfTickets = ProtoField.uint8("dofus.numberOfTickets", "NumberOfTickets", base.DEC)
dofus_proto.fields.serverTickets = ProtoField.uint8("dofus.serverTickets", "Ticket", base.DEC)

-- AuthenticationTicketMessage
dofus_proto.fields.lang = ProtoField.string("dofus.lang", "Language", base.ASCII)
dofus_proto.fields.ticket = ProtoField.string("dofus.ticket","Ticket", base.ASCII)

--BasicAckMessage
dofus_proto.fields.ackSeq = ProtoField.uint8("dofus.ackSeq", "Seq", base.DEC)
dofus_proto.fields.lastPacketID = ProtoField.uint16("dofus.lastPacketId", "LastPacketId", base.DEC)

-- BasicTimeMessage
dofus_proto.fields.timestamp = ProtoField.absolute_time("dofus.timestamp", "Timestamp", base.UTC)
dofus_proto.fields.timezoneOffset = ProtoField.uint16("dofus.timezoneOffset", "TimezoneOffset", base.DEC)

-- ServerSettingsMessage
dofus_proto.fields.hasFreeAutopilot = ProtoField.uint8("dofus.hasFreeAutopilot", "HasFreeAutopilot", base.DEC, nil, 0x2)
dofus_proto.fields.gameType = ProtoField.uint8("dofus.gameType", "GameType", base.DEC)
dofus_proto.fields.arenaLeaveBanTime = ProtoField.uint16("dofus.arenaLeaveBanTime", "ArenaLeaveBanTime", base.DEC)
dofus_proto.fields.itemMaxLevel = ProtoField.uint24("dofus.itemMaxLevel", "ItemMaxLevel", base.DEC)

-- ServerSessionConstantsMessage
dofus_proto.fields.numberOfConstants = ProtoField.uint16("dofus.numberOfConstants", "NumberOfConstants", base.DEC)
dofus_proto.fields.constantId = ProtoField.uint16("dofus.constantId", "Id", base.DEC)
dofus_proto.fields.constantInstance = ProtoField.uint16("dofus.constantInstance" , "Instance", base.DEC)

-- TrustStatusMessage
dofus_proto.fields.certified = ProtoField.uint8("dofus.certified", "Certified", base.DEC)

-- AccountSubscriptionElapsedDurationMessage
dofus_proto.fields.subscriptionElapsedDuration = ProtoField.absolute_time("dofus.subscriptionElapsedDuration", "SubscriptionElapsedDuration", base.UTC)

-- HaapiApiKeyMessage & HaapiShopApiKeyMessage
dofus_proto.fields.token = ProtoField.string("dofus.token", "Token", base.ASCII)

-- QueueStatusMessage
dofus_proto.fields.queuePosition = ProtoField.uint16("queuePosition", "Position", base.DEC)
dofus_proto.fields.queueTotal = ProtoField.uint16("queueTotal", "Total", base.DEC)

-- CharactersListMessage & CharaterBaseInformations
dofus_proto.fields.numberOfCharacters = ProtoField.uint16("dofus.numberOfCharacters","NumberOfCharacters", base.DEC)
dofus_proto.fields.characterSex = ProtoField.uint8("dofus.characterSex" , "Sex", base.DEC)
dofus_proto.fields.characterId = ProtoField.uint24("dofus.characterId", "CharacterId", base.DEC)
dofus_proto.fields.characterName = ProtoField.string("dofus.characterName", "Name", base.ASCII)
dofus_proto.fields.characterLevel = ProtoField.uint8("dofus.characterLevel", "Level", base.DEC)
dofus_proto.fields.characterBonesId = ProtoField.uint16("dofus.characterBonesId", "BonesId", base.DEC)
dofus_proto.fields.skinsLength = ProtoField.uint16("dofus.skinsLenght", "SkinsLength", base.DEC)
dofus_proto.fields.skin = ProtoField.uint16("dofus.skin", "Skin", base.DEC)
dofus_proto.fields.indexedColorsLength = ProtoField.uint16("dofus.indexedColorsLength", "IndexedColorsLength", base.DEC)
dofus_proto.fields.indexedColor = ProtoField.uint32("dofus.indexedColor", "IndexedColor", base.DEC)
dofus_proto.fields.scalesLength = ProtoField.uint16("dofus.scalesLength", "ScalesLength", base.DEC)
dofus_proto.fields.scale = ProtoField.uint16("dofus.scale", "Scale", base.DEC)
dofus_proto.fields.subentitiesLength = ProtoField.uint16("dofus.subentitiesLength", "SubentitiesLength", base.DEC)
dofus_proto.fields.subentitie = ProtoField.uint16("dofus.subentitie" ,"Subentitie" , base.DEC)
dofus_proto.fields.characterBreed = ProtoField.uint8("dofus.characterBreed", "Breed", base.DEC)

-- FriendsListMessage & FriendInformations
dofus_proto.fields.numberOfFriends = ProtoField.uint16("dofus.numberOfFriends", "NumberOfFriends", base.DEC)
dofus_proto.fields.friendId = ProtoField.uint32("dofus.friendId", "FriendId", base.DEC)
dofus_proto.fields.nickname = ProtoField.string("dofus.nickname", "Nickname", base.ASCII)
dofus_proto.fields.playerState = ProtoField.uint8("dofus.playerState", "PlayerState", base.DEC)
dofus_proto.fields.lastConnection = ProtoField.uint16("dofus.lastConnection", "LastConnection", base.DEC)
dofus_proto.fields.achievementPoints = ProtoField.uint32("dofus.achievementPoints", "AchievementPoints", base.DEC)
dofus_proto.fields.leagueId = ProtoField.uint16("dofus.leagueId", "LeagueId", base.DEC)
dofus_proto.fields.ladderPosition = ProtoField.uint32("dofus.ladderPosition", "LadderPosition", base.DEC)

-- KamasUpdateMessage & StoraheKamasUpdate
dofus_proto.fields.kamasTotal = ProtoField.uint24("dofus.kamasTotal", "KamasTotal", base.DEC)

-- BasicPongMessage & BasicPingMessage
dofus_proto.fields.quiet = ProtoField.uint8("dofus.quiet", "Quiet", base.DEC)

-- ChatServerMessage & ChatClientMultiMessage & ChatAbstractClientMessage
dofus_proto.fields.channel = ProtoField.uint8("dofus.channel", "Channel", base.DEC, ChatChannelsMultiEnum)
dofus_proto.fields.messContent = ProtoField.string("dofus.messContent", "Content", base.ASCII)
dofus_proto.fields.messTimestamp = ProtoField.absolute_time("dofus.messTimestamp", "Timestamp", base.UTC)
dofus_proto.fields.messFingerprint = ProtoField.string("dofus.messFingerprint", "Fingerprint", base.ASCII)
dofus_proto.fields.senderId = ProtoField.double("dofus.senderId", "SenderId", base.FLOAT)
dofus_proto.fields.senderName = ProtoField.string("dofus.senderName", "SenderName", base.ASCII)
dofus_proto.fields.prefix = ProtoField.string("dofus.prefix", "Prefix", base.ASCII)
dofus_proto.fields.senderAccountId = ProtoField.uint32("dofus.senderAccountId", "SenderAccountId", base.DEC)

-- MapInformationsRequestMessage & MapComplementaryInformationsDataMessage
dofus_proto.fields.subAreaId = ProtoField.uint16("dofus.subAreaId", "SubAreaId", base.DEC)
dofus_proto.fields.mapId = ProtoField.double("dofus.mapId", "MapId", base.DEC)
dofus_proto.fields.numberOfHouses = ProtoField.uint16("dofus.numberOfHouses", "NumberOfHouses", base.DEC)
dofus_proto.fields.numberOfActors = ProtoField.uint16("dofus.numberOfActors", "NumberOfActors", base.DEC)
dofus_proto.fields.numberOfInteractiveElements = ProtoField.uint16("dofus.numberOfInteractiveElements", "NumberOfInteractiveElements", base.DEC)
dofus_proto.fields.numberOfStatedElements = ProtoField.uint16("dofus.numberOfStatedElements", "NumberOfStatedElements", base.DEC)
dofus_proto.fields.numberOfObstacles = ProtoField.uint16("dofus.numberOfObstacles", "NumberOfObstacles", base.DEC)
dofus_proto.fields.numberOfFights = ProtoField.uint16("dofus.numberOfFights", "NumberOfFights", base.DEC)
dofus_proto.fields.hasAggressiveMonsters = ProtoField.uint8("dofus.hasAggressiveMonsters", "HasAggressiveMonsters", base.DEC)

-- ChangeMapMessage
dofus_proto.fields.autopilot = ProtoField.uint8("dofus.autopilot", "Autopilot", base.DEC)

-- HouseInformations
dofus_proto.fields.houseId = ProtoField.uint32("dofus.houseId", "HouseId", base.DEC)
dofus_proto.fields.modelId = ProtoField.uint16("dofus.modelId", "ModelId", base.DEC)

-- GameContextActorInformations 

-- GameContextActorPositionInformations
dofus_proto.fields.contextualId = ProtoField.double("dofus.contextualID", "ContextualId", base.FLOAT)

-- EntityDispositionInformations
dofus_proto.fields.cellId = ProtoField.uint16("dofus.cellId", "CellId", base.DEC)
dofus_proto.fields.direction = ProtoField.uint8("dofus.direction", "Direction", base.DEC)

-- SetCharacterRestrictionsMessage
dofus_proto.fields.actorId = ProtoField.double("dofus.actorId", "ActorId", base.FLOAT)

-- ActorRestrictionsInformations
dofus_proto.fields.restriction1 = ProtoField.uint8("dofus.restriction1", "Restriction 1", base.DEC)
dofus_proto.fields.cantBeAggressed = ProtoField.uint8("dofus.restriction1.cantBeAggressed", "CantBeAggressed", base.DEC, nil, 0x1)
dofus_proto.fields.cantBeChallenged = ProtoField.uint8("dofus.restriction1.cantBeChallenged", "CantBeChallenged", base.DEC, nil, 0x2)
dofus_proto.fields.cantTrade = ProtoField.uint8("dofus.restriction1.cantTrade", "CantTrade", base.DEC, nil, 0x4)
dofus_proto.fields.cantBeAttackedByMutant = ProtoField.uint8("dofus.restriction1.cantBeAttackedByMutant", "CantBeAttackedByMutant", base.DEC, nil, 0x8)
dofus_proto.fields.cantRun = ProtoField.uint8("dofus.restriction1.cantRun", "CantRun", base.DEC, nil, 0x10)
dofus_proto.fields.forceSlowWalk = ProtoField.uint8("dofus.restriction1.forceSlowWalk", "ForceSlowWalk", base.DEC, nil, 0x20)
dofus_proto.fields.cantMinimize = ProtoField.uint8("dofus.restriction1.cantMinimize", "CantMinimize", base.DEC, nil, 0x40)
dofus_proto.fields.cantMove = ProtoField.uint8("dofus.restriction1.cantMove", "CantMove", base.DEC, nil, 0x80)
dofus_proto.fields.restriction2 = ProtoField.uint8("dofus.restriction2", "Restriction 2", base.DEC)
dofus_proto.fields.cantAggress = ProtoField.uint8("dofus.restriction2.cantAggress", "CantAggress", base.DEC, nil, 0x1)
dofus_proto.fields.cantChallenge = ProtoField.uint8("dofus.restriction2.cantChallenge", "CantChallenge", base.DEC, nil, 0x2)
dofus_proto.fields.cantExchange = ProtoField.uint8("dofus.restriction2.cantExchange", "CantExchange", base.DEC, nil, 0x4)
dofus_proto.fields.cantAttack = ProtoField.uint8("dofus.restriction2.cantAttack", "CantAttack", base.DEC, nil, 0x8)
dofus_proto.fields.cantChat = ProtoField.uint8("dofus.restriction2.cantChat", "CantChat", base.DEC, nil, 0x10)
dofus_proto.fields.cantUseObject = ProtoField.uint8("dofus.restriction2.cantUseObject", "CantUseObject", base.DEC, nil, 0x20)
dofus_proto.fields.cantUseTaxCollector = ProtoField.uint8("dofus.restriction2.cantUseTaxCollector", "CantUseTaxCollector", base.DEC, nil, 0x40)
dofus_proto.fields.cantUseInteractive = ProtoField.uint8("dofus.restriction2.cantUseInteractive", "CantUseInteractive", base.DEC, nil, 0x80)
dofus_proto.fields.restriction3 = ProtoField.uint8("dofus.restriction3", "Restriction 3", base.DEC)
dofus_proto.fields.cantSpeakToNPC = ProtoField.uint8("dofus.restriction3.cantSpeakToNPC", "CantSpeakToNPC", base.DEC, nil, 0x1)
dofus_proto.fields.cantChangeZone = ProtoField.uint8("dofus.restriction3.cantChangeZone", "CantChangeZone", base.DEC, nil, 0x2)
dofus_proto.fields.cantAttackMonster = ProtoField.uint8("dofus.restriction3.cantAttackMonster", "CantAttackMonster", base.DEC, nil, 0x4)

-- GameMapMovementMessage & GameMapMovementRequestMessage
dofus_proto.fields.numberOfKeyMovements = ProtoField.uint16("dofus.numberOfKeyMovements", "NumberOfKeyMovements", base.DEC)
dofus_proto.fields.keyMovement = ProtoField.uint16("dofus.keyMovement", "KeyMovement", base.DEC)
dofus_proto.fields.forcedDirection = ProtoField.uint16("dofus.forcedDirection", "ForceDirection", base.DEC)

-- BasicLatencyStatsMessage
dofus_proto.fields.latency = ProtoField.uint16("dofus.latency", "Latency", base.DEC)
dofus_proto.fields.sampleCount = ProtoField.uint16("dofus.sampleCount", "SampleCount", base.DEC)
dofus_proto.fields.maxSampleCount = ProtoField.uint16("dofus.maxSampleCount", "MaxSampleCount", base.DEC)

-- ChatServerWithObjectMessage
dofus_proto.fields.numberOfObjects = ProtoField.uint16("dofus.numberOfObjects", "NumberOfObjects", base.DEC)

-- ObjectItem
dofus_proto.fields.objectPosition = ProtoField.uint16("dofus.objectPosition", "Position", base.DEC)
dofus_proto.fields.objectGID = ProtoField.uint32("dofus.objectGID", "ObjectGID", base.DEC)
dofus_proto.fields.numberOfEffects = ProtoField.uint16("dofus.numberOfEffects", "NumberOfEffects", base.DEC)
dofus_proto.fields.objectUID = ProtoField.uint32("dofus.objectUID", "ObjectUID", base.DEC)
dofus_proto.fields.objectQuantity = ProtoField.uint32("dofus.objectQuantity", "ObjectQuantity", base.DEC)

-- ObjectEffect
dofus_proto.fields.objectActionId = ProtoField.uint32("dofus.objectActionId","ActionId", base.DEC)

-- CharacterLevelUpMessage
dofus_proto.fields.newLevel = ProtoField.uint16("dofus.nexLevel", "NewLevel", base.DEC)

-- CharacterDeletionPrepareMessage
dofus_proto.fields.secretQuestion = ProtoField.string("dofus.secretQuestion", "SecretQuestion", base.ASCII)
dofus_proto.fields.needSecretAnswer = ProtoField.uint8("dofus.needSecretAnswer", "NeedSecretAnswer", base.DEC)

-- CharacterDeletionRequestMessage
dofus_proto.fields.secretAnswerHash = ProtoField.string("dofus.secretAnswerHash", "SecretAnswerHash", base.ASCII)

-- ExchangePlayerRequest
dofus_proto.fields.target = ProtoField.uint64("dofus.target", "target", base.DEC)

-- ExchangeKamaModifiedMessage
dofus_proto.fields.quantity = ProtoField.uint24("dofus.quantity", "quantity", base.DEC)

-- this is the size of the Dofus response/request message header (variable)
local DOFUS_RESPONSE_MSG_HDR_LEN = 2
local DOFUS_REQUEST_MSG_HDR_LEN = 6

--------------------------------------------------------------------------------
-- The following creates the callback function for the dissector.
-- It's the same as doing "dofus_proto.dissector = function (tvbuf,pkt,root)"
-- The 'tvbuf' is a Tvb object, 'pinfo' is a Pinfo object, and 'root' is a TreeItem object.
-- Whenever Wireshark dissects a packet that our Proto is hooked into, it will call
-- this function and pass it these arguments for the packet it's dissecting.
function dofus_proto.dissector(tvbuf, pinfo, root)

    -- Clear info column
    pinfo.cols.info:clear()

    -- get the length of the packet buffer (Tvb).
    local pktlen = tvbuf:len()

    local bytes_consumed = 0

    -- we do this in a while loop, because there could be multiple DOFUS messages
    -- inside a single TCP segment, and thus in the same tvbuf - but our
    -- dofus_proto.dissector() will only be called once per TCP segment, so we
    -- need to do this loop to dissect each DOFUS message in it

    -- For response packets
    if pinfo.src_port == 5555 then
        while bytes_consumed < pktlen do

            -- We're going to call our "dissect()" function, which is defined
            -- later in this script file. The dissect() function returns the
            -- length of the DOFUS message it dissected as a positive number, or if
            -- it's a negative number then it's the number of additional bytes it
            -- needs if the Tvb doesn't have them all. If it returns a 0, it's a
            -- dissection error.

            local result = dissectDofusResponse(tvbuf, pinfo, root, bytes_consumed)

            if result > 0 then
                -- we successfully processed an DOFUS message, of 'result' length
                bytes_consumed = bytes_consumed + result
                -- go again on another while loop
            elseif result == 0 then
                -- If the result is 0, then it means we hit an error of some kind,
                -- so return 0. Returning 0 tells Wireshark this packet is not for
                -- us, and it will try heuristic dissectors or the plain "data"
                -- one, which is what should happen in this case.
                return 0
            else
                -- we need more bytes, so set the desegment_offset to what we
                -- already consumed, and the desegment_len to how many more
                -- are needed
                pinfo.desegment_offset = bytes_consumed

                -- invert the negative result so it's a positive number
                result = -result

                pinfo.desegment_len = result

                -- even though we need more bytes, this packet is for us, so we
                -- tell wireshark all of its bytes are for us by returning the
                -- number of Tvb bytes we "successfully processed", namely the
                -- length of the Tvb
                return pktlen
            end        
        end

        -- In a TCP dissector, you can either return nothing, or return the number of
        -- bytes of the tvbuf that belong to this protocol, which is what we do here.
        -- Do NOT return the number 0, or else Wireshark will interpret that to mean
        -- this packet did not belong to your protocol, and will try to dissect it
        -- with other protocol dissectors (such as heuristic ones)
        return bytes_consumed

    -- For request packets
    else
        while bytes_consumed < pktlen do

            -- We're going to call our "dissect()" function, which is defined
            -- later in this script file. The dissect() function returns the
            -- length of the DOFUS message it dissected as a positive number, or if
            -- it's a negative number then it's the number of additional bytes it
            -- needs if the Tvb doesn't have them all. If it returns a 0, it's a
            -- dissection error.

            local result = dissectDofusRequest(tvbuf, pinfo, root, bytes_consumed)

            if result > 0 then
                -- we successfully processed an DOFUS message, of 'result' length
                bytes_consumed = bytes_consumed + result
                -- go again on another while loop
            elseif result == 0 then
                -- If the result is 0, then it means we hit an error of some kind,
                -- so return 0. Returning 0 tells Wireshark this packet is not for
                -- us, and it will try heuristic dissectors or the plain "data"
                -- one, which is what should happen in this case.
                return 0
            else
                -- we need more bytes, so set the desegment_offset to what we
                -- already consumed, and the desegment_len to how many more
                -- are needed
                pinfo.desegment_offset = bytes_consumed

                -- invert the negative result so it's a positive number
                result = -result

                pinfo.desegment_len = result

                -- even though we need more bytes, this packet is for us, so we
                -- tell wireshark all of its bytes are for us by returning the
                -- number of Tvb bytes we "successfully processed", namely the
                -- length of the Tvb
                return pktlen
            end        
        end
        -- In a TCP dissector, you can either return nothing, or return the number of
        -- bytes of the tvbuf that belong to this protocol, which is what we do here.
        -- Do NOT return the number 0, or else Wireshark will interpret that to mean
        -- this packet did not belong to your protocol, and will try to dissect it
        -- with other protocol dissectors (such as heuristic ones)
        return bytes_consumed
    end
end


----------------------------------------
-- The following is a local function used for dissecting our DOFUS messages
-- inside the TCP segment using the desegment_offset/desegment_len method.
-- It's a separate function because we run over TCP and thus might need to
-- parse multiple messages in a single segment/packet. So we invoke this
-- function only dissects one DOFUS message and we invoke it in a while loop
-- from the Proto's main disector function.
--
-- This function is passed in the original Tvb, Pinfo, and TreeItem from the Proto's
-- dissector function, as well as the offset in the Tvb that this function should
-- start dissecting from.
--
-- This function returns the length of the DOFUS message it dissected as a
-- positive number, or as a negative number the number of additional bytes it
-- needs if the Tvb doesn't have them all, or a 0 for error.
--
function dissectDofusResponse(tvbuf, pinfo, root, offset)

    -- set the protocol column to show our protocol name
    pinfo.cols.protocol:set("DOFUS")

    -- If we need more byte for the header
    if tvbuf:len() - offset < DOFUS_RESPONSE_MSG_HDR_LEN then return -DESEGMENT_ONE_MORE_SEGMENT
    elseif tvbuf:len() - offset < DOFUS_RESPONSE_MSG_HDR_LEN + tvbuf(offset,2):bitfield(14,2) then return -DESEGMENT_ONE_MORE_SEGMENT end
    
    -- Set the function name into the info column
    if DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] ~= nil then
        pinfo.cols.info:append(DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] .. "; ")
    end

    -- Get the size of the len field
    local lenType = tvbuf(offset,2):bitfield(14,2)
    
    -- If the size_len is equal to 0, this means that the function used does not require a pdu
    if lenType ~= 0 then

        local length_val, length_tvbr = checkDofusResponseLength(tvbuf, offset) -- Get the value of the len field and tvbuf

        if length_val <= 0 then
            return length_val
        end

        -- if we got here, then we have a whole message in the Tvb buffer
        -- so let's finish dissecting it...

        -- We start by adding our protocol to the dissection display tree.
        local tree = root:add(dofus_proto, tvbuf:range(offset, length_val))

        -- dissect the protocolID field
        local protocolID_tvbr = tvbuf:range(offset, 2)

        tree:add(dofus_proto.fields.protocolID, protocolID_tvbr)    

        -- dissect the length type field
        local lengthType_tvbr = tvbuf:range(offset, 2)
        tree:add(dofus_proto.fields.lengthType, lengthType_tvbr)

        -- dissect the length field
        local lenValue = tvbuf(offset+2, lenType):uint()
        tree:add(dofus_proto.fields.length, length_tvbr)

        dissectDofusAPDU(tvbuf, tree, offset, DOFUS_RESPONSE_MSG_HDR_LEN+lengthType_tvbr:bitfield(14,2), lenValue)

        return length_val -- Return the number of bytes consummed
    else

        -- We start by adding our protocol to the dissection display tree.
        local tree = root:add(dofus_proto, tvbuf:range(offset, DOFUS_RESPONSE_MSG_HDR_LEN))

        -- dissect the protocolID field
        local protocolID_tvbr = tvbuf:range(offset, 2) 

        tree:add(dofus_proto.fields.protocolID, protocolID_tvbr)    

        -- dissect the length type field
        local lengthType_tvbr = tvbuf:range(offset, 2)
        tree:add(dofus_proto.fields.lengthType, lengthType_tvbr)

        return DOFUS_RESPONSE_MSG_HDR_LEN -- Return header size
    end
end


----------------------------------------
-- The function to check the length field.
--
-- This returns two things: (1) the length, and (2) the TvbRange object, which
-- might be nil if length <= 0.
checkDofusResponseLength = function (tvbuf, offset)

    -- "msglen" is the number of bytes remaining in the Tvb buffer which we
    -- have available to dissect in this run 
    local msglen = tvbuf:len() - offset

    -- check if capture was only capturing partial packet size
    if msglen ~= tvbuf:reported_length_remaining(offset) then
        -- captured packets are being sliced/cut-off, so don't try to desegment/reassemble
        return 0
    end


    if msglen < DOFUS_RESPONSE_MSG_HDR_LEN then
        -- we need more bytes, so tell the main dissector function that we
        -- didn't dissect anything, and we need an unknown number of more
        -- bytes (which is what "DESEGMENT_ONE_MORE_SEGMENT" is used for)
        -- return as a negative number
        return -DESEGMENT_ONE_MORE_SEGMENT
    end

    -- if we got here, then we know we have enough bytes in the Tvb buffer
    -- to at least figure out the full length of this DOFUS messsage (the length
    -- is the 16-bit integer in third and fourth bytes)

    local lenType = tvbuf(offset,2):bitfield(14,2)

    -- get the TvbRange of bytes 3+4
    local length_tvbr = tvbuf:range(offset + 2, lenType)

    -- get the length as an unsigned integer, in network-order (big endian)
    local length_val  = length_tvbr:uint() + 2 + lenType

    if length_val > default_settings.max_msg_len then
        -- too many bytes, invalid message
        return 0
    end

    if msglen < length_val then
        -- we need more bytes to get the whole DOFUS message
        return -(length_val - msglen)
    end

    return length_val, length_tvbr
end


function dissectDofusRequest(tvbuf, pinfo, root, offset)

    -- set the protocol column to show our protocol name
    pinfo.cols.protocol:set("DOFUS")

    -- If we need more byte for the header
    if tvbuf:len() - offset < DOFUS_RESPONSE_MSG_HDR_LEN then return -DESEGMENT_ONE_MORE_SEGMENT
    elseif tvbuf:len() - offset < DOFUS_RESPONSE_MSG_HDR_LEN + tvbuf(offset,2):bitfield(14,2) then return -DESEGMENT_ONE_MORE_SEGMENT end

    -- Set the function name into the info column
    if DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] ~= nil then
        pinfo.cols.info:append(DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] .. "; ")
    end

    -- Get the size of the len field
    local lenType = tvbuf(offset,2):bitfield(14,2)

    if lenType ~= 0 then

        local length_val, length_tvbr = checkDofusRequestLength(tvbuf, offset) -- Get the value of the len field and tvbuf


        if length_val <= 0 then
            return length_val
        end

        -- if we got here, then we have a whole message in the Tvb buffer
        -- so let's finish dissecting it...

        -- We start by adding our protocol to the dissection display tree.
        local tree = root:add(dofus_proto, tvbuf:range(offset, length_val))

        -- dissect the protocolID field
        local protocolID_tvbr = tvbuf:range(offset, 2)
        tree:add(dofus_proto.fields.protocolID, protocolID_tvbr)    

        -- dissect the length type field
        local lengthType_tvbr = tvbuf:range(offset, 2)
        tree:add(dofus_proto.fields.lengthType, lengthType_tvbr)

        -- dissect the sequence ID field
        local seqID_tvbr = tvbuf:range(offset+2, 4)
        tree:add(dofus_proto.fields.seqID, seqID_tvbr)

        -- dissect the length field
        local lenValue = tvbuf(offset+6, lenType):uint()
        tree:add(dofus_proto.fields.length, length_tvbr)

        dissectDofusAPDU(tvbuf, tree, offset, DOFUS_REQUEST_MSG_HDR_LEN+lengthType_tvbr:bitfield(14,2), lenValue)

        return length_val -- Return the numbre of bytes consummed
    else
        -- We start by adding our protocol to the dissection display tree.
        local tree = root:add(dofus_proto, tvbuf:range(offset, DOFUS_REQUEST_MSG_HDR_LEN))

        -- dissect the protocolID field
        local protocolID_tvbr = tvbuf:range(offset, 2)

        tree:add(dofus_proto.fields.protocolID, protocolID_tvbr)    

        -- dissect the length type field
        local lengthType_tvbr = tvbuf:range(offset, 2)
        tree:add(dofus_proto.fields.lengthType, lengthType_tvbr)

        -- dissect the sequence ID field
        local seqID_tvbr = tvbuf:range(offset+2, 4)
        tree:add(dofus_proto.fields.seqID, seqID_tvbr)

        return DOFUS_REQUEST_MSG_HDR_LEN -- Return header size
    end

end


----------------------------------------
-- Function to check the length field.
--
-- This returns two things: (1) the length, and (2) the TvbRange object, which
-- might be nil if length <= 0.
checkDofusRequestLength = function (tvbuf, offset)

    -- "msglen" is the number of bytes remaining in the Tvb buffer which we
    -- have available to dissect in this run
   
    local msglen = tvbuf:len() - offset

    -- check if capture was only capturing partial packet size
    if msglen ~= tvbuf:reported_length_remaining(offset) then
        -- captured packets are being sliced/cut-off, so don't try to desegment/reassemble
        return 0
    end

    if msglen < DOFUS_REQUEST_MSG_HDR_LEN then
        -- we need more bytes, so tell the main dissector function that we
        -- didn't dissect anything, and we need an unknown number of more
        -- bytes (which is what "DESEGMENT_ONE_MORE_SEGMENT" is used for)
        -- return as a negative number
        return -DESEGMENT_ONE_MORE_SEGMENT
    end

    -- if we got here, then we know we have enough bytes in the Tvb buffer
    -- to at least figure out the full length of this DOFUS messsage (the length
    -- is the 16-bit integer in third and fourth bytes)


    local lenType = tvbuf(offset,2):bitfield(14,2)

    -- get the TvbRange of bytes 3+4
    local length_tvbr = tvbuf:range(offset + 6, lenType)

    -- get the length as an unsigned integer, in network-order (big endian)
    local length_val  = length_tvbr:uint() + 6 + lenType

    if length_val > default_settings.max_msg_len then
        -- too many bytes, invalid message
        return 0
    end

    if msglen < length_val then
        -- we need more bytes to get the whole DOFUS message
        return -(length_val - msglen)
    end

    return length_val, length_tvbr
end


function dissectDofusAPDU(tvbuf, tree, offset, header_size, lenValue)

    if DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "ProtocolRequired" then ProtocolRequired(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "ClientKeyMessage" then ClientKeyMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "IdentificationSuccessMessage" then IdentificationSuccessMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "ServersListMessage" then ServersListMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "SelectedServerDataMessage" then SelectedServerDataMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "AuthenticationTicketMessage" then AuthenticationTicketMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "BasicAckMessage" then BasicAckMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "BasicTimeMessage" then BasicTimeMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "ServerSettingsMessage" then ServerSettingsMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "TrustStatusMessage" then TrustStatusMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "AccountSubscriptionElapsedDurationMessage" then AccountSubscriptionElapsedDurationMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "HaapiApiKeyMessage" then HaapiApiKeyMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "HaapiShopApiKeyMessage" then HaapiShopApiKeyMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "QueueStatusMessage" then QueueStatusMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "FriendsListMessage" then FriendsListMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "KamasUpdateMessage" then KamasUpdateMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "StorageKamasUpdateMessage" then StorageKamasUpdateMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "CharactersListMessage" then CharactersListMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "BasicPingMessage" then BasicPingMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "BasicPongMessage" then BasicPongMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "ChatServerMessage" then ChatServerMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "ChatClientMultiMessage" then ChatClientMultiMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "MapInformationsRequestMessage" then MapInformationsRequestMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "MapComplementaryInformationsDataMessage" then MapComplementaryInformationsDataMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "SetCharacterRestrictionsMessage" then SetCharacterRestrictionsMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "GameMapMovementRequestMessage" then GameMapMovementRequestMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "GameMapMovementMessage" then GameMapMovementMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "BasicLatencyStatsMessage" then BasicLatencyStatsMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "ChatServerWithObjectMessage" then ChatServerWithObjectMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "CharacterLevelUpInformationMessage" then CharacterLevelUpInformationMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "CharacterLevelUpMessage" then CharacterLevelUpMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "CharacterDeletionPrepareRequestMessage" then CharacterDeletionPrepareRequestMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "CharacterDeletionRequestMessage" then CharacterDeletionRequestMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "ChangeMapMessage" then ChangeMapMessage(tvbuf, tree, offset, header_size)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "ExchangePlayerRequestMessage" then ExchangePlayerRequestMessage(tvbuf, tree, offset, header_size, lenValue)
    elseif DOFUS_MESSAGE_TYPES[tvbuf(offset,2):bitfield(0,14)] == "ExchangeKamaModifiedMessage" then ExchangeKamaModifiedMessage(tvbuf, tree, offset, header_size, lenValue)

        -- elseif tvbuf(offset,2):bitfield(0,14) == "ServerSessionConstantsMessage" then ServerSessionConstantsMessage(tvbuf, tree, offset, header_size)
    else
        -- dissect the data field
        tree:add(dofus_proto.fields.data, tvbuf(offset+header_size, lenValue))
    end

end


function ProtocolRequired(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.protoVersion, tvbuf(offset+header_size+2, tvbuf(offset+header_size, 2):int()))
end

function ClientKeyMessage(tvbuf, tree, offset, header_size)
    local key_size = tvbuf(offset+header_size, 2):uint()
    tree:add(dofus_proto.fields.key, tvbuf(offset+header_size+2,key_size))
end

function IdentificationSuccessMessage(tvbuf, tree, offset, header_size)
    local accountFlags_tree = tree:add(dofus_proto.fields.accountFlags, tvbuf(offset+header_size, 1))
    accountFlags_tree:add(dofus_proto.fields.hasRights, tvbuf(offset+header_size,1))
    accountFlags_tree:add(dofus_proto.fields.hasForceRights, tvbuf(offset+header_size,1))
    accountFlags_tree:add(dofus_proto.fields.wasAlreadyConnected, tvbuf(offset+header_size,1))
    local login_size = tvbuf(offset+header_size+1,2):int()
    tree:add(dofus_proto.fields.login, tvbuf(offset+header_size+3, login_size))
    local accountTag_size = tvbuf(offset+header_size + 3 + login_size,2):int()
    tree:add(dofus_proto.fields.accountTag, tvbuf(offset+header_size+ 5 + login_size, accountTag_size))
    local accountID_size = tvbuf(offset+header_size+5+login_size+accountTag_size,2):int()
    tree:add(dofus_proto.fields.accountID, tvbuf(offset+header_size+ 7 + login_size + accountTag_size, accountID_size))
    tree:add(dofus_proto.fields.communityID, tvbuf(offset+header_size+7+login_size+accountTag_size+accountID_size, 1))
    tree:add(dofus_proto.fields.accountCreation, tvbuf(offset+header_size+12+login_size+accountTag_size+accountID_size, 8), readDate(tvbuf(offset+header_size+12+login_size+accountTag_size+accountID_size, 8))) -- 11
    tree:add(dofus_proto.fields.subscriptionEndDate, tvbuf(offset+header_size+20+login_size+accountTag_size+accountID_size, 8), readDate(tvbuf(offset+header_size+20+login_size+accountTag_size+accountID_size,8))) -- 19
    tree:add(dofus_proto.fields.havenbagAvailableRoom, tvbuf(offset+header_size+login_size+accountTag_size+accountID_size+28,1))
    -- Problèmes de dissection au niveau des dates ...
end

function ServersListMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.serversLength, tvbuf(offset+header_size, 2))
    local a = 0
    for i=0, tvbuf(offset+header_size, 2):int()-1,1 do
        local server_tree = tree:add(dofus_proto, tvbuf(offset+header_size+2+a, 16), "Server ".. GameServerTypeEnum[tvbuf(offset+header_size+a+4, 1):int()])
        local serverFlags_tree = server_tree:add(dofus_proto.fields.serverFlags, tvbuf(offset+header_size+a+2,1))
        serverFlags_tree:add(dofus_proto.fields.isMonoAccount, tvbuf(offset+header_size+a+2,1))
        serverFlags_tree:add(dofus_proto.fields.isSelectable, tvbuf(offset+header_size+a+2,1))
        server_tree:add(dofus_proto.fields.serverID, tvbuf(offset+header_size+a+3, 2), readVarShort(tvbuf(offset+header_size+a+3, 2)))
        server_tree:add(dofus_proto.fields.serverType, tvbuf(offset+header_size+a+5,1))
        server_tree:add(dofus_proto.fields.serverStatus, tvbuf(offset+header_size+a+6, 1))
        server_tree:add(dofus_proto.fields.serverCompletion, tvbuf(offset+header_size+a+7, 1))
        server_tree:add(dofus_proto.fields.charactersCount, tvbuf(offset+header_size+a+8, 1))
        server_tree:add(dofus_proto.fields.charactersSlots, tvbuf(offset+header_size+a+9, 1))
        server_tree:add(dofus_proto.fields.serverDate, tvbuf(offset+header_size+a+10, 8), readDate(tvbuf(offset+header_size+a+10, 8)))
        a=a+16
    end
end

function SelectedServerDataMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.serverID, tvbuf(offset+header_size,2), readVarShort(tvbuf(offset+header_size,2)))
    local address_size = tvbuf(offset+header_size+2,2):uint()
    tree:add(dofus_proto.fields.serverAddress, tvbuf(offset+header_size+4,address_size))
    tree:add(dofus_proto.fields.numberOfPorts, tvbuf(offset+header_size+4+address_size, 2))
    local ports_tree = tree:add(dofus_proto, tvbuf(offset+header_size+5+address_size,tvbuf(offset+header_size+4+address_size, 2):uint()),"Ports")
    local a=0
    if tvbuf(offset+header_size+4+address_size, 2):uint() ~= 1 then 
        for i=0, tvbuf(offset+header_size+4+address_size, 2):uint()-1,1 do
            ports_tree:add(dofus_proto.fields.serverPorts, tvbuf(offset+header_size+6+address_size+a, 2), readVarShort(tvbuf(offset+header_size+6+address_size+a, 2)))
            a=a+2
        end
    else
        tree:add(dofus_proto.fields.serverPorts, tvbuf(offset+header_size+6+address_size, 2))
    end
    tree:add(dofus_proto.fields.canCreateNewCharacter, tvbuf(offset+header_size+6+a+address_size, 1))
    tree:add(dofus_proto.fields.numberOfTickets, tvbuf(offset+header_size+7+a+address_size,1), readVarInt(tvbuf(offset+header_size+7+a+address_size,1)))
    local tickets_tree = tree:add(dofus_proto, tvbuf(offset+header_size+8+a+address_size,tvbuf(offset+header_size+7+a+address_size,1):uint()),"Tickets")
    local b=0
    for i=0,tvbuf(offset+header_size+7+a+address_size,1):uint()-1,1 do
        tickets_tree:add(dofus_proto.fields.serverTickets, tvbuf(offset+header_size+8+a+b+address_size,1))
        b=b+1
    end


end


function AuthenticationTicketMessage(tvbuf, tree, offset, header_size)
    local lang_size = tvbuf(offset+header_size, 2):uint()
    tree:add(dofus_proto.fields.lang, tvbuf(offset+header_size+2, lang_size))
    local ticket_size = tvbuf(offset+header_size+lang_size+2, 2):uint()
    tree:add(dofus_proto.fields.ticket, tvbuf(offset+header_size+lang_size+4, ticket_size))
    
end

function BasicAckMessage(tvbuf, tree, offset, header_size)
    local ackSeq_size = tvbuf(offset+2,1):uint()-2
    tree:add(dofus_proto.fields.ackSeq, tvbuf(offset+header_size,ackSeq_size), readVarInt(tvbuf(offset+header_size,ackSeq_size)))
    tree:add(dofus_proto.fields.lastPacketID, tvbuf(offset+header_size+ackSeq_size,2), readVarShort(tvbuf(offset+header_size+ackSeq_size,2)))
end

function BasicTimeMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.timestamp, tvbuf(offset+header_size,8), readDate(tvbuf(offset+header_size,8)))
    tree:add(dofus_proto.fields.timezoneOffset, tvbuf(offset+header_size+8,2))
end

function ServerSettingsMessage(tvbuf, tree, offset, header_size)
    local serverFlags_tree = tree:add(dofus_proto.fields.serverFlags, tvbuf(offset+header_size, 1))
    serverFlags_tree:add(dofus_proto.fields.isMonoAccount, tvbuf(offset+header_size,1))
    serverFlags_tree:add(dofus_proto.fields.hasFreeAutopilot, tvbuf(offset+header_size,1))
    local lang_size = tvbuf(offset+header_size+1,2):uint()
    tree:add(dofus_proto.fields.lang, tvbuf(offset+header_size+3, lang_size))
    tree:add(dofus_proto.fields.communityID, tvbuf(offset+header_size+3+lang_size, 1))
    tree:add(dofus_proto.fields.gameType, tvbuf(offset+header_size+lang_size+4,1))
    tree:add(dofus_proto.fields.arenaLeaveBanTime, tvbuf(offset+header_size+lang_size+5,2), readVarShort(tvbuf(offset+header_size+lang_size+5,2)))
    tree:add(dofus_proto.fields.itemMaxLevel, tvbuf(offset+header_size+lang_size+7, 3))
end

function ServerSessionConstantsMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.numberOfConstants, tvbuf(offset+header_size,2))
    local a=0
    for i=0, tvbuf(offset+header_size,2):uint(),1 do
        tree:add(dofus_proto.fields.constantId, tvbuf(offset+header_size+a+2,2))
        tree:add(dofus_proto.fields.constantInstance, tvbuf(offset+header_size+a+4,2))
        a=a+4
    end
end

function TrustStatusMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.certified, tvbuf(offset+header_size,1))
end

function AccountSubscriptionElapsedDurationMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.subscriptionElapsedDuration, tvbuf(offset+header_size,8), readDate(tvbuf(offset+header_size,8)))
end

function HaapiApiKeyMessage(tvbuf, tree, offset, header_size)
    local token_size = tvbuf(offset+header_size, 2):uint()
    tree:add(dofus_proto.fields.token, tvbuf(offset+header_size+2,token_size))
end

function QueueStatusMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.queuePosition, tvbuf(offset+header_size,2))
    tree:add(dofus_proto.fields.queueTotal, tvbuf(offset+header_size+2,2))
end

function CharactersListMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.numberOfCharacters, tvbuf(offset+header_size, 2))
    tree:add(dofus_proto.fields.characterId, tvbuf(offset+header_size+2,8), readVarLong(tvbuf(offset+header_size+2,8)))
    local name_size = tvbuf(offset+header_size+10,2):uint()
    tree:add(dofus_proto.fields.characterName, tvbuf(offset+header_size+12,name_size))
    tree:add(dofus_proto.fields.characterLevel, tvbuf(offset+header_size+12+name_size,1))
    tree:add(dofus_proto.fields.characterBonesId, tvbuf(offset+header_size+13+name_size,2), readVarShort(tvbuf(offset+header_size+13+name_size,2)))
    tree:add(dofus_proto.fields.skinsLength, tvbuf(offset+header_size+15+name_size,2))
    -- h = 0
    -- for j=0, tvbuf(offset+header_size+15+name_size,2):uint()-1, 1 do
    --     tree:add(dofus_proto.fields.skin, tvbuf(offset+header_size+17+name_size+h,2), readVarShort(tvbuf(offset+header_size+17+name_size+h,2)))
    --     h = h+2
    -- end
    -- tree:add(dofus_proto.fields.indexedColorsLength, tvbuf(offset+header_size+17+name_size+h,2))
    -- y=0
    -- for t=0, tvbuf(offset+header_size+17+name_size+h,2):uint()-1, 1 do
    --     tree:add(dofus_proto.fields.indexedColor, tvbuf(offset+header_size+19+name_size+h+y,4))
    --     y=y+4
    -- end
    -- tree:add(dofus_proto.fields.scalesLength, tvbuf(offset+header_size+21+name_size+h+y,2))
    -- o=0
    -- for k=0, tvbuf(offset+header_size+21+name_size+h+y,2):uint()-1, 1 do
    --     tree:add(dofus_proto.fields.scale, tvbuf(offset+header_size+23+name_size+h+o+y,2))
    --     o = o+2
    -- end
    -- tree:add(dofus_proto.fields.subentitiesLength, tvbuf(offset+header_size+25+name_size+h+o+y,2))
    -- p = 0
    -- for l=0, tvbuf(offset+header_size+25+name_size+h+o+y,2):uint()-1, 1 do
    --     tree:add(dofus_proto.fields.subentitie, tvbuf(offset+header_size+27+name_size+h+o+p+y,2))
    --     p = p+2
    -- end
    -- tree:add(dofus_proto.fields.characterBreed, tvbuf(offset+header_size+29+name_size+h+o+p+y,2))
    -- tree:add(dofus_proto.fields.characterSex, tvbuf(offset+header_size+31+name_size+h+o+p+y,2))
end

function FriendsListMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.numberOfFriends, tvbuf(offset+header_size,2))
    local a=0
    for i=1, tvbuf(offset+header_size,2):uint(),1 do
        local nickname_size = tvbuf(offset+header_size+8+a,2):uint()
        local accountTag_size = tvbuf(offset+header_size+10+nickname_size+a,2):uint()
        local friend_tree = tree:add(dofus_proto, tvbuf(offset+header_size+2+a,nickname_size+accountTag_size+23), "Friend n°" .. tostring(i))
        friend_tree:add(dofus_proto.fields.friendId, tvbuf(offset+header_size+4+a,4))
        friend_tree:add(dofus_proto.fields.nickname, tvbuf(offset+header_size+10+a,nickname_size))
        friend_tree:add(dofus_proto.fields.accountTag, tvbuf(offset+header_size+12+nickname_size+a,accountTag_size))
        friend_tree:add(dofus_proto.fields.playerState, tvbuf(offset+header_size+12+nickname_size+accountTag_size+a,1))
        friend_tree:add(dofus_proto.fields.lastConnection, tvbuf(offset+header_size+13+nickname_size+accountTag_size+a,2), readVarShort(tvbuf(offset+header_size+13+nickname_size+accountTag_size+a,2))):append_text("h")
        friend_tree:add(dofus_proto.fields.achievementPoints, tvbuf(offset+header_size+15+nickname_size+accountTag_size+a,4))
        friend_tree:add(dofus_proto.fields.leagueId, tvbuf(offset+header_size+19+nickname_size+accountTag_size+a,2))
        friend_tree:add(dofus_proto.fields.ladderPosition, tvbuf(offset+header_size+21+nickname_size+accountTag_size+a,4))
        a=a+nickname_size+accountTag_size+23
    end
end

function KamasUpdateMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.kamasTotal, tvbuf(offset+header_size,tvbuf(offset+2,1):uint()),readVarLong(tvbuf(offset+header_size,tvbuf(offset+2,1):uint())))
end

function StorageKamasUpdateMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.kamasTotal, tvbuf(offset+header_size,tvbuf(offset+2,1):uint()), readVarLong(tvbuf(offset+header_size,tvbuf(offset+2,1):uint())))
end

function BasicPingMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.quiet, tvbuf(offset+header_size,1))
end

function BasicPongMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.quiet, tvbuf(offset+header_size,1))
end

function ChatServerMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.channel, tvbuf(offset+header_size,1))
    local content_size = tvbuf(offset+header_size+1,2):uint()
    tree:add(dofus_proto.fields.messContent, tvbuf(offset+header_size+3, content_size))
    tree:add(dofus_proto.fields.messTimestamp, tvbuf(offset+header_size+3+content_size,4))
    local fingerprint_size = tvbuf(offset+header_size+7+content_size,2):uint()
    tree:add(dofus_proto.fields.messFingerprint, tvbuf(offset+header_size+9+content_size, fingerprint_size))
    tree:add(dofus_proto.fields.senderId, tvbuf(offset+header_size+9+content_size+fingerprint_size,8))
    local senderName_size = tvbuf(offset+header_size+17+content_size+fingerprint_size,2):uint()
    tree:add(dofus_proto.fields.senderName, tvbuf(offset+header_size+19+content_size+fingerprint_size,senderName_size))
    local prefix_size = tvbuf(offset+header_size+19+content_size+fingerprint_size+senderName_size,2):uint()
    tree:add(dofus_proto.fields.prefix, tvbuf(offset+header_size+21+content_size+fingerprint_size+senderName_size,prefix_size))
    tree:add(dofus_proto.fields.senderAccountId, tvbuf(offset+header_size+21+content_size+fingerprint_size+senderName_size+prefix_size, 4))
end

function MapInformationsRequestMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.mapId, tvbuf(offset+header_size,8))
end

function MapComplementaryInformationsDataMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.subAreaId, tvbuf(offset+header_size,2), readVarShort(tvbuf(offset+header_size,2)))
    tree:add(dofus_proto.fields.mapId, tvbuf(offset+header_size+2,8))
    tree:add(dofus_proto.fields.numberOfHouses, tvbuf(offset+header_size+10,2))
    -- a=0
    -- for i=0, tvbuf(offset+header_size+10,2):uint()-1,1 do
    --     local house_tree = tree:add(dofus_proto, tvbuf(offset+header_size+14+a,6), "House")
    --     house_tree:add(dofus_proto.fields.houseId, tvbuf(offset+header_size+14+a,4), readVarInt(tvbuf(offset+header_size+14+a,4)))
    --     house_tree:add(dofus_proto.fields.modelId, tvbuf(offset+header_size+18+a,2), readVarShort(tvbuf(offset+header_size+18+a,2)))
    --     a = a+6
    -- end
    -- tree:add(dofus_proto.fields.numberOfActors, tvbuf(offset+header_size+12+a,2))
    -- u=0
    -- for i=0, tvbuf(offset+header_size+12+a,2):uint()-1, 1 do
    --     local actor_tree = tree:add(dofus_proto, tvbuf(offset+header_size+16+a+u,11), "Actor")
    --     actor_tree:add(dofus_proto.fields.contextualId, tvbuf(offset+header_size+16+a+u,8))
    --     actor_tree:add(dofus_proto.fields.cellId, tvbuf(offset+header_size+24+a+u,2))
    --     actor_tree:add(dofus_proto.fields.direction, tvbuf(offset+header_size+26+a+u,1))
    --     u=u+11
    -- end


end

function ChatClientMultiMessage(tvbuf, tree, offset, header_size)
    local messContent_size = tvbuf(offset+header_size,2):uint()
    tree:add(dofus_proto.fields.messContent, tvbuf(offset+header_size+2,messContent_size))
    tree:add(dofus_proto.fields.channel, tvbuf(offset+header_size+2+messContent_size,1))
end

function SetCharacterRestrictionsMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.actorId, tvbuf(offset+header_size,8))
    local restriction1_tree = tree:add(dofus_proto.fields.restriction1, tvbuf(offset+header_size+8,1))
    restriction1_tree:add(dofus_proto.fields.cantBeAggressed, tvbuf(offset+header_size+8,1))
    restriction1_tree:add(dofus_proto.fields.cantBeChallenged, tvbuf(offset+header_size+8,1))
    restriction1_tree:add(dofus_proto.fields.cantTrade, tvbuf(offset+header_size+8,1))
    restriction1_tree:add(dofus_proto.fields.cantBeAttackedByMutant, tvbuf(offset+header_size+8,1))
    restriction1_tree:add(dofus_proto.fields.cantRun, tvbuf(offset+header_size+8,1))
    restriction1_tree:add(dofus_proto.fields.forceSlowWalk, tvbuf(offset+header_size+8,1))
    restriction1_tree:add(dofus_proto.fields.cantMinimize, tvbuf(offset+header_size+8,1))
    restriction1_tree:add(dofus_proto.fields.cantMove, tvbuf(offset+header_size+8,1))
    local restriction2_tree = tree:add(dofus_proto.fields.restriction2, tvbuf(offset+header_size+9,1))
    restriction2_tree:add(dofus_proto.fields.cantAggress, tvbuf(offset+header_size+9,1))
    restriction2_tree:add(dofus_proto.fields.cantChallenge, tvbuf(offset+header_size+9,1))
    restriction2_tree:add(dofus_proto.fields.cantExchange, tvbuf(offset+header_size+9,1))
    restriction2_tree:add(dofus_proto.fields.cantAttack, tvbuf(offset+header_size+9,1))
    restriction2_tree:add(dofus_proto.fields.cantChat, tvbuf(offset+header_size+9,1))
    restriction2_tree:add(dofus_proto.fields.cantUseObject, tvbuf(offset+header_size+9,1))
    restriction2_tree:add(dofus_proto.fields.cantUseTaxCollector, tvbuf(offset+header_size+9,1))
    restriction2_tree:add(dofus_proto.fields.cantUseInteractive, tvbuf(offset+header_size+9,1))
    local restriction3_tree = tree:add(dofus_proto.fields.restriction3, tvbuf(offset+header_size+10,1))
    restriction3_tree:add(dofus_proto.fields.cantSpeakToNPC, tvbuf(offset+header_size+10,1))
    restriction3_tree:add(dofus_proto.fields.cantChangeZone, tvbuf(offset+header_size+10,1))
    restriction3_tree:add(dofus_proto.fields.cantAttackMonster, tvbuf(offset+header_size+10,1))

end

function GameMapMovementRequestMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.numberOfKeyMovements, tvbuf(offset+header_size, 2))
    a=0
    for i=0, tvbuf(offset+header_size, 2):uint()-1,1 do
        tree:add(dofus_proto.fields.keyMovement, tvbuf(offset+header_size+2+a,2))
        a=a+2
    end
    tree:add(dofus_proto.fields.mapId, tvbuf(offset+header_size+2+a,8))
end

function BasicLatencyStatsMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.latency, tvbuf(offset+header_size,2)):append_text(" ms")
    tree:add(dofus_proto.fields.sampleCount, tvbuf(offset+header_size+2,2), readVarShort(tvbuf(offset+header_size+2,2)))
    -- tree:add(dofus_proto.fields.maxSampleCount, tvbuf(offset+header_size+4,2), readVarShort(tvbuf(offset+header_size+4,2)))
end


function GameMapMovementMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.numberOfKeyMovements, tvbuf(offset+header_size, 2))
    a=0
    for i=0, tvbuf(offset+header_size, 2):uint()-1,1 do
        tree:add(dofus_proto.fields.keyMovement, tvbuf(offset+header_size+2+a,2))
        a=a+2
    end
    tree:add(dofus_proto.fields.forcedDirection, tvbuf(offset+header_size+a+2,2))
    tree:add(dofus_proto.fields.actorId, tvbuf(offset+header_size+4+a,8))
    

end


function HaapiShopApiKeyMessage(tvbuf, tree, offset, header_size)
    local token_size = tvbuf(offset+header_size,2):uint()
    tree:add(dofus_proto.fields.token, tvbuf(offset+header_size+2,token_size))
end

function ChatServerWithObjectMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.channel, tvbuf(offset+header_size,1))
    local content_size = tvbuf(offset+header_size+1,2):uint()
    tree:add(dofus_proto.fields.messContent, tvbuf(offset+header_size+3, content_size))
    tree:add(dofus_proto.fields.messTimestamp, tvbuf(offset+header_size+3+content_size,4))
    local fingerprint_size = tvbuf(offset+header_size+7+content_size,2):uint()
    tree:add(dofus_proto.fields.messFingerprint, tvbuf(offset+header_size+9+content_size, fingerprint_size))
    tree:add(dofus_proto.fields.senderId, tvbuf(offset+header_size+9+content_size+fingerprint_size,8))
    local senderName_size = tvbuf(offset+header_size+17+content_size+fingerprint_size,2):uint()
    tree:add(dofus_proto.fields.senderName, tvbuf(offset+header_size+19+content_size+fingerprint_size,senderName_size))
    local prefix_size = tvbuf(offset+header_size+19+content_size+fingerprint_size+senderName_size,2):uint()
    tree:add(dofus_proto.fields.prefix, tvbuf(offset+header_size+21+content_size+fingerprint_size+senderName_size,prefix_size))
    tree:add(dofus_proto.fields.senderAccountId, tvbuf(offset+header_size+21+content_size+fingerprint_size+senderName_size+prefix_size, 4))
    tree:add(dofus_proto.fields.numberOfObjects, tvbuf(offset+header_size+25+content_size+fingerprint_size+senderName_size+prefix_size, 2))
    -- a=0
    -- for i=0, tvbuf(offset+header_size+25+content_size+fingerprint_size+senderName_size+prefix_size, 2):uint()-1,1 do
    --     tree:add(dofus_proto.fields.objectPosition, tvbuf(offset+header_size+27+content_size+fingerprint_size+senderName_size+prefix_size+a, 2))
    --     tree:add(dofus_proto.fields.objectGID, tvbuf(offset+header_size+29+content_size+fingerprint_size+senderName_size+prefix_size+a, 4), readVarInt(tvbuf(offset+header_size+29+content_size+fingerprint_size+senderName_size+prefix_size+a, 4)))
    --     tree:add(dofus_proto.fields.numberOfEffects, tvbuf(offset+header_size+33+content_size+fingerprint_size+senderName_size+prefix_size+a, 2))
    --     d=0
    --     for e=0, tvbuf(offset+header_size+33+content_size+fingerprint_size+senderName_size+prefix_size+a, 2):uint()-1,1 do
    --         tree:add(dofus_proto.fields.objectActionId, tvbuf(offset+header_size+37+content_size+fingerprint_size+senderName_size+prefix_size+a+d, 2), readVarShort(tvbuf(offset+header_size+37+content_size+fingerprint_size+senderName_size+prefix_size+a+d, 2)))
    --         d=d+2
    --     end
    --     tree:add(dofus_proto.fields.objectUID, tvbuf(offset+header_size+35+content_size+fingerprint_size+senderName_size+prefix_size+a+d, 4), readVarInt(tvbuf(offset+header_size+35+content_size+fingerprint_size+senderName_size+prefix_size+a+d, 4)))
    --     tree:add(dofus_proto.fields.objectQuantity, tvbuf(offset+header_size+39+content_size+fingerprint_size+senderName_size+prefix_size+a+d, 4), readVarInt(tvbuf(offset+header_size+39+content_size+fingerprint_size+senderName_size+prefix_size+a+d, 4)))
    --     a=a+16+d
    -- end


end

function CharacterLevelUpInformationMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.newLevel, tvbuf(offset+header_size,1), readVarShort(tvbuf(offset+header_size,1)))
    local name_size = tvbuf(offset+header_size+1,2):uint()
    tree:add(dofus_proto.fields.characterName, tvbuf(offset+header_size+3,name_size))
    tree:add(dofus_proto.fields.characterId, tvbuf(offset+header_size+3+name_size,tvbuf(offset+2,1):uint()-3-name_size), readVarLong(tvbuf(offset+header_size+3+name_size,tvbuf(offset+2,1):uint()-3-name_size)))
end

function CharacterLevelUpMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.newLevel, tvbuf(offset+header_size,tvbuf(offset+2,1):uint()), readVarShort(tvbuf(offset+header_size,tvbuf(offset+2,1):uint())))
end

function CharacterDeletionPrepareRequestMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.characterId, tvbuf(offset+header_size, tvbuf(offset+6,1):uint()), readVarLong(tvbuf(offset+header_size, tvbuf(offset+6,1):uint())))
end

function CharacterDeletionRequestMessage(tvbuf, tree, offset, header_size)
    characterId_size = tvbuf(offset+6,1):uint()-34
    tree:add(dofus_proto.fields.characterId, tvbuf(offset+header_size, characterId_size), readVarLong(tvbuf(offset+header_size, characterId_size)))
    local secretAnswerHash_size = tvbuf(offset+header_size+characterId_size,2):uint()
    tree:add(dofus_proto.fields.secretAnswerHash, tvbuf(offset+header_size+characterId_size+2,secretAnswerHash_size))
end

function ChangeMapMessage(tvbuf, tree, offset, header_size)
    tree:add(dofus_proto.fields.mapId, tvbuf(offset+header_size, 8))
    tree:add(dofus_proto.fields.autopilot, tvbuf(offset+header_size+8,1))
end

function ExchangePlayerRequestMessage(tvbuf, tree, offset, header_size, lenValue)
    tree:add(dofus_proto.fields.target, tvbuf(offset+header_size, lenValue))
end

function ExchangeKamaModifiedMessage(tvbuf, tree, offset, header_size, lenValue)
    tree:add(dofus_proto.fields.quantity, tvbuf(offset+header_size, lenValue),readVarLong(tvbuf(offset+header_size,lenValue)))
end

local tcp_table = DissectorTable.get("tcp.port")
tcp_table:add(5555, dofus_proto)