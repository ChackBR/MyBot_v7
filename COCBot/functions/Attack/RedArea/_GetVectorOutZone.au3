
; #FUNCTION# ====================================================================================================================
; Name ..........: _GetVectorOutZone
; Description ...:
; Syntax ........: _GetVectorOutZone($eVectorType)
; Parameters ....: $eVectorType         - an unknown value.
; Return values .: None
; Author ........: didipe
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: NoNo
; ===============================================================================================================================
Func _GetVectorOutZone($eVectorType)
	debugRedArea("_GetVectorOutZone IN")
	Local $vectorOutZone[0]

	If ($eVectorType = $eVectorLeftTop) Then
		$xMin = $ExternalArea[2][0] ; 430
		$yMin = $ExternalArea[2][1] ; 29
		$xMax = $ExternalArea[0][0] ; 33
		$yMax = $ExternalArea[0][1] ; 325
		$xStep = -4
		$yStep = 3
	ElseIf ($eVectorType = $eVectorRightTop) Then
		$xMin = $ExternalArea[2][0] ; 430
		$yMin = $ExternalArea[2][1] ; 29
		$xMax = $ExternalArea[1][0] ; 834
		$yMax = $ExternalArea[0][1] ; 325
		$xStep = 4
		$yStep = 3
	ElseIf ($eVectorType = $eVectorLeftBottom) Then
		$xMin = $ExternalArea[0][0] ; 39
		$yMin = $ExternalArea[0][1] ; 338
		$xMax = $ExternalArea[2][0] ; 430
		$yMax = $ExternalArea[3][1] ; 630
		$xStep = 4
		$yStep = 3
	Else ; bottom right
		$xMin = $ExternalArea[1][0] ; 834
		$yMin = $ExternalArea[0][1] ; 325
		$xMax = $ExternalArea[2][0] ; 430
		$yMax = $ExternalArea[3][1] ; 630
		$xStep = -4
		$yStep = 3
	EndIf

	CheckAttackLocation($xMin, $yMin)
	CheckAttackLocation($xMax, $yMax)

	Local $pixel[2]
	Local $x = $xMin
	For $y = $yMin To $yMax Step $yStep
		$x += $xStep
		$pixel[0] = $x
		$pixel[1] = $y
		ReDim $vectorOutZone[UBound($vectorOutZone) + 1]
		$vectorOutZone[UBound($vectorOutZone) - 1] = $pixel
	Next

	Return $vectorOutZone
EndFunc   ;==>_GetVectorOutZone
