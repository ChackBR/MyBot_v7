; #FUNCTION# ====================================================================================================================
; Name ..........: Config_Apply.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........:
; Parameters ....:
; Return values .: NA
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;
; MOD Config - Save Data
;

	;Max logout time
	If $TrainLogoutMaxTime = 1 Then
		GUICtrlSetState($chkTrainLogoutMaxTime, $GUI_CHECKED)
	ElseIf $TrainLogoutMaxTime = 0 Then
		GUICtrlSetState($chkTrainLogoutMaxTime, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($txtTrainLogoutMaxTime, $TrainLogoutMaxTimeTXT)

;
; LunaEclipse
;

	; Multi Finger
	_GUICtrlComboBox_SetCurSel($cmbDBMultiFinger,$iMultiFingerStyle)
	cmbDBMultiFinger()

	; CSV Deployment Speed Mod
	GUICtrlSetData($sldSelectedSpeedDB, $isldSelectedCSVSpeed[$DB])
	GUICtrlSetData($sldSelectedSpeedAB, $isldSelectedCSVSpeed[$LB])
	sldSelectedSpeedDB()
	sldSelectedSpeedAB()

;
; AwesomeGamer
;

	; DEB
	If $iChkDontRemove = 1 Then
		GUICtrlSetState($chkDontRemove, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkDontRemove, $GUI_UNCHECKED)
	EndIf

	; Check Collectors Outside
	If $ichkDBMeetCollOutside = 1 Then
		GUICtrlSetState($chkDBMeetCollOutside, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkDBMeetCollOutside, $GUI_UNCHECKED)
	EndIf
	chkDBMeetCollOutside()
	GUICtrlSetData($txtDBMinCollOutsidePercent, $iDBMinCollOutsidePercent)

	; Smart Upgarde
	If $ichkSmartUpgrade = 1 Then
		GUICtrlSetState($chkSmartUpgrade, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkSmartUpgrade, $GUI_UNCHECKED)
	EndIf
	chkSmartUpgrade()

	GUICtrlSetData($SmartMinGold, $iSmartMinGold)
	GUICtrlSetData($SmartMinElixir, $iSmartMinElixir)
	GUICtrlSetData($SmartMinDark, $iSmartMinDark)

	If $ichkIgnoreTH = 1 Then
		GUICtrlSetState($chkIgnoreTH, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreTH, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreKing = 1 Then
		GUICtrlSetState($chkIgnoreKing, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreKing, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreQueen = 1 Then
		GUICtrlSetState($chkIgnoreQueen, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreQueen, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreWarden = 1 Then
		GUICtrlSetState($chkIgnoreWarden, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreWarden, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreCC = 1 Then
		GUICtrlSetState($chkIgnoreCC, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreCC, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreLab = 1 Then
		GUICtrlSetState($chkIgnoreLab, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreLab, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreBarrack = 1 Then
		GUICtrlSetState($chkIgnoreBarrack, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreBarrack, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreDBarrack = 1 Then
		GUICtrlSetState($chkIgnoreDBarrack, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreDBarrack, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreFactory = 1 Then
		GUICtrlSetState($chkIgnoreFactory, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreFactory, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreDFactory = 1 Then
		GUICtrlSetState($chkIgnoreDFactory, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreDFactory, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreGColl = 1 Then
		GUICtrlSetState($chkIgnoreGColl, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreGColl, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreEColl = 1 Then
		GUICtrlSetState($chkIgnoreEColl, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreEColl, $GUI_UNCHECKED)
	EndIf

	If $ichkIgnoreDColl = 1 Then
		GUICtrlSetState($chkIgnoreDColl, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkIgnoreDColl, $GUI_UNCHECKED)
	EndIf
	chkSmartUpgrade()

