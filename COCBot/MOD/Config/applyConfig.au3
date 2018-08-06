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

			; Check Collector Outside - Team AiO MOD++
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

			; Classic Four Finger - Team AiO MOD++
			Bridge()

		Case "Save"

			; Check Collector Outside - Team AiO MOD++
			$g_bDBMeetCollOutside = (GUICtrlRead($g_hChkDBMeetCollOutside) = $GUI_CHECKED)
			$g_iTxtDBMinCollOutsidePercent = GUICtrlRead($g_hTxtDBMinCollOutsidePercent)
			$g_bDBCollectorsNearRedline = GUICtrlRead($g_hChkDBCollectorsNearRedline) = $GUI_CHECKED ? 1 : 0
			$g_iCmbRedlineTiles = _GUICtrlComboBox_GetCurSel($g_hCmbRedlineTiles)
			$g_bSkipCollectorCheck = GUICtrlRead($g_hChkSkipCollectorCheck) = $GUI_CHECKED ? 1 : 0
			$g_iTxtSkipCollectorGold = GUICtrlRead($g_hTxtSkipCollectorGold)
			$g_iTxtSkipCollectorElixir = GUICtrlRead($g_hTxtSkipCollectorElixir)
			$g_iTxtSkipCollectorDark = GUICtrlRead($g_hTxtSkipCollectorDark)
			$g_bSkipCollectorCheckTH = GUICtrlRead($g_hChkSkipCollectorCheckTH) = $GUI_CHECKED ? 1 : 0
			$g_iCmbSkipCollectorCheckTH = _GUICtrlComboBox_GetCurSel($g_hCmbSkipCollectorCheckTH)

	EndSwitch
EndFunc   ;==>ApplyConfig_MOD
