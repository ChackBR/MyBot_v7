; #FUNCTION# ====================================================================================================================
; Name ..........: CheckTrainingTab (#-13)
; Description ...: Check Troops training tab and Spells brewing tab, return suggested training methods for army camp & queue
; Author ........: DEMEN
; Modified ......: Team AiO MOD++ (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckTrainingTab($sText = "troop")

	Local $aeTrainMethod[2] = [$g_eNoTrain, $g_eNoTrain] ; return value: train army | train queue
	Local $Tab = $TrainTroopsTAB
	If $ichkFillArcher <> 1 Then $iFillArcher = 0

	Local $iTopUp = $iFillArcher

	If $sText = "spell" Then
		$Tab = $BrewSpellsTAB
		If Not $g_bQuickTrainEnable And TotalSpellsToBrewInGUI() = 0 Then Return $aeTrainMethod ; quit checking spell tab (no brew all)
		$iTopUp = $ichkFillEQ ; (0 or 1)
	EndIf

	If $sText = "troop" Then
		OpenTroopsTab()
	Else
		OpenSpellsTab()
	EndIf

	If _Sleep(1000) Then Return
	If Not ISArmyWindow(False, $Tab) Then Return

	Local $ArmyCamp = GetOCRCurrent(43, 160)

	SetLog("»» Checking " & $sText & " tab: " & $ArmyCamp[0] & "/" & $ArmyCamp[1] * 2)

	Switch $ArmyCamp[0]
		Case 0 ;	0/240 troop	| 0/11 spell
			SetLog("  » No " & $sText)
			$aeTrainMethod[0] = $g_eFull
			$aeTrainMethod[1] = $g_eFull ; full army + full queue

		Case 1 To $ArmyCamp[1] - $iTopUp - 1 ; 1-234/240 troops | 1-9/11 spells
			SetLog("  » Not full " & $sText & " camp")
			If ClearTrainingTroops() Then SetLog("  » All training " & $sText & " cleared!")
			$aeTrainMethod[0] = $g_eRemained
			$aeTrainMethod[1] = $g_eFull ; remained army + full queue

		Case $ArmyCamp[1] - $iTopUp To $ArmyCamp[1] ; 235-240/240 troops | 10-11/1 spells
			If $ArmyCamp[0] - $ArmyCamp[1] < 0 Then
				TopUpCamp($sText, $ArmyCamp[1] - $ArmyCamp[0])
			Else
				SetLog("  » Zero queue " & $sText)
			EndIf
			$aeTrainMethod[1] = $g_eFull ; no army + full queue

		Case $ArmyCamp[1] + 1 To $ArmyCamp[1] * 2 - $iTopUp - 1 ; 241-474/240 troops | 11-20/11 spells
			SetLog("  » Queueing some " & $sText & "s")
			If $sText = "spell" And $g_bForceBrewSpells Then
				If Not $g_bQuickTrainEnable Then
					SetLog("  » Force brew spell is active, keep brewing anyway")
					ForceBrewSpells($ArmyCamp[1] * 2 - $ArmyCamp[0]) ; force brew spells anyway
				Else
					$aeTrainMethod[1] = $g_eRemained
				EndIf
			Else
				If Not $g_bQuickTrainEnable Then
					$aeTrainMethod = CheckQueue($sText) ; remained army + full queue / full queue / remained queue
				Else
					DeleteQueue($sText)
					CheckBlockTroops($sText)
					$aeTrainMethod[1] = $g_eFull
				EndIf
			EndIf

		Case $ArmyCamp[1] * 2 - $iTopUp To $ArmyCamp[1] * 2 ; 475-480/240 troops | 21-22/11
			If $ArmyCamp[0] - $ArmyCamp[1] * 2 < 0 Then
				TopUpCamp($sText, $ArmyCamp[1] * 2 - $ArmyCamp[0])
			Else
				SetLog("  » Full queue")
			EndIf
			Local $bSkipTraining = $g_bFullArmy
			If $sText = "spell" Then $bSkipTraining = $g_bFullArmySpells Or $g_bForceBrewSpells
			If Not $bSkipTraining And _ColorCheck(_GetPixelColor(824, 243, True), Hex(0x949522, 6), 20) Then ; the green check symbol [bottom right] at slot 0 troop
				If ProfileSwitchAccountEnabled() And $g_abDonateOnly[$g_iCurAccount] Then ; SwitchAcc - Demen_SA_#9001
					SetLog("  » A big guy is blocking our camp, but you are in donate account, so just leave it")
				Else
					SetLog("  » A big guy is blocking in queue, try delete queued troops")
					ClearTrainingTroops()
					If CheckBlockTroops($sText) = False Then ; check if camp is not full after delete queue
						$aeTrainMethod[1] = $g_eFull
					Else
						$aeTrainMethod[0] = $g_eRemained
						$aeTrainMethod[1] = $g_eFull
					EndIf
				EndIf
			EndIf
	EndSwitch

	If $sText = "spell" Then $g_iMultiClick = _Max(Ceiling(($ArmyCamp[1] * 2 - $ArmyCamp[0])/2), 1)

	Return $aeTrainMethod

EndFunc   ;==>CheckTrainingTab

Func ClearTrainingTroops($eOpenTrainTab = -1)
	If $g_bQuickTrainEnable Then Return False ;	not applicable for quick-train mode

	If $eOpenTrainTab > 0 Then OpenArmyTab()

	If _ColorCheck(_GetPixelColor(820, 220, True), Hex(0xCFCFC8, 6), 15) Then Return False ; Gray background found, no troop is training

	Local $x = 0
	While _ColorCheck(_GetPixelColor(820, 220, True), Hex(0xCFCFC8, 6), 15) = False ; the gray background at slot 0 troop
		PureClick(820, 202, 2, 50)
		$x += 1
		If $x = 480 Then ExitLoop
	WEnd
	If _Sleep(250) Then Return

	Return True

EndFunc   ;==>ClearTrainingTroops

Func TopUpCamp($sText = "troop", $ArchToMake = 0)
	If $ArchToMake <= 0 Then Return False
	If $sText = "troop" Then
		SetLog("  » Fill some archers")
		If ISArmyWindow(False, $TrainTroopsTAB) Then TrainIt($eArch, $ArchToMake, 500)
		SetLog("    Trained " & $ArchToMake & " archer(s)!")
	ElseIf $sText = "spell" Then
		SetLog("  » Fill 1 EQ spell")
		If ISArmyWindow(False, $BrewSpellsTAB) Then TrainIt($eESpell, 1, 500)
		SetLog("    Trained " & $ArchToMake & " archer(s)!")
	EndIf
	Return True
EndFunc   ;==>TopUpCamp

Func ForceBrewSpells($iRemainQueue)
	For $i = 0 To ($eSpellCount - 1)
		If Not $g_bRunState Then Return
		If $g_aiArmyCompSpells[$i] > 0 And $iRemainQueue - $g_aiSpellSpace[$i] >= 0 Then
			Local $iBrewedCount = 0
			While $iRemainQueue - $g_aiSpellSpace[$i] >= 0
				;train 1
				Local $SpellName = $g_asSpellShortNames[$i]
				Local $iSpellIndex = TroopIndexLookup($SpellName)
				If CheckValuesCost($SpellName, 1) Then
					TrainIt($iSpellIndex, 1, $g_iTrainClickDelay)
					$iBrewedCount += 1
					$iRemainQueue -= $g_aiSpellSpace[$i]
				Else
					SetLog("    No resources to brew more " & $g_asSpellNames[$i], $COLOR_ORANGE)
					ExitLoop
				EndIf
				If $iBrewedCount >= $g_aiArmyCompSpells[$i] Then ExitLoop
			WEnd
			If $iBrewedCount > 0 Then SetLog("    Brewed " & $g_asSpellNames[$i] & " x" & $iBrewedCount, $COLOR_GREEN)
		EndIf
	Next
EndFunc   ;==>ForceBrewSpells

Func CheckBlockTroops($sText = "troop")
	Local $NewCampOCR = GetOCRCurrent(43, 160)
	If $NewCampOCR[0] - $NewCampOCR[1] >= 0 Then ; Full camp after deleting queue.
		Return False ; train $g_efull
	Else
		If $sText = "troop" Then
			If $NewCampOCR[1] - $NewCampOCR[0] <= $iFillArcher Then
				TopUpCamp($sText, $NewCampOCR[1] - $NewCampOCR[0])
				Return False ; train $g_efull
			Else
				Return True ; train remained
			EndIf
		ElseIf $sText = "spell" Then
			If $ichkFillEQ = 1 And $NewCampOCR[1] - $NewCampOCR[0] = 1 Then
				TopUpCamp($sText, 1)
				Return False ; train $g_efull
			Else
				Return True ; train remained
			EndIf
		EndIf
	EndIf
EndFunc   ;==>CheckBlockTroops
