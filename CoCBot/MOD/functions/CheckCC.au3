; #FUNCTION# ====================================================================================================================
; Name ..........: CheckCC & remove unexpected troops in CC (#-24)
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: DEMEN
; Modified ......: Team AiO MOD++ (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckCC($close = True)
	Local $directory = @ScriptDir & "\imgxml\ArmyOverview\Troops"
	Local $aToRemove[8] ; 6 slots for troop and 2 slots for spell
	Local $aPos[2] = [70, 575]
	Local $bNeedRemoveCC = False
	Local $Spell_Offset = 0, $Mid_Offset = 0
	Local $asLogText[1] = [""]

	If $g_bChkCCTroops = False Then Return

	ResetVariables("CCTroops")

	If Not IsArmyWindow(False, $ArmyTAB) Then
		OpenArmyOverview()
		If _Sleep(1500) Then Return
	EndIf

	; spell in middle: check gray background at 1st slot and blue color at mid slot
	If _ColorCheck(_GetPixelColor(525, 508, True), Hex(0xCFCFC8, 6), 15) And _ColorCheck(_GetPixelColor(525 + 37, 508, True), Hex(0x4488C5, 6), 15) Then $Mid_Offset = 37

	For $i = 0 To 7
		If $i = 6 Then ; Start checking Spell
			$Spell_Offset = 54 + $Mid_Offset
			$directory = $g_sImgArmyOverviewSpells
		EndIf

		If $g_bDebugSetlog Then SetDebugLog("SLOT : " & $i, $COLOR_DEBUG) ;Debug
		If $Mid_Offset = 37 And $i = 7 Then ExitLoop ; Slot 6 is the last
		If _ColorCheck(_GetPixelColor(Round(30 + 72.8 * $i + $Spell_Offset, 0), 508, True), Hex(0xCFCFC8, 6), 15) = True Then
			If $i < 6 Then
				$i = 5 ; jump to check spell
				If $g_bDebugSetlog Then SetDebugLog("No more CC troop, jump to slot: " & $i + 1, $COLOR_DEBUG) ;Debug
				ContinueLoop
			Else
				ExitLoop ; Slot 6 has no spell
				If $g_bDebugSetlog Then SetDebugLog("No CC spell, quit checking", $COLOR_DEBUG) ;Debug
			EndIf
		EndIf

		_CaptureRegion2(Round(23 + 72.8 * $i + $Spell_Offset, 0), 517, Round(95 + 72.8 * $i + $Spell_Offset, 0), 557)

		Local $Res = DllCall($g_hLibMyBot, "str", "SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)
		If $Res[0] = "" Or $Res[0] = "0" Then
			SetLog("Some kind of error, no image file return for slot: " & $i, $COLOR_RED)
		ElseIf StringInStr($Res[0], "-1") <> 0 Then
			SetLog("DLL Error", $COLOR_RED)
		Else ; name of first file found
			Local $aResult = StringSplit($Res[0], "_") ; $aResult[1] = troop short name "Barb" or "LSpell"
			Local $iQty = Number(getBarracksNewTroopQuantity(Round(35 + 72.8 * $i + $Spell_Offset, 0), 498)) ; coc-newarmy
			Local $eIndex = Eval("e" & $aResult[1])
			If $g_bDebugSetlog Then SetDebugLog("Found: " & $aResult[1] & " x" & $iQty, $COLOR_DEBUG) ;Debug

			Local $iFound, $iExpect
			If $i <= 5 Then
				$g_aiCCTroops[$eIndex] += $iQty
				$iFound = $g_aiCCTroops[$eIndex]
				$iExpect = $g_aiCCTroopsExpected[$eIndex]
			Else
				$g_aiCCSpells[$eIndex - $eLSpell] += $iQty
				$iFound = $g_aiCCSpells[$eIndex - $eLSpell]
				$iExpect = $g_aiCCSpellsExpected[$eIndex - $eLSpell]
			EndIf

			If $iFound - $iExpect > 0 Then
				$aToRemove[$i] = $iFound - $iExpect
				If $aToRemove[$i] > $iQty Then $aToRemove[$i] = $iQty
				If $g_bDebugSetlog Then SetDebugLog("Expected: " & $aResult[1] & " x" & $iExpect & ". Should remove: x" & $aToRemove[$i], $COLOR_DEBUG) ;Debug
				$bNeedRemoveCC = True
			EndIf
		EndIf
	Next

	SetLog("Checking CC Troops & Spells")
	For $i = 0 To $eTroopCount - 1
		If $g_aiCCTroops[$i] > 0 Then
			SetLog(" - " & $g_aiCCTroops[$i] & "x " & NameOfTroop($i, $g_aiCCTroops[$i] > 1 ? 1 : 0) & " available in Clan Castle", $COLOR_GREEN)
			If $g_aiCCTroops[$i] - $g_aiCCTroopsExpected[$i] > 0 Then
				ReDim $asLogText[UBound($asLogText)+1]
				$asLogText[UBound($asLogText)-2] = " - " & $g_aiCCTroops[$i] & "x " & NameOfTroop($i, $g_aiCCTroops[$i] > 1 ? 1 : 0)
			EndIf
		EndIf
	Next
	For $i = 0 To $eSpellCount - 1
		If $g_aiCCSpells[$i] > 0 Then
			SetLog(" - " & $g_aiCCSpells[$i] & "x " & $g_asSpellNames[$i] & " Spell available in Clan Castle", $COLOR_GREEN)
			If $g_aiCCSpells[$i] - $g_aiCCSpellsExpected[$i] > 0 Then
				ReDim $asLogText[UBound($asLogText)+1]
				$asLogText[UBound($asLogText)-2] = " - " & $g_aiCCSpells[$i] & "x " & $g_asSpellNames[$i]
			EndIf
		EndIf
	Next

	If $bNeedRemoveCC Then
		SetLog("Some unexpected troops/spells in Clan Castle, let's remove.")
		For $i = 0 To UBound($asLogText)-2
			SetLog($asLogText[$i])
		Next
		If Not _ColorCheck(_GetPixelColor(806, 516, True), Hex(0xCEEF76, 6), 25) Then ; If no 'Edit Army' Button found in army tab to edit troops
			SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_ORANGE)
			If $close Then ClickP($aAway, 2, 0)
			Return ; Exit function
		EndIf
		Click(Random(715, 825, 1), Random(507, 545, 1)) ; Click on Edit Army Button
		If _Sleep(500) Then Return

		For $i = 0 To 7
			If $aToRemove[$i] > 0 Then
				$aPos[0] = 74 * ($i + 1) - 4
				If $i > 5 Then $aPos[0] += 54 + $Mid_Offset
				ClickRemoveTroop($aPos, $aToRemove[$i], $g_iTrainClickDelay) ; Click on Remove button as much as needed
			EndIf
		Next

		For $i = 0 To 6
			If _ColorCheck(_GetPixelColor(806, 567, True), Hex(0xCEEF76, 6), 25) Then
				Click(Random(720, 815, 1), Random(558, 589, 1)) ; Click on 'Okay' button to save changes
				ExitLoop
			Else
				If $i = 6 Then
					SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_ORANGE)
					If $close Then ClickP($aAway, 2, 0)
					Return ; Exit function
				EndIf
				If _Sleep(200) Then Return
			EndIf
		Next

		For $i = 0 To 6
			If _ColorCheck(_GetPixelColor(508, 428, True), Hex(0xFFFFFF, 6), 30) Then
				Click(Random(445, 583, 1), Random(402, 455, 1)) ; Click on 'Okay' button to Save changes... Last button
				ExitLoop
			Else
				If $i = 6 Then
					SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_ORANGE)
					If $close Then ClickP($aAway, 2, 0)
					Return ; Exit function
				EndIf
				If _Sleep(300) Then Return
			EndIf
		Next

		SetLog("Unexpected CC Troops/Spells removed")
		If _Sleep(200) Then Return
	EndIf
	If $close Then ClickP($aAway, 2, 0)

EndFunc   ;==>CheckCC
