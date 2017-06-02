; #FUNCTION# ====================================================================================================================
; Name ..........: multiFinger
; Description ...: Contains functions for all the multi-finger deployment
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: LunaEclipse(January, 2016)
; Modified ......: Samkie (23 Feb 2017)
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
	;SelectDropTroop($kind) ; Select Troop
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
	If $g_iDebugSetlog = 1 Then SetLog("Launch " & $aAttackTypeString[$multiStyle] & " with CC " & $CC & ", K " & $King & ", Q " & $Queen & ", W " & $Warden , $COLOR_PURPLE)

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
		Local $barPosition = $aDeployButtonPositions[$kind]

		If IsString($kind) And ($kind = "CC" Or $kind = "HEROES") Then
			$RandomEdge = $g_aaiEdgeDropPoints[Round(Random(0, 3))]
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
	Return True
EndFunc   ;==>launchMultiFinger

Func cmbDBMultiFinger()
	If $g_aiAttackStdDropSides[$DB] = 4 Then
		GUICtrlSetState($lblDBMultiFinger, $GUI_SHOW)
		GUICtrlSetState($cmbDBMultiFinger, $GUI_SHOW)
		$iMultiFingerStyle = _GUICtrlComboBox_GetCurSel($cmbDBMultiFinger)
	Else
		GUICtrlSetState($lblDBMultiFinger, $GUI_HIDE)
		GUICtrlSetState($cmbDBMultiFinger, $GUI_HIDE)
	EndIf
EndFunc   ;==>cmbDBMultiFinger

Func cmbDeployAB()
	$g_aiAttackStdDropSides[$LB] = _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropOrderAB)
	If $g_aiAttackStdDropSides[$LB] = 4 Then
		GUICtrlSetState($g_hChkSmartAttackRedAreaAB, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkSmartAttackRedAreaAB, $GUI_DISABLE)
		chkSmartAttackRedAreaAB()
	Else
		GUICtrlSetState($g_hChkSmartAttackRedAreaAB, $GUI_ENABLE)
	EndIf
EndFunc

Func cmbDeployDB()
	$g_aiAttackStdDropSides[$DB] = _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropSidesDB)
	;SetLog("$g_aiAttackStdDropSides[$DB]: " & $g_aiAttackStdDropSides[$DB])
	If $g_aiAttackStdDropSides[$DB] = 4 Then
		GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_DISABLE)
		chkSmartAttackRedAreaDB()
	Else
		GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_ENABLE)
	EndIf
	cmbDBMultiFinger()
EndFunc
