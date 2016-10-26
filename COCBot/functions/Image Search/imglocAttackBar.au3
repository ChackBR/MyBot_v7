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


