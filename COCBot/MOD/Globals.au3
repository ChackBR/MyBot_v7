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

; --------------------------------------------
; === TimerHandle New Used in Donate/Train only Mode - Light__Version (by Ezeck 06.14.17)
; --------------------------------------------
Global $g_hTrainTimeLeft = 0
Global $g_hCurrentDonateButtonBitMap = 0

; --------------------------------------------
; Auto Dock, Hide Emulator & Bot - AiO++
; --------------------------------------------
Global $g_bEnableAuto = False, $g_iChkAutoDock = False, $g_iChkAutoHideEmulator = True, $g_iChkAutoMinimizeBot = False

; --------------------------------------------
; Check Collector Outside - AiO++
; --------------------------------------------
Global $g_bScanMineAndElixir = False
#region Check Collectors Outside
; Collectors Outside Filter
Global $g_bDBMeetCollOutside = False, $g_iTxtDBMinCollOutsidePercent = 80
; constants
Global Const $THEllipseWidth = 200, $THEllipseHeigth = 150, $CollectorsEllipseWidth = 130, $CollectorsEllipseHeigth = 97.5
Global $hBitmapFirst
Global $g_bDBCollectorsNearRedline = 1, $g_bSkipCollectorCheck = 1, $g_bSkipCollectorCheckTH = 1
Global $g_iCmbRedlineTiles = 1, $g_iCmbSkipCollectorCheckTH = 1
Global $g_iTxtSkipCollectorGold = 400000, $g_iTxtSkipCollectorElixir = 400000, $g_iTxtSkipCollectorDark = 0
#endregion

; --------------------------------------------
; Max logout time - AiO++
; --------------------------------------------
Global $g_bTrainLogoutMaxTime = False, $g_iTrainLogoutMaxTime = 4

; --------------------------------------------
; Smart Train - AiO++
; --------------------------------------------

Global $g_bChkSmartTrain = False, $g_bChkPreciseArmyCamp = False, $g_bChkFillArcher = False, $g_bChkFillEQ = False, $g_iTxtFillArcher = 5
Global Enum $g_eFull, $g_eRemained, $g_eNoTrain
Global $g_bWrongTroop, $g_bWrongSpell, $g_sSmartTrainError = ""
Global $g_bChkMultiClick, $g_iMultiClick = 1
Global $g_aiQueueTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiQueueSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

; --------------------------------------------
; Request CC Troops at first - AiO++
; --------------------------------------------
Global $g_bReqCCFirst = True
Global $chkReqCCFirst = 1

; --------------------------------------------
; CheckCC Troops - AiO++
; --------------------------------------------
Global $g_aiCCTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiCCSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiCCTroopsExpected[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiCCSpellsExpected[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_bChkCC = True
Global $g_bChkCCTroops = False
Global $g_bChkCCSpells = False
Global $g_aiCmbCCSlot[5], $g_aiTxtCCSlot[5]
Global $g_iCmbCastleCapacityT = 5, $g_iCmbCastleCapacityS = 1

; --------------------------------------------
; Check Grand Warden Mode - AiO++
; --------------------------------------------
Global $g_bCheckWardenMode = False, $g_iCheckWardenMode = 0

; --------------------------------------------
; Unit/Wave Factor
; --------------------------------------------
Global $g_iChkGiantSlot = 0, $g_iChkUnitFactor = 0, $g_iChkWaveFactor = 0
Global $g_iCmbGiantSlot = 0, $g_iTxtUnitFactor = 10, $g_iTxtWaveFactor = 100
Global $g_iSlotsGiants = 1, $g_aiSlotsGiants = 1

; --------------------------------------------
; Restart Search Legend league - AiO++
; --------------------------------------------
Global $g_bIsSearchTimeout = False, $g_iSearchTimeout = 10, $g_iTotalSearchTime = 0

; --------------------------------------------
; Request troops for defense - AiO++
; --------------------------------------------
Global $g_bRequestTroopsEnableDefense = False, $g_sRequestTroopsTextDefense = "", $g_iRequestDefenseEarly = 0
