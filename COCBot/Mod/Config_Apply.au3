;
; MOD Config - Save Data
;

	; by AwesomeGamer
	If $iChkDontRemove = 1 Then
		GUICtrlSetState($chkDontRemove, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkDontRemove, $GUI_UNCHECKED)
	EndIf

	If $iChkBarrackSpell = 1 Then
		GUICtrlSetState($chkBarrackSpell, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkBarrackSpell, $GUI_UNCHECKED)
	EndIf
	
	; SmartZap Settings - Added by LunaEclipse
	If $ichkSmartZap = 1 Then
		GUICtrlSetState($chkSmartLightSpell, $GUI_CHECKED)
		GUICtrlSetState($chkSmartZapDB, $GUI_ENABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_ENABLE)
		GUICtrlSetState($txtMinDark, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkSmartZapDB, $GUI_DISABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_DISABLE)
		GUICtrlSetState($txtMinDark, $GUI_DISABLE)
		GUICtrlSetState($chkSmartLightSpell, $GUI_UNCHECKED)
	EndIf
	If $ichkSmartZapDB = 1 Then
		GUICtrlSetState($chkSmartZapDB, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkSmartZapDB, $GUI_UNCHECKED)
	EndIf
	If $ichkSmartZapSaveHeroes = 1 Then
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($txtMinDark, $itxtMinDE)

	; No League Search
	If $iChkNoLeague[$DB] = 1 Then
		GUICtrlSetState($chkDBNoLeague, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkDBNoLeague, $GUI_UNCHECKED)
	EndIf

	If $iChkNoLeague[$LB] = 1 Then
		GUICtrlSetState($chkABNoLeague, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkABNoLeague, $GUI_UNCHECKED)
	EndIf

	; CSV Deployment Speed Mod
	GUICtrlSetData($sldSelectedSpeedDB, $isldSelectedCSVSpeed[$DB])
	GUICtrlSetData($sldSelectedSpeedAB, $isldSelectedCSVSpeed[$LB])
	sldSelectedSpeedDB()
	sldSelectedSpeedAB()
	
	;Max logout time
	If $TrainLogoutMaxTime = 1 Then
		GUICtrlSetState($chkTrainLogoutMaxTime, $GUI_CHECKED)
	ElseIf $TrainLogoutMaxTime = 0 Then
		GUICtrlSetState($chkTrainLogoutMaxTime, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($txtTrainLogoutMaxTime, $TrainLogoutMaxTimeTXT)	