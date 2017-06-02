; #FUNCTION# ====================================================================================================================
; Name ..........: fourFingerSpiralLeft
; Description ...: Contains function to set up vectors for four finger spiral left deployment
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: LunaEclipse(January, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Set up the vectors to deploy troops
Func fourFingerSpiralLeftVectors(ByRef $dropVectors, $listInfoDeploy)
	If Not IsArray($dropVectors) Or Not IsArray($listInfoDeploy) Then Return

	ReDim $dropVectors[UBound($listInfoDeploy)][4]

	Local $kind, $waveNumber, $waveCount, $position, $remainingWaves, $waveDropAmount, $dropAmount, $barPosition
	Local $startPoint[2] = [0, 0], $endPoint[2] = [0, 0]
	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $unitCount = unitCountArray()

	For $i = 0 To UBound($listInfoDeploy) - 1
		$kind = $listInfoDeploy[$i][0]
		$waveNumber = $listInfoDeploy[$i][2]
		$waveCount = $listInfoDeploy[$i][3]
		$position = $listInfoDeploy[$i][4]
		$remainingWaves = ($waveCount - $waveNumber) + 1
		$barPosition = $aDeployButtonPositions[$kind]

		If IsNumber($kind) And $barPosition <> -1 And $position = 0 Then
			$waveDropAmount = calculateDropAmount($unitCount[$kind], $remainingWaves, $position)
			$unitCount[$kind] -= $waveDropAmount

			; Top Left
			$dropAmount = Ceiling($waveDropAmount / 4)
			If $dropAmount > 0 Then
				$startPoint = convertToPoint($g_aaiTopLeftDropPoints[4][0], $g_aaiTopLeftDropPoints[4][1])
				$endPoint = convertToPoint($g_aaiTopLeftDropPoints[0][0], $g_aaiTopLeftDropPoints[0][1])
				addVector($dropVectors, $i, 0, $startPoint, $endPoint, $dropAmount)
				$waveDropAmount -= $dropAmount
			EndIf

			; Top Right
			$dropAmount = Ceiling($waveDropAmount / 3)
			If $dropAmount > 0 Then
				$startPoint = convertToPoint($g_aaiTopRightDropPoints[4][0], $g_aaiTopRightDropPoints[4][1])
				$endPoint = convertToPoint($g_aaiTopRightDropPoints[0][0], $g_aaiTopRightDropPoints[0][1])
				addVector($dropVectors, $i, 1, $startPoint, $endPoint, $dropAmount)
				$waveDropAmount -= $dropAmount
			EndIf

			; Bottom Right
			$dropAmount = Ceiling($waveDropAmount / 2)
			If $dropAmount > 0 Then
				$startPoint = convertToPoint($g_aaiBottomRightDropPoints[0][0], $g_aaiBottomRightDropPoints[0][1])
				$endPoint = convertToPoint($g_aaiBottomRightDropPoints[4][0], $g_aaiBottomRightDropPoints[4][1])
				addVector($dropVectors, $i, 2, $startPoint, $endPoint, $dropAmount)
				$waveDropAmount -= $dropAmount
			EndIf

			; Bottom Left
			$dropAmount = $waveDropAmount
			If $dropAmount > 0 Then
				$startPoint = convertToPoint($g_aaiBottomLeftDropPoints[0][0], $g_aaiBottomLeftDropPoints[0][1])
				$endPoint = convertToPoint($g_aaiBottomLeftDropPoints[4][0], $g_aaiBottomLeftDropPoints[4][1])
				addVector($dropVectors, $i, 3, $startPoint, $endPoint, $dropAmount)
				$waveDropAmount -= $dropAmount
			EndIf
		EndIf
	Next
EndFunc   ;==>fourFingerSpiralLeftVectors