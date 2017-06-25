; #FUNCTION# ====================================================================================================================
; Name ..........: Global_Variables.au3
; Description ...: Extension of MBR Global Variables
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;
; Global Variables
;

; Fix drop on edge from Doc Octopus
Global Const $g_aaiTopLeftDropPoints[5][2] = [[62, 306], [156, 238], [221, 188], [288, 142], [383, 76]]
Global Const $g_aaiTopRightDropPoints[5][2] = [[486, 59], [586, 134], [652, 184], [720, 231], [817, 308]]
Global Const $g_aaiBottomLeftDropPoints[5][2] = [[20, 373], [101, 430], [171, 481], [244, 535], [346, 615]]
Global Const $g_aaiBottomRightDropPoints[5][2] = [[530, 615], [632, 535], [704, 481], [781, 430], [848, 373]]
Global Const $g_aaiEdgeDropPoints[4] = [$g_aaiBottomRightDropPoints, $g_aaiTopLeftDropPoints, $g_aaiBottomLeftDropPoints, $g_aaiTopRightDropPoints]

;
; mandryd
;

; Max logout time
Global $TrainLogoutMaxTime, $TrainLogoutMaxTimeTXT

;
; LunaEclipse
;

; Multi Finger Attack Style Setting
Global $LblDBMultiFinger = 0, $TxtUnitFactor = 0, $TxtWaveFactor = 0
Global $CmbDBMultiFinger = 0, $ChkUnitFactor = 0, $ChkWaveFactor = 0

Global Enum $directionLeft, $directionRight
Global Enum $sideBottomRight, $sideTopLeft, $sideBottomLeft, $sideTopRight
Global Enum $mfRandom, $mfFFStandard, $mfFFSpiralLeft, $mfFFSpiralRight, $mf8FBlossom, $mf8FImplosion, $mf8FPinWheelLeft, $mf8FPinWheelRight

Global $iMultiFingerStyle = 4
Global Enum $eCCSpell = $eHaSpell + 1

; CSV Deployment Speed Mod
Global $isldSelectedCSVSpeed[$g_iModeCount], $iCSVSpeeds[21]
$isldSelectedCSVSpeed[$DB] = 3
$isldSelectedCSVSpeed[$LB] = 3
$iCSVSpeeds[0] = .25
$iCSVSpeeds[1] = .5
$iCSVSpeeds[2] = .75
$iCSVSpeeds[3] = 1
$iCSVSpeeds[4] = 1.25
$iCSVSpeeds[5] = 1.5
$iCSVSpeeds[6] = 1.75
$iCSVSpeeds[7] = 2
$iCSVSpeeds[8] = 2.25
$iCSVSpeeds[9] = 2.5
$iCSVSpeeds[10] = 2.75
$iCSVSpeeds[11] = 3
$iCSVSpeeds[12] = 3.25
$iCSVSpeeds[13] = 3.5
$iCSVSpeeds[14] = 3.75
$iCSVSpeeds[15] = 4
$iCSVSpeeds[16] = 8
$iCSVSpeeds[17] = 12
$iCSVSpeeds[18] = 24
$iCSVSpeeds[19] = 48
$iCSVSpeeds[20] = 96
Global $grpScriptSpeedDB, $lbltxtSelectedSpeedDB, $sldSelectedSpeedDB, $grpScriptSpeedAB, $lbltxtSelectedSpeedAB, $sldSelectedSpeedAB

;
; AwesomeGamer
;

; No League Search
Global $chkDBNoLeague, $chkABNoLeague, $iChkNoLeague[$g_iModeCount]
Global $aNoLeague[4] = [30, 30, 0x616568, 20] ; No League Shield

; Check Collectors Outside
#region Check Collectors Outside
; Collectors outside filter
Global $ichkDBMeetCollOutside, $iDBMinCollOutsidePercent = 80, $iCollOutsidePercent ; check later if $iCollOutsidePercent obsolete

; constants
Global Const $THEllipseWidth = 200, $THEllipseHeigth = 150, $CollectorsEllipseWidth = 130, $CollectorsEllipseHeigth = 97.5
Global Const $centerX = 430, $centerY = 335 ; check later if $THEllipseWidth, $THEllipseHeigth obsolete
Global $hBitmapFirst
;samm0d
Global $ichkSkipCollectorCheckIF = 1
Global $itxtSkipCollectorGold = 400000
Global $itxtSkipCollectorElixir = 400000
Global $itxtSkipCollectorDark = 0
Global $ichkSkipCollectorCheckIFTHLevel = 1
Global $itxtIFTHLevel = 7
Global $ichkDBCollectorsNearRedline = 0
Global $icmbRedlineTiles = 1
Global $chkDBMeetCollOutside, $txtDBMinCollOutsidePercent, $chkDBCollectorsNearRedline, $cmbRedlineTiles, $chkSkipCollectorCheckIF, $lblSkipCollectorGold, $txtSkipCollectorGold, $lblSkipCollectorElixir, _
$txtSkipCollectorElixir, $lblSkipCollectorDark, $txtSkipCollectorDark, $chkSkipCollectorCheckIFTHLevel, $txtIFTHLevel
#endregion

;
; DEMEN
;

; SwitchAcc_Demen_Style
Global $profile = $g_sProfilePath & "\Profile.ini"
Global $ichkSwitchAcc = 0, $icmbTotalCoCAcc, $nTotalCoCAcc = 8, $ichkSmartSwitch, $ichkCloseTraining
Global Enum $eNull, $eActive, $eDonate, $eIdle, $eStay, $eContinuous ; Enum for Profile Type & Switch Case & ForceSwitch
Global $ichkForceSwitch, $iForceSwitch, $eForceSwitch = 0, $iProfileBeforeForceSwitch
Global $ichkForceStayDonate
Global $nTotalProfile = 1, $nCurProfile = 1, $nNextProfile
Global $ProfileList
Global $aProfileType[8] ; Type of the all Profiles, 1 = active, 2 = donate, 3 = idle
Global $aMatchProfileAcc[8] ; Accounts match with All Profiles
Global $aDonateProfile, $aActiveProfile
Global $aAttackedCountSwitch[8], $ActiveSwitchCounter = 0, $DonateSwitchCounter = 0
Global $bReMatchAcc = False
Global $aTimerStart[8], $aTimerEnd[8]
Global $aRemainTrainTime[8], $aUpdateRemainTrainTime[8], $nMinRemainTrain
Global $aLocateAccConfig[8], $aAccPosY[8]

Global $g_bNeedLocateLab = True, $g_bLabReady[9]
Global $g_aLabTimeAcc[8], $g_aLabTime[4] = [0, 0, 0, 0] ; day | hour | minute | time in minutes
Global $g_aLabTimerStart[8], $g_aLabTimerEnd[8]
