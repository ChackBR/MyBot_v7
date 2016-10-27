; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $cmbScriptNameAB, $lblNotesScriptAB

$hGUI_ACTIVEBASE_ATTACK_SCRIPTED = GUICreate("", $_GUI_MAIN_WIDTH - 195, $_GUI_MAIN_HEIGHT - 344, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_ACTIVEBASE)
;GUISetBkColor($COLOR_WHITE, $hGUI_ACTIVEBASE_ATTACK_SCRIPTED)

Local $x = 25, $y = 20
	$grpAttackCSVAB = GUICtrlCreateGroup(GetTranslated(607,1, -1), $x - 20, $y - 20, 270, 306)
;	$x -= 15
;	    $chkmakeIMGCSVAB = GUICtrlCreateCheckbox(GetTranslated(607,2, -1), $x + 150, $y, -1, -1)
;			$txtTip = GetTranslated(607,3, -1)
;			GUICtrlSetState(-1, $GUI_UNCHECKED)
;			GUICtrlSetState(-1, $GUI_HIDE)
;			_GUICtrlSetTip(-1, $txtTip)
		$y +=15
		$cmbScriptNameAB=GUICtrlCreateCombo("", $x , $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(607,4, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "cmbScriptNameAB")
		$picreloadScriptsAB = GUICtrlCreateIcon($pIconLib, $eIcnReload, $x + 192, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,5, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, 'UpdateComboScriptNameAB') ; Run this function when the secondary GUI [X] is clicked
		$y +=25
			$lblNotesScriptAB =  GUICtrlCreateLabel("", $x, $y + 5, 180, 118)
			PopulateComboScriptsFilesAB() ; populate
			$picreloadScriptsAB = GUICtrlCreateIcon($pIconLib, $eIcnEdit, $x + 192, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,6, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "EditScriptAB")
		$y +=25
			$picnewScriptsAB = GUICtrlCreateIcon($pIconLib, $eIcnAddcvs, $x + 192, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,7, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "NewScriptAB")
		$y +=25
			$picduplicateScriptsAB = GUICtrlCreateIcon($pIconLib, $eIcnCopy, $x + 192, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,8, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "DuplicateScriptAB")

		; Attack Now (CSV) By MR.ViPeR
		$y += 130
		$btnAttNow = GUICtrlCreateButton("Attack Now", $x, $y-30, 91, 25)
				_GUICtrlSetTip(-1, "Attack Now Button (Useful for CSV Testing)")
				GUISetState(@SW_SHOW)
				GUICtrlSetOnEvent(-1, "AttackNowAB")

		; CSV Deployment Speed Mod
		$y +=  4
		$grpScriptSpeedAB = GUICtrlCreateGroup("CSV Deployment Speed", $x, $y, 230, 50)
			$lbltxtSelectedSpeedAB = GUICtrlCreateLabel("Normal speed", $x + 15, $y + 20, 75, 25)
				_GUICtrlSetTip(-1, "Increase or decrease the speed at which the CSV attack script deploys troops and waves.")
			$sldSelectedSpeedAB = GUICtrlCreateSlider($x + 98, $y + 20, 125, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
				_GUICtrlSetTip(-1, "Increase or decrease the speed at which the CSV attack script deploys troops and waves.")
				_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
				_GUICtrlSlider_SetTicFreq(-1, 1)
				GUICtrlSetLimit(-1, 12, 0) ; change max/min value
				GUICtrlSetData(-1, 4) ; default value
				GUICtrlSetOnEvent(-1, "sldSelectedSpeedAB")
			GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

;GUISetState()

;------------------------------------------------------------------------------------------
;----- populate list of script and assign the default value if no exist profile -----------
UpdateComboScriptNameAB()
Local $tempindex = _GUICtrlComboBox_FindStringExact($cmbScriptNameAB, $scmbABScriptName)
If $tempindex = -1 Then 	$tempindex = 0
_GUICtrlComboBox_SetCurSel($cmbScriptNameAB, $tempindex)
;------------------------------------------------------------------------------------------
