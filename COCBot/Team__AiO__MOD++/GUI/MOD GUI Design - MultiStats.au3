; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design MultiStats - Demen
; Description ...: This file creates the "MultiStats" Subtab under the "Stats" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......: Team AiO MOD++ (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_ahGrpVillageAcc[8], $g_ahLblResultGoldNowAcc[8], $g_ahLblResultElixirNowAcc[8], $g_ahLblResultDENowAcc[8], $g_ahLblResultTrophyNowAcc[8], $g_ahLblResultBuilderNowAcc[8], $g_ahLblResultGemNowAcc[8] ; GUI village report
Global $g_ahLblHourlyStatsGoldAcc[8], $g_ahLblHourlyStatsElixirAcc[8], $g_ahLblHourlyStatsDarkAcc[8], $g_ahLblHourlyStatsTrophyAcc[8] ; GUI Gain per Hour
Global $g_ahLblResultAttacked[8]
Global $g_ahLblHeroStatus[3][8], $g_ahLblTroopsTime[8]
Global $g_ahLblLab[8], $g_ahLblLabTime[8]

Func CreateMultiStats()

	Local $x = 25, $y = 45

	For $i = 0 To 7
		$x = 5
		$y = 30

		Local $i_X = Mod($i, 2), $i_Y = Int($i / 2)
		Local $delY = 18, $delY2 = 100, $delX = 65, $delX1 = 147, $delX2 = 224

		$g_ahGrpVillageAcc[$i] = GUICtrlCreateGroup("Village name ", $x - 3 + $i_X * $delX2, $y + $i_Y * $delY2, 221, 95)

		GUICtrlCreateGraphic($x + 130 + $i_X * $delX2, $y + $i_Y * $delY2, 70, 17, $SS_WHITERECT)
		$g_ahLblTroopsTime[$i] = GUICtrlCreateLabel("", $x + 137 + $i_X * $delX2, $y + $i_Y * $delY2, 50, 16, $SS_CENTER)
		GUICtrlSetColor(-1, $COLOR_GRAY)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x + 190 + $i_X * $delX2, $y + $i_Y * $delY2, 16, 14)

		; Village report (resources)
		$g_ahLblResultGoldNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)
		$g_ahLblResultElixirNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
		$g_ahLblResultDENowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 16)
		$g_ahLblResultTrophyNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 16, 16)

		; Village report (info)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + $delX1 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 14)
		$g_ahLblResultBuilderNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX1 + 20 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 30, 17, $SS_LEFT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGem, $x + $delX1 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 14)
		$g_ahLblResultGemNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX1 + 20 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 30, 17, $SS_LEFT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + $delX1 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 14)
		$g_ahLblResultAttacked[$i] = GUICtrlCreateLabel("", $x + $delX1 + 20 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 30, 17, $SS_LEFT)

		$g_ahLblLab[$i] = GUICtrlCreateLabel("Lab:", $x + $delX1 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 22, 17, $SS_CENTER)
		GUICtrlSetColor(-1, $COLOR_GRAY)
		$g_ahLblLabTime[$i] = GUICtrlCreateLabel("", $x + $delX1 + 22 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 45, 17, $SS_CENTER)

		; Hero Status
		$g_ahLblHeroStatus[0][$i] = GUICtrlCreateLabel("K", $x + 200 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 12, 14, $SS_CENTER)
		GUICtrlSetColor(-1, $COLOR_GRAY)
		$g_ahLblHeroStatus[1][$i] = GUICtrlCreateLabel("Q", $x + 200 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 12, 14, $SS_CENTER)
		GUICtrlSetColor(-1, $COLOR_GRAY)
		$g_ahLblHeroStatus[2][$i] = GUICtrlCreateLabel("W", $x + 200 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 12, 14, $SS_CENTER)
		GUICtrlSetColor(-1, $COLOR_GRAY)

		; Loot Stats
		$g_ahLblHourlyStatsGoldAcc[$i] = GUICtrlCreateLabel(" k/h", $x + $delX + 12 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		$g_ahLblHourlyStatsElixirAcc[$i] = GUICtrlCreateLabel(" k/h", $x + $delX + 12 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		$g_ahLblHourlyStatsDarkAcc[$i] = GUICtrlCreateLabel(" /h", $x + $delX + 12 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		$g_ahLblHourlyStatsTrophyAcc[$i] = GUICtrlCreateLabel(" /h", $x + $delX + 12 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 60, 17, $SS_RIGHT)

		GUICtrlCreateGroup("", -99, -99, 1, 1)

		For $j = $g_ahGrpVillageAcc[$i] To $g_ahLblHourlyStatsTrophyAcc[$i]
			GUICtrlSetState($j, $GUI_HIDE)
		Next
	Next
EndFunc   ;==>CreateMultiStats
