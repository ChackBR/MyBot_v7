; #FUNCTION# ====================================================================================================================
; Name ..........: Global Variables - Mod.au3
; Description ...: Extension of MBR Global Variables for Mod
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

;
; mandryd
;

; Max logout time
Global $TrainLogoutMaxTime, $TrainLogoutMaxTimeTXT

;
; LunaEclipse
;

; Multi Finger Attack Style Setting
Global Enum $directionLeft, $directionRight
Global Enum $sideBottomRight, $sideTopLeft, $sideBottomLeft, $sideTopRight
Global Enum $mfRandom, $mfFFStandard, $mfFFSpiralLeft, $mfFFSpiralRight, $mf8FBlossom, $mf8FImplosion, $mf8FPinWheelLeft, $mf8FPinWheelRight

Global $iMultiFingerStyle = 0

Global Enum  $eCCSpell = $eHaSpell + 1

;
; AwesomeGamer
;

; DEB
Global $iChkDontRemove = 1
Global $chkDontRemove = True

; No League Search
Global $aNoLeague[4] = [30, 30, 0x616568, 20] ; No League Shield
Global $chkDBNoLeague, $chkABNoLeague, $iChkNoLeague[$iModeCount]

