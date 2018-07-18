; FUNCTION ====================================================================================================================
; Name ..........: AreCollectorsOutside
; Description ...: dark drills are ignored since they can be zapped
; Syntax ........:
; Parameters ....: $percent				minimum % of collectors outside of walls to all
; Return values .: True					more collectors outside than specified
;				 : False				less collectors outside than specified
; Author ........: McSlither (Jan-2016)
; Modified ......: TheRevenor (Jul 2016), Samkie (13 Jan 2017), Team AiO MOD++ (2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: None
; ===============================================================================================================================

Func AreCollectorsOutside($percent)
	If $g_bDBCollectorsNearRedline = 1 Then Return AreCollectorsNearRedline($percent)

	SetLog("Locating Mines & Collectors", $COLOR_INFO)
	; reset variables
	Global $g_aiPixelMine[0]
	Global $g_aiPixelElixir[0]
	Global $g_aiPixelNearCollector[0]
	Global $colOutside = 0
	Global $hTimer = TimerInit()
	_WinAPI_DeleteObject($hBitmapFirst)
	$hBitmapFirst = _CaptureRegion2()

	SuspendAndroid()
	$g_aiPixelMine = GetLocationMine()
	If (IsArray($g_aiPixelMine)) Then
		_ArrayAdd($g_aiPixelNearCollector, $g_aiPixelMine, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
	EndIf
	$g_aiPixelElixir = GetLocationElixir()
	If (IsArray($g_aiPixelElixir)) Then
		_ArrayAdd($g_aiPixelNearCollector, $g_aiPixelElixir, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
	EndIf
	ResumeAndroid()

	$g_bScanMineAndElixir = True

	Global $colNbr = UBound($g_aiPixelNearCollector)
	SetLog("Located collectors in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds")
	SetLog("[" & UBound($g_aiPixelMine) & "] Gold Mines")
	SetLog("[" & UBound($g_aiPixelElixir) & "] Elixir Collectors")

	Global $minColOutside = Round($colNbr * $percent / 100)
	Global $radiusAdjustment = 1

	If $g_iSearchTH = "-" Or $g_iSearchTH = "" Then FindTownhall(True)
	If $g_iSearchTH <> "-" Then
		$radiusAdjustment *= Number($g_iSearchTH) / 10
	Else
		If $g_iTownHallLevel > 0 Then
			$radiusAdjustment *= Number($g_iTownHallLevel) / 10
		EndIf
	EndIf
	If $g_bDebugSetlog Then SetLog("$g_iSearchTH: " & $g_iSearchTH)

	For $i = 0 To $colNbr - 1
		Global $arrPixel = $g_aiPixelNearCollector[$i]
		If UBound($arrPixel) > 0 Then
			If isOutsideEllipse($arrPixel[0], $arrPixel[1], $CollectorsEllipseWidth * $radiusAdjustment, $CollectorsEllipseHeigth * $radiusAdjustment) Then
				If $g_bDebugSetlog Then SetDebugLog("Collector (" & $arrPixel[0] & ", " & $arrPixel[1] & ") is outside", $COLOR_DEBUG)
				$colOutside += 1
			EndIf
		EndIf
		If $colOutside >= $minColOutside Then
			If $g_bDebugSetlog Then SetDebugLog("More than " & $percent & "% of the collectors are outside", $COLOR_DEBUG)
			Return True
		EndIf
	Next
	If $g_bDebugSetlog Then SetDebugLog($colOutside & " collectors found outside (out of " & $colNbr & ")", $COLOR_DEBUG)
	Return False
EndFunc   ;==>AreCollectorsOutside

; FUNCTION ====================================================================================================================
; Name ..........: AreCollectorsNearRedline
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .: True					more collectors near redline
;				 : False				less collectors outside than specified
; Author ........: Samkie (7 FEB 2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: None
; ===============================================================================================================================

Func AreCollectorsNearRedline($percent)
	SetLog("Locating Mines & Collectors", $COLOR_INFO)
	; reset variables
	Global $g_aiPixelMine[0]
	Global $g_aiPixelElixir[0]
	Global $g_aiPixelNearCollector[0]

	Global $hTimer = TimerInit()
	Global $iTotalCollectorNearRedline = 0
	_WinAPI_DeleteObject($hBitmapFirst)
	$hBitmapFirst = _CaptureRegion2()
	_GetRedArea()

	SuspendAndroid()
	$g_aiPixelMine = GetLocationMine()
	If (IsArray($g_aiPixelMine)) Then
		_ArrayAdd($g_aiPixelNearCollector, $g_aiPixelMine, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
	EndIf
	$g_aiPixelElixir = GetLocationElixir()
	If (IsArray($g_aiPixelElixir)) Then
		_ArrayAdd($g_aiPixelNearCollector, $g_aiPixelElixir, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
	EndIf
	ResumeAndroid()

	$g_bScanMineAndElixir = True

	Global $colNbr = UBound($g_aiPixelNearCollector)

	SetLog("Located collectors in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds")
	SetLog("[" & UBound($g_aiPixelMine) & "] Gold Mines")
	SetLog("[" & UBound($g_aiPixelElixir) & "] Elixir Collectors")

 	Local $diamondx = $g_iMilkFarmOffsetX + $g_iMilkFarmOffsetXStep * $g_iCmbRedlineTiles
 	Local $diamondy = $g_iMilkFarmOffsetY + $g_iMilkFarmOffsetYStep * $g_iCmbRedlineTiles
	Local $arrCollectorsFlag[0]

	If $colNbr > 0 Then
		ReDim $arrCollectorsFlag[$colNbr]
		Local $iMaxRedArea = UBound($g_aiPixelRedArea) - 1
		For $i = 0 To $iMaxRedArea
			Local $pixelCoord = $g_aiPixelRedArea[$i]
			For $j = 0 To $colNbr - 1
				If $arrCollectorsFlag[$j] <> True Then
					Local $pixelCoord2 = $g_aiPixelNearCollector[$j]
					If Abs(($pixelCoord[0] - $pixelCoord2[0]) / $diamondx) + Abs(($pixelCoord[1] - $pixelCoord2[1]) / $diamondy) <= 1 Then
						$arrCollectorsFlag[$j] = True
						$iTotalCollectorNearRedline += 1
					EndIf
				EndIf
			Next
			If $iTotalCollectorNearRedline >= $colNbr Then ExitLoop
		Next
		SetLog("Total collectors Found: " & $colNbr)
		SetLog("Total collectors near red line: " & $iTotalCollectorNearRedline)
		If $iTotalCollectorNearRedline >= Round($colNbr * $percent / 100) Then
			Return True
		EndIf
	EndIf
	If $g_bDebugMakeIMGCSV Then AttackCSVDEBUGIMAGE()
	Return False
EndFunc

; FUNCTION ====================================================================================================================
; Name ..........: isOutsideEllipse
; Description ...: This function can test if a given coordinate is inside (True) or outside (False) the village grass borders (a diamond shape).
;                  It will also exclude some special area's like the CHAT tab, BUILDER button and GEM shop button.
; Syntax ........: isInsideDiamondXY($Coordx, $Coordy), isInsideDiamond($aCoords)
; Parameters ....: ($coordx, $coordY) as coordinates or ($aCoords), an array of (x,y) to test
; Return values .: True or False
; Author ........: McSlither (Jan-2016)
; Modified ......: TheRevenor (Jul-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: isInsideDiamond($aCoords)
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: None
; ===============================================================================================================================

Func isOutsideEllipse($coordX, $coordY, $ellipseWidth = 200, $ellipseHeigth = 150, $centerX = 430, $centerY = 335)

	Global $normalizedX = $coordX - $centerX
	Global $normalizedY = $coordY - $centerY
	Local $result = ($normalizedX * $normalizedX) / ($ellipseWidth * $ellipseWidth) + ($normalizedY * $normalizedY) / ($ellipseHeigth * $ellipseHeigth) > 1

	If $g_bDebugSetlog Then
		If $result Then
			SetDebugLog("Coordinate Outside Ellipse (" & $ellipseWidth & ", " & $ellipseHeigth & ")", $COLOR_DEBUG)
		Else
			SetDebugLog("Coordinate Inside Ellipse (" & $ellipseWidth & ", " & $ellipseHeigth & ")", $COLOR_DEBUG)
		EndIf
	EndIf

	Return $result

EndFunc   ;==>isOutsideEllipse

; Check Collectors Outside
Func chkDBMeetCollOutside()
	If GUICtrlRead($g_hChkDBMeetCollOutside) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_hLblDBMinCollOutsideText & "#" & $g_hTxtDBMinCollOutsidePercent & "#" & $g_hLblDBMinCollOutsideText1)
		_GUI_Value_STATE("ENABLE", $g_hChkDBCollectorsNearRedline & "#" & $g_hChkSkipCollectorCheck & "#" & $g_hChkSkipCollectorCheckTH)
		chkDBCollectorsNearRedline()
		chkSkipCollectorCheck()
		chkSkipCollectorCheckTH()
	Else
		For $i = $g_hLblDBMinCollOutsideText To $g_hCmbSkipCollectorCheckTH
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkDBMeetCollOutside

Func chkDBCollectorsNearRedline()
	If GUICtrlRead($g_hChkDBCollectorsNearRedline) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_hLblRedlineTiles & "#" & $g_hCmbRedlineTiles)
	Else
		_GUI_Value_STATE("DISABLE", $g_hLblRedlineTiles & "#" & $g_hCmbRedlineTiles)
	EndIf
EndFunc   ;==>chkDBCollectorsNearRedline

Func chkSkipCollectorCheck()
	If GUICtrlRead($g_hChkSkipCollectorCheck) = $GUI_CHECKED Then
		For $i = $g_hLblSkipCollectorCheck To $g_hTxtSkipCollectorDark
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_hLblSkipCollectorCheck To $g_hTxtSkipCollectorDark
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkSkipCollectorCheck

Func chkSkipCollectorCheckTH()
	If GUICtrlRead($g_hChkSkipCollectorCheckTH) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_hLblSkipCollectorCheckTHText1 & "#" & $g_hLblSkipCollectorCheckTHText2 & "#" & $g_hCmbSkipCollectorCheckTH)
	Else
		_GUI_Value_STATE("DISABLE", $g_hLblSkipCollectorCheckTHText1 & "#" & $g_hLblSkipCollectorCheckTHText2 & "#" & $g_hCmbSkipCollectorCheckTH)
	EndIf
EndFunc   ;==>chkSkipCollectorCheckTH
