; #FUNCTION# ====================================================================================================================
; Name ..........: Config_Save.au3
; Description ...: Saves all of the GUI values to the config.ini and building.ini files
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SaveConfig_SwitchAcc()
	ApplyConfig_SwitchAcc("Save")

	IniWriteS($profile, "SwitchAcc", "Enable", $ichkSwitchAcc ? 1 : 0)
	IniWriteS($profile, "SwitchAcc", "Total Coc Account", $icmbTotalCoCAcc) ; 1 = 1 Acc, 2 = 2 Acc, etc.
	IniWriteS($profile, "SwitchAcc", "Smart Switch", $ichkSmartSwitch ? 1 : 0)
	IniWriteS($profile, "SwitchAcc", "Force Switch", $ichkForceSwitch ? 1 : 0)
	IniWriteS($profile, "SwitchAcc", "Force Switch Search", $iForceSwitch)
	IniWriteS($profile, "SwitchAcc", "Force Stay Donate", $ichkForceStayDonate ? 1 : 0)
	IniWriteS($profile, "SwitchAcc", "Sleep Combo", $ichkCloseTraining) ; 0 = No Sleep, 1 = Close CoC, 2 = Close Android
	For $i = 1 To 8
		IniWriteS($profile, "SwitchAcc", "MatchProfileAcc." & $i, _GUICtrlComboBox_GetCurSel($cmbAccountNo[$i - 1]) + 1) ; 1 = Acc 1, 2 = Acc 2, etc.
		IniWriteS($profile, "SwitchAcc", "ProfileType." & $i, _GUICtrlComboBox_GetCurSel($cmbProfileType[$i - 1]) + 1) ; 1 = Active, 2 = Donate, 3 = Idle
	Next
EndFunc   ;==>SaveConfig_SwitchAcc


;
; MOD Config - Save Data
;
Func SaveConfig_MOD()

	ApplyConfig_MOD("Save")

	; Max logout time
	If GUICtrlRead($chkTrainLogoutMaxTime) = $GUI_CHECKED Then
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 1)
	Else
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 0)
	EndIf
	IniWrite($config, "TrainLogout", "TrainLogoutMaxTimeTXT", GUICtrlRead($txtTrainLogoutMaxTime))

;
; LunaEclipse
;

	; Multi Finger
	IniWrite($config, "MultiFinger", "Select", _GUICtrlComboBox_GetCurSel($cmbDBMultiFinger))

	; CSV Deployment Speed Mod
	IniWriteS($config, "attack", "CSVSpeedDB", $isldSelectedCSVSpeed[$DB])
	IniWriteS($config, "attack", "CSVSpeedAB", $isldSelectedCSVSpeed[$LB])

;
; AwesomeGamer
;

	; DEB
	If GUICtrlRead($chkDontRemove) = $GUI_CHECKED Then
		IniWrite($config, "troop", "DontRemove", 1)
	Else
		IniWrite($config, "troop", "DontRemove", 0)
	EndIf

	; Check Collectors Outside
	If GUICtrlRead($chkDBMeetCollOutside) = $GUI_CHECKED Then
		IniWriteS($config, "search", "DBMeetCollOutside", 1)
	Else
		IniWriteS($config, "search", "DBMeetCollOutside", 0)
	EndIf
	IniWriteS($config, "search", "DBMinCollOutsidePercent", GUICtrlRead($txtDBMinCollOutsidePercent))

	; Smart Upgrade
	IniWrite($config, "upgrade", "chkSmartUpgrade", $ichkSmartUpgrade)
	IniWrite($config, "upgrade", "chkIgnoreTH", $ichkIgnoreTH)
	IniWrite($config, "upgrade", "chkIgnoreKing", $ichkIgnoreKing)
	IniWrite($config, "upgrade", "chkIgnoreQueen", $ichkIgnoreQueen)
	IniWrite($config, "upgrade", "chkIgnoreWarden", $ichkIgnoreWarden)
	IniWrite($config, "upgrade", "chkIgnoreCC", $ichkIgnoreCC)
	IniWrite($config, "upgrade", "chkIgnoreLab", $ichkIgnoreLab)
	IniWrite($config, "upgrade", "chkIgnoreBarrack", $ichkIgnoreBarrack)
	IniWrite($config, "upgrade", "chkIgnoreDBarrack", $ichkIgnoreDBarrack)
	IniWrite($config, "upgrade", "chkIgnoreFactory", $ichkIgnoreFactory)
	IniWrite($config, "upgrade", "chkIgnoreDFactory", $ichkIgnoreDFactory)
	IniWrite($config, "upgrade", "chkIgnoreGColl", $ichkIgnoreGColl)
	IniWrite($config, "upgrade", "chkIgnoreEColl", $ichkIgnoreEColl)
	IniWrite($config, "upgrade", "chkIgnoreDColl", $ichkIgnoreDColl)
	IniWrite($config, "upgrade", "SmartMinGold", GUICtrlRead($SmartMinGold))
	IniWrite($config, "upgrade", "SmartMinElixir", GUICtrlRead($SmartMinElixir))
	IniWrite($config, "upgrade", "SmartMinDark", GUICtrlRead($SmartMinDark))

EndFunc   ;==>SaveConfig_MOD
