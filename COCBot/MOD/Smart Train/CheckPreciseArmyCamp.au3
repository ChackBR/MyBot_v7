; #FUNCTION# ====================================================================================================================
; Name ..........: CheckPreciseArmyCamp
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: Demen
; Modified ......: Team AiO MOD++ (2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckPreciseArmyCamp()

	If Not $g_bChkPreciseArmyCamp Then Return False

	Local $sTextTroop = "Troops are so far so good!"
	Local $sTextSpell = "Spells are so far so good!"

	SetLog("Checking ArmyWindow for Troops & Spells precision", $COLOR_INFO)

	Local $bReturnArmyTab = False
	Local $toRemove = CheckWrongArmyCamp(False) ; Return $toRemove, Get value of $g_bWrongTroop & $g_bWrongSpell
	If @error Then Return SetError(2) ; Quit SmartTrain

	If Not $g_bWrongTroop And Not $g_bWrongSpell Then ; Troops & Spells are correct
		If $g_bFullArmy Then $sTextTroop = "All troops are correct!"
		If $g_bFullArmySpells Then $sTextSpell = "All spells are correct!"
		If $g_bForceBrewSpells Then $sTextSpell = "Skip checking spells as ForceBrewSpell is activated!"

		SetLog($sTextTroop & " " & $sTextSpell, $COLOR_SUCCESS)
		Return False

	Else ; Wrong troops or Wrong spells
		Local $bNeedClearTroop = $g_bWrongTroop And _ColorCheck(_GetPixelColor($aGreenArrowTrainTroops[0], $aGreenArrowTrainTroops[1], True), Hex(0xA0D077, 6), 30)
		Local $bNeedClearSpell = $g_bWrongSpell And _ColorCheck(_GetPixelColor($aGreenArrowBrewSpells[0], $aGreenArrowBrewSpells[1], True), Hex(0xA0D077, 6), 30)

		If $bNeedClearTroop Then
			SetLog("Need to clear queued troops before removing!", $COLOR_ACTION)
			ClearTrainingArmyCamp("Troop", Not $bNeedClearSpell) ; open Troop tab, clear all training, return to Army tab if Not $bNeedClearSpell.
			If @error Then Return SetError(2) ; Quit SmartTrain
		EndIf

		If $bNeedClearSpell Then
			SetLog("Need to clear queued spells before removing!", $COLOR_ACTION)
			ClearTrainingArmyCamp("Spell", True) ; open Troop tab, clear all training, return to Army tab.
			If @error Then Return SetError(2) ; Quit SmartTrain
		EndIf

		If $bNeedClearTroop Or $bNeedClearSpell Then $toRemove = CheckWrongArmyCamp()
		If @error Then Return SetError(2) ; Quit SmartTrain

		If _Sleep(200) Then Return
		RemoveWrongArmyCamp($toRemove)
		If @error Then Return SetError(2) ; Quit SmartTrain
		Return True
	EndIf

EndFunc   ;==>CheckPreciseArmyCamp

Func CheckWrongArmyCamp($bCheckExistentArmy = True)

	$g_sSmartTrainError = ""
	Local $toRemove[1][2] = [["Arch", 0]] ; Wrong Troops & Spells to be removed
	$g_bWrongTroop = False
	$g_bWrongSpell = False

	If Not OpenArmyTab() Then $g_sSmartTrainError = SetError(3, 0, "Error OpenArmyTab called from CheckWrongArmyCamp.")
	If @error Then Return ; quit smarttrain

	If _Sleep(500) Then Return

	If $bCheckExistentArmy Then
		getArmyTroops()
		If Not $g_bForceBrewSpells Then getArmySpells()
	EndIf

	; Troops
	For $i = 0 To ($eTroopCount - 1)
		If $g_aiCurrentTroops[$i] - $g_aiArmyCompTroops[$i] > 0 Then
			$toRemove[UBound($toRemove) - 1][0] = $g_asTroopShortNames[$i]
			$toRemove[UBound($toRemove) - 1][1] = $g_aiCurrentTroops[$i] - $g_aiArmyCompTroops[$i]
			ReDim $toRemove[UBound($toRemove) + 1][2]
		EndIf
	Next

	; Spells
	If Not $g_bForceBrewSpells Then
		For $i = 0 To ($eSpellCount - 1)
			If $g_aiCurrentSpells[$i] - $g_aiArmyCompSpells[$i] > 0 Then
				$toRemove[UBound($toRemove) - 1][0] = $g_asSpellShortNames[$i]
				$toRemove[UBound($toRemove) - 1][1] = $g_aiCurrentSpells[$i] - $g_aiArmyCompSpells[$i]
				ReDim $toRemove[UBound($toRemove) + 1][2]
			EndIf
		Next
	EndIf

	If UBound($toRemove) = 1 And $toRemove[0][0] = "Arch" And $toRemove[0][1] = 0 Then Return ; If was default Wrong Troops

	If UBound($toRemove) > 0 Then ; If needed to remove troops
		SetLog("Troops To Remove: ", $COLOR_INFO)
		; Loop through Troops needed to get removed Just to write some Logs
		Local $CounterToRemove = 0
		For $i = 0 To (UBound($toRemove) - 1)
			If IsSpellToBrew($toRemove[$i][0]) Then ExitLoop
			$CounterToRemove += 1
			If $toRemove[$i][1] > 0 Then
				SetLog(" - " & $g_asTroopNames[TroopIndexLookup($toRemove[$i][0])] & ": " & $toRemove[$i][1] & "x", $COLOR_SUCCESS)
				$g_bWrongTroop = True
			EndIf
		Next

		If TotalSpellsToBrewInGUI() > 0 Then
			If $CounterToRemove <= UBound($toRemove) - 1 Then
				SetLog("Spells To Remove: ", $COLOR_INFO)
				For $i = $CounterToRemove To (UBound($toRemove) - 1)
					If $toRemove[$i][1] > 0 Then SetLog(" - " & $g_asSpellNames[TroopIndexLookup($toRemove[$i][0]) - $eLSpell] & ": " & $toRemove[$i][1] & "x", $COLOR_SUCCESS)
				Next
				$g_bWrongSpell = True
			EndIf
		EndIf
	EndIf
	Return $toRemove

EndFunc   ;==>CheckWrongArmyCamp


Func RemoveWrongArmyCamp($toRemove)

	If Not IsArray($toRemove) Then Return
	$g_sSmartTrainError = ""

	If UBound($toRemove) > 0 Then ; If needed to remove troops
		Local $rGetSlotNumber = GetSlotNumber() ; Get all available Slot numbers with troops assigned on them
		Local $rGetSlotNumberSpells = GetSlotNumber(True) ; Get all available Slot numbers with Spells assigned on them

		If Not _ColorCheck(_GetPixelColor(806, 516, True), Hex(0xCEEF76, 6), 25) Then ; If no 'Edit Army' Button found in army tab to edit troops
			SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_WARNING)
			$g_sSmartTrainError = SetError(3, 0, "Error finding 'Edit Army' button, called from RemoveWrongArmyCamp.")
			Return ; quit SmartTrain
		EndIf

		Click(Random(719, 838, 1), Random(505, 545, 1)) ; Click on Edit Army Button

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

		If Not _ColorCheck(_GetPixelColor(806, 567, True), Hex(0xCEEF76, 6), 25) Then ; If no 'Okay' button found in army tab to save changes
			SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_WARNING)
			$g_sSmartTrainError = SetError(3, 0, "Error finding 'Okay' button, called from RemoveWrongArmyCamp.")
			Return ; quit SmartTrain
		EndIf

		If _Sleep(700) Then Return
		Click(Random(724, 827, 1), Random(556, 590, 1)) ; Click on 'Okay' button to save changes

		If _Sleep(1200) Then Return

		If Not _ColorCheck(_GetPixelColor(508, 428, True), Hex(0xFFFFFF, 6), 30) Then ; If no 'Okay' button found to verify that we accept the changes
			SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_WARNING)
			$g_sSmartTrainError = SetError(3, 0, "Error finding 'Okay #2' button, called from RemoveWrongArmyCamp.")
			Return ; quit SmartTrain
		EndIf

		Click(Random(443, 583, 1), Random(400, 457, 1)) ; Click on 'Okay' button to Save changes... Last button

		SetLog("All wrong troops removed", $COLOR_SUCCESS)
		If _Sleep(200) Then Return
	EndIf

EndFunc   ;==>RemoveWrongArmyCamp
