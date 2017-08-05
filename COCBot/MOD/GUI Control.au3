; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file controls the "MOD" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; QuickTrainCombo
Func chkQuickTrainCombo()
	If GUICtrlRead($g_ahChkArmy[0]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[1]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[2]) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_ahChkArmy[0], $GUI_CHECKED)
		ToolTip("QuickTrainCombo: " & @CRLF & "At least 1 Army Check is required! Default Army1.")
		Sleep(2000)
		ToolTip('')
	EndIf

	If GUICtrlRead($g_ahChkArmy[2]) = $GUI_CHECKED And GUICtrlRead($g_hChkUseQuickTrain) = $GUI_CHECKED Then
		_GUI_Value_STATE("HIDE", $g_hLblRemoveArmy & "#" & $g_hBtnRemoveArmy)
		_GUI_Value_STATE("SHOW", $g_hChkMultiClick)
	Else
		_GUI_Value_STATE("HIDE", $g_hChkMultiClick)
		_GUI_Value_STATE("SHOW", $g_hLblRemoveArmy & "#" & $g_hBtnRemoveArmy)
	EndIf

EndFunc   ;==>chkQuickTrainCombo

; SmartTrain
Func chkSmartTrain()
	If GUICtrlRead($g_hchkSmartTrain) = $GUI_CHECKED Then
		If GUICtrlRead($g_hChkUseQuickTrain) = $GUI_UNCHECKED Then _GUI_Value_STATE("ENABLE", $g_hchkPreciseTroops)
		_GUI_Value_STATE("ENABLE", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
		chkPreciseTroops()
		chkFillArcher()
	Else
		_GUI_Value_STATE("DISABLE", $g_hchkPreciseTroops & "#" & $g_hchkFillArcher & "#" & $g_htxtFillArcher & "#" & $g_hchkFillEQ)
		_GUI_Value_STATE("UNCHECKED", $g_hchkPreciseTroops & "#" & $g_hchkFillArcher & "#" & $g_hchkFillEQ)
	EndIf
EndFunc   ;==>chkSmartTrain

Func chkPreciseTroops()
	If GUICtrlRead($g_hchkPreciseTroops) = $GUI_CHECKED Then
		_GUI_Value_STATE("DISABLE", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
		_GUI_Value_STATE("UNCHECKED", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
		chkFillArcher()
	Else
		_GUI_Value_STATE("ENABLE", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
	EndIf
EndFunc   ;==>chkPreciseTroops

Func chkFillArcher()
	If GUICtrlRead($g_hchkFillArcher) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_htxtFillArcher)
	Else
		_GUI_Value_STATE("DISABLE", $g_htxtFillArcher)
	EndIf
EndFunc   ;==>chkFillArcher

Func AddProfileToList()
	Switch @GUI_CtrlId
		Case $g_hBtnAddProfile
			SaveConfig_SwitchAcc()

		Case $g_hBtnConfirmAddProfile
			Local $iNewProfile = _GUICtrlComboBox_GetCurSel($g_hCmbProfile)
			Local $UpdatedProfileList = _GUICtrlComboBox_GetListArray($g_hCmbProfile)
			Local $nUpdatedTotalProfile = _GUICtrlComboBox_GetCount($g_hCmbProfile)
			If $iNewProfile <= 7 Then
				_GUICtrlComboBox_SetCurSel($cmbAccountNo[$iNewProfile], -1) ; clear config of new profile
				_GUICtrlComboBox_SetCurSel($cmbProfileType[$iNewProfile], -1)
				For $i = 7 To $iNewProfile + 1 Step -1
					_GUICtrlComboBox_SetCurSel($cmbAccountNo[$i], $aMatchProfileAcc[$i - 1] - 1) ; push config up 1 level. -1 because $aMatchProfileAcc is saved from 1 to 8
					_GUICtrlComboBox_SetCurSel($cmbProfileType[$i], $aProfileType[$i - 1] - 1)
				Next
			EndIf
			btnUpdateProfile()
	EndSwitch
EndFunc   ;==>AddProfileToList

Func RemoveProfileFromList($iDeleteProfile)
	Local $UpdatedProfileList = _GUICtrlComboBox_GetListArray($g_hCmbProfile)
	Local $nUpdatedTotalProfile = _GUICtrlComboBox_GetCount($g_hCmbProfile)
	If $iDeleteProfile <= 7 Then
		For $i = $iDeleteProfile To 7
			If $i <= 6 Then
				_GUICtrlComboBox_SetCurSel($cmbAccountNo[$i], $aMatchProfileAcc[$i + 1] - 1)
				_GUICtrlComboBox_SetCurSel($cmbProfileType[$i], $aProfileType[$i + 1] - 1)
			Else
				_GUICtrlComboBox_SetCurSel($cmbAccountNo[$i], -1)
				_GUICtrlComboBox_SetCurSel($cmbProfileType[$i], -1)
			EndIf
		Next
	EndIf
	btnUpdateProfile()
EndFunc   ;==>RemoveProfileFromList

Func g_btnUpdateProfile()
	btnUpdateProfile()
EndFunc   ;==>g_btnUpdateProfile

Func btnUpdateProfile($Config = True)

	If $Config = True Then
		SaveConfig_SwitchAcc()
		ReadConfig_SwitchAcc()
		ApplyConfig_SwitchAcc("Read")
	EndIf

	$aActiveProfile = _ArrayFindAll($aProfileType, $eActive)
	$aDonateProfile = _ArrayFindAll($aProfileType, $eDonate)
	$ProfileList = _GUICtrlComboBox_GetListArray($g_hCmbProfile)
	$nTotalProfile = _Min(8, _GUICtrlComboBox_GetCount($g_hCmbProfile))

	For $i = 0 To 7
		If $i <= $nTotalProfile - 1 Then
			GUICtrlSetData($lblProfileName[$i], $ProfileList[$i + 1])
			For $j = $lblProfileNo[$i] To $cmbProfileType[$i]
				GUICtrlSetState($j, $GUI_SHOW)
			Next
			; Update stats GUI
			For $j = $aStartHide[$i] To $aEndHide[$i]
				GUICtrlSetState($j, $GUI_SHOW)
			Next
			Switch $aProfileType[$i]
				Case 1
					GUICtrlSetData($grpVillageAcc[$i], $ProfileList[$i + 1] & " (Active)")
				Case 2
					GUICtrlSetData($grpVillageAcc[$i], $ProfileList[$i + 1] & " (Donate)")
;~ 					For $j = $aSecondHide[$i] To $aEndHide[$i]
;~ 						GUICtrlSetState($j, $GUI_HIDE)
;~ 					Next
				Case Else
					GUICtrlSetData($grpVillageAcc[$i], $ProfileList[$i + 1] & " (Idle)")
;~ 					For $j = $aSecondHide[$i] To $aEndHide[$i]
;~ 						GUICtrlSetState($j, $GUI_HIDE)
;~ 					Next
			EndSwitch
		Else
			GUICtrlSetData($lblProfileName[$i], "")
			_GUICtrlComboBox_SetCurSel($cmbAccountNo[$i], -1)
			_GUICtrlComboBox_SetCurSel($cmbProfileType[$i], -1)
			For $j = $lblProfileNo[$i] To $cmbProfileType[$i]
				GUICtrlSetState($j, $GUI_HIDE)
			Next
			; Update stats GUI
			For $j = $aStartHide[$i] To $aEndHide[$i]
				GUICtrlSetState($j, $GUI_HIDE)
			Next
		EndIf
	Next
EndFunc   ;==>btnUpdateProfile

Func btnClearProfile()
	For $i = 0 To 7
		_GUICtrlComboBox_SetCurSel($cmbAccountNo[$i], -1)
		_GUICtrlComboBox_SetCurSel($cmbProfileType[$i], -1)
	Next
EndFunc   ;==>btnClearProfile

Func chkSwitchAcc()
	If GUICtrlRead($chkSwitchAcc) = $GUI_CHECKED Then
		If _GUICtrlComboBox_GetCount($g_hCmbProfile) <= 1 Then
			GUICtrlSetState($chkSwitchAcc, $GUI_UNCHECKED)
			MsgBox($MB_OK, GetTranslated(109, 60, "SwitchAcc Mode"), GetTranslated(109, 61, "Cannot enable SwitchAcc Mode") & @CRLF & GetTranslated(109, 62, "You have only ") & _GUICtrlComboBox_GetCount($g_hCmbProfile) & " Profile", 30, $g_hGUI_BOT)
		Else
			For $i = $cmbTotalAccount To $g_EndHideSwitchAcc
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
			radNormalSwitch()
			chkForceSwitch()
			btnUpdateProfile(False)
		EndIf
	Else
		_GUI_Value_STATE("UNCHECKED", $g_hChkForceSwitch & "#" & $g_hChkForceStayDonate)
		For $i = $cmbTotalAccount To $g_EndHideSwitchAcc
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		For $j = $aStartHide[0] To $aEndHide[7]
			GUICtrlSetState($j, $GUI_HIDE)
		Next
	EndIf
EndFunc   ;==>chkSwitchAcc

Func radNormalSwitch()
	If GUICtrlRead($radNormalSwitch) = $GUI_CHECKED Then
		_GUI_Value_STATE("UNCHECKED", $g_hChkForceStayDonate & "#" & $chkUseTrainingClose)
		_GUI_Value_STATE("DISABLE", $g_hChkForceStayDonate & "#" & $chkUseTrainingClose & "#" & $radCloseCoC & "#" & $radCloseAndroid)
	Else
		_GUI_Value_STATE("ENABLE", $g_hChkForceStayDonate & "#" & $chkUseTrainingClose & "#" & $radCloseCoC & "#" & $radCloseAndroid)
	EndIf
EndFunc   ;==>radNormalSwitch

Func chkForceSwitch()
	If GUICtrlRead($g_hChkForceSwitch) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_txtForceSwitch & "#" & $g_lblForceSwitch)
	Else
		_GUI_Value_STATE("DISABLE", $g_txtForceSwitch & "#" & $g_lblForceSwitch)
	EndIf
EndFunc   ;==>chkForceSwitch

Func cmbMatchProfileAcc1()
	MatchProfileAcc(0)
EndFunc   ;==>cmbMatchProfileAcc1
Func cmbMatchProfileAcc2()
	MatchProfileAcc(1)
EndFunc   ;==>cmbMatchProfileAcc2
Func cmbMatchProfileAcc3()
	MatchProfileAcc(2)
EndFunc   ;==>cmbMatchProfileAcc3
Func cmbMatchProfileAcc4()
	MatchProfileAcc(3)
EndFunc   ;==>cmbMatchProfileAcc4
Func cmbMatchProfileAcc5()
	MatchProfileAcc(4)
EndFunc   ;==>cmbMatchProfileAcc5
Func cmbMatchProfileAcc6()
	MatchProfileAcc(5)
EndFunc   ;==>cmbMatchProfileAcc6
Func cmbMatchProfileAcc7()
	MatchProfileAcc(6)
EndFunc   ;==>cmbMatchProfileAcc7
Func cmbMatchProfileAcc8()
	MatchProfileAcc(7)
EndFunc   ;==>cmbMatchProfileAcc8

Func MatchProfileAcc($Num)
	If _GUICtrlComboBox_GetCurSel($cmbAccountNo[$Num]) > _GUICtrlComboBox_GetCurSel($cmbTotalAccount) Then
		MsgBox($MB_OK, GetTranslated(109, 70, "SwitchAcc Mode"), GetTranslated(109, 71, "Account [") & _GUICtrlComboBox_GetCurSel($cmbAccountNo[$Num]) & GetTranslated(109, 72, "] exceeds Total Account declared"), 30, $g_hGUI_BOT)
		_GUICtrlComboBox_SetCurSel($cmbAccountNo[$Num], -1)
		_GUICtrlComboBox_SetCurSel($cmbProfileType[$Num], -1)
		btnUpdateProfile()
	EndIf

	Local $AccSelected = _GUICtrlComboBox_GetCurSel($cmbAccountNo[$Num])
	If $AccSelected >= 0 Then
		For $i = 0 To 7
			If $i = $Num Then ContinueLoop
			If $AccSelected = _GUICtrlComboBox_GetCurSel($cmbAccountNo[$i]) Then
				MsgBox($MB_OK, GetTranslated(109, 70, "SwitchAcc Mode"), GetTranslated(109, 71, "Account [") & $AccSelected + 1 & GetTranslated(109, 73, "] has been assigned to Profile [") & $i + 1 & "]", 30, $g_hGUI_BOT)
				_GUICtrlComboBox_SetCurSel($cmbAccountNo[$Num], -1)
				_GUICtrlComboBox_SetCurSel($cmbProfileType[$Num], -1)
				btnUpdateProfile()
				ExitLoop
			EndIf
		Next

		If _GUICtrlComboBox_GetCurSel($cmbAccountNo[$Num]) >= 0 Then
			_GUICtrlComboBox_SetCurSel($cmbProfileType[$Num], 0)
			btnUpdateProfile()
		EndIf
	EndIf
EndFunc   ;==>MatchProfileAcc

Func btnLocateAcc()
	Local $AccNo = _GUICtrlComboBox_GetCurSel($cmbLocateAcc) + 1
	Local $stext, $MsgBox

	Local $wasRunState = $g_bRunState
	$g_bRunState = True

	SetLog(GetTranslated(109, 80, "Locating Y-Coordinate of CoC Account No. ") & $AccNo & GetTranslated(109, 81, ", please wait..."), $COLOR_BLUE)
	WinGetAndroidHandle()

	Zoomout()

	Click(820, 585, 1, 0, "Click Setting") ;Click setting
	Sleep(500)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = GetTranslated(109, 82, "Click Connect/Disconnect on emulator to show the accout list") & @CRLF & @CRLF & _
				GetTranslated(109, 83, "Click OK then click on your Account No. ") & $AccNo & @CRLF & @CRLF & _
				GetTranslated(109, 84, "Do not move mouse quickly after clicking location") & @CRLF & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslated(109, 85, "Ok|Cancel"), GetTranslated(109, 86, "Locate CoC Account No. ") & $AccNo, $stext, 60, $g_hFrmBot)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			Local $aPos = FindPos()
			$aLocateAccConfig[$AccNo - 1] = Int($aPos[1])
			ClickP($aAway, 1, 0, "#0379")
		Else
			SetLog(GetTranslated(109, 87, "Locate CoC Account Cancelled"), $COLOR_BLUE)
			ClickP($aAway, 1, 0, "#0382")
			Return
		EndIf
		SetLog(GetTranslated(109, 88, "Locate CoC Account Successfully: ") & "(383, " & $aLocateAccConfig[$AccNo - 1] & ")", $COLOR_GREEN)

		ExitLoop
	WEnd
	Clickp($aAway, 2, 0, "#0207")
	IniWriteS($profile, "Switch Account", "AccLocation." & $AccNo, $aLocateAccConfig[$AccNo - 1])
	$g_bRunState = $wasRunState
	AndroidShield("LocateAcc") ; Update shield status due to manual $RunState

EndFunc   ;==>btnLocateAcc

Func btnClearAccLocation()
	For $i = 1 To 8
		$aLocateAccConfig[$i - 1] = -1
		$aAccPosY[$i - 1] = -1
	Next
	Setlog(GetTranslated(109, 89, "Position of all accounts cleared"))
	SaveConfig_SwitchAcc()
EndFunc   ;==>btnClearAccLocation

; Classic Four Finger (Demen) - Added by NguyenAnhHD
Func cmbStandardDropSidesAB() ; avoid conflict between FourFinger and SmartAttack
	If _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropSidesAB) = 4 Then
		GUICtrlSetState($g_hChkSmartAttackRedAreaAB, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkSmartAttackRedAreaAB, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hChkSmartAttackRedAreaAB, $GUI_ENABLE)
	EndIf
	chkSmartAttackRedAreaAB()
