; #FUNCTION# ====================================================================================================================
; Name ..........: UpdateProfileStats
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
		GUICtrlSetData($lblResultGoldNowAcc[$i], _NumberFormat($aGoldCurrentAcc[$i], True))
		GUICtrlSetData($lblResultElixirNowAcc[$i], _NumberFormat($aElixirCurrentAcc[$i], True))
		GUICtrlSetData($lblResultDeNowAcc[$i], _NumberFormat($aDarkCurrentAcc[$i], True))
		GUICtrlSetData($lblResultTrophyNowAcc[$i], _NumberFormat($aTrophyCurrentAcc[$i], True))
		GUICtrlSetData($lblResultGemNowAcc[$i], _NumberFormat($aGemAmountAcc[$i], True))
		GUICtrlSetData($lblResultBuilderNowAcc[$i], $aFreeBuilderCountAcc[$i] & "/" & $aTotalBuilderCountAcc[$i])

		; gain stats
		GUICtrlSetData($lblHourlyStatsGoldAcc[$i], _NumberFormat(Round($aGoldTotalAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h")
		GUICtrlSetData($lblHourlyStatsElixirAcc[$i], _NumberFormat(Round($aElixirTotalAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h")
		GUICtrlSetData($lblHourlyStatsDarkAcc[$i], _NumberFormat(Round($aDarkTotalAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
		GUICtrlSetData($lblHourlyStatsTrophyAcc[$i], _NumberFormat(Round($aTrophyLootAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
		GUICtrlSetData($lblResultAttacked[$i], $aAttackedCountAcc[$i])
	Next

	GUICtrlSetData($g_hLblResultSkippedHourNow, $aSkippedVillageCountAcc[$nCurProfile - 1]) ;	Counting skipped village at Bottom GUI
	GUICtrlSetData($g_hLblResultAttackedHourNow, $aAttackedCountAcc[$nCurProfile - 1]) ;	Counting attacked village at Bottom GUI

	If $g_iFirstAttack = 2 Then
		GUICtrlSetData($g_hLblResultGoldHourNow, _NumberFormat(Round($aGoldTotalAcc[$nCurProfile - 1] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, _NumberFormat(Round($aElixirTotalAcc[$nCurProfile - 1] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultDEHourNow, _NumberFormat(Round($aDarkTotalAcc[$nCurProfile - 1] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h") ;GUI BOTTOM
	EndIf ; ============= Update Gain Stats at Bottom GUI

EndFunc   ;==>UpdateStatsForSwitchAcc

Func ResetStatsForSwitchAcc()

	For $i = 0 To $nTotalProfile - 1 ; SwitchAcc Mod - Demen
		$aGoldTotalAcc[$i] = 0
		$aElixirTotalAcc[$i] = 0
		$aDarkTotalAcc[$i] = 0
		$aTrophyLootAcc[$i] = 0
		$aAttackedCountAcc[$i] = 0
		$aSkippedVillageCountAcc[$i] = 0
	Next

EndFunc   ;==>ResetStatsForSwitchAcc
