; #FUNCTION# ====================================================================================================================
; Name ..........: multiFinger
; Description ...: Contains functions for all the multi-finger deployment
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: LunaEclipse(January, 2016)
; Modified ......: Samkie (9 Jan 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Local $aAttackTypeString[$mf8FPinWheelRight + 1] = ["Random", _
													"Four Finger Standard", _
													"Four Finger Spiral Left", _
													"Four Finger Spiral Right", _
													"Eight Finger Blossom", _
													"Eight Finger Implosion", _
													"Eight Finger Pin Wheel Spiral Left", _
													"Eight Finger Pin Wheel Spiral Right"]

Func multiFingerSetupVecors($multiStyle, ByRef $dropVectors, $listInfoDeploy)
	Switch $multiStyle
		Case $mfFFStandard
			fourFingerStandardVectors($dropVectors, $listInfoDeploy)
		Case $mfFFSpiralLeft
			fourFingerSpiralLeftVectors($dropVectors, $listInfoDeploy)
		Case $mfFFSpiralRight
			fourFingerSpiralRightVectors($dropVectors, $listInfoDeploy)
		Case $mf8FBlossom
			eightFingerBlossomVectors($dropVectors, $listInfoDeploy)
		Case $mf8FImplosion
			eightFingerImplosionVectors($dropVectors, $listInfoDeploy)
		Case $mf8FPinWheelLeft
			eightFingerPinWheelLeftVectors($dropVectors, $listInfoDeploy)
		Case $mf8FPinWheelRight
			eightFingerPinWheelRightVectors($dropVectors, $listInfoDeploy)
	EndSwitch
EndFunc

Func multiFingerDropOnEdge($multiStyle, $dropVectors, $waveNumber, $kind, $dropAmount, $position = 0)
	If $dropAmount = 0 Or isProblemAffect(True) Then Return
	If $position = 0 Or $dropAmount < $position Then $position = $dropAmount

	KeepClicks()
	 If _SleepAttack($DELAYDROPONEDGE1) Then Return
	SelectDropTroop($kind) ; Select Troop
	 If _SleepAttack($DELAYDROPONEDGE2) Then Return

	Switch $multiStyle
		Case $mfFFStandard, $mfFFSpiralLeft, $mfFFSpiralRight
			fourFingerDropOnEdge($dropVectors, $waveNumber, $kind, $dropAmount, $position)
		Case $mf8FBlossom, $mf8FImplosion, $mf8FPinWheelLeft, $mf8FPinWheelRight
			eightFingerDropOnEdge($dropVectors, $waveNumber, $kind, $dropAmount, $position)
	EndSwitch
	ReleaseClicks()
EndFunc   ;==>multiFingerDropOnEdge

Func launchMultiFinger($listInfoDeploy, $g_iClanCastleSlot, $g_iKingSlot, $g_iQueenSlot, $g_iWardenSlot, $overrideSmartDeploy = -1)
	Local $kind, $nbSides, $waveNumber, $waveCount, $position, $remainingWaves, $dropAmount
	Local $RandomEdge, $RandomXY
	Local $dropVectors[0][0]
	Local $barPosition

	Local $multiStyle = ($iMultiFingerStyle = $mfRandom) ? Random($mfFFStandard, $mf8FPinWheelRight, 1) : $iMultiFingerStyle

	SetLog("Attacking " & $aAttackTypeString[$multiStyle] & " fight style.", $COLOR_BLUE)
	If $g_iDebugSetlog = 1 Then SetLog("Launch " & $aAttackTypeString[$multiStyle] & " with CC " & $g_iClanCastleSlot & ", K " & $g_iKingSlot & ", Q " & $g_iQueenSlot & ", W " & $g_iWardenSlot, $COLOR_PURPLE)

	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $unitCount = unitCountArray()

	; Setup the attack vectors for the troops
	SetLog("Calculating attack vectors for all troop deployments, please be patient...", $COLOR_PURPLE)
	multiFingerSetupVecors($multiStyle, $dropVectors, $listInfoDeploy)

	For $i = 0 To UBound($listInfoDeploy) - 1
		$kind = $listInfoDeploy[$i][0]
		$nbSides = $listInfoDeploy[$i][1]
		$waveNumber = $listInfoDeploy[$i][2]
		$waveCount = $listInfoDeploy[$i][3]
		$position = $listInfoDeploy[$i][4]
		$remainingWaves = ($waveCount - $waveNumber) + 1
		$barPosition = $aDeployButtonPositions[$kind]

		If IsString($kind) And ($kind = "CC" Or $kind = "HEROES") Then
			$RandomEdge = $g_aaiEdgeDropPoints[Round(Random(0, 3))]
			$RandomXY = Round(Random(0, 4))

			If $kind = "CC" Then
				dropCC($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $g_iClanCastleSlot)
			ElseIf $kind = "HEROES" Then
				dropHeroes($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $g_iKingSlot, $g_iQueenSlot, $g_iWardenSlot)
			EndIf
		ElseIf IsNumber($kind) And $barPosition <> -1 Then
			$dropAmount = calculateDropAmount($unitCount[$kind], $remainingWaves, $position)
			$unitCount[$kind] -= $dropAmount

			If $dropAmount > 0 Then

				multiFingerDropOnEdge($multiStyle, $dropVectors, $i, $barPosition, $dropAmount, $position)
				If _SleepAttack(SetSleep(1)) Then Return
			EndIf
		EndIf
	Next
	If _Sleep($DELAYALGORITHM_ALLTROOPS4) Then Return
	SetLog("Dropping left over troops", $COLOR_INFO)
	For $x = 0 To 1
		If PrepareAttack($g_iMatchMode, True) = 0 Then
			If $g_iDebugSetlog = 1 Then Setlog("No Wast time... exit, no troops usable left", $COLOR_DEBUG)
			ExitLoop ;Check remaining quantities
		EndIf
		For $i = $eBarb To $eBowl ; lauch all remaining troops
			;If $i = $eBarb Or $i = $eArch Then
			LauchTroop($i, $nbSides, 0, 1, 0)
		CheckHeroesHealth()
			;Else
			;	 LauchTroop($i, $nbSides, 0, 1, 2)
			;EndIf
			If _Sleep($DELAYALGORITHM_ALLTROOPS5) Then Return
		Next
	Next
	CheckHeroesHealth()
	SetLog("Finished Attacking, waiting for the battle to end")
	Local $usingMultiFinger = False
	Return True
EndFunc   ;==>launchMultiFinger

Func dropRemainingTroops($nbSides, $overrideSmartDeploy = -1) ; Uses any left over troops
	SetLog("Dropping left over troops", $COLOR_BLUE)

	For $x = 0 To 1
		PrepareAttack($g_iMatchMode, True) ; Check remaining quantities
		For $i = $eBarb To $eLava ; Loop through all troop types
			LaunchTroops($i, $nbSides, 0, 1, 0, $overrideSmartDeploy)
			CheckHeroesHealth()

			If _SleepAttack($DELAYALGORITHM_ALLTROOPS5) Then Return
		Next
	Next
EndFunc   ;==>dropRemainingTroops

Func LaunchTroops($kind, $nbSides, $waveNb, $maxWaveNb, $slotsPerEdge = 0, $overrideSmartDeploy = -1, $overrideNumberTroops = -1)
	Local $troopNb
	Local $troop = unitLocation($kind)

	If $overrideNumberTroops = -1 Then
		$troopNb = Ceiling(unitCount($kind) / $maxWaveNb)
	Else
		$troopNb = $overrideNumberTroops
	EndIf

	If ($troop = -1) Or ($troopNb = 0) Then ; Troop not trained or 0 units to deploy
		Return False; nothing to do => skip this wave
	EndIf

	;SetLog("Dropping " & getWaveName($waveNb, $maxWaveNb) & " wave of " & $troopNb & " " & $name, $COLOR_GREEN)
	modDropTroop($troop, $nbSides, $troopNb, $slotsPerEdge, -1, $overrideSmartDeploy)

	Return True
EndFunc   ;==>LaunchTroops

Func modDropTroop($troop, $nbSides, $number, $slotsPerEdge = 0, $indexToAttack = -1, $overrideSmartDeploy = -1)
	If isProblemAffect(True) Then Return

	Local $nameFunc = "[modDropTroop]"
	debugRedArea($nameFunc & " IN ")
	debugRedArea("troop : [" & $troop & "] / nbSides : [" & $nbSides & "] / number : [" & $number & "] / slotsPerEdge [" & $slotsPerEdge & "]")

	If ($g_abAttackStdSmartAttack[$g_iMatchMode]) And $overrideSmartDeploy = -1 Then
		If $slotsPerEdge = 0 Or $number < $slotsPerEdge Then $slotsPerEdge = $number
		If _SleepAttack($DelayDropTroop1) Then Return
		If _SleepAttack($DelayDropTroop2) Then Return

		If $nbSides < 1 Then Return
		Local $nbTroopsLeft = $number
		If ($g_abAttackStdSmartNearCollectors[$g_iMatchMode][0] = 0 And $g_abAttackStdSmartNearCollectors[$g_iMatchMode][1] = 0 And $g_abAttackStdSmartNearCollectors[$g_iMatchMode][2] = 0) Then
			If $nbSides = 4 Then
				Local $g_aaiEdgeDropPointsPixelToDrop = GetPixelDropTroop($troop, $number, $slotsPerEdge)

				For $i = 0 To $nbSides - 3
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $listEdgesPixelToDrop[2] = [$g_aaiEdgeDropPointsPixelToDrop[$i], $g_aaiEdgeDropPointsPixelToDrop[$i + 2]]
					DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
					$nbTroopsLeft -= $nbTroopsPerEdge * 2
				Next
				Return
			EndIf

			For $i = 0 To $nbSides - 1
				If $nbSides = 1 Or ($nbSides = 3 And $i = 2) Then
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $g_aaiEdgeDropPointsPixelToDrop = GetPixelDropTroop($troop, $nbTroopsPerEdge, $slotsPerEdge)
					Local $listEdgesPixelToDrop[1] = [$g_aaiEdgeDropPointsPixelToDrop[$i]]
					DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
					$nbTroopsLeft -= $nbTroopsPerEdge
				ElseIf ($nbSides = 2 And $i = 0) Or ($nbSides = 3 And $i <> 1) Then
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $g_aaiEdgeDropPointsPixelToDrop = GetPixelDropTroop($troop, $nbTroopsPerEdge, $slotsPerEdge)
					Local $listEdgesPixelToDrop[2] = [$g_aaiEdgeDropPointsPixelToDrop[$i + 3], $g_aaiEdgeDropPointsPixelToDrop[$i + 1]]

					DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
					$nbTroopsLeft -= $nbTroopsPerEdge * 2
				EndIf
			Next
		Else
			Local $listEdgesPixelToDrop[0]
			If ($indexToAttack <> -1) Then
				Local $nbTroopsPerEdge = $number
				Local $maxElementNearCollector = $indexToAttack
				Local $startIndex = $indexToAttack
			Else
				Local $nbTroopsPerEdge = Round($number / UBound($g_aiPixelNearCollector))
				Local $maxElementNearCollector = UBound($g_aiPixelNearCollector) - 1
				Local $startIndex = 0
			EndIf
			If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
			For $i = $startIndex To $maxElementNearCollector
				Local $pixel = $g_aiPixelNearCollector[$i]
				ReDim $listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) + 1]
				If ($troop = $eArch Or $troop = $eWiza Or $troop = $eMini or $troop = $eBarb) Then
					$listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) - 1] = _FindPixelCloser($g_aiPixelRedAreaFurther, $pixel, 5)
				Else
					$listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) - 1] = _FindPixelCloser($g_aiPixelRedArea, $pixel, 5)
				EndIf
			Next
			DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
		EndIf
	Else
		DropOnEdges($troop, $nbSides, $number, $slotsPerEdge)
	EndIf

	debugRedArea($nameFunc & " OUT ")
EndFunc   ;==>modDropTroop


Func cmbDBMultiFinger()
	If _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropSidesDB) = 5 Then

		 For $i = $g_hChkRandomSpeedAtkDB To $g_hPicAttackNearDarkElixirDrillDB
			GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkRandomSpeedAtkDB, $GUI_UNCHECKED)
			GUICtrlSetState($i, $GUI_DISABLE + $GUI_HIDE)
		 Next
	     For $i = $LblDBMultiFinger To $TxtWaveFactor
			GUICtrlSetState($i, $GUI_SHOW)
	     Next

	Else

		 For $i = $g_hChkRandomSpeedAtkDB To $g_hChkSmartAttackRedAreaDB
			GUICtrlSetState($i, $GUI_ENABLE + $GUI_SHOW)
		 Next

	     For $i = $LblDBMultiFinger To $TxtWaveFactor
			GUICtrlSetState($i, $GUI_HIDE)
	     Next

	EndIf
EndFunc   ;==>cmbDBMultiFinger

Func Bridge()
    cmbDBMultiFinger()
    cmbStandardDropSidesDB()
EndFunc ;==>Bridge