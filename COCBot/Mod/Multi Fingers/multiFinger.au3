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
	; If _SleepAttack($iDelayDropOnEdge1) Then Return
	SelectDropTroop($kind) ; Select Troop
	; If _SleepAttack($iDelayDropOnEdge2) Then Return

	Switch $multiStyle
		Case $mfFFStandard, $mfFFSpiralLeft, $mfFFSpiralRight
			fourFingerDropOnEdge($dropVectors, $waveNumber, $kind, $dropAmount, $position)
		Case $mf8FBlossom, $mf8FImplosion, $mf8FPinWheelLeft, $mf8FPinWheelRight
			eightFingerDropOnEdge($dropVectors, $waveNumber, $kind, $dropAmount, $position)
	EndSwitch
	ReleaseClicks()
EndFunc   ;==>multiFingerDropOnEdge

Func launchMultiFinger($listInfoDeploy, $CC, $King, $Queen, $Warden, $overrideSmartDeploy = -1)
	Local $kind, $nbSides, $waveNumber, $waveCount, $position, $remainingWaves, $dropAmount
	Local $RandomEdge, $RandomXY
	Local $dropVectors[0][0]

	Local $multiStyle = ($iMultiFingerStyle = $mfRandom) ? Random($mfFFStandard, $mf8FPinWheelRight, 1) : (($iMultiFingerStyle = -1) ? Random($mfFFStandard, $mf8FPinWheelRight, 1) : $iMultiFingerStyle)

	SetLog("Attacking " & $aAttackTypeString[$multiStyle] & " fight style.", $COLOR_BLUE)
	If $debugSetLog = 1 Then SetLog("Launch " & $aAttackTypeString[$multiStyle] & " with CC " & $CC & ", K " & $King & ", Q " & $Queen & ", W " & $Warden , $COLOR_PURPLE)

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
			$RandomEdge = $Edges[Round(Random(0, 3))]
			$RandomXY = Round(Random(0, 4))

			If $kind = "CC" Then
				dropCC($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $CC)
			ElseIf $kind = "HEROES" Then
				dropHeroes($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $King, $Queen, $Warden)
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

	SetLog("Finished Attacking, waiting for the battle to end")
	$usingMultiFinger = False
	Return True
EndFunc   ;==>launchMultiFinger

Func dropRemainingTroops($nbSides, $overrideSmartDeploy = -1) ; Uses any left over troops
	SetLog("Dropping left over troops", $COLOR_BLUE)

	For $x = 0 To 1
		PrepareAttack($iMatchMode, True) ; Check remaining quantities
		For $i = $eBarb To $eLava ; Loop through all troop types
			LaunchTroops($i, $nbSides, 0, 1, 0, $overrideSmartDeploy)
			CheckHeroesHealth()

			If _SleepAttack($iDelayalgorithm_AllTroops5) Then Return
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

	$nameFunc = "[modDropTroop]"
	debugRedArea($nameFunc & " IN ")
	debugRedArea("troop : [" & $troop & "] / nbSides : [" & $nbSides & "] / number : [" & $number & "] / slotsPerEdge [" & $slotsPerEdge & "]")

	If ($iChkRedArea[$iMatchMode]) And $overrideSmartDeploy = -1 Then
		If $slotsPerEdge = 0 Or $number < $slotsPerEdge Then $slotsPerEdge = $number
		If _SleepAttack($iDelayDropTroop1) Then Return
		If _SleepAttack($iDelayDropTroop2) Then Return

		If $nbSides < 1 Then Return
		Local $nbTroopsLeft = $number
		If ($iChkSmartAttack[$iMatchMode][0] = 0 And $iChkSmartAttack[$iMatchMode][1] = 0 And $iChkSmartAttack[$iMatchMode][2] = 0) Then
			If $nbSides = 4 Then
				Local $edgesPixelToDrop = GetPixelDropTroop($troop, $number, $slotsPerEdge)

				For $i = 0 To $nbSides - 3
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $listEdgesPixelToDrop[2] = [$edgesPixelToDrop[$i], $edgesPixelToDrop[$i + 2]]
					DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
					$nbTroopsLeft -= $nbTroopsPerEdge * 2
				Next
				Return
			EndIf

			For $i = 0 To $nbSides - 1
				If $nbSides = 1 Or ($nbSides = 3 And $i = 2) Then
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $edgesPixelToDrop = GetPixelDropTroop($troop, $nbTroopsPerEdge, $slotsPerEdge)
					Local $listEdgesPixelToDrop[1] = [$edgesPixelToDrop[$i]]
					DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
					$nbTroopsLeft -= $nbTroopsPerEdge
				ElseIf ($nbSides = 2 And $i = 0) Or ($nbSides = 3 And $i <> 1) Then
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $edgesPixelToDrop = GetPixelDropTroop($troop, $nbTroopsPerEdge, $slotsPerEdge)
					Local $listEdgesPixelToDrop[2] = [$edgesPixelToDrop[$i + 3], $edgesPixelToDrop[$i + 1]]

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
				Local $nbTroopsPerEdge = Round($number / UBound($PixelNearCollector))
				Local $maxElementNearCollector = UBound($PixelNearCollector) - 1
				Local $startIndex = 0
			EndIf
			If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
			For $i = $startIndex To $maxElementNearCollector
				$pixel = $PixelNearCollector[$i]
				ReDim $listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) + 1]
				If ($troop = $eArch Or $troop = $eWiza Or $troop = $eMini or $troop = $eBarb) Then
					$listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) - 1] = _FindPixelCloser($PixelRedAreaFurther, $pixel, 5)
				Else
					$listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) - 1] = _FindPixelCloser($PixelRedArea, $pixel, 5)
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
	If $iChkDeploySettings[$DB] = 5 Then
		GUICtrlSetState($lblDBMultiFinger, $GUI_SHOW)
		GUICtrlSetState($cmbDBMultiFinger, $GUI_SHOW)
		$iMultiFingerStyle = _GUICtrlComboBox_GetCurSel($cmbDBMultiFinger)
	Else
		GUICtrlSetState($lblDBMultiFinger, $GUI_HIDE)
		GUICtrlSetState($cmbDBMultiFinger, $GUI_HIDE)
	EndIf
EndFunc   ;==>cmbDBMultiFinger

Func cmbDeployAB()
	$iChkDeploySettings[$LB] = _GUICtrlComboBox_GetCurSel($cmbDeployAB)
	If $iChkDeploySettings[$LB] = 4 Then
		GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_UNCHECKED)
		GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_DISABLE)
		chkSmartAttackRedAreaAB()
	Else
		GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_ENABLE)
	EndIf
EndFunc	;==>cmbDeployAB

Func cmbDeployDB()
	$iChkDeploySettings[$DB] = _GUICtrlComboBox_GetCurSel($cmbDeployDB)
	If $iChkDeploySettings[$DB] = 4 Or $iChkDeploySettings[$DB] = 5 Then
		GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_UNCHECKED)
		GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_DISABLE)
		chkSmartAttackRedAreaDB()
	Else
		GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_ENABLE)
	EndIf
	cmbDBMultiFinger()
EndFunc	;==>cmbDeployDB
