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
; Request CC Troops at first - AiO++
; --------------------------------------------
Global $g_bReqCCFirst = True
Global $chkReqCCFirst = 1

; --------------------------------------------
; Unit/Wave Factor - AiO++
; --------------------------------------------
Global $g_iChkGiantSlot = 0, $g_iChkUnitFactor = 0, $g_iChkWaveFactor = 0
Global $g_iCmbGiantSlot = 0, $g_iTxtUnitFactor = 10, $g_iTxtWaveFactor = 100
Global $g_iSlotsGiants = 1, $g_aiSlotsGiants = 1
