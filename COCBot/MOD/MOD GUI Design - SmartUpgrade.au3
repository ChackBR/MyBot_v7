; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Roro-Titi
; Modified ......: Team++ AIO (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_hChkSmartUpgrade = 0
Global $iconIgnoreTH = 0, $iconIgnoreKing = 0, $iconIgnoreQueen = 0, $iconIgnoreWarden = 0, $iconIgnoreCC = 0, $iconIgnoreLab = 0, $iconIgnoreBarrack = 0, $iconIgnoreDBarrack = 0, _
	   $iconIgnoreFactory = 0, $iconIgnoreDFactory = 0, $iconIgnoreGColl = 0, $iconIgnoreEColl = 0, $iconIgnoreDColl = 0
Global $g_hChkIgnoreTH = 0, $g_hChkIgnoreKing = 0, $g_hChkIgnoreQueen = 0, $g_hChkIgnoreWarden = 0, $g_hChkIgnoreCC = 0, $g_hChkIgnoreLab = 0, $g_hChkIgnoreBarrack = 0, $g_hChkIgnoreDBarrack = 0, _
	   $g_hChkIgnoreFactory = 0, $g_hChkIgnoreDFactory = 0, $g_hChkIgnoreGColl = 0, $g_hChkIgnoreEColl = 0, $g_hChkIgnoreDColl = 0
Global $SmartMinGold = 0, $SmartMinElixir = 0, $SmartMinDark = 0, $SmartUpgradeLog = 0

Func CreateSmartUpgradeGUI()

	Local $x = 25, $y = 45

	GUICtrlCreateGroup(GetTranslated(671,1, "SmartUpgrade"), $x - 20, $y - 20, 430, 335)
	$g_hChkSmartUpgrade = GUICtrlCreateCheckbox(GetTranslated(671,2, "Enable SmartUpgrade"), $x - 5, $y, -1, -1)
		Local $sTxtTip = GetTranslated(671,3, "Check box to enable automatically starting Upgrades from builders menu")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "chkSmartUpgrade")

	GUICtrlCreateGroup(GetTranslated(671,4, "Upgrades to ignore"), $x - 15, $y + 30, 420, 155)

	Local $x = 15, $y = 45

	$iconIgnoreTH = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTH11, $x + 5, $y + 50, 40, 40)
	$g_hChkIgnoreTH = GUICtrlCreateCheckbox("", $x + 20, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreTH")

	$iconIgnoreKing = GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x + 95, $y + 50, 40, 40)
	$g_hChkIgnoreKing = GUICtrlCreateCheckbox("", $x + 110, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreKing")

	$iconIgnoreQueen = GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x + 140, $y + 50, 40, 40)
	$g_hChkIgnoreQueen = GUICtrlCreateCheckbox("", $x + 155, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreQueen")

	$iconIgnoreWarden = GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x + 185, $y + 50, 40, 40)
	$g_hChkIgnoreWarden = GUICtrlCreateCheckbox("", $x + 200, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreWarden")

	$iconIgnoreCC = GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, $x + 275, $y + 50, 40, 40)
	$g_hChkIgnoreCC = GUICtrlCreateCheckbox("", $x + 290, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreCC")

	$iconIgnoreLab = GUICtrlCreateIcon($g_sLibIconPath, $eIcnLaboratory, $x + 365, $y + 50, 40, 40)
	$g_hChkIgnoreLab = GUICtrlCreateCheckbox("", $x + 380, $y + 90, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreLab")

	$iconIgnoreBarrack = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarrack, $x + 5, $y + 120, 40, 40)
	$g_hChkIgnoreBarrack = GUICtrlCreateCheckbox("", $x + 20, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreBarrack")

	$iconIgnoreDBarrack = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkBarrack, $x + 50, $y + 120, 40, 40)
	$g_hChkIgnoreDBarrack = GUICtrlCreateCheckbox("", $x + 65, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreDBarrack")

	$iconIgnoreFactory = GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellFactory, $x + 140, $y + 120, 40, 40)
	$g_hChkIgnoreFactory = GUICtrlCreateCheckbox("", $x + 155, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreFactory")

	$iconIgnoreDFactory = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkSpellFactory, $x + 185, $y + 120, 40, 40)
	$g_hChkIgnoreDFactory = GUICtrlCreateCheckbox("", $x + 200, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreDFactory")

	$iconIgnoreGColl = GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 275, $y + 120, 40, 40)
	$g_hChkIgnoreGColl = GUICtrlCreateCheckbox("", $x + 290, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreGColl")

	$iconIgnoreEColl = GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 320, $y + 120, 40, 40)
	$g_hChkIgnoreEColl = GUICtrlCreateCheckbox("", $x + 335, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreEColl")

	$iconIgnoreDColl = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 365, $y + 120, 40, 40)
	$g_hChkIgnoreDColl = GUICtrlCreateCheckbox("", $x + 380, $y + 160, 17, 17)
	GUICtrlSetOnEvent(-1, "chkIgnoreDColl")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$SmartMinGold = GUICtrlCreateInput("200000", 162, 37, 57, 17, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
	GUICtrlCreateLabel(GetTranslated(671,5, "Gold to save"), 224, 40, 64, 17)
	$SmartMinElixir = GUICtrlCreateInput("200000", 162, 57, 57, 17, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
	GUICtrlCreateLabel(GetTranslated(671,6, "Elixir to save"), 224, 60, 63, 17)
	$SmartMinDark = GUICtrlCreateInput("1500", 290, 37, 65, 17, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
	GUICtrlCreateLabel(GetTranslated(671,7, "Dark to save"), 360, 40, 65, 17)
	GUICtrlCreateLabel(GetTranslated(671,8, "... after launching upgrade"), 296, 60, 128, 17)
	$SmartUpgradeLog = GUICtrlCreateEdit("", 10, 232, 420, 124, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
	GUICtrlSetData(-1, GetTranslated(671,9, "                                        ----- SMART UPGRADE LOG -----"))

GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc