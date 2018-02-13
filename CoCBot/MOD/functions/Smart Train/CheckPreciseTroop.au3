; #FUNCTION# ====================================================================================================================
; Name ..........: CheckPreciseTroop (#-13)
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: Demen
; Modified ......: Team AiO MOD++ (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckPreciseTroop()

	If $iChkPreciseTroops = 0 Then Return False

	Local $sTextTroop = "Troops are so far so good."
	Local $sTextSpell = "Spells are so far so good."

	SetLog("»» Checking Army Window for troops & spells precision")

	Local $bReturnArmyTab = False
	Local $toRemove = CheckWrongTroops(True, Not ($g_bForceBrewSpells), False) ; If $g_bForceBrewSpells = True Then CheckWrongTroops(True, FALSE, False); $g_abRCheckWrongTroops[1] always FALSE

	If $g_abRCheckWrongTroops[0] = False And $g_abRCheckWrongTroops[1] = False Then ; Troops & Spells are correct
		If $g_bFullArmy Then $sTextTroop = "All troops are correct!"
		If $g_bFullArmySpells Then $sTextSpell = "All spells are correct!"
		If $g_bForceBrewSpells Then $sTextSpell = "Skip checking spells as ForceBrewSpell is activated."

		SetLog("  » " & $sTextTroop & " " & $sTextSpell)
		Return False

	Else ; Wrong troops or Wrong spells
		Local $text = ""
		If $g_abRCheckWrongTroops[0] And _ColorCheck(_GetPixelColor($aGreenArrowTrainTroops[0], $aGreenArrowTrainTroops[1], True), Hex(0xa0d077, 6), 30) Then $text = " Troops &"
		If $g_abRCheckWrongTroops[1] And _ColorCheck(_GetPixelColor($aGreenArrowTrainTroops[0], $aGreenArrowTrainTroops[1], True), Hex(0xa0d077, 6), 30) Then $text &= " Spells "
		If StringRight($text, 1) = "&" Then $text = StringTrimRight($text, 1) ; Remove last " &" as it is not needed

		If $text <> "" Then
			SetLog("  » Need to clear queued" & $text & "before removing")
			If $g_abRCheckWrongTroops[0] Then ClearTrainingTroops($TrainTroopsTAB)
			If $g_abRCheckWrongTroops[1] Then ClearTrainingTroops($BrewSpellsTAB)
			$bReturnArmyTab = True
		EndIf

		If $bReturnArmyTab Then OpenArmyTab()
		If _Sleep(200) Then Return
		RemoveWrongTroops($g_abRCheckWrongTroops[0], $g_abRCheckWrongTroops[1], $toRemove)
		Return True

	EndIf

EndFunc   ;==>CheckPreciseTroop

Func CheckWrongTroops($Troop = True, $Spell = False, $CheckExistentArmy = True)
	$g_abRCheckWrongTroops[0] = False
	$g_abRCheckWrongTroops[1] = False
	Local $toRemove[1][2] = [["Arch", 0]] ; Wrong Troops & Spells to be removed

	If Not ISArmyWindow(False, $ArmyTAB) Then OpenArmyTab()
	If _Sleep(500) Then Return

	If $Troop = True Then
		If $CheckExistentArmy Then getArmyTroops(False, False, False, True)
		For $i = 0 To ($eTroopCount - 1)
			If Not $g_bRunState Then Return
			If $g_aiCurrentTroops[$i] - $g_aiArmyCompTroops[$i] > 0 Then
				$toRemove[UBound($toRemove) - 1][0] = $g_asTroopShortNames[$i]
				$toRemove[UBound($toRemove) - 1][1] = $g_aiCurrentTroops[$i] - $g_aiArmyCompTroops[$i]
				ReDim $toRemove[UBound($toRemove) + 1][2]
			EndIf
		Next
	EndIf

	If $Spell Then
		If $CheckExistentArmy Then getArmySpells(False, False, False, True)
		For $i = 0 To ($eSpellCount - 1)
			If Not $g_bRunState Then Return
			If $g_aiCurrentSpells[$i] - $g_aiArmyCompSpells[$i] > 0 Then
				$toRemove[UBound($toRemove) - 1][0] = $g_asSpellShortNames[$i]
				$toRemove[UBound($toRemove) - 1][1] = $g_aiCurrentSpells[$i] - $g_aiArmyCompSpells[$i]
				ReDim $toRemove[UBound($toRemove) + 1][2]
			EndIf
		Next
	EndIf
	If UBound($toRemove) = 1 And $toRemove[0][0] = "Arch" And $toRemove[0][1] = 0 Then Return ; If was default Wrong Troops

	If UBound($toRemove) > 0 Then ; If needed to remove troops
		SetLog("  » Troops To Remove: ", $COLOR_GREEN)
		; Loop through Troops needed to get removed Just to write some Logs
		Local $CounterToRemove = 0
		For $i = 0 To (UBound($toRemove) - 1)
			If IsSpellToBrew($toRemove[$i][0]) Then ExitLoop
			$CounterToRemove += 1
			If $toRemove[$i][1] > 0 Then SetLog("    " & $g_asTroopNames[TroopIndexLookup($toRemove[$i][0])] & ": " & $toRemove[$i][1] & "x", $COLOR_GREEN)
		Next
		If $CounterToRemove > 0 And IsSpellToBrew($toRemove[1][0]) = False Then $g_abRCheckWrongTroops[0] = True

		If TotalSpellsToBrewInGUI() > 0 Then
			If $CounterToRemove <= UBound($toRemove) - 1 Then
				SetLog("  » Spells To Remove: ", $COLOR_GREEN)
				For $i = $CounterToRemove To (UBound($toRemove) - 1)
					If $toRemove[$i][1] > 0 Then SetLog("    " & $g_asSpellNames[TroopIndexLookup($toRemove[$i][0]) - $eLSpell] & ": " & $toRemove[$i][1] & "x", $COLOR_GREEN)
				Next
				$g_abRCheckWrongTroops[1] = True
			EndIf
		EndIf
	EndIf
	Return $toRemove

EndFunc   ;==>CheckWrongTroops

Func RemoveWrongTroops($Troop, $Spell, $toRemove)

	If Not $Troop And Not $Spell Then Return
	If Not IsArray($toRemove) Then $toRemove = CheckWrongTroops($Troop, $Spell, True)

	If UBound($toRemove) = 1 And $toRemove[0][0] = "Arch" And $toRemove[0][1] = 0 Then Return ; If was default Wrong Troops

	If UBound($toRemove) > 0 Then ; If needed to remove troops
		Local $rGetSlotNumber = GetSlotNumber() ; Get all available Slot numbers with troops assigned on them
		Local $rGetSlotNumberSpells = GetSlotNumber(True) ; Get all available Slot numbers with Spells assigned on them

		If Not _ColorCheck(_GetPixelColor(806, 516, True), Hex(0xCEEF76, 6), 25) Then ; If no 'Edit Army' Button found in army tab to edit troops
			SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_ORANGE)
			Return ; Exit function
		EndIf

		Click(Random(715, 825, 1), Random(507, 543, 1)) ; Click on Edit Army Button

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

		If _Sleep(500) Then Return

		If Not _ColorCheck(_GetPixelColor(806, 567, True), Hex(0xCDEF76, 6), 25) Then ; If no 'Okay' button found in army tab to save changes
			SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_ORANGE)
			Return ; Exit Function
		EndIf

		If _Sleep(700) Then Return
		If Not $g_bRunState Then Return
		Click(Random(720, 815, 1), Random(558, 589, 1)) ; Click on 'Okay' button to save changes

		If _Sleep(1200) Then Return

		If Not _ColorCheck(_GetPixelColor(508, 428, True), Hex(0xFFFFFF, 6), 30) Then ; If no 'Okay' button found to verify that we accept the changes
			SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_ORANGE)
			Return ; Exit function
		EndIf

		Click(Random(445, 583, 1), Random(402, 455, 1)) ; Click on 'Okay' button to Save changes... Last button

		SetLog("    All wrong troops removed")
		If _Sleep(200) Then Return
	EndIf

EndFunc   ;==>RemoveWrongTroops
