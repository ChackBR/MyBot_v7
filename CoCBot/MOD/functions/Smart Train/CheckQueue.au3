; #FUNCTION# ====================================================================================================================
; Name ..........: CheckQueue
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: Demen
; Modified ......: Team AiO MOD++ (2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckQueue(ByRef $eTrainMethod_0, $sText = "Troops")
	Local $CheckTroop[4] = [825, 204, 0xCFCFC8, 15] ; the gray background
	Local $CheckPink[4] = [825, 186, 0xD7AFA9, 10] ; the pink background
	Local $directory = @ScriptDir & "\imgxml\Train\Queue_" & $sText
	Local $iTotalQueue = 0
	Local $bResult = False

	If $g_bQuickTrainEnable Then
		SetLog("Delete all queue for quick train", $COLOR_WARNING)
		DeleteQueue($sText)
		$bResult = True
	EndIf

	; Reset $g_aiQueueTroops Or $g_aiQueueSpells data
	If $sText = "Troops" Then
		For $i = 0 To $eTroopCount - 1
			$g_aiQueueTroops[$i] = 0
		Next
	ElseIf $sText = "Spells" Then
		For $i = 0 To $eSpellCount - 1
			$g_aiQueueSpells[$i] = 0
		Next
	EndIf

	SetLog("Checking queue " & $sText, $COLOR_INFO)

	; Delete slot 11 anyway
	If Not _ColorCheck(_GetPixelColor($CheckTroop[0] - 11 * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) Then ; Grey bkground
		SetLog("So many troops queued, removing queues at the last slot", $COLOR_ACTION)
		Local $x = 0
		While Not _ColorCheck(_GetPixelColor($CheckTroop[0] - 11 * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3])
			If _Sleep(20) Then Return
			If Not $g_bRunState Then Return
			PureClick($CheckTroop[0] - 11 * 70, 202, 2, 50)
			$x += 1
			If $x = 290 Then ExitLoop
		WEnd
	EndIf

	; Check queue troops/spells & quantity
	For $i = 0 To 10
		If _ColorCheck(_GetPixelColor($CheckPink[0] - $i * 70, $CheckPink[1], True), Hex($CheckPink[2], 6), $CheckPink[3]) Then ; Pink bkground found

			; name of first file found: troop short name e.g. "Barb"
			Local $sTroopNameFound = QuickMIS("N1", $directory, Int(795 - 70.5 * $i), 210, Int(815 - 70.5 * $i), 230, True, $g_bDebugSetlog)
			If $sTroopNameFound = "none" Then ContinueLoop

			Local $iQty = getQueueTroopsQuantity(Int(772 - (70.5 * $i)), 190)
			Local $eIndex = Eval("e" & $sTroopNameFound)

			If $sText = "Troops" Then
				$g_aiQueueTroops[$eIndex] += $iQty
			ElseIf $sText = "Spells" Then
				$g_aiQueueSpells[$eIndex - $eLSpell] += $iQty
			EndIf
		EndIf
	Next

	If $sText = "Troops" Then
		For $j = 0 To $eTroopCount - 1
			If $g_aiQueueTroops[$j] > 0 Then
				SetLog(" - " & NameOfTroop($j, $g_aiQueueTroops[$j] > 1 ? 1 : 0) & " x" & $g_aiQueueTroops[$j])
				$iTotalQueue += $g_aiQueueTroops[$j] * $g_aiTroopSpace[$j]
			EndIf
		Next
	ElseIf $sText = "Spells" Then
		For $j = 0 To $eSpellCount - 1
			If $g_aiQueueSpells[$j] > 0 Then
				SetLog(" - " & NameOfTroop($j + $eLSpell, $g_aiQueueSpells[$j] > 1 ? 1 : 0) & " x" & $g_aiQueueSpells[$j])
				$iTotalQueue += $g_aiQueueSpells[$j] * $g_aiSpellSpace[$j]
			EndIf
		Next
	EndIf

	; Check block troop
	Local $NewCampOCR = GetOCRCurrent(43, 160)
	If $NewCampOCR[0] < $NewCampOCR[1] + $iTotalQueue Then
		SetLog("A big guy blocks our camp", $COLOR_ACTION)
		ClearTrainingArmyCamp()
		If CheckBlockTroops($sText) Then
			$eTrainMethod_0 = $g_eRemained
		Else
			$eTrainMethod_0 = $g_eNoTrain
		EndIf
		$bResult = True

	Else ; check wrong queue
		If $sText = "Troops" Then
			For $i = 0 To ($eTroopCount - 1)
				If $g_aiQueueTroops[$i] - $g_aiArmyCompTroops[$i] > 0 Then $bResult = True
				If $bResult Then ExitLoop
			Next
		ElseIf $sText = "Spells" Then
			For $i = 0 To ($eSpellCount - 1)
				If $g_aiQueueSpells[$i] - $g_aiArmyCompSpells[$i] > 0 Then $bResult = True
				If $bResult Then ExitLoop
			Next
		EndIf

		If $bResult Then
			SetLog("Some wrong " & $sText & " in queue", $COLOR_WARNING)
			DeleteQueue($sText)
		EndIf

	EndIf

	Return $bResult

EndFunc   ;==>CheckQueue

Func DeleteQueue($sText = "Troops")
	Local $CheckTroop[4] = [825, 204, 0xCFCFC8, 15] ; the gray background
	Local $CheckPink[4] = [825, 186, 0xD7AFA9, 10] ; the pink background
	SetLog("Removing all queue " & $sText, $COLOR_SUCCESS)
	For $i = 0 To 11
		If _ColorCheck(_GetPixelColor($CheckPink[0] - $i * 70, $CheckPink[1], True), Hex($CheckPink[2], 6), $CheckPink[3]) Then ; Pink background found
			If $g_bDebugSetlog Then SetDebugLog("Slot: " & $i & " Found queue", $COLOR_DEBUG)
			Local $x = 0
			While Not _ColorCheck(_GetPixelColor($CheckTroop[0] - $i * 70, $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3])
				If _Sleep(20) Then Return
				If Not $g_bRunState Then Return
				PureClick($CheckTroop[0] - $i * 70, 202, 2, 50)
				$x += 1
				If $sText = "Troops" Then
					If $x = 290 Then ExitLoop
				ElseIf $sText = "Spells" Then
					If $x = 22 Then ExitLoop
				EndIf
			WEnd
			If $g_bDebugSetlog Then SetDebugLog("Delete all queue, let's exit clicking", $COLOR_DEBUG)
			ExitLoop
		EndIf
	Next
	If _Sleep(250) Then Return
EndFunc   ;==>DeleteQueue
