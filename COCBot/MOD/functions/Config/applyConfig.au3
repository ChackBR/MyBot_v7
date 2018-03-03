; #FUNCTION# ====================================================================================================================
; Name ..........: applyConfig.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........: applyConfig()
; Parameters ....: $bRedrawAtExit = True, redraws bot window after config was applied
; Return values .: NA
; Author ........: AiO++ Team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;  «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»
;  AiO++ Team
;  «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

Func ApplyConfig_MOD($TypeReadSave)
	Switch $TypeReadSave
		Case "Read"

			; Classic 4Fingers - AiO++ Team
			cmbStandardDropSidesAB()
			Bridge()

			; Check Collector Outside - Persian MOD (#-08)
			GUICtrlSetState($g_hChkDBMeetCollOutside, $g_bDBMeetCollOutside = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtDBMinCollOutsidePercent, $g_iTxtDBMinCollOutsidePercent)

			GUICtrlSetState($g_hChkDBCollectorsNearRedline, $g_bDBCollectorsNearRedline = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbRedlineTiles, $g_iCmbRedlineTiles)

			GUICtrlSetState($g_hChkSkipCollectorCheck, $g_bSkipCollectorCheck = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtSkipCollectorGold, $g_iTxtSkipCollectorGold)
			GUICtrlSetData($g_hTxtSkipCollectorElixir, $g_iTxtSkipCollectorElixir)
			GUICtrlSetData($g_hTxtSkipCollectorDark, $g_iTxtSkipCollectorDark)

			GUICtrlSetState($g_hChkSkipCollectorCheckTH, $g_bSkipCollectorCheckTH = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbSkipCollectorCheckTH, $g_iCmbSkipCollectorCheckTH)
			chkDBMeetCollOutside()

			; Smart Train - Persian MOD (#-13)
			GUICtrlSetState($g_hchkSmartTrain, $ichkSmartTrain = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hchkPreciseTroops, $ichkPreciseTroops = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hchkFillArcher, $ichkFillArcher = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_htxtFillArcher, $iFillArcher)
			GUICtrlSetState($g_hchkFillEQ, $ichkFillEQ = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkSmartTrain()

		Case "Save"

			; Check Collector Outside - Persian MOD (#-08)
			$g_bDBMeetCollOutside = GUICtrlRead($g_hChkDBMeetCollOutside) = $GUI_CHECKED
			$g_iTxtDBMinCollOutsidePercent = GUICtrlRead($g_hTxtDBMinCollOutsidePercent)

			$g_bDBCollectorsNearRedline = GUICtrlRead($g_hChkDBCollectorsNearRedline) = $GUI_CHECKED ? 1 : 0
			$g_iCmbRedlineTiles = _GUICtrlComboBox_GetCurSel($g_hCmbRedlineTiles)

			$g_bSkipCollectorCheck = GUICtrlRead($g_hChkSkipCollectorCheck) = $GUI_CHECKED ? 1 : 0
			$g_iTxtSkipCollectorGold = GUICtrlRead($g_hTxtSkipCollectorGold)
			$g_iTxtSkipCollectorElixir = GUICtrlRead($g_hTxtSkipCollectorElixir)
			$g_iTxtSkipCollectorDark = GUICtrlRead($g_hTxtSkipCollectorDark)

			$g_bSkipCollectorCheckTH = GUICtrlRead($g_hChkSkipCollectorCheckTH) = $GUI_CHECKED ? 1 : 0
			$g_iCmbSkipCollectorCheckTH = _GUICtrlComboBox_GetCurSel($g_hCmbSkipCollectorCheckTH)

			; CSV Deploy Speed - Persian MOD (#-09)
			$icmbCSVSpeed[$LB] = _GUICtrlComboBox_GetCurSel($cmbCSVSpeed[$LB])
			$icmbCSVSpeed[$DB] = _GUICtrlComboBox_GetCurSel($cmbCSVSpeed[$DB])

			; Smart Train - Persian MOD (#-13)
			$ichkSmartTrain = GUICtrlRead($g_hchkSmartTrain) = $GUI_CHECKED ? 1 : 0
			$ichkPreciseTroops = GUICtrlRead($g_hchkPreciseTroops) = $GUI_CHECKED ? 1 : 0
			$ichkFillArcher = GUICtrlRead($g_hchkFillArcher) = $GUI_CHECKED ? 1 : 0
			$iFillArcher = GUICtrlRead($g_htxtFillArcher)
			$ichkFillEQ = GUICtrlRead($g_hchkFillEQ) = $GUI_CHECKED ? 1 : 0

	EndSwitch
EndFunc   ;==>ApplyConfig_MOD
