#cs FUNCTION ====================================================================================================================
	; Name ..........: AreCollectorsOutside
	; Description ...: dark drills are ignored since they can be zapped
	; Syntax ........:
	; Parameters ....: $percent				minimum % of collectors outside of walls to all
	; Return values .: True					more collectors outside than specified
	;				 : False				less collectors outside than specified
	; Author ........: McSlither (Jan-2016)
	; Modified ......: TheRevenor (Jul 2016)
	; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
	;                  MyBot is distributed under the terms of the GNU GPL
	; Related .......:
	; Link ..........: https://github.com/MyBotRun/MyBot/wiki
	; Example .......: None
#ce ===============================================================================================================================

Func AreCollectorsOutside($percent)
	SetLog("Locating Mines & Collectors", $COLOR_BLUE)
	; reset variables
	Global $PixelMine[0]
	Global $PixelElixir[0]
	Global $PixelNearCollector[0]
	Global $colOutside = 0
	Global $hTimer = TimerInit()
	_WinAPI_DeleteObject($hBitmapFirst)
	$hBitmapFirst = _CaptureRegion2()

	$PixelMine = GetLocationMine()
	If (IsArray($PixelMine)) Then
		_ArrayAdd($PixelNearCollector, $PixelMine)
	EndIf
	$PixelElixir = GetLocationElixir()
	If (IsArray($PixelElixir)) Then
		_ArrayAdd($PixelNearCollector, $PixelElixir)
	EndIf
	Global $colNbr = UBound($PixelNearCollector)
	SetLog("Located collectors in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds:")
	SetLog("[" & UBound($PixelMine) & "] Gold Mines")
	SetLog("[" & UBound($PixelElixir) & "] Elixir Collectors")
	$iNbrOfDetectedMines[$DB] += UBound($PixelMine)
	$iNbrOfDetectedCollectors[$DB] += UBound($PixelElixir)
	UpdateStats()

	Global $minColOutside = Round($colNbr * $percent / 100)
	Global $radiusAdjustment = 1
	If $searchTH <> "-" Then
		$radiusAdjustment *= Number($searchTH) / 10
	EndIf

	For $i = 0 To $colNbr - 1
		Global $arrPixel = $PixelNearCollector[$i]
		If UBound($arrPixel) > 0 Then
			If isOutsideEllipse($arrPixel[0], $arrPixel[1], $CollectorsEllipseWidth * $radiusAdjustment, $CollectorsEllipseHeigth * $radiusAdjustment) Then
				If $debugsetlog = 1 Then SetLog("Collector (" & $arrPixel[0] & ", " & $arrPixel[1] & ") is outside", $COLOR_PURPLE)
				$colOutside += 1
			EndIf
		EndIf
		If $colOutside >= $minColOutside Then
			If $debugsetlog = 1 Then SetLog("More than " & $percent & "% of the collectors are outside", $COLOR_PURPLE)
			Return True
		EndIf
	Next
	If $debugsetlog = 1 Then SetLog($colOutside & " collectors found outside (out of " & $colNbr & ")", $COLOR_PURPLE)
	Return False
EndFunc   ;==>AreCollectorsOutside

#cs FUNCTION ====================================================================================================================
	; Name ..........: isOutsideEllipse
	; Description ...: This function can test if a given coordinate is inside (True) or outside (False) the village grass borders (a diamond shape).
	;                  It will also exclude some special area's like the CHAT tab, BUILDER button and GEM shop button.
	; Syntax ........: isInsideDiamondXY($Coordx, $Coordy), isInsideDiamond($aCoords)
	; Parameters ....: ($coordx, $coordY) as coordinates or ($aCoords), an array of (x,y) to test
	; Return values .: True or False
	; Author ........: McSlither (Jan-2016)
	; Modified ......: TheRevenor (Jul-2016)
	; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
	;                  MyBot is distributed under the terms of the GNU GPL
	; Related .......: isInsideDiamond($aCoords)
	; Link ..........: https://github.com/MyBotRun/MyBot/wiki
	; Example .......: None
#ce ===============================================================================================================================

Func isOutsideEllipse($coordX, $coordY, $ellipseWidth = 200, $ellipseHeigth = 150, $centerX = $centerX, $centerY = $centerY)

	Global $normalizedX = $coordX - $centerX
	Global $normalizedY = $coordY - $centerY
	Local $result = ($normalizedX * $normalizedX) / ($ellipseWidth * $ellipseWidth) + ($normalizedY * $normalizedY) / ($ellipseHeigth * $ellipseHeigth) > 1

	If $debugsetlog = 1 Then
		If $result Then
			Setlog("Coordinate Outside Ellipse (" & $ellipseWidth & ", " & $ellipseHeigth & ")", $COLOR_PURPLE)
		Else
			Setlog("Coordinate Inside Ellipse (" & $ellipseWidth & ", " & $ellipseHeigth & ")", $COLOR_PURPLE)
		EndIf
	EndIf

	Return $result

EndFunc   ;==>isOutsideEllipse

; Check Collectors Outside
Func chkDBMeetCollOutside()
	If GUICtrlRead($chkDBMeetCollOutside) = $GUI_CHECKED Then
		GUICtrlSetState($txtDBMinCollOutsidePercent, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtDBMinCollOutsidePercent, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDBMeetCollOutside
