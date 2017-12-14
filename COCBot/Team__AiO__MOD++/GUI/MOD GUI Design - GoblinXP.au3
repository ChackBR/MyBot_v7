; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design - GoblinXP
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Mr.Viper
; Modified ......: AiO++ Team
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $grpSuperXP = 0, $chkEnableSuperXP = 0, $chkSkipZoomOutXP = 0, $rbSXTraining = 0, $lblLOCKEDSX = 0, $rbSXIAttacking = 0, $txtMaxXPtoGain = 0
Global $chkSXBK = 0, $chkSXAQ = 0, $chkSXGW = 0
Global $DocXP1 = 0, $DocXP2 = 0, $DocXP3 = 0, $DocXP4 = 0
Global $lblXPatStart = 0, $lblXPCurrent = 0, $lblXPSXWon = 0, $lblXPSXWonHour = 0

Func GoblinXPGUI()

	Local $x = 25, $y = 45, $xStart = 25, $yStart = 45
	$grpSuperXP = GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "Group_01", "Goblin XP"), $x - 20, $y - 20, $g_iSizeWGrpTab2, $g_iSizeHGrpTab3)
		$chkEnableSuperXP = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "chkEnableSuperXP", "Enable Goblin XP"), $x, $y - 1, 102, 17, -1, -1)
		GUICtrlSetOnEvent(-1, "chkEnableSuperXP")
			$chkSkipZoomOutXP = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "chkSkipZoomOutXP", "Skip ZoomOut"), $x + 130, $y - 3, -1, -1)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")
			$rbSXTraining = GUICtrlCreateRadio(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "rbSXTraining", "Farm XP during troops Training"), $x, $y + 25, 175, 17)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")
			$lblLOCKEDSX = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "lblLOCKEDSX", "LOCKED"), $x + 210, $y + 35, 173, 50)
			GUICtrlSetFont(-1, 30, 800, 0, "Arial")
			GUICtrlSetColor(-1, 0xFF0000)
			GUICtrlSetState(-1, $GUI_HIDE)
			$rbSXIAttacking = GUICtrlCreateRadio(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "rbSXIAttacking", "Farm XP instead of Attacking"), $x, $y + 45, 158, 17)
			GUICtrlCreateLabel (GetTranslatedFileIni("MOD GUI Design - GoblinXP", "rbSXIAttacking_Info_01", "Max XP to Gain") & ":", $x, $y + 78, -1, 17)
			GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")
			$txtMaxXPtoGain = GUICtrlCreateInput("500", $x + 85, $y + 75, 70, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 8)
			GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")
	$x += 129
	$y += 120
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "Label_01", "Use"), $x - 35, $y + 13, 23, 17)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x, $y, 32, 32)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x + 40, $y, 32, 32)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x + 80, $y, 32, 32)
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "Label_02", "to gain XP"), $x + 123, $y + 13, 53, 17)
	$x += 10
		$chkSXBK = GUICtrlCreateCheckbox("", $x, $y + 35, 13, 13)
		GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")
		$chkSXAQ = GUICtrlCreateCheckbox("", $x + 40, $y + 35, 13, 13)
		GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")
		$chkSXGW = GUICtrlCreateCheckbox("", $x + 80, $y + 35, 13, 13)
		GUICtrlSetOnEvent(-1, "chkEnableSuperXP2")

	$x = $xStart + 25
	$y += 85
		GUICtrlCreateLabel("", $x - 25, $y, 5, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP1 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "DocXP1", "XP at Start"), $x - 20, $y, 98, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP2 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "DocXP2", "Current XP"), $x + 63 + 15, $y, 104, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP3 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "DocXP3", "XP Won"), $x + 71 + 76 + 35, $y, 103, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP4 = GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "DocXP4", "XP Won/Hour"), $x + 69 + 55 + 110 + 45, $y, 87, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
	$y += 15
			GUICtrlCreateLabel("", $x - 25, $y + 7, 5, 36)
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPatStart = GUICtrlCreateLabel("0", $x - 20, $y + 7, 99, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPCurrent = GUICtrlCreateLabel("0", $x + 78, $y + 7, 105, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPSXWon = GUICtrlCreateLabel("0", $x + 182, $y + 7, 97, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPSXWonHour = GUICtrlCreateLabel("0", $x + 279, $y + 7, 87, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)

	$x = $xStart
	$y += 60
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "Label_03", "Goblin XP attack continuously the TH of Goblin Picnic to farm XP."), $x, $y, -1, 17)
		GUICtrlCreateLabel(GetTranslatedFileIni("MOD GUI Design - GoblinXP", "Label_04", "At each attack, you win 5 XP"), $x, $y + 20, -1, 17)

	chkEnableSuperXP()

	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>GoblinXPGUI
