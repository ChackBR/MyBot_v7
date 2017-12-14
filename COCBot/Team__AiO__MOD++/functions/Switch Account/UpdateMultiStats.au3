; #FUNCTION# ====================================================================================================================
; Name ..........: UpdateMultiStats (#-12)
; Description ...: Additional functions for UpdateStats
; Syntax ........: UpdateStats()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func UpdateStatsForSwitchAcc()

	For $i = 0 To 7
		;village report
		GUICtrlSetData($g_ahLblResultGoldNowAcc[$i], _NumberFormat($g_aiGoldCurrentAcc[$i], True))
		GUICtrlSetData($g_ahLblResultElixirNowAcc[$i], _NumberFormat($g_aiElixirCurrentAcc[$i], True))
		GUICtrlSetData($g_ahLblResultDENowAcc[$i], _NumberFormat($g_aiDarkCurrentAcc[$i], True))
		GUICtrlSetData($g_ahLblResultTrophyNowAcc[$i], _NumberFormat($g_aiTrophyCurrentAcc[$i], True))

		If $g_aiGemAmountAcc[$i] < 10000 Then
			GUICtrlSetData($g_ahLblResultGemNowAcc[$i], _NumberFormat($g_aiGemAmountAcc[$i], True))
		Else
			GUICtrlSetData($g_ahLblResultGemNowAcc[$i], Round($g_aiGemAmountAcc[$i]/1000,1) & " K")
		EndIf

		GUICtrlSetData($g_ahLblResultBuilderNowAcc[$i], $g_aiFreeBuilderCountAcc[$i] & "/" & $g_aiTotalBuilderCountAcc[$i])

		; gain stats
		GUICtrlSetData($g_ahLblHourlyStatsGoldAcc[$i], _NumberFormat(Round($g_aiGoldTotalAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h")
		GUICtrlSetData($g_ahLblHourlyStatsElixirAcc[$i], _NumberFormat(Round($g_aiElixirTotalAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h")
		GUICtrlSetData($g_ahLblHourlyStatsDarkAcc[$i], _NumberFormat(Round($g_aiDarkTotalAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
		GUICtrlSetData($g_ahLblHourlyStatsTrophyAcc[$i], _NumberFormat(Round($g_aiTrophyLootAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
		If $g_aiAttackedCountAcc[$i] < 10000 Then
			GUICtrlSetData($g_ahLblResultAttacked[$i], $g_aiAttackedCountAcc[$i])
		Else
			GUICtrlSetData($g_ahLblResultAttacked[$i], Round($g_aiAttackedCountAcc[$i]/1000,1) & " K")
		EndIf
	Next

	GUICtrlSetData($g_hLblResultSkippedHourNow, $g_aiSkippedVillageCountAcc[$g_iCurAccount]) ;	Counting skipped village at Bottom GUI
	GUICtrlSetData($g_hLblResultAttackedHourNow, $g_aiAttackedCountAcc[$g_iCurAccount]) ;	Counting attacked village at Bottom GUI

	If $g_iFirstAttack = 2 Then
		GUICtrlSetData($g_hLblResultGoldHourNow, _NumberFormat(Round($g_aiGoldTotalAcc[$g_iCurAccount] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, _NumberFormat(Round($g_aiElixirTotalAcc[$g_iCurAccount] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultDEHourNow, _NumberFormat(Round($g_aiDarkTotalAcc[$g_iCurAccount] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h") ;GUI BOTTOM
	EndIf ; ============= Update Gain Stats at Bottom GUI

EndFunc   ;==>UpdateStatsForSwitchAcc

Func ResetStatsForSwitchAcc()

	For $i = 0 To $g_iTotalAcc
		$g_aiGoldTotalAcc[$i] = 0
		$g_aiElixirTotalAcc[$i] = 0
		$g_aiDarkTotalAcc[$i] = 0
		$g_aiTrophyLootAcc[$i] = 0
		$g_aiAttackedCountAcc[$i] = 0
		$g_aiSkippedVillageCountAcc[$i] = 0
		For $j = 0 To 2
			GUICtrlSetState($g_ahLblHeroStatus[$j][$i], $GUI_HIDE)
		Next
		GUICtrlSetColor($g_ahLblLab[$i], $COLOR_MEDGRAY)
		GUICtrlSetData($g_ahLblLabTime[$i], "")
	Next

EndFunc   ;==>ResetStatsForSwitchAcc

Func UpdateHeroStatus()

	Local $hHero = 0
    Local $sHeroStatus
    If Not OpenArmyOverview() Then Return
    If _Sleep($DELAYCHECKARMYCAMP5) Then Return

    For $i = 0 to 2
        $sHeroStatus = ArmyHeroStatus($i)
		If $g_bChkSwitchAcc Then $hHero = $g_ahLblHeroStatus[$i][$g_iCurAccount]

		Select
			Case $sHeroStatus = "heal" ; Yellow
				GUICtrlSetColor($g_ahLblHero[$i], "0xFFB41E") ; dark yellow, Bottom GUI
				GUICtrlSetState($hHero, $GUI_SHOW)
				GUICtrlSetBkColor($hHero, $COLOR_YELLOW)
				GUICtrlSetColor($hHero, $COLOR_BLACK)
			Case $sHeroStatus = "upgrade" ; Red
				GUICtrlSetColor($g_ahLblHero[$i], $COLOR_RED) ; Bottom GUI
				GUICtrlSetState($hHero, $GUI_SHOW)
				GUICtrlSetBkColor($hHero, $COLOR_RED)
				GUICtrlSetColor($hHero, $COLOR_WHITE)
			Case $sHeroStatus = "king" Or $sHeroStatus = "queen" Or $sHeroStatus = "warden" ; Green
				GUICtrlSetColor($g_ahLblHero[$i], $COLOR_GREEN) ; Bottom GUI
				GUICtrlSetState($hHero, $GUI_SHOW)
				GUICtrlSetBkColor($hHero, $COLOR_GREEN)
				GUICtrlSetColor($hHero, $COLOR_WHITE)
			Case Else ; Hide lbl
				GUICtrlSetColor($g_ahLblHero[$i], $COLOR_MEDGRAY) ; Grey, Bottom GUI
				GUICtrlSetState($hHero, $GUI_HIDE)
		EndSelect
	Next

	$g_bCanRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
    ClickP($aAway, 1, 0, "#0000") ;Click Away
    If _Sleep($DELAYCHECKARMYCAMP4) Then Return

EndFunc   ;==>UpdateHeroStatus

Func ResetHeroLabStatus()
	For $i = 0 To 2
		GUICtrlSetColor($g_ahLblHero[$i], $COLOR_MEDGRAY) ; Grey, Bottom GUI
	Next
	GUICtrlSetColor($g_hLblLab, $COLOR_MEDGRAY)
	GUICtrlSetData($g_hLblLabTime, "")
EndFunc   ;==>ResetHeroLabStatus
