; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design
; Description ...: This file creates the "MOD" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Eloy - NguyenAnhHD
; Modified ......: AiO++ Team
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_MOD = 0, $g_hGUI_MOD_PROFILES = 0, $g_hGUI_LOG_SA = 0
Global $g_hGUI_MOD_TAB = 0, $g_hGUI_MOD_TAB_ITEM1 = 0, $g_hGUI_MOD_TAB_ITEM2 = 0, $g_hGUI_MOD_TAB_ITEM3 = 0, $g_hGUI_MOD_TAB_ITEM4 = 0, $g_hGUI_MOD_TAB_ITEM5 = 0, $g_hGUI_MOD_TAB_ITEM6 = 0
Global $g_hGUI_MOD_PROFILES_TAB = 0, $g_hGUI_MOD_PROFILES_TAB_ITEM1 = 0, $g_hGUI_MOD_PROFILES_TAB_ITEM2 = 0, $g_hGUI_MOD_PROFILES_TAB_ITEM3 = 0

; Switch Account & Profiles
#include "MOD GUI Design - Profiles.au3"
#include "MOD GUI Design - SwitchAcc.au3"
#include "MOD GUI Design - MultiStats.au3"

; Bot Humanization
#include "MOD GUI Design - BotHumanization.au3"

; Goblin XP
#include "MOD GUI Design - GoblinXP.au3"

; ChatBot
#include "MOD GUI Design - Chatbot.au3"

; CheckCC Troops
#include "MOD GUI Design - CheckTroopsCC.au3"

; Farm Schedule
#include "MOD GUI Design - FarmSchedule.au3"

Func CreateMODTab()

	$g_hGUI_MOD = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)

	$g_hGUI_MOD_PROFILES = _GUICreate("", $g_iSizeWGrpTab2, 342, 5, 90, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_MOD)
	CreateModProfiles()

	GUISwitch($g_hGUI_MOD)
	$g_hGUI_MOD_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
		$g_hGUI_MOD_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_01", "Profiles"))
			CreateBotProfiles()
		$g_hGUI_MOD_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_02", "Humanization"))
			HumanizationGUI()
		$g_hGUI_MOD_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_03", "Goblin XP"))
			GoblinXPGUI()
		$g_hGUI_MOD_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_04", "Chat"))
			ChatbotGUI()
		$g_hGUI_MOD_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_05", "Stat's"))
			$g_hLastControlToHide = GUICtrlCreateDummy()
			ReDim $g_aiControlPrevState[$g_hLastControlToHide + 1]
			CreateMultiStats()
		$g_hGUI_MOD_TAB_ITEM6 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_06", "Reserved"))

	; needed to init the window now, like if it's a tab
	CreateDropOrderGUI()

	GUICtrlCreateTabItem("")
EndFunc   ;==>CreateMODTab

Func CreateModProfiles()

	$g_hGUI_LOG_SA = _GUICreate("", 200, 227, 230, 113, BitOR($WS_CHILD, 0), -1, $g_hGUI_MOD_PROFILES)

	GUISwitch($g_hGUI_MOD_PROFILES)
	$g_hGUI_MOD_PROFILES_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, 342, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
		$g_hGUI_MOD_PROFILES_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_01_STab_01", "Switch Accounts"))
			CreateModSwitchAcc()
		$g_hGUI_MOD_PROFILES_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_01_STab_02", "Switch Profiles"))
			CreateModSwitchProfile()
		$g_hGUI_MOD_PROFILES_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06_STab_01_STab_03", "Farming Schedule"))
			CreateModFarmSchedule()

	$g_hLastControlToHide = GUICtrlCreateDummy()
	ReDim $g_aiControlPrevState[$g_hLastControlToHide + 1]
	; Set SwitchAcc Log
	CreateModSwitchAccLog()

	GUICtrlCreateTabItem("")
EndFunc   ;==>CreateModProfiles
