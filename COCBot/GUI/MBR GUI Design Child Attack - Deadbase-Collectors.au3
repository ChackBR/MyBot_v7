; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Collectors" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkDBDisableCollectorsFilter = 0
Global $g_ahChkDBCollectorLevel[13] = [-1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0] ; elements 0 thru 5 are never referenced
Global $g_ahCmbDBCollectorLevel[13] = [-1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0] ; elements 0 thru 5 are never referenced
Global $g_hCmbMinCollectorMatches = 0, $g_hSldCollectorTolerance = 0, $g_hLblCollectorWarning = 0

; Check Collector Outside - Team AiO MOD++
Global $g_hChkDBMeetCollOutside = 0, $g_hChkDBCollectorsNearRedline = 0, $g_hChkSkipCollectorCheck = 0, $g_hChkSkipCollectorCheckTH = 0
Global $g_hCmbRedlineTiles = 0, $g_hCmbSkipCollectorCheckTH = 0
Global $g_hLblDBMinCollOutsideText = 0, $g_hLblDBMinCollOutsideText1 = 0, $g_hLblRedlineTiles = 0, $g_hLblSkipCollectorCheck = 0
Global $g_hLblSkipCollectorCheckTHText1 = 0, $g_hLblSkipCollectorCheckTHText2 = 0, $g_hLblSkipCollectorGold = 0, $g_hLblSkipCollectorElixir = 0, $g_hLblSkipCollectorDark = 0
Global $g_hTxtDBMinCollOutsidePercent = 0, $g_hTxtSkipCollectorGold = 0, $g_hTxtSkipCollectorElixir = 0, $g_hTxtSkipCollectorDark = 0

