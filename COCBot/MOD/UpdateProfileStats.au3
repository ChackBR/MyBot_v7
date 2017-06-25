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

		If $aGemAmountAcc[$i] < 10000 Then
			GUICtrlSetData($lblResultGemNowAcc[$i], _NumberFormat($aGemAmountAcc[$i], True))
		Else
			GUICtrlSetData($lblResultGemNowAcc[$i], Round($aGemAmountAcc[$i]/1000,1) & " K")
		EndIf

		GUICtrlSetData($lblResultBuilderNowAcc[$i], $aFreeBuilderCountAcc[$i] & "/" & $aTotalBuilderCountAcc[$i])

		; gain stats
		GUICtrlSetData($lblHourlyStatsGoldAcc[$i], _NumberFormat(Round($aGoldTotalAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h")
		GUICtrlSetData($lblHourlyStatsElixirAcc[$i], _NumberFormat(Round($aElixirTotalAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h")
		GUICtrlSetData($lblHourlyStatsDarkAcc[$i], _NumberFormat(Round($aDarkTotalAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
		GUICtrlSetData($lblHourlyStatsTrophyAcc[$i], _NumberFormat(Round($aTrophyLootAcc[$i] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
		If $aAttackedCountAcc[$i] < 10000 Then
			GUICtrlSetData($lblResultAttacked[$i], $aAttackedCountAcc[$i])
		Else
			GUICtrlSetData($lblResultAttacked[$i], Round($aAttackedCountAcc[$i]/1000,1) & " K")
		EndIf
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
		For $j = 0 To 2
			GUICtrlSetState($g_ahLblHeroStatus[$j][$i], $GUI_HIDE)
		Next
		GUICtrlSetColor($g_ahLblLab[$i], $COLOR_MEDGRAY)
		GUICtrlSetData($g_ahLblLabTime[$i], "")
	Next

EndFunc   ;==>ResetStatsForSwitchAcc

Func UpdateHeroStatus() ;	Show on Profile Stats - Demen

	Local $hHero = 0
    Local $sHeroStatus
    If Not OpenArmyOverview() Then Return
    If _Sleep($DELAYCHECKARMYCAMP5) Then Return

    For $i = 0 to 2
        $sHeroStatus = ArmyHeroStatus($i)
;		Setlog("---Checking status of " & NameOfTroop($i+$eKing) & ": " & $sHeroStatus)
		If $ichkSwitchAcc = 1 Then $hHero = $g_ahLblHeroStatus[$i][$nCurProfile - 1]

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
