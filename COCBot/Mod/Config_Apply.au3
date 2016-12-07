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