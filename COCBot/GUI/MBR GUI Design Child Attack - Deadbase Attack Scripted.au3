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

Global $cmbScriptNameDB, $lblNotesScriptAB

$hGUI_DEADBASE_ATTACK_SCRIPTED = GUICreate("", $_GUI_MAIN_WIDTH - 195, $_GUI_MAIN_HEIGHT - 344, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_DEADBASE)
;GUISetBkColor($COLOR_WHITE, $hGUI_DEADBASE_ATTACK_SCRIPTED)

Local $x = 25, $y = 20
	$grpAttackCSVDB = GUICtrlCreateGroup(GetTranslated(607,1,"Deploy"), $x - 20, $y - 20, 270, 306)
;	 $x -= 15
;		$chkmakeIMGCSVDB = GUICtrlCreateCheckbox(GetTranslated(607,2, "IMG"), $x + 150, $y, -1, -1)
;			$txtTip = GetTranslated(607,3, "Make IMG with extra info in Profile -> Temp Folder")
;			GUICtrlSetState(-1, $GUI_UNCHECKED)
;			GUICtrlSetState(-1, $GUI_HIDE)
;			_GUICtrlSetTip(-1, $txtTip)
		$y +=5
		$cmbScriptNameDB = GUICtrlCreateCombo("", $x, $y, 200, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
			$txtTip = GetTranslated(607,4, "Choose the script; You can edit/add new scripts located in folder: 'CSV/Attack'")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "cmbScriptNameDB")
		$picreloadScriptsDB = GUICtrlCreateIcon($pIconLib, $eIcnReload, $x + 210, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,5, "Reload Script Files")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, 'UpdateComboScriptNameDB') ; Run this function when the secondary GUI [X] is clicked
		$y +=20
		$lblNotesScriptDB =  GUICtrlCreateLabel("", $x, $y + 5, 208, 112)
		$cmbScriptRedlineImplDB = GUICtrlCreateCombo("", $x, $y + 205, 230, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(607,9, "ImgLoc Raw Redline (default)|ImgLoc Redline Drop Points|Original Redline|External Edges"))
			_GUICtrlComboBox_SetCurSel(-1, $iRedlineRoutine[$DB])
			$txtTip = GetTranslated(607,10, "Choose the Redline implementation. ImgLoc Redline is default and best.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "cmbScriptRedlineImplDB")
		$cmbScriptDroplineDB = GUICtrlCreateCombo("", $x, $y + 230, 230, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(607,11, "Drop line fix outer corner|Drop line fist Redline point|Full Drop line fix outer corner|Full Drop line fist Redline point|No Drop line"))
			_GUICtrlComboBox_SetCurSel(-1, $iDroplineEdge[$DB])
			$txtTip = GetTranslated(607,12, "Choose the drop line edges. Default is outer corner and safer. First Redline point can improve attack.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "cmbScriptDroplineDB")
		$picreloadScripts = GUICtrlCreateIcon($pIconLib, $eIcnEdit, $x + 210, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,6, "Show/Edit current Attack Script")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "EditScriptDB")
		$y +=25
		$picnewScriptsDB = GUICtrlCreateIcon($pIconLib, $eIcnAddcvs, $x + 210, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,7, "Create a new Attack Script")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "NewScriptDB")
		$y +=25
		$picduplicateScriptsDB = GUICtrlCreateIcon($pIconLib, $eIcnCopy, $x + 210, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,8, "Copy current Attack Script to a new name")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "DuplicateScriptDB")

	; Attack Now (CSV) By MR.ViPeR
	$y += 106
	$btnAttNowDB = GUICtrlCreateButton(GetTranslated(671, 58, "Attack Now: Testing CSV File"), $x, $y-30, -1, 25)
		_GUICtrlSetTip(-1, "Attack Now Button (Useful for CSV Testing)")
		;GUISetState(@SW_SHOW)
		GUICtrlSetOnEvent(-1, "AttackNowDB")

	; CSV Deployment Speed Mod
	$y -=4
	$grpScriptSpeedDB = GUICtrlCreateGroup(GetTranslated(671, 55, "CSV Deployment Speed - Dead Base"), $x, $y, 230, 50)
		$lbltxtSelectedSpeedDB = GUICtrlCreateLabel("Normal speed", $x + 10, $y+20, 75, 25)
			$txtTip = GetTranslated(671, 56, "Increase or decrease the speed at which the CSV attack script deploys troops and waves.")
			_GUICtrlSetTip(-1, $txtTip)
		$sldSelectedSpeedDB = GUICtrlCreateSlider($x + 98, $y + 20, 125, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
			_GUICtrlSetTip(-1, $txtTip)
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 18, 0) ; change max/min value
			GUICtrlSetData(-1, 5) ; default value
			GUICtrlSetOnEvent(-1, "sldSelectedSpeedDB")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

;GUISetState()

;------------------------------------------------------------------------------------------
;----- populate list of script and assign the default value if no exist profile -----------
UpdateComboScriptNameDB()
Local $tempindex = _GUICtrlComboBox_FindStringExact($cmbScriptNameDB, $scmbDBScriptName)
If $tempindex = -1 Then $tempindex = 0
_GUICtrlComboBox_SetCurSel($cmbScriptNameDB, $tempindex)
;------------------------------------------------------------------------------------------
