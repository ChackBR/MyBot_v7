; #FUNCTION# ====================================================================================================================
; Name ..........: SmartQuickTrain
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: DEMEN
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Functions used:
;	GetOCRCurrent($x_start, $y_start)
;	ISArmyWindow($writelogs = False, $TabNumber = 0)
;	OpenTrainTabNumber($Num)
; 	MakingDonatedTroops()
; 	CheckExistentArmy()
;	IsSpellToBrew()
;	CheckValuesCost()
; 	TrainArmyNumber()

Func SimpleTrain()

	Local $bRemoveUnpreciseTroops = False
	Local $eTrainMethod = $g_eNoTrain, $eBrewMethod = $g_eNoTrain, $eTrainMethod2 = $g_eNoTrain, $eBrewMethod2 = $g_eNoTrain
	Local $bCheckWrongTroops = False, $bCheckWrongSpells = False

	If $g_bQuickTrainEnable = False Then
		Setlog("Start Simple Custom Train")
	Else
		Setlog("Start Simple Quick Train")
	EndIf

	If $iChkPreciseTroops = 1 Then
		Setlog(" - Checking precision of troops and spells", $COLOR_ACTION1)
		Local $toRemove = CheckWrongTroops(True, True, False)
		Local $text = ""
		If $g_abRCheckWrongTroops[0] = False Then $text &= " Troops &"
		If $g_abRCheckWrongTroops[1] = False Then $text &= " Spells &"
		If StringRight($text, 1) = "&" Then $text = StringTrimRight($text, 2) ; Remove last " &" as it is not needed

		If $g_abRCheckWrongTroops[0] = False And $g_abRCheckWrongTroops[0] = False Then ; Troops & Spells are correct
			If $g_bFullArmy And $g_bFullArmySpells Then
				Setlog(" »» Full" & $text & ". All are correct!")
			Else
				If $g_bFullArmy Then Setlog(" »» All troops are correct. Spells are so far, so good.")
				If $g_bFullArmySpells Then Setlog(" »» All spells are correct. Troops are so far, so good.")
				If $g_bFullArmy = False And $g_bFullArmySpells = False Then Setlog(" »» So far, so good.")
			EndIf

		Else ; Wrong troops or Wrong spells
			$text = ""
			If $g_abRCheckWrongTroops[0] Then $text &= " Troops &"
			If $g_abRCheckWrongTroops[1] Then $text &= " Spells &"
			If StringRight($text, 1) = "&" Then $text = StringTrimRight($text, 2) ; Remove last " &" as it is not needed
			Setlog(" »» Need to clear queued" & $text & " before removing")
			If $g_abRCheckWrongTroops[0] Then ClearTrainingTroops(False, True)
			If $g_abRCheckWrongTroops[1] Then ClearTrainingTroops(True, True)
			If _Sleep(200) Then Return
			OpenTrainTabNumber($ArmyTAB, "SimpleTrain()")
			If _Sleep(200) Then Return
			RemoveWrongTroops($g_abRCheckWrongTroops[0], $g_abRCheckWrongTroops[1], $toRemove)
			Setlog("Continue Simple Train...")
			$bRemoveUnpreciseTroops = True
		EndIf
	EndIf

	If $g_bDonationEnabled And $g_bChkDonate And $bRemoveUnpreciseTroops = False Then MakingDonatedTroops()

	If $g_bRunState = False Then Return

	; Troops
	OpenTrainTabNumber($TrainTroopsTAB, "SimpleTrain()")
	If _Sleep(1000) Then Return
	If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

	Local $ArmyCamp = GetOCRCurrent(48, 160)

	Setlog(" - Current queue/capacity: " & $ArmyCamp[0] & "/" & $ArmyCamp[1])

	If $ichkFillArcher <> 1 Then $iFillArcher = 0

	Switch $ArmyCamp[0] - $ArmyCamp[1]
		Case -$ArmyCamp[1] ;	0/240
			SetLog(" »» No troop")
			$eTrainMethod = $g_eFull
			$eTrainMethod2 = $g_eFull

		Case -$ArmyCamp[1] + 1 To -$iFillArcher - 1 ; 234/240
			If $g_bQuickTrainEnable = False And _ColorCheck(_GetPixelColor(820, 220, True), Hex(0xCFCFC8, 6), 15) = False Then
				SetLog(" »» Not full troop camp. Let's clear training troops")
				ClearTrainingTroops(False, False)
			Else
				SetLog(" »» Not full troop camp.")
			EndIf
			If $bRemoveUnpreciseTroops = False Then $bCheckWrongTroops = True
			$eTrainMethod = $g_eRemained
			$eTrainMethod2 = $g_eFull

		Case -$iFillArcher To 0 ; 235-240/240
			If $ArmyCamp[0] - $ArmyCamp[1] < 0 Then
				SetLog(" »» Fill some archers")
				FillArcher($ArmyCamp[1] - $ArmyCamp[0])
			Else
				SetLog(" »» Zero queue")
			EndIf
			$eTrainMethod = $g_eFull

		Case 1 To $ArmyCamp[1] - $iFillArcher - 1 ; 474/240
			SetLog(" »» Not full queue. Delete queued troops")
			DeleteQueue()
			If CheckBlockTroops() = False Then ; check if camp is not full after delete queue
				$eTrainMethod = $g_eFull
			Else
				ClearTrainingTroops(False, False)
				$bCheckWrongTroops = True
				$eTrainMethod = $g_eRemained
				$eTrainMethod2 = $g_eFull
			EndIf

		Case $ArmyCamp[1] - $iFillArcher To $ArmyCamp[1] ; 475-480/240
			If $ArmyCamp[0] - $ArmyCamp[1] < $ArmyCamp[1] Then
				SetLog(" »» Fill some archers")
				FillArcher($ArmyCamp[1] * 2 - $ArmyCamp[0])
			Else
				SetLog(" »» Full queue")
			EndIf
			If $g_bFullArmy Then
				$eTrainMethod = $g_eNoTrain
			ElseIf _ColorCheck(_GetPixelColor(824, 243, True), Hex(0x949522, 6), 20) Then ; the green check symbol [bottom right] at slot 0 troop
				If $ichkSwitchAcc = 1 And $aProfileType[$nCurProfile - 1] = $eDonate Then
					SetLog("  » A big troop is blocking, but you are in donate account, so just leave it")
					$eTrainMethod = $g_eNoTrain
				Else
					SetLog("  » A big troop is blocking in queue, try delete queued troops")
					ClearTrainingTroops(False, False)
					If CheckBlockTroops() = False Then ; check if camp is not full after delete queue
						$eTrainMethod = $g_eFull
					Else
						If $bRemoveUnpreciseTroops = False Then $bCheckWrongTroops = True
						$eTrainMethod = $g_eRemained
						$eTrainMethod2 = $g_eFull
					EndIf
				EndIf
			EndIf

	EndSwitch

	If $g_bQuickTrainEnable = False And $bCheckWrongTroops = False And $eTrainMethod <> $g_eNoTrain Then
		MakeCustomTrain($eTrainMethod, $g_eNoTrain)
		If $eTrainMethod2 = $g_eFull Then MakeCustomTrain($eTrainMethod2, $g_eNoTrain)	; train 1 more combo for queueing
		$eTrainMethod = $g_eNoTrain
		$eTrainMethod2 = $g_eNoTrain
	EndIf

	; Spells
	If $g_bQuickTrainEnable Or TotalSpellsToBrewInGUI() > 0 Then
		OpenTrainTabNumber($BrewSpellsTAB, "SimpleTrain()")
		If _Sleep(1000) Then Return
		If ISArmyWindow(True, $BrewSpellsTAB) = False Then Return

		Local $SpellCamp = GetOCRCurrent(48, 160)
		Setlog(" - Current queue/capacity: " & $SpellCamp[0] & "/" & $SpellCamp[1])

		Switch $SpellCamp[0] - $SpellCamp[1]
			Case -$SpellCamp[1] ; 0/11
				SetLog(" »» No spell")
				$eBrewMethod = $g_eFull
				$eBrewMethod2 = $g_eFull

			Case -$SpellCamp[1] + 1 To -1 ; 10/11
				If $ichkFillEQ = 0 Or $SpellCamp[0] - $SpellCamp[1] < -1 Then
					If $g_bQuickTrainEnable = False Then
						SetLog(" »» Not full spell camp. Let's clear brewing spells")
						If ISArmyWindow(False, $BrewSpellsTAB) Then ClearTrainingTroops(True, False)
					Else
						SetLog(" »» Not full spell camp.")
					EndIf
					If $bRemoveUnpreciseTroops = False Then $bCheckWrongSpells = True
					$eBrewMethod = $g_eRemained
					$eBrewMethod2 = $g_eFull
				Else
					SetLog(" »» Fill with 1 EQ spell")
					If ISArmyWindow(False, $BrewSpellsTAB) Then TrainIt($eESpell, 1, 500)
					SetLog(" » Brewed 1 EQ spell!")
					$eBrewMethod = $g_eFull
				EndIf

			Case 0 ; 11/11
				SetLog(" »» Full spell camp, Zero queue")
				$eBrewMethod = $g_eFull

			Case 1 To $SpellCamp[1] - 1 ; 21/11
				If $ichkFillEQ = 0 Or $SpellCamp[0] - $SpellCamp[1] < $SpellCamp[1] - 1 Then
					SetLog(" »» Not full queue, Delete queued spells")
					DeleteQueue(True)
					If CheckBlockTroops(True) = False Then ; check if spell camp is not full after delete queue
						$eBrewMethod = $g_eFull
					Else
						ClearTrainingTroops(True, False)
						$bCheckWrongSpells = True
						$eBrewMethod = $g_eRemained
						$eBrewMethod2 = $g_eFull
					EndIf
				Else
					SetLog(" »» Fill with 1 EQ spell")
					If ISArmyWindow(False, $BrewSpellsTAB) Then TrainIt($eESpell, 1, 500)
					SetLog(" » Brewed 1 EQ spell!")
					$eBrewMethod = $g_eNoTrain
				EndIf

			Case $SpellCamp[1] ; 22/11
				If $g_bFullArmySpells Then
					SetLog(" »» Full queue")
					$eBrewMethod = $g_eNoTrain
				ElseIf _ColorCheck(_GetPixelColor(824, 243, True), Hex(0x949522, 6), 20) Then ; the green check symbol [bottom right] at slot 0 troop
					If $ichkSwitchAcc = 1 And $aProfileType[$nCurProfile - 1] = $eDonate Then
						SetLog("  » A big spell is blocking, but you are in donate account, so just leave it")
						$eBrewMethod = $g_eNoTrain
					Else
						SetLog("  » A big spell is blocking in queue, try delete queued spells")
						ClearTrainingTroops(True, False)
						If CheckBlockTroops(True) = False Then ; check if spell camp is not full after delete queue
							$eBrewMethod = $g_eFull
						Else
							If $bRemoveUnpreciseTroops = False Then $bCheckWrongSpells = True
							$eBrewMethod = $g_eRemained
							$eBrewMethod2 = $g_eFull
						EndIf
					EndIf
				EndIf
		EndSwitch

		If $g_bQuickTrainEnable = False And $bCheckWrongSpells = False And $eBrewMethod <> $g_eNoTrain Then
			MakeCustomTrain($g_eNoTrain, $eBrewMethod)
			If $eBrewMethod2 = $g_eFull Then MakeCustomTrain($g_eNoTrain, $eBrewMethod2) ; train 1 more combo spell for queueing
			$eBrewMethod = $g_eNoTrain
			$eBrewMethod2 = $g_eNoTrain
		EndIf
	EndIf

	If $g_bQuickTrainEnable = False Then ; Custom Train
		If _Sleep(500) Then Return
		If $bCheckWrongTroops Or $bCheckWrongSpells Then RemoveWrongTroops($bCheckWrongTroops, $bCheckWrongSpells, False)
		If _Sleep(1000) Then Return
		MakeCustomTrain($eTrainMethod, $eBrewMethod)
		If $eTrainMethod2 = $g_eFull Or $eBrewMethod2 = $g_eFull Then MakeCustomTrain($eTrainMethod2, $eBrewMethod2)

	ElseIf $eTrainMethod <> $g_eNoTrain Or $eBrewMethod <> $g_eNoTrain Then ; Quick Train
		OpenTrainTabNumber($QuickTrainTAB, "SimpleTrain()")
		If _Sleep(500) Then Return
		TrainArmyNumber($g_bQuickTrainArmy)
	Else
		Setlog("Full queue, skip Quick Train")
	EndIf

	ClickP($aAway, 2, 0, "#0000") ;Click Away

	If $bRemoveUnpreciseTroops Then CheckArmySpellCastel()

