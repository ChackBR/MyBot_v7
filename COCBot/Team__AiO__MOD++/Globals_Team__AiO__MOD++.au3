; #FUNCTION# ====================================================================================================================
; Name ..........: Globals - AiO++ Team
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........: AiO++ Team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»
; AiO++ Team
; «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»
; Unit/Wave Factor - AiO++ Team
Global $g_iChkGiantSlot = 0, $g_iChkUnitFactor = 0, $g_iChkWaveFactor = 0
Global $g_iCmbGiantSlot = 0, $g_iTxtUnitFactor = 10, $g_iTxtWaveFactor = 100
Global $g_iSlotsGiants = 1, $g_aiSlotsGiants = 1

; Auto Dock, Hide Emulator & Bot - AiO++ Team
Global $g_bEnableAuto = False, $g_iChkAutoDock = False, $g_iChkAutoHideEmulator = True, $g_iChkAutoMinimizeBot = False

; Check Collector Outside - AiO++ Team
Global $g_bScanMineAndElixir = False
#region Check Collectors Outside

; Collectors Outside Filter
Global $g_bDBMeetCollOutside = False, $g_iTxtDBMinCollOutsidePercent = 80
; constants
Global Const $THEllipseWidth = 200, $THEllipseHeigth = 150, $CollectorsEllipseWidth = 130, $CollectorsEllipseHeigth = 97.5
Global Const $centerX = 430, $centerY = 335
Global $hBitmapFirst
Global $g_bDBCollectorsNearRedline = 1, $g_bSkipCollectorCheck = 1, $g_bSkipCollectorCheckTH = 1
Global $g_iCmbRedlineTiles = 1, $g_iCmbSkipCollectorCheckTH = 1
Global $g_iTxtSkipCollectorGold = 400000, $g_iTxtSkipCollectorElixir = 400000, $g_iTxtSkipCollectorDark = 0
#endregion

; CSV Speed Deployment - AiO++ Team
Global $cmbCSVSpeed[2] = [$LB, $DB]
Global $icmbCSVSpeed[2] = [2, 2]
Global $g_CSVSpeedDivider[2] = [1, 1] ; default CSVSpeed for DB & LB

; Switch Accounts - Demen - AiO++ Team
Global $g_bInitiateSwitchAcc = True, $g_bChkSwitchAcc, $g_bChkSmartSwitch, $g_bReMatchAcc = False
Global $g_iTotalAcc, $g_iNextAccount, $g_iCurAccount
Global $g_iTrainTimeToSkip = 0
Global $g_abAccountNo[8], $g_aiProfileNo[8], $g_abDonateOnly[8]
Global $g_aiAttackedCountSwitch[8], $g_iActiveSwitchCounter = 0, $g_iDonateSwitchCounter = 0
Global $g_aiRemainTrainTime[8], $g_aiTimerStart[8]
Global $g_oTxtSALogInitText = ObjCreate("Scripting.Dictionary")
Global $g_hSwitchLogFile = 0
Global $g_aiGoldTotalAcc[8], $g_aiElixirTotalAcc[8], $g_aiDarkTotalAcc[8], $g_aiTrophyLootAcc[8], $g_aiAttackedCountAcc[8], $g_aiSkippedVillageCountAcc[8] ; Total Gain
Global $g_aiGoldCurrentAcc[8], $g_aiElixirCurrentAcc[8], $g_aiDarkCurrentAcc[8], $g_aiTrophyCurrentAcc[8], $g_aiGemAmountAcc[8], $g_aiFreeBuilderCountAcc[8], $g_aiTotalBuilderCountAcc[8] ; village report

; Smart Train - Demen - AiO++ Team
Global $ichkSmartTrain, $ichkPreciseTroops, $ichkFillArcher, $iFillArcher, $ichkFillEQ
; ForceSwitch while waiting for CC troops - Demen - AiO++ Team
Global $g_bWaitForCCTroopSpell = False
Global Enum $g_eFull, $g_eRemained, $g_eNoTrain
Global $g_abRCheckWrongTroops[2] = [False, False] ; Result of checking wrong troops & spells
Global $g_bChkMultiClick, $g_iMultiClick = 1
Global $g_aiQueueTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiQueueSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

; Hero and Lab Status - AiO++ Team
Global $g_bNeedLocateLab = True, $g_bLabReady[9]
Global $g_aLabTimeAcc[8], $g_aLabTime[4] = [0, 0, 0, 0] ; day | hour | minute | time in minutes
Global $g_aLabTimerStart[8], $g_aLabTimerEnd[8]

; Bot Humanization - AiO++ Team
Global $g_iacmbPriority[13] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iacmbMaxSpeed[2] = [1, 1]
Global $g_iacmbPause[2] = [0, 0]
Global $g_iahumanMessage[2] = ["Hello !", "Hello !"]
Global $g_ichallengeMessage = "Can you beat my village?"

