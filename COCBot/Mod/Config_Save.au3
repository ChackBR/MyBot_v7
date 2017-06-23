; #FUNCTION# ====================================================================================================================
; Name ..........: Config_Save.au3
; Description ...: Saves all of the GUI values to the config.ini and building.ini files
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;
; MOD Config - Save Data
;
Func SaveConfig_MOD()

	ApplyConfig_MOD("Save")

;
; Mandrid
;

#CS
	; Max logout time
	If GUICtrlRead($chkTrainLogoutMaxTime) = $GUI_CHECKED Then
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 1)
	Else
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 0)
	EndIf
	IniWrite($config, "TrainLogout", "TrainLogoutMaxTimeTXT", GUICtrlRead($txtTrainLogoutMaxTime))
#CE

;
; LunaEclipse
;

	; Multi Finger
	_Ini_Add("MultiFinger", "Select", $iMultiFingerStyle)

#CS
	; CSV Deploy Speed
	_Ini_Add("Attack", "CSVSpeedDB", $isldSelectedCSVSpeed[$DB])
	_Ini_Add("Attack", "CSVSpeedAB", $isldSelectedCSVSpeed[$LB])
#CE

;
; AwesomeGamer
;

	; Check Collector Outside (McSlither) - Added by NguyenAnhHD
	_Ini_Add("search", "DBMeetCollOutside", $ichkDBMeetCollOutside ? 1 : 0)
	_Ini_Add("search", "DBMinCollOutsidePercent", $iDBMinCollOutsidePercent)

EndFunc   ;==>SaveConfig_MOD

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