EndFunc   ;==>SimpleTrain

Func ClearTrainingTroops($Spell = False, $OpenTrainTab = False)
	Local $x = 0, $nClick = 480
	If $Spell = True Then $nClick = 22
	If $OpenTrainTab = True Then
		If $Spell = False Then
			OpenTrainTabNumber($TrainTroopsTAB, "ClearTrainingTroops()")
		Else
			OpenTrainTabNumber($BrewSpellsTAB, "ClearTrainingTroops()")
		EndIf
	EndIf

	While _ColorCheck(_GetPixelColor(820, 220, True), Hex(0xCFCFC8, 6), 15) = False ; the gray background at slot 0 troop
		PureClick(820, 202, 2, 50)
		$x += 1
		If $x = $nClick Then ExitLoop
	WEnd

	If _Sleep(250) Then Return

EndFunc   ;==>ClearTrainingTroops

Func FillArcher($ArchToMake)
	If ISArmyWindow(False, $TrainTroopsTAB) Then TrainIt($eArch, $ArchToMake, 500)
	SetLog(" » Trained " & $ArchToMake & " archer(s)!")
EndFunc   ;==>FillArcher

Func DeleteQueue($Spell = False)
	Local $CheckTroop[4] = [810, 186, 0xCFCFC8, 15] ; the gray background
	For $i = 0 To 11
		If _ColorCheck(_GetPixelColor($CheckTroop[0] - $i * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) = False Then
			Local $x = 0
			While _ColorCheck(_GetPixelColor($CheckTroop[0] - $i * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) = False
				If _Sleep(20) Then Return
				If $g_bRunState = False Then Return
				PureClick($CheckTroop[0] - $i * 70, 202, 2, 50)
				$x += 1
				If $Spell = False Then
					If $x = 250 Then ExitLoop
				Else
					If $x = 22 Then ExitLoop
				EndIf
			WEnd
			ExitLoop
		EndIf
	Next
	If _Sleep(250) Then Return
EndFunc   ;==>DeleteQueue

Func CheckBlockTroops($Spell = False)
	Local $NewCampOCR = GetOCRCurrent(48, 160)
	If $NewCampOCR[0] - $NewCampOCR[1] >= 0 Then ; Full camp after deleting queue.
		Return False	; train $g_efull
	Else
		If $Spell = False Then
			If $NewCampOCR[1] - $NewCampOCR[0] <=  $iFillArcher Then
				SetLog("   Fill some archers")
				FillArcher($NewCampOCR[1] - $NewCampOCR[0])
				Return False ; train $g_efull
			Else
				Return True ; train remained
			EndIf
		Else
			If $ichkFillEQ = 1 And $NewCampOCR[1] - $NewCampOCR[0] = 1 Then
				SetLog("   Fill with 1 EQ spell")
				If ISArmyWindow(False, $BrewSpellsTAB) Then TrainIt($eESpell, 1, 500)
				Return False ; train $g_efull
			Else
				Return True ; train remained
			EndIf
		EndIf
	EndIf
EndFunc   ;==>CheckBlockTroops

Func CheckWrongTroops($Troop = True, $Spell = False, $CheckExistentArmy = True)
	$g_abRCheckWrongTroops[0] = False
	$g_abRCheckWrongTroops[1] = False
	Local $toRemove[1][2] = [["Arch", 0]] ; Wrong Troops & Spells to be removed

	If ISArmyWindow(True, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB, "CheckWrongTroops()")
	If _Sleep(500) Then Return

	If $Troop = True Then
		If $CheckExistentArmy Then CheckExistentArmy("Troops", True)
		For $i = 0 To ($eTroopCount - 1)
			If $g_bRunState = False Then Return
			If $g_aiCurrentTroops[$i] - $g_aiArmyCompTroops[$i] > 0 Then
				$toRemove[UBound($toRemove) - 1][0] = $g_asTroopShortNames[$i]
				$toRemove[UBound($toRemove) - 1][1] = $g_aiCurrentTroops[$i] - $g_aiArmyCompTroops[$i]
				ReDim $toRemove[UBound($toRemove) + 1][2]
			EndIf
		Next
	EndIf

	If $Spell = True Then
		If $CheckExistentArmy Then CheckExistentArmy("Spells", True)
		For $i = 0 To ($eSpellCount - 1)
			If $g_bRunState = False Then Return
			If $g_aiCurrentSpells[$i] - $g_aiArmyCompSpells[$i] > 0 Then
				$toRemove[UBound($toRemove) - 1][0] = $g_asSpellShortNames[$i]
				$toRemove[UBound($toRemove) - 1][1] = $g_aiCurrentSpells[$i] - $g_aiArmyCompSpells[$i]
				ReDim $toRemove[UBound($toRemove) + 1][2]
			EndIf
		Next
	EndIf
	If UBound($toRemove) = 1 And $toRemove[0][0] = "Arch" And $toRemove[0][1] = 0 Then Return ; If was default Wrong Troops

	If UBound($toRemove) > 0 Then ; If needed to remove troops
		SetLog("Troops To Remove: ", $COLOR_GREEN)
		; Loop through Troops needed to get removed Just to write some Logs
		Local $CounterToRemove = 0
		For $i = 0 To (UBound($toRemove) - 1)
			If IsSpellToBrew($toRemove[$i][0]) Then ExitLoop
			$CounterToRemove += 1
			If $toRemove[$i][1] > 0 Then SetLog("  " & $g_asTroopNames[TroopIndexLookup($toRemove[$i][0])] & ": " & $toRemove[$i][1] & "x", $COLOR_GREEN)
		Next
		If $CounterToRemove > 0 And IsSpellToBrew($toRemove[1][0]) = False Then $g_abRCheckWrongTroops[0] = True

		If TotalSpellsToBrewInGUI() > 0 Then
			If $CounterToRemove <= UBound($toRemove) - 1 Then
				SetLog("Spells To Remove: ", $COLOR_GREEN)
				For $i = $CounterToRemove To (UBound($toRemove) - 1)
					If $toRemove[$i][1] > 0 Then SetLog("  " & $g_asSpellNames[TroopIndexLookup($toRemove[$i][0]) - $eLSpell] & ": " & $toRemove[$i][1] & "x", $COLOR_GREEN)
				Next
				$g_abRCheckWrongTroops[1] = True
			EndIf
		EndIf
	EndIf
	Return $toRemove

EndFunc   ;==>CheckWrongTroops

Func RemoveWrongTroops($Troop, $Spell, $toRemove)

	If $Troop = False And $Spell = False Then Return
	If IsArray($toRemove) = False Then $toRemove = CheckWrongTroops($Troop, $Spell, True)

	If UBound($toRemove) = 1 And $toRemove[0][0] = "Arch" And $toRemove[0][1] = 0 Then Return ; If was default Wrong Troops

	If UBound($toRemove) > 0 Then ; If needed to remove troops
		Local $rGetSlotNumber = GetSlotNumber() ; Get all available Slot numbers with troops assigned on them
		Local $rGetSlotNumberSpells = GetSlotNumber(True) ; Get all available Slot numbers with Spells assigned on them

		If _ColorCheck(_GetPixelColor(806, 472, True), Hex(0xD0E878, 6), 25) = False Then ; If no 'Edit Army' Button found in army tab to edit troops
			SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_ORANGE)
			Return ; Exit function
		EndIf

		Click(Random(723, 812, 1), Random(469, 513, 1)) ; Click on Edit Army Button

		; Loop through troops needed to get removed
		Local $CounterToRemove = 0
		For $j = 0 To (UBound($toRemove) - 1)
			If IsSpellToBrew($toRemove[$j][0]) Then ExitLoop
			$CounterToRemove += 1
			For $i = 0 To (UBound($rGetSlotNumber) - 1) ; Loop through All available slots
				If $toRemove[$j][0] = $rGetSlotNumber[$i] Then ; If $toRemove Troop Was the same as The Slot Troop
					Local $pos = GetSlotRemoveBtnPosition($i + 1) ; Get positions of - Button to remove troop
					ClickRemoveTroop($pos, $toRemove[$j][1], $g_iTrainClickDelay) ; Click on Remove button as much as needed
				EndIf
			Next
		Next

		If TotalSpellsToBrewInGUI() > 0 Then
			For $j = $CounterToRemove To (UBound($toRemove) - 1)
				For $i = 0 To (UBound($rGetSlotNumberSpells) - 1) ; Loop through All available slots
					If $toRemove[$j][0] = $rGetSlotNumberSpells[$i] Then ; If $toRemove Troop Was the same as The Slot Troop
						Local $pos = GetSlotRemoveBtnPosition($i + 1, True) ; Get positions of - Button to remove troop
						ClickRemoveTroop($pos, $toRemove[$j][1], $g_iTrainClickDelay) ; Click on Remove button as much as needed
					EndIf
				Next
			Next
		EndIf

		If _Sleep(150) Then Return

		If _ColorCheck(_GetPixelColor(806, 561, True), Hex(0xD0E878, 6), 25) = False Then ; If no 'Okay' button found in army tab to save changes
			SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_ORANGE)
			Return ; Exit Function
		EndIf

		If _Sleep(700) Then Return
		If $g_bRunState = False Then Return
		Click(Random(720, 815, 1), Random(558, 589, 1)) ; Click on 'Okay' button to save changes

		If _Sleep(1200) Then Return

		If _ColorCheck(_GetPixelColor(508, 428, True), Hex(0xFFFFFF, 6), 30) = False Then ; If no 'Okay' button found to verify that we accept the changes
			SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_ORANGE)
			Return ; Exit function
		EndIf

		Click(Random(445, 585, 1), Random(400, 455, 1)) ; Click on 'Okay' button to Save changes... Last button

		SetLog("  All Extra troops removed")
		If _Sleep(200) Then Return
	EndIf