Global $g_iMinimumPriority, $g_iMaxActionsNumber, $g_iActionToDo
Global $g_aSetActionPriority[13] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Global $g_sFrequenceChain = "Never|Sometimes|Frequently|Often|Very Often"
Global $g_sReplayChain = "1|2|4"
Global $g_ichkUseBotHumanization = 0, $g_ichkUseAltRClick = 0, $g_icmbMaxActionsNumber = 1, $g_ichkCollectAchievements = 0, $g_ichkLookAtRedNotifications = 0

Global $g_aReplayDuration[2] = [0, 0] ; An array, [0] = Minute | [1] = Seconds
Global $g_bOnReplayWindow, $g_iReplayToPause

Global $g_iLastLayout = 0

; Request CC Troops at first - Demen - AiO++ Team
Global $g_bReqCCFirst = False
Global $chkReqCCFirst = 0

; Goblin XP - AiO++ Team
Global $ichkEnableSuperXP = 0, $ichkSkipZoomOutXP = 0, $irbSXTraining = 1, $ichkSXBK = 0, $ichkSXAQ = 0, $ichkSXGW = 0, $iStartXP = 0, $iCurrentXP = 0, $iGainedXP = 0, $iGainedXPHour = 0, $itxtMaxXPtoGain = 500
Global $g_bDebugSX = False

Global $g_DpGoblinPicnic[3][4] = [[300, 205, 5, 5], [340, 140, 5, 5], [290, 220, 5, 5]]
Global $g_BdGoblinPicnic[3] = [0, "5000-7000", "6000-8000"] ; [0] = Queen, [1] = Warden, [2] = Barbarian King
Global $g_ActivatedHeroes[3] = [False, False, False] ; [0] = Queen, [1] = Warden, [2] = Barbarian King , Prevent to click on them to Activate Again And Again
Global Const $g_minStarsToEnd = 1
Global $g_canGainXP = False

; ClanHop - AiO++ Team
Global $g_bChkClanHop = False

; Max Logout Time - TeAiO++ Team
Global $g_bTrainLogoutMaxTime = False, $g_iTrainLogoutMaxTime = 4

; ExtendedAttackBar - Demen - AiO++ Team
Global $g_hChkExtendedAttackBarLB, $g_hChkExtendedAttackBarDB, $g_abChkExtendedAttackBar[2]
Global $g_iTotalAttackSlot = 10, $g_bDraggedAttackBar = False ; flag if AttackBar is dragged or not

; Chatbot - AiO++ Team
Global $chatIni = ""
Global $GlobalMessages1 = "", $GlobalMessages2 = "", $GlobalMessages3 = "", $GlobalMessages4 = ""
Global $ClanMessages = "", $ClanResponses = ""
Global $g_iGlobalChat = False, $g_iGlobalScramble = False, $g_iSwitchLang = False, $g_iCmbLang = 1
Global $g_iClanChat = False, $g_iRusLang = 0, $g_iUseResponses = False, $g_iUseGeneric = False, $g_iChatPushbullet = False, $g_iPbSendNewChats = False
Global $ChatbotStartTime
Global $ChatbotQueuedChats[0], $ChatbotReadQueued = False, $ChatbotReadInterval = 0, $ChatbotIsOnInterval = False

; CheckCC Troops - Demen - AiO++ Team
Global $g_aiCCTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiCCSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiCCTroopsExpected[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiCCSpellsExpected[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_bChkCC, $g_bChkCCTroops
Global $g_aiCmbCCSlot[5], $g_aiTxtCCSlot[5]
Global $g_iCmbCastleCapacityT, $g_iCmbCastleCapacityS

; Switch Profile - Demen - AiO++ Team
Global $g_abChkSwitchMax[4], $g_abChkSwitchMin[4], $g_aiCmbSwitchMax[4], $g_aiCmbSwitchMin[4]
Global $g_abChkBotTypeMax[4], $g_abChkBotTypeMin[4], $g_aiCmbBotTypeMax[4], $g_aiCmbBotTypeMin[4]
Global $g_aiConditionMax[4], $g_aiConditionMin[4]

; Check Grand Warden Mode - AiO++ Team
Global $g_bCheckWardenMode = False, $g_iCheckWardenMode = 0

; Farm Schedule - Demen - AiO++ Team
Global $g_abChkSetFarm[8]
Global $g_aiCmbAction1[8], $g_aiCmbCriteria1[8], $g_aiTxtResource1[8], $g_aiCmbTime1[8]
Global $g_aiCmbAction2[8], $g_aiCmbCriteria2[8], $g_aiTxtResource2[8], $g_aiCmbTime2[8]

; Restart Search Legend league - AiO++ Team
Global $g_bIsSearchTimeout = False, $g_iSearchTimeout = 10, $g_iTotalSearchTime = 0

; Stop on Low Battery - AiO++ Team
Global $g_bStopOnBatt = False, $g_iStopOnBatt = 10