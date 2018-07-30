; #FUNCTION# ====================================================================================================================
; Name ..........: SmartTrain
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: Demen
; Modified ......: Team AiO MOD++ (2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SmartTrain()

	Local $bRemoveUnpreciseTroops = False
	Local $aeTrainMethod[2] = [$g_eNoTrain, $g_eNoTrain], $aeBrewMethod[2] = [$g_eNoTrain, $g_eNoTrain]
	Local $bCheckWrongArmyCamp = False, $bCheckWrongSpells = False

	If Not $g_bQuickTrainEnable Then
		SetLog("Start Smart Custom Train")
	Else
		SetLog("Start Smart Quick Train")
	EndIf

	While 1
		$bRemoveUnpreciseTroops = CheckPreciseArmyCamp() ; checking troop precision. remove wrong troop if any.
		If @error Then ExitLoop

		If $bRemoveUnpreciseTroops Then SetLog("Continue Smart Train...!")

		; Troops tab
		If $g_iTotalCampSpace <> 0 Then
			$aeTrainMethod = CheckTrainingTab("Troops")
			If @error Then ExitLoop
			If IsArray($aeTrainMethod) Then
				If $aeTrainMethod[0] = $g_eRemained And Not $bRemoveUnpreciseTroops Then
					$bCheckWrongArmyCamp = True
				ElseIf Not $g_bQuickTrainEnable Then
					MakeCustomTrain("Troops", $aeTrainMethod)
					If @error Then ExitLoop
					$aeTrainMethod[0] = $g_eNoTrain
					$aeTrainMethod[1] = $g_eNoTrain
				EndIf
			EndIf
		EndIf

		; Spells tab
		If $g_iTotalSpellValue <> 0 Then
			$aeBrewMethod = CheckTrainingTab("Spells")
			If @error Then ExitLoop
			If IsArray($aeBrewMethod) Then
				If $aeBrewMethod[0] = $g_eRemained And Not $bRemoveUnpreciseTroops Then
					$bCheckWrongSpells = True
				ElseIf Not $g_bQuickTrainEnable Then
					MakeCustomTrain("Spells", $aeBrewMethod)
					If @error Then ExitLoop
					$aeBrewMethod[0] = $g_eNoTrain
					$aeBrewMethod[1] = $g_eNoTrain
				EndIf
			EndIf
		EndIf

		; Train
		If Not IsArray($aeTrainMethod) Or Not IsArray($aeBrewMethod) Then
			SetLog("Some kinds of error. Quit training", $COLOR_ERROR)
		Else
			If Not $g_bQuickTrainEnable Then ; Custom Train
				If _Sleep(500) Then Return
				If $bCheckWrongArmyCamp Or $bCheckWrongSpells Then
					Local $toRemove = CheckWrongArmyCamp()
					If @error Then ExitLoop
					RemoveWrongArmyCamp($toRemove)
					If @error Then ExitLoop
				EndIf

				If _Sleep(1000) Then Return
				Local $aeTB_Method = $aeTrainMethod
				_ArrayConcatenate($aeTB_Method, $aeBrewMethod)
				MakeCustomTrain("All", $aeTB_Method)
				If @error Then ExitLoop
			ElseIf $aeTrainMethod[1] <> $g_eNoTrain Or $aeBrewMethod[1] <> $g_eNoTrain Then ; Quick Train
				If Not OpenQuickTrainTab() Then $g_sSmartTrainError = SetError(1, 0, "Error OpenQuickTrainTab called from SmartTrain")
				If @error Then ExitLoop
				If _Sleep(500) Then Return
				Local $iMultiClick = 1
				If $g_bChkMultiClick Then $iMultiClick = $g_iMultiClick
				TrainArmyNumber($g_bQuickTrainArmy, $iMultiClick)
			Else
				SetLog("Full queue, skip Quick Train", $COLOR_INFO)
			EndIf
			SetLog("Smart Train accomplished")
		EndIf

		ExitLoop

	WEnd

	If @error Then SetLog("Quit training. " & $g_sSmartTrainError, $COLOR_ERROR)

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
	If $sText <> "Spells" Then
		If Not OpenTroopsTab() Then $g_sSmartTrainError = SetError(2, 0, "Error OpenTroopsTab called from MakeCustomTrain")
		If @error Then Return ; quit SmartTrain

		For $i = 0 To 1
			$bTrainQueue = Mod($i, 2) = 1
			$aArmy = DefineWhatToTrain("Troops", $aeMethod[$i], $bTrainQueue)
			TrainNow("Troops", $aArmy)
			If @error Then SetError(2)
		Next
	EndIf

	If $sText <> "Troops" Then
		If Not OpenSpellsTab() Then $g_sSmartTrainError = SetError(2, 0, "Error OpenSpellsTab called from MakeCustomTrain")
		If @error Then Return ; quit SmartTrain

		Local $x = 0
		If $sText = "All" Then $x = 2
		For $i = $x To $x + 1
			$bTrainQueue = Mod($i, 2) = 1
			$aArmy = DefineWhatToTrain("Spells", $aeMethod[$i], $bTrainQueue)
			TrainNow("Spells", $aArmy)
			If @error Then SetError(2)
		Next
	EndIf
	Return True

EndFunc   ;==>MakeCustomTrain

Func TrainNow($sText, $aArmy)
	If Not IsArray($aArmy) Then Return

	; Train it
	For $i = 0 To (UBound($aArmy) - 1)
		If $aArmy[$i][1] > 0 Then
			If Not DragIfNeeded($aArmy[$i][0]) Then $g_sSmartTrainError = SetError(3, 0, "Error DragIfNeeded called from TrainNow")
			If @error Then Return ; quit SmartTrain

			Local $sAction = "Training "
			If $sText = "Spells" Then
				$sAction = "Brewing "
			EndIf
			Local $iTS_Index = TroopIndexLookup($aArmy[$i][0])
			Local $sTS_Name = NameOfTroop($iTS_Index, $aArmy[$i][1] > 1 ? 1 : 0)


			If CheckValuesCost($aArmy[$i][0], $aArmy[$i][1]) Then
				SetLog(" - " & $sAction & $aArmy[$i][1] & "x " & $sTS_Name, $COLOR_SUCCESS)
				If Not TrainIt($iTS_Index, $aArmy[$i][1], $g_iTrainClickDelay) Then $g_sSmartTrainError = SetError(3, 0, "Error TrainIt called from TrainNow")
				If @error Then Return ; quit SmartTrain
			Else
				SetLog("No resources for " & $sAction & $aArmy[$i][1] & "x " & $sTS_Name, $COLOR_ACTION)
			EndIf
		EndIf
	Next
EndFunc   ;==>TrainNow

Func DefineWhatToTrain($sText = "Troops", $TrainMethod = $g_eFull, $bTrainQueue = False)

	Local $rWTT[1][2] = [["Arch", 0]] ; result of what to train
	If $sText = "Spells" Then $rWTT[0][0] = "LSpell"

	Local $eCount = $eTroopCount
	If $sText = "Spells" Then $eCount = $eSpellCount

	Local $aCurrent[$eCount], $iIndex, $aiArmyComp[$eCount], $asShortNames[$eCount]
	Local $aiCurrentQty[$eCount], $aiQueueQty[$eCount]

	Switch $TrainMethod
		Case $g_eNoTrain
			Return False ; No train

		Case $g_eFull
			If Not $bTrainQueue Then
				SetLog("Custom train full set of " & $sText, $COLOR_INFO)
			Else
				SetLog("Custom train full set of queue " & $sText, $COLOR_INFO)
			EndIf

			For $i = 0 To (UBound($aCurrent) - 1)
				If $sText = "Troops" Then
					$iIndex = $g_aiTrainOrder[$i]
					$aiArmyComp[$iIndex] = $g_aiArmyCompTroops[$iIndex]
					$asShortNames[$iIndex] = $g_asTroopShortNames[$iIndex]

				ElseIf $sText = "Spells" Then
					$iIndex = $g_aiBrewOrder[$i]
					$aiArmyComp[$iIndex] = $g_aiArmyCompSpells[$iIndex]
					$asShortNames[$iIndex] = $g_asSpellShortNames[$iIndex]
				EndIf

				If $aiArmyComp[$iIndex] > 0 Then
					$rWTT[UBound($rWTT) - 1][0] = $asShortNames[$iIndex]
					$rWTT[UBound($rWTT) - 1][1] = $aiArmyComp[$iIndex]
					Local $iTS_Index = TroopIndexLookup($rWTT[UBound($rWTT) - 1][0])
					Local $sTS_Name = NameOfTroop($iTS_Index, $rWTT[UBound($rWTT) - 1][1] > 1 ? 1 : 0)
					ReDim $rWTT[UBound($rWTT) + 1][2]
				EndIf
			Next

		Case $g_eRemained
			If Not $bTrainQueue Then
				SetLog("Custom train remaining " & $sText, $COLOR_INFO)
			Else
				SetLog("Custom train remaining queue " & $sText, $COLOR_INFO)
			EndIf

			For $i = 0 To (UBound($aCurrent) - 1)
				If $sText = "Troops" Then
					$iIndex = $g_aiTrainOrder[$i]
					$aiCurrentQty[$iIndex] = $g_aiCurrentTroops[$iIndex]
					$aiQueueQty[$iIndex] = $g_aiQueueTroops[$iIndex]
					$aiArmyComp[$iIndex] = $g_aiArmyCompTroops[$iIndex]
					$asShortNames[$iIndex] = $g_asTroopShortNames[$iIndex]

				ElseIf $sText = "Spells" Then
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
					ReDim $rWTT[UBound($rWTT) + 1][2]
				EndIf
			Next
	EndSwitch
	Return $rWTT

EndFunc   ;==>DefineWhatToTrain
