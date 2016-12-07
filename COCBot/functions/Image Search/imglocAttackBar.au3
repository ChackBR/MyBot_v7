; #FUNCTION# ====================================================================================================================
; Name ..........: searchTroopBar
; Description ...: Searches for the Troops and Spels in Troop Attack Bar
; Syntax ........: searchTroopBar($directory, $maxReturnPoints = 1, $TroopBarSlots)
; Parameters ....: $directory - tile location to perform search , $maxReturnPoints ( max number of coords returned ,   $TroopBarSlots array to hold return values
; Return values .: $TroopBarSlots
; Author ........: TRLopes (June 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func TestImglocTroopBar()
	Local $currentRunState = $RunState
	$RunState = True
	ImglocPrepareAttack()
	$RunState = $currentRunState
EndFunc   ;==>TestImglocTroopBar

Func searchTroopBar($directory, $TroopBarSlots, $maxReturnPoints = 1)
	; $TroopBarSlots is a predefined array with 11 slots of objectname,objectcoord
	; set $maxReturnPoints = 2 for spell locating
	; Default values for multisearch
	Local $troopBarArea = "TRPBAR"
	Local $redLines = "TRPBAR" ; overide redline has there is none in troopbar
	Local $minLevel = 0
	Local $maxLevel = 1000
	Local $lineResult[5] = ["", "", "", "", 1]
	Local $foundTroopSpell
	Local $aCoords, $aCoordsSplit
	Local $slotNum = 0
	; Capture the screen for comparison

	_CaptureRegion2()

	; Perform the search
	Local $returnProps = "objectname,objectpoints,filepath"
	Local $result = findMultiple($directory, $troopBarArea, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, True)

	; Process results and fill $TroopBarSlots array with found objects. each position in $TroopBarSlots is the slot equivalent
	SetLog(" searchTroopBar start: trropbarslots: " & UBound($TroopBarSlots), $COLOR_RED)

	If IsArray($result) Then
		; Loop through the array
		For $p = 0 To UBound($result) - 1
			$foundTroopSpell = $result[$p] ; objectname,objectpoints,filepath
			$lineResult[0] = decodeTroopName($foundTroopSpell[0]) ; autoit Enum for troop/spell
			$lineResult[1] = $foundTroopSpell[0] ; imgloc troop/spell name
			$lineResult[2] = $foundTroopSpell[1] ; Coords
			$lineResult[3] = $foundTroopSpell[2] ; Filepath ( needed for recheck later )
			; Loop through the found coords
			SetLog(" lineResult " & $p & " : " & $lineResult[0] & ":" & $lineResult[1], $COLOR_BLUE)
			$aCoords = StringSplit($foundTroopSpell[1], "|", $STR_NOCOUNT)
			For $j = 0 To UBound($aCoords) - 1 ; spells can have more that 1 coords
				; Split the coords into an array
				$aCoordsSplit = StringSplit($aCoords[$j], ",", $STR_NOCOUNT)
				If UBound($aCoordsSplit) = 2 Then
					; Store the coords into a two dimensional array
					$xCoord = $aCoordsSplit[0] ; X coord.
					$slotNum = getTroopSpellSlot(Number($xCoord))
					SetLog(" found Slot: " & $slotNum, $COLOR_BLUE)
					$lineResult[4] = getTroopCountSmall($xCoord - 30, 640) ; ocr
					If Asc($lineResult[4]) = 0 Then
						$lineResult[4] = getTroopCountBig($xCoord - 30, 635) ; ocr
					EndIf
					If Asc($lineResult[4]) = 0 Then $lineResult[4] = 1 ; troop found cannot be 0, can be King,Queen or Castle
					$TroopBarSlots[$slotNum][0] = $lineResult[0]
					$TroopBarSlots[$slotNum][1] = $lineResult[1]
					$TroopBarSlots[$slotNum][2] = $lineResult[2]
					$TroopBarSlots[$slotNum][3] = $lineResult[3]
					$TroopBarSlots[$slotNum][4] = $lineResult[4]
				EndIf

			Next

		Next
	EndIf
	Return $TroopBarSlots
EndFunc   ;==>searchTroopBar

Func getTroopSpellSlot($xPos)
	SetLog(" getTroopSpellSlot :for: " & $xPos, $COLOR_BLUE)
	Local $slot = 0
	For $slot = 0 To 11
		If $xPos < 95 Then
			$slot = 0
			ExitLoop
		EndIf
		If $xPos < ($slot * 72) + 95 Then
			ExitLoop
		EndIf
	Next

	Return $slot
EndFunc   ;==>getTroopSpellSlot

Func ImglocPrepareAttack()

	Local $troopReturn[1]
	$troopReturn[0] = ""
	Local $troopName = ""
	Local $troopQtd = 1

	If $debugSetlog = 1 Then SetLog(_PadStringCenter(" IMGLOC Attack Bar begin (" & $sBotVersion & ")", 54, "="), $COLOR_BLUE)
	; $TroopBarSlots - array that holds found troops/heroes/spels format:"Enum", "Name","Coords","FilePath","Count"
	Local $TroopBarSlots[11][5] = [["empty", "", "", "", 0], ["empty", "", "", "", 0], ["empty", "", "", "", 0], ["empty", "", "", "", 0], ["empty", "", "", "", 0], ["empty", "", "", "", 0], ["empty", "", "", "", 0], ["empty", "", "", "", 0], ["empty", "", "", "", 0], ["empty", "", "", "", 0], ["empty", "", "", "", 0]]
	If $debugSetlog = 1 Then SetLog(" IMGLOC Searching Troops ", $COLOR_BLUE)
	; search troops, maxfound = 1 so it won't return any double found tile on same troop
	$TroopBarSlots = searchTroopBar(@ScriptDir & "\imgxml\imgloctroopBar\troops", $TroopBarSlots, 1)
	; search spells, maxfound = 2 to get Dual Dark spell locations
	If $debugSetlog = 1 Then SetLog(" IMGLOC Searching Spels ", $COLOR_BLUE)
	$TroopBarSlots = searchTroopBar(@ScriptDir & "\imgxml\imgloctroopBar\spells", $TroopBarSlots, 2) ; there can be more that 1 dark spell
	If $debugSetlog = 1 Then SetLog(" IMGLOC Finished Searching TroopBar ", $COLOR_BLUE)
	If $debugSetlog = 1 Then SetLog("####################################################", $COLOR_BLUE)

	For $tpos = 0 To UBound($TroopBarSlots) - 1
		If $debugSetlog = 1 Then SetLog("Slot: " & $tpos & " found " & $TroopBarSlots[$tpos][0] & "/" & $TroopBarSlots[$tpos][1] & " at " & $TroopBarSlots[$tpos][2] & " # " & $TroopBarSlots[$tpos][4], $COLOR_RED)
		; $TroopBarSlots - array that holds found troops/heroes/spels format:"Enum", "Name","Coords","FilePath","Count"
		If IsInt($TroopBarSlots[$tpos][0]) Then
			$troopName = $TroopBarSlots[$tpos][0] ; Troop Enum
			;set to 1 Queen, King,Warden if found
			;SetLog(" debug slot " & $tpos & " : " & Asc($TroopBarSlots[$tpos][2]) )
			$troopQtd = $TroopBarSlots[$tpos][4]
			If $troopReturn[0] = "" Then
				$troopReturn[0] = $troopName & "#" & $tpos & "#" & $troopQtd
			Else
				$troopReturn[0] &= "|" & $troopName & "#" & $tpos & "#" & $troopQtd
			EndIf
		EndIf
	Next
	SetLog("RETURNING TROOPLIST: " & $troopReturn[0])
	If $debugSetlog = 1 Then SetLog("####################################################", $COLOR_BLUE)
	If $debugSetlog = 1 Then SetLog(_PadStringCenter(" IMGLOC Attack Bar end ", 54, "="), $COLOR_BLUE)
	Return $troopReturn
EndFunc   ;==>ImglocPrepareAttack


;################ ProMac ##################
Func AttackBarCheck()

	Local $x = 0, $y = 659, $x1 = 853, $y1 = 698
	; Setup arrays, including default return values for $return
	Local $aResult[1][5], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	Local $redLines = "FV"
	;Local $directory = @ScriptDir & "\imgxml\AttackBar"  ; moved to bundles
	Local $directory =  "attackbar-bundle"
	If $RunState = False Then Return
	; Capture the screen for comparison
	_CaptureRegion2($x, $y, $x1, $y1)

	Local $strinToReturn = ""
	; Perform the search
	$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", $redLines, "Int", 0, "Int", 1000)

	If IsArray($res) Then
		If $res[0] = "0" Or $res[0] = "" Then
			SetLog("Imgloc|AttackBarCheck not found!", $COLOR_RED)
		ElseIf StringLeft($res[0], 2) = "-1" Then
			SetLog("DLL Error: " & $res[0] & ", AttackBarCheck", $COLOR_RED)
		Else
			; Get the keys for the dictionary item.
			Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

			; Redimension the result array to allow for the new entries
			ReDim $aResult[UBound($aKeys)][5]

			; Loop through the array
			For $i = 0 To UBound($aKeys) - 1
				If $RunState = False Then Return
				; Get the property values
				$aResult[$i][0] = returnPropertyValue($aKeys[$i], "objectname")
				; Get the coords property
				$aValue = returnPropertyValue($aKeys[$i], "objectpoints")
				$aCoords = StringSplit($aValue, "|", $STR_NOCOUNT)
				$aCoordsSplit = StringSplit($aCoords[0], ",", $STR_NOCOUNT)
				If UBound($aCoordsSplit) = 2 Then
					; Store the coords into a two dimensional array
					$aCoordArray[0][0] = $aCoordsSplit[0] ; X coord.
					$aCoordArray[0][1] = $aCoordsSplit[1] ; Y coord.
				Else
					$aCoordArray[0][0] = -1
					$aCoordArray[0][1] = -1
				EndIf
				If $debugSetlog = 1 Then Setlog($aResult[$i][0] & " | $aCoordArray: " & $aCoordArray[0][0] & "-" & $aCoordArray[0][1])
				;;;;;;;; If exist Castle Spell ;;;;;;;
				If UBound($aCoords) > 1 And StringInStr($aResult[$i][0], "Spell") <> 0 Then
					If $debugSetlog = 1 Then Setlog($aResult[$i][0] & " detected twice!")
					Local $aCoordsSplit2 = StringSplit($aCoords[1], ",", $STR_NOCOUNT)
					If UBound($aCoordsSplit2) = 2 Then
						; Store the coords into a two dimensional array
						If $aCoordsSplit2[0] < $aCoordsSplit[0] Then
							$aCoordArray[0][0] = $aCoordsSplit2[0] ; X coord.
							$aCoordArray[0][1] = $aCoordsSplit2[1] ; Y coord.
							If $debugSetlog = 1 Then Setlog($aResult[$i][0] & " | $aCoordArray: " & $aCoordArray[0][0] & "-" & $aCoordArray[0][1])
						EndIf
					Else
						$aCoordArray[0][0] = -1
						$aCoordArray[0][1] = -1
					EndIf
				EndIf
				; Store the coords array as a sub-array
				$aResult[$i][1] = Number($aCoordArray[0][0])
				$aResult[$i][2] = Number($aCoordArray[0][1])
			Next

			_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

			For $i = 0 To UBound($aResult) - 1
				Local $Slottemp
				If $aResult[$i][1] > 0 Then
					If $debugSetlog = 1 Then SetLog("$aResult : " & $i, $COLOR_DEBUG) ;Debug
					If $debugSetlog = 1 Then SetLog("UBound($aResult) : " & $aResult[$i][0] & "|" & $aResult[$i][1] & "|" & $aResult[$i][2], $COLOR_DEBUG) ;Debug
					$Slottemp = SlotAttack($aResult[$i][1])
					If $debugSetlog = 1 Then SetLog("$Slottemp : " & $Slottemp[0] & "|" & $Slottemp[1], $COLOR_DEBUG) ;Debug
					If $aResult[$i][0] = "Castle" Or $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Then
						$aResult[$i][3] = 1
						$aResult[$i][4] = $Slottemp[1]
					Else
						$aResult[$i][3] = Number(getTroopCountBig(Number($Slottemp[0]), 636)) ; For Bigg Numbers , when the troops is selected
						$aResult[$i][4] = $Slottemp[1]
						If $aResult[$i][3] = "" Or $aResult[$i][3] = 0 Then
							$aResult[$i][3] = Number(getTroopCountSmall(Number($Slottemp[0]), 641)) ; For small Numbers
							$aResult[$i][4] = $Slottemp[1]
						EndIf
					EndIf
					$strinToReturn &= "|" & Eval("e" & $aResult[$i][0]) & "#" & $aResult[$i][4] & "#" & $aResult[$i][3]
				EndIf
			Next
		EndIf
	EndIf

	If $debugImageSave = 1 Then
		Local $x = 0, $y = 659, $x1 = 853, $y1 = 698
		_CaptureRegion($x, $y, $x1, $y1)
		Local $subDirectory = $dirTempDebug & "AttackBarDetection"
		DirCreate($subDirectory)
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $filename = String($Date & "_" & $Time & "_.png")
		Local $editedImage = $hBitmap
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED

		For $i = 0 To UBound($aResult) - 1
			_GDIPlus_GraphicsDrawRect($hGraphic, $aResult[$i][1] - 5, $aResult[$i][2] - 5, 10, 10, $hPenRED)
		Next

		_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $filename)
		_GDIPlus_PenDispose($hPenRED)
		_GDIPlus_GraphicsDispose($hGraphic)
	EndIf

	$strinToReturn = StringTrimLeft($strinToReturn, 1)

	; Setlog("String: " & $strinToReturn)
	; Will return [0] = Name , [1] = X , [2] = Y , [3] = Quantities , [4] = Slot Number
	; Old style is: "|" & Troopa Number & "#" & Slot Number & "#" & Quantities
	Return $strinToReturn

EndFunc   ;==>AttackBarCheck

Func SlotAttack($PosX)

	Local $CheckSlot11 = _ColorCheck(_GetPixelColor(17, 580 + $bottomOffsetY, True), Hex(0x07202A, 6), 10)

	If $debugSetlog = 1 Then
		Setlog(" Slot 0  _ColorCheck 0x07202A at (17," & 580 + $bottomOffsetY & "): " & $CheckSlot11, $COLOR_DEBUG) ;Debug
		Local $SlotPixelColorTemp = _GetPixelColor(17, 580 + $bottomOffsetY, $bCapturePixel)
		Setlog(" Slot 0  _GetPixelColo(17," & 580 + $bottomOffsetY & "): " & $SlotPixelColorTemp, $COLOR_DEBUG) ;Debug
	EndIf

	Local $Slottemp[2] = [0, 0]
	If $RunState = False Then Return

	for $i = 0 to 12
		If $PosX > 25 + ($i * 73)  and $PosX < 98 + ($i * 73) then
			$Slottemp[0] = 35 + ($i * 73)
			$Slottemp[1] = $i
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			If $debugSetlog = 1 Then Setlog("Slot: " & $i & " | $x > " & 25 + ($i * 73) & " and $x < " & 98 + ($i * 73) & @CRLF)
			If $debugSetlog = 1 Then Setlog("Slot: " & $i & " | $PosX: " & $PosX & " |  $Slottemp[0]: " & $Slottemp[0] & " | $Slottemp[1]: " & $Slottemp[1] & @CRLF)
			Return $Slottemp
		EndIF
	next

EndFunc   ;==>SlotAttack