EndFunc   ;==>g_hCmbStandardDropSidesAB

Func cmbStandardDropSidesDB() ; avoid conflict between FourFinger and SmartAttack
	If _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropSidesDB) = 4 Then
		GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_ENABLE)
	EndIf
	chkSmartAttackRedAreaDB()
EndFunc   ;==>g_hCmbStandardDropSidesDB

Func Bridge()
    cmbDeployDB()
    cmbStandardDropSidesDB()
EndFunc ;==>Bridge

; CSV Deployment Speed Mod
Func sldSelectedSpeedDB()
	$isldSelectedCSVSpeed[$DB] = GUICtrlRead($sldSelectedSpeedDB)
	Local $speedText = $iCSVSpeeds[$isldSelectedCSVSpeed[$DB]] & "x";
	IF $isldSelectedCSVSpeed[$DB] = 3 Then $speedText = "Normal"
	GUICtrlSetData($lbltxtSelectedSpeedDB, $speedText & " speed")
EndFunc   ;==>sldSelectedSpeedDB

Func sldSelectedSpeedAB()
	$isldSelectedCSVSpeed[$LB] = GUICtrlRead($sldSelectedSpeedAB)
	Local $speedText = $iCSVSpeeds[$isldSelectedCSVSpeed[$LB]] & "x";
	IF $isldSelectedCSVSpeed[$LB] = 3 Then $speedText = "Normal"
	GUICtrlSetData($lbltxtSelectedSpeedAB, $speedText & " speed")
EndFunc   ;==>sldSelectedSpeedAB