EndFunc   ;==>RemoveWrongTroops

Func MakeCustomTrain($eTrainMethod, $eBrewMethod)

	If $eTrainMethod = $g_eNoTrain And $eBrewMethod = $g_eNoTrain Then
		Setlog("Full barracks & spell factories, skip training")
		Return
	EndIf

	;Troops
	If $eTrainMethod <> $g_eNoTrain Then
		Local $rWTT[1][2] = [["Arch", 0]] ; result of what to train
		If $eTrainMethod = $g_eRemained Then OpenTrainTabNumber($TrainTroopsTAB, "MakeCustomTrain()")
		If ISArmyWindow(True, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB, "MakeCustomTrain()")
		If $eTrainMethod = $g_eRemained Then
			Setlog("Custom train troops left")
			For $i = 0 To ($eTroopCount - 1)
				Local $troopIndex = $g_aiTrainOrder[$i]
				If $g_bRunState = False Then Return
				If $g_aiArmyCompTroops[$troopIndex] - $g_aiCurrentTroops[$troopIndex] > 0 Then
					$rWTT[UBound($rWTT) - 1][0] = $g_asTroopShortNames[$troopIndex]
					$rWTT[UBound($rWTT) - 1][1] = Abs($g_aiArmyCompTroops[$troopIndex] - $g_aiCurrentTroops[$troopIndex])
					Local $iTroopIndex = TroopIndexLookup($rWTT[UBound($rWTT) - 1][0])
					Local $sTroopName = ($rWTT[UBound($rWTT) - 1][1] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
					setlog(UBound($rWTT) & ". " & $sTroopName & " x " & $rWTT[UBound($rWTT) - 1][1])
					ReDim $rWTT[UBound($rWTT) + 1][2]
				EndIf
			Next

		ElseIf $eTrainMethod = $g_eFull Then
			Setlog("Custom train full set of troops")
			For $i = 0 To ($eTroopCount - 1)
				Local $troopIndex = $g_aiTrainOrder[$i]
				If $g_aiArmyCompTroops[$troopIndex] > 0 Then
					$rWTT[UBound($rWTT) - 1][0] = $g_asTroopShortNames[$troopIndex]
					$rWTT[UBound($rWTT) - 1][1] = $g_aiArmyCompTroops[$troopIndex]
					Local $iTroopIndex = TroopIndexLookup($rWTT[UBound($rWTT) - 1][0])
					Local $sTroopName = ($rWTT[UBound($rWTT) - 1][1] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
					setlog(UBound($rWTT) & ". " & $sTroopName & " x " & $rWTT[UBound($rWTT) - 1][1])
					ReDim $rWTT[UBound($rWTT) + 1][2]
				EndIf
			Next
		EndIf

		; Train it
		For $i = 0 To (UBound($rWTT) - 1)
			If $g_bRunState = False Then Return
			If $rWTT[$i][1] > 0 Then
				If DragIfNeeded($rWTT[$i][0]) = False Then Return False
				If CheckValuesCost($rWTT[$i][0], $rWTT[$i][1]) Then
					Local $iTroopIndex = TroopIndexLookup($rWTT[$i][0])
					Local $sTroopName = ($rWTT[$i][1] > 1 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex])
					SetLog("Training " & $rWTT[$i][1] & "x " & $sTroopName, $COLOR_GREEN)
					TrainIt($iTroopIndex, $rWTT[$i][1], $g_iTrainClickDelay)
				Else
					SetLog("No resources to Train " & $rWTT[$i][1] & "x " & $sTroopName, $COLOR_ORANGE)
				EndIf
			EndIf
		Next
	EndIf

	;Spells
	If $eBrewMethod <> $g_eNoTrain Then
		Local $rWTT[1][2] = [["LSpell", 0]] ; result of what to train
		If $eTrainMethod = $g_eRemained Then OpenTrainTabNumber($BrewSpellsTAB, "MakeCustomTrain()")
		If ISArmyWindow(True, $BrewSpellsTAB) = False Then OpenTrainTabNumber($BrewSpellsTAB, "MakeCustomTrain()")
		If $eBrewMethod = $g_eRemained Then
			Setlog("Custom brew spells left")
			For $i = 0 To ($eSpellCount - 1)
				If $g_bRunState = False Then Return
				If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
				If $g_aiArmyCompSpells[$i] - $g_aiCurrentSpells[$i] > 0 Then
					$rWTT[UBound($rWTT) - 1][0] = $g_asSpellShortNames[$i]
					$rWTT[UBound($rWTT) - 1][1] = $g_aiArmyCompSpells[$i] - $g_aiCurrentSpells[$i]
					Local $iSpellIndex = TroopIndexLookup($rWTT[UBound($rWTT) - 1][0])
					Local $sSpellName = $g_asSpellNames[$iSpellIndex - $eLSpell]
					setlog(UBound($rWTT) & ". " & $sSpellName & " x " & $rWTT[UBound($rWTT) - 1][1])
					ReDim $rWTT[UBound($rWTT) + 1][2]
				EndIf
			Next
		ElseIf $eBrewMethod = $g_eFull Then
			Setlog("Custom brew full set of spells")
			For $i = 0 To ($eSpellCount - 1)
				If $g_bRunState = False Then Return
				If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
				If $g_aiArmyCompSpells[$i] > 0 Then
					$rWTT[UBound($rWTT) - 1][0] = $g_asSpellShortNames[$i]
					$rWTT[UBound($rWTT) - 1][1] = $g_aiArmyCompSpells[$i]
					Local $iSpellIndex = TroopIndexLookup($rWTT[UBound($rWTT) - 1][0])
					Local $sSpellName = $g_asSpellNames[$iSpellIndex - $eLSpell]
					setlog(UBound($rWTT) & ". " & $sSpellName & " x " & $rWTT[UBound($rWTT) - 1][1])
					ReDim $rWTT[UBound($rWTT) + 1][2]
				EndIf
			Next
		EndIf

		; Train it
		For $i = 0 To (UBound($rWTT) - 1)
			If $g_bRunState = False Then Return
			If $rWTT[$i][1] > 0 Then
				If CheckValuesCost($rWTT[$i][0], $rWTT[$i][1]) Then
					Local $iSpellIndex = TroopIndexLookup($rWTT[$i][0])
					Local $sSpellName = $g_asSpellNames[$iSpellIndex - $eLSpell]
					SetLog("Brewing " & $rWTT[$i][1] & "x " & $sSpellName, $COLOR_GREEN)
					TrainIt($iSpellIndex, $rWTT[$i][1], $g_iTrainClickDelay)
				Else
					SetLog("No resources to Train " & $rWTT[$i][1] & "x " & $sSpellName, $COLOR_ORANGE)
				EndIf
			EndIf
		Next
	EndIf
EndFunc   ;==>MakeCustomTrain
