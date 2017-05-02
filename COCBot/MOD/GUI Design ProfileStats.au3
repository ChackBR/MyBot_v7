; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "ProfileStats" Subtab under the "Stats" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; ProfileStats	- SwitchAcc_Demen
Global $aGoldTotalAcc[8], $aElixirTotalAcc[8], $aDarkTotalAcc[8], $aTrophyLootAcc[8], $aAttackedCountAcc[8], $aSkippedVillageCountAcc[8] ; Total Gain
Global $aGoldCurrentAcc[8], $aElixirCurrentAcc[8], $aDarkCurrentAcc[8], $aTrophyCurrentAcc[8], $aGemAmountAcc[8], $aFreeBuilderCountAcc[8], $aTotalBuilderCountAcc[8] ; village report
Global $grpVillageAcc[8], $lblResultGoldNowAcc[8], $lblResultElixirNowAcc[8], $lblResultDENowAcc[8], $lblResultTrophyNowAcc[8], $lblResultBuilderNowAcc[8], $lblResultGemNowAcc[8] ; GUI village report
;~ Global $lblGoldLootAcc[8], $lblElixirLootAcc[8], $lblDarkLootAcc[8], $lblTrophyLootAcc[8]	; GUI Total Gain
Global $lblHourlyStatsGoldAcc[8], $lblHourlyStatsElixirAcc[8], $lblHourlyStatsDarkAcc[8], $lblHourlyStatsTrophyAcc[8] ; GUI Gain per Hour
Global $lblResultAttacked[8]
Global $g_lblKingStatus[8], $g_lblQueenStatus[8], $g_lblWardenStatus[8], $g_lblTroopsTime[8]
;~ Global $lblLabStatus[8]
Global $aStartHide[8], $aSecondHide[8], $aEndHide[8] ; GUI support

Func CreateProfileStats()

	Local $x = 25, $y = 30

	For $i = 0 To 7
		$x = 15
		$y = 30

		Local $i_X = Mod($i, 2), $i_Y = Int($i / 2)
		Local $delY = 18, $delY2 = 100, $delX = 65, $delX1 = 77, $delX2 = 220

		$aStartHide[$i] = GUICtrlCreateDummy()
		$grpVillageAcc[$i] = GUICtrlCreateGroup("Village name ", $x - 8 + $i_X * $delX2, $y + $i_Y * $delY2, 215, 95)

		GUICtrlCreateGraphic($x + 130 + $i_X * $delX2, $y + $i_Y * $delY2, 70, 17, $SS_WHITERECT)
		$g_lblTroopsTime[$i] = GUICtrlCreateLabel("No Data", $x + 132 + $i_X * $delX2, $y + $i_Y * $delY2, 55, 16, $SS_CENTER)
		GUICtrlSetColor(-1, $COLOR_GRAY)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x + 185 + $i_X * $delX2, $y + $i_Y * $delY2, 16, 16)

		$lblResultGoldNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)
		$lblResultElixirNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
		$lblResultDENowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 16)
		$lblResultTrophyNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 16, 16)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + 152 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 14)
		$lblResultBuilderNowAcc[$i] = GUICtrlCreateLabel("", $x + 172 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 30, 17, $SS_LEFT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGem, $x + 152 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 14)
		$lblResultGemNowAcc[$i] = GUICtrlCreateLabel("", $x + 172 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 40, 17, $SS_LEFT)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 152 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 14)

		$aSecondHide[$i] = GUICtrlCreateDummy()

;~ 		$lblLabStatus[$i] = GUICtrlCreateLabel("Lab", $x + 157 + $i_X * $delX2, $y + $delY*3 + $i_Y * $delY2, 30, 17, $SS_RIGHT)

		$lblResultAttacked[$i] = GUICtrlCreateLabel("", $x + 172 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 30, 17, $SS_LEFT)

		$lblHourlyStatsGoldAcc[$i] = GUICtrlCreateLabel(" k/h", $x + $delX1 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		$lblHourlyStatsElixirAcc[$i] = GUICtrlCreateLabel(" k/h", $x + $delX1 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		$lblHourlyStatsDarkAcc[$i] = GUICtrlCreateLabel(" /h", $x + $delX1 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 60, 17, $SS_RIGHT)
		$lblHourlyStatsTrophyAcc[$i] = GUICtrlCreateLabel(" /h", $x + $delX1 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 60, 17, $SS_RIGHT)

		$aEndHide[$i] = GUICtrlCreateDummy()

		$g_lblKingStatus[$i] = GUICtrlCreateLabel("K", $x + 152 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 12, 14, $SS_CENTER)
		GUICtrlSetState(-1, $GUI_HIDE)
		$g_lblQueenStatus[$i] = GUICtrlCreateLabel("Q", $x + 172 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 12, 14, $SS_CENTER)
		GUICtrlSetState(-1, $GUI_HIDE)
		$g_lblWardenStatus[$i] = GUICtrlCreateLabel("W", $x + 192 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 12, 14, $SS_CENTER)
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		For $j = $aStartHide[$i] To $aEndHide[$i]
			GUICtrlSetState($j, $GUI_HIDE)
		Next
	Next
EndFunc   ;==>CreateProfileStats
