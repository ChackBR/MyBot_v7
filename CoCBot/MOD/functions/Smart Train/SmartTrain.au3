; #FUNCTION# ====================================================================================================================
; Name ..........: SmartTrain (#-13)
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: DEMEN
; Modified ......: Team AiO MOD++ (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SmartTrain()

	Local $bRemoveUnpreciseTroops = False
	Local $aeTrainMethod[2] = [$g_eNoTrain, $g_eNoTrain], $aeBrewMethod[2] = [$g_eNoTrain, $g_eNoTrain]
	Local $bCheckWrongTroops = False, $bCheckWrongSpells = False

	If Not $g_bQuickTrainEnable Then
		SetLog("Start Smart Custom Train")
	Else
		SetLog("Start Smart Quick Train")
	EndIf

	$bRemoveUnpreciseTroops = CheckPreciseTroop() ; checking troop precision. remove wrong troop if any.
	If $bRemoveUnpreciseTroops Then SetLog("Continue Smart Train...")

	If Not $g_bRunState Then Return

	; Troops tab
	$aeTrainMethod = CheckTrainingTab("troop")
	If IsArray($aeTrainMethod) Then
		If $aeTrainMethod[0] = $g_eRemained And Not $bRemoveUnpreciseTroops Then
			$bCheckWrongTroops = True
		ElseIf Not $g_bQuickTrainEnable Then
			MakeCustomTrain("troop", $aeTrainMethod)
			$aeTrainMethod[0] = $g_eNoTrain
			$aeTrainMethod[1] = $g_eNoTrain
		EndIf
	EndIf

	; Spells tab
	$aeBrewMethod = CheckTrainingTab("spell")
	If IsArray($aeBrewMethod) Then
		If $aeBrewMethod[0] = $g_eRemained And Not $bRemoveUnpreciseTroops Then
			$bCheckWrongSpells = True
		ElseIf Not $g_bQuickTrainEnable Then
			MakeCustomTrain("spell", $aeBrewMethod)
			$aeBrewMethod[0] = $g_eNoTrain
			$aeBrewMethod[1] = $g_eNoTrain
		EndIf
	EndIf

	; Train
	If Not IsArray($aeTrainMethod) Or Not IsArray($aeBrewMethod) Then
		SetLog("Some kinds of error. Quit training", $COLOR_ERROR)
	Else
		If Not $g_bQuickTrainEnable Then ; Custom Train
			If _Sleep(500) Then Return
			If $bCheckWrongTroops Or $bCheckWrongSpells Then RemoveWrongTroops($bCheckWrongTroops, $bCheckWrongSpells, False)
			If _Sleep(1000) Then Return
			Local $aeTB_Method = $aeTrainMethod
			_ArrayConcatenate($aeTB_Method, $aeBrewMethod)
			MakeCustomTrain("all", $aeTB_Method)
		ElseIf $aeTrainMethod[1] <> $g_eNoTrain Or $aeBrewMethod[1] <> $g_eNoTrain Then ; Quick Train
			OpenQuickTrainTab()
			If _Sleep(500) Then Return
			Local $iMultiClick = 1
			If $g_bChkMultiClick Then $iMultiClick = $g_iMultiClick
			TrainArmyNumber($g_bQuickTrainArmy, $iMultiClick)
		Else
			SetLog("  Full queue, skip Quick Train")
		EndIf
		SetLog("Smart Train accomplished")
	EndIf

	ClickP($aAway, 2, 0, "#0000") ;Click Away

	If $bRemoveUnpreciseTroops Then CheckIfArmyIsReady()

EndFunc   ;==>SmartTrain

Func MakeCustomTrain($sText, $aeMethod)

	If Not IsArray($aeMethod) Then Return False

	For $i = 0 To UBound($aeMethod) - 1
		If $aeMethod[$i] <> $g_eNoTrain Then ExitLoop
		If $i = 3 Then Return True; no train
	Next

	Local $aArmy, $bTrainQueue = False

	If $sText <> "spell" Then
		OpenTroopsTab()
		If Not ISArmyWindow(False, $TrainTroopsTAB) Then OpenTroopsTab()
		If Not $g_bRunState Then Return
		For $i = 0 To 1
			If $i = 1 Then $bTrainQueue = True
			$aArmy = DefineWhatToTrain("troop", $aeMethod[$i], $bTrainQueue)
			TrainNow("troop", $aArmy)
		Next
	EndIf

	If $sText <> "troop" Then
		OpenSpellsTab()
		If Not ISArmyWindow(False, $BrewSpellsTAB) Then OpenSpellsTab()
		If Not $g_bRunState Then Return
		Local $x = 0
		If $sText = "all" Then $x = 2
		For $i = $x To $x + 1
			If $i = 1 Or $i = 3 Then $bTrainQueue = True
			$aArmy = DefineWhatToTrain("spell", $aeMethod[$i], $bTrainQueue)
			TrainNow("spell", $aArmy)
		Next
	EndIf
	Return True

EndFunc   ;==>MakeCustomTrain

Func TrainNow($sText, $aArmy)
	If Not IsArray($aArmy) Then Return

	; Train it
	For $i = 0 To (UBound($aArmy) - 1)
		If Not $g_bRunState Then Return
		If $aArmy[$i][1] > 0 Then
			If Not DragIfNeeded($aArmy[$i][0]) Then Return False

			Local $sAction = "Training "
			If $sText = "spell" Then
				$sAction = "Brewing "
			EndIf
			Local $iTS_Index = TroopIndexLookup($aArmy[$i][0])
			Local $sTS_Name = NameOfTroop($iTS_Index, $aArmy[$i][1] > 1 ? 1 : 0)


			If CheckValuesCost($aArmy[$i][0], $aArmy[$i][1]) Then
				SetLog("    " & $sAction & $aArmy[$i][1] & "x " & $sTS_Name, $COLOR_GREEN)
				TrainIt($iTS_Index, $aArmy[$i][1], $g_iTrainClickDelay)
			Else
				SetLog("No resources for " & $sAction & $aArmy[$i][1] & "x " & $sTS_Name, $COLOR_ORANGE)
			EndIf
		EndIf
	Next
EndFunc   ;==>TrainNow

Func DefineWhatToTrain($sText = "troop", $TrainMethod = $g_eFull, $bTrainQueue = False)

	Local $rWTT[1][2] = [["Arch", 0]] ; result of what to train
	If $sText = "spell" Then $rWTT[0][0] = "LSpell"

	Local $eCount = $eTroopCount
	If $sText = "spell" Then $eCount = $eSpellCount

	Local $aCurrent[$eCount], $iIndex, $aiArmyComp[$eCount], $asShortNames[$eCount]
	Local $aiCurrentQty[$eCount], $aiQueueQty[$eCount]

	Switch $TrainMethod
		Case $g_eNoTrain
			Return False ; No train

		Case $g_eFull
			If Not $bTrainQueue Then
				SetLog("  » Custom train full set of " & $sText)
			Else
				SetLog("  » Custom train full set of queue " & $sText)
			EndIf

			For $i = 0 To (UBound($aCurrent) - 1)
				If Not $g_bRunState Then Return
				If $sText = "troop" Then
					$iIndex = $g_aiTrainOrder[$i]
					$aiArmyComp[$iIndex] = $g_aiArmyCompTroops[$iIndex]
					$asShortNames[$iIndex] = $g_asTroopShortNames[$iIndex]

				ElseIf $sText = "spell" Then
					$iIndex = $g_aiBrewOrder[$i]
					$aiArmyComp[$iIndex] = $g_aiArmyCompSpells[$iIndex]
					$asShortNames[$iIndex] = $g_asSpellShortNames[$iIndex]
				EndIf

				If $aiArmyComp[$iIndex] > 0 Then
					$rWTT[UBound($rWTT) - 1][0] = $asShortNames[$iIndex]
					$rWTT[UBound($rWTT) - 1][1] = $aiArmyComp[$iIndex]
					Local $iTS_Index = TroopIndexLookup($rWTT[UBound($rWTT) - 1][0])
					Local $sTS_Name = NameOfTroop($iTS_Index, $rWTT[UBound($rWTT) - 1][1] > 1 ? 1 : 0)
;~ 					SetLog("    " & UBound($rWTT) & ". " & $sTS_Name & " x " & $rWTT[UBound($rWTT) - 1][1])
					ReDim $rWTT[UBound($rWTT) + 1][2]
				EndIf
			Next

		Case $g_eRemained
			If Not $bTrainQueue Then
				SetLog("  » Custom train remaining " & $sText)
			Else
				SetLog("  » Custom train remaining queue " & $sText)
			EndIf

			For $i = 0 To (UBound($aCurrent) - 1)
				If Not $g_bRunState Then Return
				If $sText = "troop" Then
					$iIndex = $g_aiTrainOrder[$i]
					$aiCurrentQty[$iIndex] = $g_aiCurrentTroops[$iIndex]
					$aiQueueQty[$iIndex] = $g_aiQueueTroops[$iIndex]
					$aiArmyComp[$iIndex] = $g_aiArmyCompTroops[$iIndex]
					$asShortNames[$iIndex] = $g_asTroopShortNames[$iIndex]

				ElseIf $sText = "spell" Then
					$iIndex = $g_aiBrewOrder[$i]
					$aiCurrentQty[$iIndex] = $g_aiCurrentSpells[$iIndex]
					$aiQueueQty[$iIndex] = $g_aiQueueSpells[$iIndex]
					$aiArmyComp[$iIndex] = $g_aiArmyCompSpells[$iIndex]
					$asShortNames[$iIndex] = $g_asSpellShortNames[$iIndex]
				EndIf

				If Not $bTrainQueue = $g_eRemained Then
					$aCurrent[$iIndex] = $aiCurrentQty[$iIndex]
				Else
					$aCurrent[$iIndex] = $aiQueueQty[$iIndex]
				EndIf

				If $aiArmyComp[$iIndex] - $aCurrent[$iIndex] > 0 Then
					$rWTT[UBound($rWTT) - 1][0] = $asShortNames[$iIndex]
					$rWTT[UBound($rWTT) - 1][1] = Abs($aiArmyComp[$iIndex] - $aCurrent[$iIndex])
					Local $iTS_Index = TroopIndexLookup($rWTT[UBound($rWTT) - 1][0])
					Local $sTS_Name = NameOfTroop($iTS_Index, $rWTT[UBound($rWTT) - 1][1] > 1 ? 1 : 0)
;~ 					SetLog("    " & UBound($rWTT) & ". " & $sTS_Name & " x " & $rWTT[UBound($rWTT) - 1][1])
					ReDim $rWTT[UBound($rWTT) + 1][2]
				EndIf
			Next
	EndSwitch

	Return $rWTT

EndFunc   ;==>DefineWhatToTrain