Func CreateAttackSearchDeadBaseCollectors()
	Local $x = 10, $y = 45
	Local $s_TxtTip1 = GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel_Info_01", "If this box is checked, then the bot will look")
	Local $g_hTxtFull = GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel_Info_02", "Full")
	Local $sTxtTip = ""

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "Group_01", "Collectors"), $x - 5, $y - 20, $g_iSizeWGrpTab4, $g_iSizeHGrpTab4)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel", "Choose which collectors to search for while looking for a dead base. Also, choose how full they must be."), $x, $y, 250, 28)
		$g_hChkDBDisableCollectorsFilter = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDisableCollectorsFilter", "Disable Collector Filter"), $x + 240, $y + 40, 150, 18)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDisableCollectorsFilter_Info_01", "Disable Collector Filter CHANGES DeadBase into another ActiveBase search"))

	$y += 40
		$g_ahChkDBCollectorLevel[6] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel6_Info_01", "for level 6 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel6", "Lvl 6. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahCmbDBCollectorLevel[6] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel6_Info_01", 'Select how full a level 6 collector needs to be for it to be marked "dead"'))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetData(-1, "50%|100%", "100%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	$y += 25
		$g_ahChkDBCollectorLevel[7] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel7_Info_01", "for level 7 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel7", "Lvl 7. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[7] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel7_Info_01", 'Select how full a level 7 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "100%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	$y += 25
		$g_ahChkDBCollectorLevel[8] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel8_Info_01", "for level 8 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel8", "Lvl 8. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[8] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel8_Info_01", 'Select how full a level 8 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "100%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	$y += 25
		$g_ahChkDBCollectorLevel[9] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel9_Info_01", "for level 9 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel9", "Lvl 9. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[9] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel9_Info_01", 'Select how full a level 9 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "100%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	$y += 25
		$g_ahChkDBCollectorLevel[10] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel10_Info_01", "for level 10 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel10", "Lvl 10. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[10] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel10_Info_01", 'Select how full a level 10 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "100%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	$y += 25
		$g_ahChkDBCollectorLevel[11] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel11_Info_01", "for level 11 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel11", "Lvl 11. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[11] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel11_Info_01", 'Select how full a level 11 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "100%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	$y += 25
		$g_ahChkDBCollectorLevel[12] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel12_Info_01", "for level 12 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel12", "Lvl 12. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[12] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel12_Info_01", 'Select how full a level 12 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblMinCollectorMatches", "Collectors required"), $x, $y + 3, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "CmbMinCollectorMatches_Info_01", 'Select how many collectors are needed to consider village "dead"')
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hCmbMinCollectorMatches = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6", "3")
			GUICtrlSetOnEvent(-1, "cmbMinCollectorMatches")

	$y += 25
		GUICtrlCreateLabel("-15" & _PadStringCenter(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorTolerance", "Tolerance"), 66, " ") & "15", $x, $y)
		;If $g_bDevMode = False Then
			GUICtrlSetState(-1, $GUI_HIDE)
		;EndIf

	$y += 15
		$g_hSldCollectorTolerance = GUICtrlCreateSlider($x, $y, 250, 20, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_01", "Use this slider to adjust the tolerance of ALL images.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_02", "If you want to adjust individual images, you must edit the files.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_03", "WARNING: Do not change this setting unless you know what you are doing. Set it to 0 if you're not sure."))
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 15, -15) ; change max/min value
			GUICtrlSetData(-1, 0) ; default value
			GUICtrlSetOnEvent(-1, "sldCollectorTolerance")
		;If $g_bDevMode = False Then
			GUICtrlSetState(-1, $GUI_HIDE)
		;EndIf

	$y += 25
		$g_hLblCollectorWarning = GUICtrlCreateLabel("Warning: no collecters are selected. The bot will never find a dead base.", $x, $y, 255, 30)
			GUICtrlSetFont(-1, 10, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_ERROR)
			GUICtrlSetState(-1, $GUI_HIDE)

		; Check Collector Outside - AiO++
		$y -= 215
		$x += 240
		$g_hChkDBMeetCollOutside = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkMeetCollOutside", "Check Collectors Outside"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkMeetCollOutside_Info_01", "Search for bases that has their collectors outside."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkDBMeetCollOutside")
		$y += 28
		$g_hLblDBMinCollOutsideText = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblDBMinCollOutsideText", "Min") & ": ", $x + 20, $y, -1, -1)
		$g_hTxtDBMinCollOutsidePercent = GUICtrlCreateInput("80", $x + 50, $y - 3, 31, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkMeetCollOutside_Info_02", "Set the Min. % of collectors outside to search for on a village to attack."))
			GUICtrlSetLimit(-1, 3)
		$g_hLblDBMinCollOutsideText1 = GUICtrlCreateLabel("%", $x + 85, $y, -1, -1)

		$y += 20
		$g_hChkDBCollectorsNearRedline = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDBCollectorsNearRedline", "Collectors near redline"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDBCollectorsNearRedline_Info_01", "Check how many collectors are near redline. If more than % you set then attack."))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollectorsNearRedline")
		$y += 28
		$g_hLblRedlineTiles = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblRedlineTiles", "Tiles") & ": ", $x + 20, $y, -1, -1)
		$g_hCmbRedlineTiles = GUICtrlCreateCombo("", $x + 50, $y - 3, 31, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5", "1")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblRedlineTiles_Info_01", "Distance between redline to collectors. Use Tiles as measure."))

		$y += 20
		$g_hChkSkipCollectorCheck = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkSkipCollectorCheck", "Skip outside collectors check"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkSkipCollectorCheck_Info_01", "If you don't want compare one of the resource below, just set to 0"))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkSkipCollectorCheck")
		$y += 25
		$g_hLblSkipCollectorCheck = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblSkipCollectorCheck", "IF Target Resource Over"), $x + 15, $y, -1, -1)
		$y += 20
		$g_hLblSkipCollectorGold = GUICtrlCreateLabel(ChrW(8805), $x, $y + 2, -1, -1)
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnGold, $x + 60, $y, 16, 16)
		$g_hTxtSkipCollectorGold = GUICtrlCreateInput("400000", $x + 8, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "TxtSkipCollectorGold", "Skip outside collectors check IF target Gold value over"))
			GUICtrlSetLimit(-1, 7)
		$x += 90
		$g_hLblSkipCollectorElixir = GUICtrlCreateLabel(ChrW(8805), $x, $y + 2, -1, -1)
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnElixir, $x + 60, $y, 16, 16)
		$g_hTxtSkipCollectorElixir = GUICtrlCreateInput("400000", $x + 8, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "TxtSkipCollectorElixir", "Skip outside collectors check IF target Elixir value over"))
			GUICtrlSetLimit(-1, 7)
		$y += 25
		$g_hLblSkipCollectorDark = GUICtrlCreateLabel(ChrW(8805), $x - 40, $y + 2, -1, -1)
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnDark, $x + 20, $y, 16, 16)
		$g_hTxtSkipCollectorDark = GUICtrlCreateInput("0", $x - 32, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "TxtSkipCollectorDark", "Skip outside collectors check IF target Dark Elixir value over"))
			GUICtrlSetLimit(-1, 6)

		$y += 25
		$x -= 90
		$g_hChkSkipCollectorCheckTH = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkSkipCollectorCheckTH", "Skip outside collectors check IF"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkSkipCollectorCheckTH_Info_01", "Compare the level if is lower than or equal my setting, just attack!"))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkSkipCollectorCheckTH")
		$y += 25
		$g_hLblSkipCollectorCheckTHText1 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblSkipCollectorCheckTHText", "Target Townhall Level"), $x + 10, $y, -1, -1)
		$g_hLblSkipCollectorCheckTHText2 = GUICtrlCreateLabel(ChrW(8804), $x + 120, $y, -1, -1)
		$g_hCmbSkipCollectorCheckTH = GUICtrlCreateCombo("", $x + 135, $y - 2, 37, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "7|8|9|10", "8")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchDeadBaseCollectors
