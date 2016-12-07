;
; MOD Config - Save Data
;

	; Max logout time
	If GUICtrlRead($chkTrainLogoutMaxTime) = $GUI_CHECKED Then
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 1)
	Else
		IniWrite($config, "TrainLogout", "TrainLogoutMaxTime", 0)
	EndIf
	IniWrite($config, "TrainLogout", "TrainLogoutMaxTimeTXT", GUICtrlRead($txtTrainLogoutMaxTime))
