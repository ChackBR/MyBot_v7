; #FUNCTION# ====================================================================================================================
; Name ..........: CheckCC & remove unexpected troops in CC
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: DEMEN
; Modified ......: Team AiO MOD++ (2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckCC($close = True)
	Local $directory = @ScriptDir & "\imgxml\ArmyOverview\Troops"
	Local $aToRemove[7] ; 5 slots for troop and 2 slots for spell
	Local $aPos[2] = [70, 575]
	Local $bNeedRemoveCC = False
	Local $Spell_Offset = 0, $Mid_Offset = 0
	Local $asLogText[1] = [""]

	If Not $g_bChkCCTroops And Not $g_bChkCCSpells Then Return

	ResetVariables("CCTroops")

	If Not IsArmyWindow(False, $ArmyTAB) Then
		OpenArmyOverview(True, "CheckCC()")
		If _Sleep(1500) Then Return
	EndIf

	SetLog("Checking CC " & ($g_bChkCCTroops ? ($g_bChkCCSpells ? "Troops & Spells" : "Troops") : "Spells"), $COLOR_INFO)

	; spell in middle: check gray background at 1st slot and blue color at mid slot
	If _ColorCheck(_GetPixelColor(525, 508, True), Hex(0xCFCFC8, 6), 15) And _ColorCheck(_GetPixelColor(525 + 37, 508, True), Hex(0x4488C5, 6), 15) Then $Mid_Offset = 37

	For $i = 0 To 4
		If Not $g_bChkCCTroops Then ExitLoop

		If $g_bDebugSetlog Then SetDebugLog("SLOT : " & $i, $COLOR_DEBUG) ;Debug
		If _ColorCheck(_GetPixelColor(Round(30 + 72.8 * $i, 0), 508, True), Hex(0xCFCFC8, 6), 15) Then
			If $g_bDebugSetlog Then SetDebugLog("No more CC troop", $COLOR_DEBUG) ;Debug
			ExitLoop
		EndIf

		; name of first file found: troop short name e.g. "Barb"
		Local $sTroopNameFound = QuickMIS("N1", $directory, Round(23 + 72.8 * $i, 0), 517, Round(95 + 72.8 * $i, 0), 557, True, $g_bDebugSetlog)
		If $sTroopNameFound = "none" Then Return

		Local $iQty = Number(getBarracksNewTroopQuantity(Round(35 + 72.8 * $i, 0), 498)) ; coc-newarmy
		Local $eIndex = Eval("e" & $sTroopNameFound)
		If $g_bDebugSetlog Then SetDebugLog("Found: " & $sTroopNameFound & " x" & $iQty, $COLOR_DEBUG) ;Debug

		Local $iFound, $iExpect
		$g_aiCCTroops[$eIndex] += $iQty
		$iFound = $g_aiCCTroops[$eIndex]
		$iExpect = $g_aiCCTroopsExpected[$eIndex]

		If $iFound - $iExpect > 0 Then
			$aToRemove[$i] = $iFound - $iExpect
			If $aToRemove[$i] > $iQty Then $aToRemove[$i] = $iQty
			If $g_bDebugSetlog Then SetDebugLog("Expected: " & $sTroopNameFound & " x" & $iExpect & ". Should remove: x" & $aToRemove[$i], $COLOR_DEBUG) ;Debug
			$bNeedRemoveCC = True
		EndIf
	Next

	For $i = 5 To 6
		If Not $g_bChkCCSpells Then ExitLoop
		$directory = $g_sImgArmyOverviewSpells

		If $g_bDebugSetlog Then SetDebugLog("SLOT : " & $i, $COLOR_DEBUG) ;Debug
		If $Mid_Offset = 37 And $i = 6 Then ExitLoop ; Slot 6 is the last
		If _ColorCheck(_GetPixelColor(Round(102 + 72.8 * $i + $Mid_Offset, 0), 508, True), Hex(0xCFCFC8, 6), 15) Then
			If $g_bDebugSetlog Then SetDebugLog("No CC spell, quit checking", $COLOR_DEBUG) ;Debug
			ExitLoop ; Slot 6 has no spell
		EndIf

		; name of first file found: spell short name e.g. "LSpell"
		Local $sSpellNameFound = QuickMIS("N1", $directory, Round(95 + 72.8 * $i + $Mid_Offset, 0), 517, Round(167 + 72.8 * $i + $Mid_Offset, 0), 557, True, $g_bDebugSetlog)
		If $sSpellNameFound = "none" Then Return

		Local $iQty = Number(getBarracksNewTroopQuantity(Round(107 + 72.8 * $i + $Mid_Offset, 0), 498)) ; coc-newarmy
		Local $eIndex = Eval("e" & $sSpellNameFound)
		If $g_bDebugSetlog Then SetDebugLog("Found: " & $sSpellNameFound & " x" & $iQty, $COLOR_DEBUG) ;Debug

		Local $iFound, $iExpect
		$g_aiCCSpells[$eIndex - $eLSpell] += $iQty
		$iFound = $g_aiCCSpells[$eIndex - $eLSpell]
		$iExpect = $g_aiCCSpellsExpected[$eIndex - $eLSpell]

		If $iFound - $iExpect > 0 Then
			$aToRemove[$i] = $iFound - $iExpect
			If $aToRemove[$i] > $iQty Then $aToRemove[$i] = $iQty
			If $g_bDebugSetlog Then SetDebugLog("Expected: " & $sSpellNameFound & " x" & $iExpect & ". Should remove: x" & $aToRemove[$i], $COLOR_DEBUG) ;Debug
			$bNeedRemoveCC = True
		EndIf
	Next

	For $i = 0 To $eTroopCount - 1
		If $g_aiCCTroops[$i] > 0 Then
			SetLog(" - " & $g_aiCCTroops[$i] & "x " & NameOfTroop($i, $g_aiCCTroops[$i] > 1 ? 1 : 0) & " available in Clan Castle", $COLOR_SUCCESS)
			If $g_aiCCTroops[$i] - $g_aiCCTroopsExpected[$i] > 0 Then
				ReDim $asLogText[UBound($asLogText)+1]
				$asLogText[UBound($asLogText)-2] = " - " & $g_aiCCTroops[$i] & "x " & NameOfTroop($i, $g_aiCCTroops[$i] > 1 ? 1 : 0)
			EndIf
		EndIf
	Next
	For $i = 0 To $eSpellCount - 1
		If $g_aiCCSpells[$i] > 0 Then
			SetLog(" - " & $g_aiCCSpells[$i] & "x " & $g_asSpellNames[$i] & " Spell available in Clan Castle", $COLOR_SUCCESS)
			If $g_aiCCSpells[$i] - $g_aiCCSpellsExpected[$i] > 0 Then
				ReDim $asLogText[UBound($asLogText)+1]
				$asLogText[UBound($asLogText)-2] = " - " & $g_aiCCSpells[$i] & "x " & $g_asSpellNames[$i]
			EndIf
		EndIf
	Next

	If $bNeedRemoveCC Then
		SetLog("Some unexpected " & ($g_bChkCCTroops ? ($g_bChkCCSpells ? "troops/spells" : "troops") : "spells") & " in Clan Castle, let's remove.", $COLOR_ACTION)
		For $i = 0 To UBound($asLogText)-2
			SetLog($asLogText[$i], $COLOR_ACTION)
		Next
		If Not _ColorCheck(_GetPixelColor(806, 516, True), Hex(0xCEEF76, 6), 25) Then ; If no 'Edit Army' Button found in army tab to edit troops
			SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_WARNING)
			If $close Then ClickP($aAway, 2, 0)
			Return ; Exit function
		EndIf
		Click(Random(719, 838, 1), Random(505, 545, 1)) ; Click on Edit Army Button
		If _Sleep(500) Then Return

		For $i = 0 To 6
			If $aToRemove[$i] > 0 Then
				$aPos[0] = 74 * ($i + 1) - 4
				If $i > 4 Then $aPos[0] += 54 + $Mid_Offset
				ClickRemoveTroop($aPos, $aToRemove[$i], $g_iTrainClickDelay) ; Click on Remove button as much as needed
			EndIf
		Next

		For $i = 0 To 6
			If _ColorCheck(_GetPixelColor(806, 567, True), Hex(0xCEEF76, 6), 25) Then
				Click(Random(724, 827, 1), Random(556, 590, 1)) ; Click on 'Okay' button to save changes
				ExitLoop
			Else
				If $i = 6 Then
					SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_WARNING)
					If $close Then ClickP($aAway, 2, 0)
					Return ; Exit function
				EndIf
				If _Sleep(200) Then Return
			EndIf
		Next

		For $i = 0 To 6
			If _ColorCheck(_GetPixelColor(508, 428, True), Hex(0xFFFFFF, 6), 30) Then
				Click(Random(443, 583, 1), Random(400, 457, 1)) ; Click on 'Okay' button to Save changes... Last button
				ExitLoop
			Else
				If $i = 6 Then
					SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_WARNING)
					If $close Then ClickP($aAway, 2, 0)
					Return ; Exit function
				EndIf
				If _Sleep(300) Then Return
			EndIf
		Next

		SetLog("Unexpected CC " & ($g_bChkCCTroops ? ($g_bChkCCSpells ? "troops/spells" : "troops") : "spells") & " removed", $COLOR_SUCCESS)
		If _Sleep(200) Then Return
	EndIf
	If $close Then ClickP($aAway, 2, 0)

EndFunc   ;==>CheckCC
