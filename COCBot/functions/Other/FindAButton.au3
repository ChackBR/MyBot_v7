; #FUNCTION# ====================================================================================================================
; Name ..........: FindAButton.au3
; Description ...: Find a specific button; Grouped non-generic functions
; Syntax ........: None
; Parameters ....:
; Return values .: None
; Author ........: MMHK (11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func FindExitButton($sButtonName)
	Local $sButtons
	Local $rootFolder = "\imgxml\imglocbuttons\exit"
	Local $aFiles
	Local $aButtonPath[0]
	Local $sPosXY = ""
	Local $aPosXY

	If Not IsString($sButtonName) Then
		If $DebugSetlog Then SetLog("Button Name not a string: " & $sButtonName, $COLOR_DEBUG)
		Return ""
	EndIf

	$sButtons = "*" & $sButtonName & "*" ; enable reuse same tile file for different $sButtonName
	$aFiles = _FileListToArray(@ScriptDir & $rootFolder, $sButtons, $FLTA_FILES, True)

	If UBound($aFiles) < 2 Or $aFiles[0] < 1 Then
		If $DebugSetlog Then SetLog("No files in: " & @ScriptDir & $rootFolder, $COLOR_DEBUG)
		Return ""
	EndIf

	For $i = 1 To $aFiles[0]
		If StringRegExp($aFiles[$i], ".+[.](xml|png|bmp)$") Then _ArrayAdd($aButtonPath, $aFiles[$i])
	Next

	If UBound($aButtonPath) <> 1 Then
		If $DebugSetlog Then SetLog("Too many same name tiles found: " & $sButtonName, $COLOR_DEBUG)
		Return ""
	EndIf

	If $DebugSetlog Then SetLog("imgLoc searching for: " & $sButtonName & ": " & $aButtonPath[0])

	Local $iBegin = TimerInit()
	$sPosXY = FindImageInPlace($sButtonName, $aButtonPath[0], GetButtonRectangle($sButtonName))
	If $DebugSetlog then SetLog("Find button " & $sButtonName & " used: " & Round(TimerDiff($iBegin)) & "ms", $COLOR_DEBUG)

	If $sPosXY <> "" Then
		$aPosXY = StringSplit($sPosXY, ",", $STR_NOCOUNT)
		If $DebugSetlog Then Setlog($sButtonName & " Button X|Y = " & $aPosXY[0] & "|" & $aPosXY[1], $COLOR_DEBUG)
		Return $aPosXY ; return just X,Y coord array
	EndIf

	SetLog("FindExitButton: " & $sButtonName & " NOT Found" , $COLOR_INFO)
	Return $sPosXY
EndFunc   ;==>FindExitButton

Func GetButtonRectangle($sButtonName)
	Local $btnRectangle = "0,0," & $DEFAULT_WIDTH & "," & $DEFAULT_HEIGHT

	Switch $sButtonName
		Case "Kunlun", "Huawei", "Kaopu", "Microvirt", "Yeshen"
			$btnRectangle = GetDummyRectangle("345,394", 10)
		Case "Qihoo"
			$btnRectangle = GetDummyRectangle("302,456", 10)
		Case "Baidu"
			$btnRectangle = GetDummyRectangle("464,426", 10)
		Case "OPPO"
			$btnRectangle = GetDummyRectangle("476,412", 10)
		Case "Anzhi"
			$btnRectangle = GetDummyRectangle("328,371", 10)
		Case "Lenovo"
			$btnRectangle = GetDummyRectangle("477,476", 10)
		Case "Aiyouxi"
			$btnRectangle = GetDummyRectangle("468,392", 10)
		Case "9game"
			$btnRectangle = GetDummyRectangle("359,406", 10)
		Case "VIVO", "Xiaomi"
			$btnRectangle = GetDummyRectangle("353,387", 10)
		Case "Guopan"
			$btnRectangle = GetDummyRectangle("409,440", 10)
		Case Else
			$btnRectangle = "0,0," & $DEFAULT_WIDTH & "," & $DEFAULT_HEIGHT ; use full image to locate button
	EndSwitch

	Return $btnRectangle
EndFunc   ;==>GetButtonRectangle
