; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design - FarmSchedule (#-27)
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......: AiO++ Team
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_ahChkSetFarm[8]
Global $g_ahCmbAction1[8], $g_ahCmbCriteria1[8], $g_ahTxtResource1[8], $g_ahCmbTime1[8]
Global $g_ahCmbAction2[8], $g_ahCmbCriteria2[8], $g_ahTxtResource2[8], $g_ahCmbTime2[8]

Func CreateModFarmSchedule()

	Local $x = 10, $y = 30

	GUICtrlCreateLabel("Account", $x - 5, $y, 60, -1, $SS_CENTER)
	GUICtrlCreateLabel("Farm Schedule 1", $x + 80, $y, 150, -1, $SS_CENTER)
	GUICtrlCreateLabel("Farm Schedule 2", $x + 260, $y, 150, -1, $SS_CENTER)

	$y += 18
	GUICtrlCreateGraphic($x, $y, 417, 1, $SS_GRAYRECT)

	$y += 8
	For $i = 0 To 7
		$x = 10
		$g_ahChkSetFarm[$i] = GUICtrlCreateCheckbox("Acc " & $i + 1 & ".", $x, $y + $i * 30, -1, -1)
			GUICtrlSetOnEvent(-1, "cmbChkSetFarm")
		$g_ahCmbAction1[$i] = GUICtrlCreateCombo("Turn...", $x + 60, $y + $i * 30, 58, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Idle|Donate|Active")
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$g_ahCmbCriteria1[$i] = GUICtrlCreateCombo("when...", $x + 123, $y + $i * 30, 62, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Gold >|Elixir >|DarkE >|Trop. >|Time:")
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetOnEvent(-1, "cmbCriteria1")
		$g_ahTxtResource1[$i] = GUICtrlCreateInput("", $x + 187, $y + 1 + $i * 30, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$g_ahCmbTime1[$i] = GUICtrlCreateCombo("", $x + 187, $y + $i * 30, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, 	"0 am|1 am|2 am|3 am|4 am|5 am|6 am|7 am|8 am|9 am|10am|11am|" & _
								"12pm|1 pm|2 pm|3 pm|4 pm|5 pm|6 pm|7 pm|8 pm|9 pm|10pm|11pm")
			GUICtrlSetState(-1, $GUI_HIDE)

		$x = 248 + 10 - 60
		$g_ahCmbAction2[$i] = GUICtrlCreateCombo("Turn...", $x + 60, $y + $i * 30, 58, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Idle|Donate|Active")
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$g_ahCmbCriteria2[$i] = GUICtrlCreateCombo("when...", $x + 123, $y + $i * 30, 62, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Gold <|Elixir <|DarkE <|Trop. <|Time:")
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetOnEvent(-1, "cmbCriteria2")
		$g_ahTxtResource2[$i] = GUICtrlCreateInput("", $x + 187, $y + 1 + $i * 30, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$g_ahCmbTime2[$i] = GUICtrlCreateCombo("", $x + 187, $y + $i * 30, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, 	"0 am|1 am|2 am|3 am|4 am|5 am|6 am|7 am|8 am|9 am|10am|11am|" & _
								"12pm|1 pm|2 pm|3 pm|4 pm|5 pm|6 pm|7 pm|8 pm|9 pm|10pm|11pm")
			GUICtrlSetState(-1, $GUI_HIDE)
	Next

EndFunc   ;==>CreateBotFarmSchedule

Func cmbChkSetFarm()
	Local $iCmbTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; combobox data starts with 2
	For $i = 0 To 7
		If $i > $iCmbTotalAcc Then ExitLoop
		If GUICtrlRead($g_ahChkSetFarm[$i]) = $GUI_CHECKED Then
			_GUI_Value_STATE("ENABLE", $g_ahCmbAction1[$i] & "#" & $g_ahCmbAction2[$i] & "#" & $g_ahCmbCriteria1[$i] & "#" & $g_ahCmbCriteria2[$i])
			cmbCriteria1()
			cmbCriteria2()
		Else
			_GUI_Value_STATE("DISABLE", $g_ahCmbAction1[$i] & "#" & $g_ahCmbCriteria1[$i] & "#" & $g_ahTxtResource1[$i] & "#" & $g_ahCmbTime1[$i] & "#" & _
					$g_ahCmbAction2[$i] & "#" & $g_ahCmbCriteria2[$i] & "#" & $g_ahTxtResource2[$i] & "#" & $g_ahCmbTime2[$i])
		EndIf
	Next
EndFunc   ;==>cmbChkSetFarm

Func cmbCriteria1()
	Local $aiDefaultValue[4] = ["6000000", "6000000", "180000", "5000"]
	Local $aiDefaultLimit[4] = [9999999, 9999999, 199999, 9999]
	Local $iCmbTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; combobox data starts with 2
	For $i = 0 To 7
		If $i > $iCmbTotalAcc Then ExitLoop
		If GUICtrlRead($g_ahChkSetFarm[$i]) = $GUI_UNCHECKED Then ContinueLoop
		Local $iCmbCriteria = _GUICtrlComboBox_GetCurSel($g_ahCmbCriteria1[$i])
		Switch $iCmbCriteria
			Case 0
				_GUI_Value_STATE("DISABLE", $g_ahCmbTime1[$i] & "#" & $g_ahTxtResource1[$i])
			Case 1 To 4
				GUICtrlSetState($g_ahCmbTime1[$i], $GUI_HIDE)
				GUICtrlSetState($g_ahTxtResource1[$i], $GUI_SHOW + $GUI_ENABLE)
				If GUICtrlRead($g_ahTxtResource1[$i]) = "" Or GUICtrlRead($g_ahTxtResource1[$i]) > $aiDefaultLimit[$iCmbCriteria - 1] Then GUICtrlSetData($g_ahTxtResource1[$i], $aiDefaultValue[$iCmbCriteria - 1])
				GUICtrlSetLimit($g_ahTxtResource1[$i], StringLen($aiDefaultValue[$iCmbCriteria - 1]))
			Case 5
				GUICtrlSetState($g_ahTxtResource1[$i], $GUI_HIDE)
				GUICtrlSetState($g_ahCmbTime1[$i], $GUI_SHOW + $GUI_ENABLE)
		EndSwitch
	Next
EndFunc   ;==>cmbCriteria1

Func cmbCriteria2()
	Local $aiDefaultValue[4] = ["1000000", "1000000", "020000", "3000"]
	Local $aiDefaultLimit[4] = [9999999, 9999999, 199999, 9999]
	Local $iCmbTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; combobox data starts with 2
	For $i = 0 To 7
		If $i > $iCmbTotalAcc Then ExitLoop
		If GUICtrlRead($g_ahChkSetFarm[$i]) = $GUI_UNCHECKED Then ContinueLoop
		Local $iCmbCriteria = _GUICtrlComboBox_GetCurSel($g_ahCmbCriteria2[$i])
		Switch $iCmbCriteria
			Case 0
				_GUI_Value_STATE("DISABLE", $g_ahTxtResource2[$i] & "#" & $g_ahCmbTime2[$i])
			Case 1 To 4
				GUICtrlSetState($g_ahCmbTime2[$i], $GUI_HIDE)
				GUICtrlSetState($g_ahTxtResource2[$i], $GUI_SHOW + $GUI_ENABLE)
				If GUICtrlRead($g_ahTxtResource2[$i]) = "" Or GUICtrlRead($g_ahTxtResource2[$i]) > $aiDefaultLimit[$iCmbCriteria - 1] Then GUICtrlSetData($g_ahTxtResource2[$i], Number($aiDefaultValue[$iCmbCriteria - 1]))
				GUICtrlSetLimit($g_ahTxtResource2[$i], StringLen($aiDefaultValue[$iCmbCriteria - 1]))
			Case 5
				GUICtrlSetState($g_ahTxtResource2[$i], $GUI_HIDE)
				GUICtrlSetState($g_ahCmbTime2[$i], $GUI_SHOW + $GUI_ENABLE)
		EndSwitch
	Next
EndFunc   ;==>cmbCriteria2
