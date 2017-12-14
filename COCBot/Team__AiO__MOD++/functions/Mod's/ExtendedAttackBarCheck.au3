; #FUNCTION# ====================================================================================================================
; Name ..........: ExtendedAttackBarCheck (part of AttackBarCheck($Remaining)) (#-22)
; Description ...: Drag Attack Bar for more troops/spells beyond the Slot 11
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Demen
; Modified ......: AiO++ Team
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ExtendedAttackBarCheck($aTroop1stPage, $Remaining)

	If Not IsArray($aTroop1stPage) Then Return

	Local $x = 0, $y = 659, $x1 = 853, $y1 = 698
	Static $CheckSlotwHero2 = False
	Local $iCCSpell = 0
	; Setup arrays, including default return values for $return
	Local $aResult[1][6], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	If Not $g_bRunState Then Return
	; Capture the screen for comparison
	_CaptureRegion2($x, $y, $x1, $y1)

	Local $strinToReturn = ""
	; Perform the search
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $g_sImgAttackBarDir, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)

	If IsArray($res) Then
		If $res[0] = "0" Or $res[0] = "" Then
			SetLog("Imgloc|AttackBarCheck not found!", $COLOR_RED)
		ElseIf StringLeft($res[0], 2) = "-1" Then
			SetLog("DLL Error: " & $res[0] & ", AttackBarCheck", $COLOR_RED)
		Else
			; Get the keys for the dictionary item.
			If $g_bDebugSetlog Then Setlog("$res[0] = " & $res[0])
			Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

			; Redimension the result array to allow for the new entries
			ReDim $aResult[UBound($aKeys)][6]

			; Loop through the array
			For $i = 0 To UBound($aKeys) - 1
				If $g_bRunState = False Then Return
				; Get the property values
				$aResult[$i][0] = RetrieveImglocProperty($aKeys[$i], "objectname")
				; Get the coords property
				$aValue = RetrieveImglocProperty($aKeys[$i], "objectpoints")
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
				If $g_bDebugSetlog Then Setlog($aResult[$i][0] & " | $aCoordArray: " & $aCoordArray[0][0] & "-" & $aCoordArray[0][1])
				;;;;;;;; If exist Castle Spell ;;;;;;; - Fix case 2 CC Spells (Demen)
				If UBound($aCoords) > 1 And StringInStr($aResult[$i][0], "Spell") <> 0 Then
					If $g_bDebugSetlog Then Setlog($aResult[$i][0] & " x" & UBound($aCoords) & " multiple detected: " & $aValue)

					Local $aTempX[UBound($aCoords)], $aTempY[UBound($aCoords)]
					For $j = 0 To UBound($aCoords) - 1
						Local $aTempXY = StringSplit($aCoords[$j], ",", $STR_NOCOUNT)
						If UBound($aTempXY) = 2 Then
							$aTempX[$j] = Number($aTempXY[0])
							$aTempY[$j] = Number($aTempXY[1])
						Else
							_ArrayDelete($aTempX, $j)
							_ArrayDelete($aTempY, $j)
						EndIf
					Next
					If IsArray($aTempX) And IsArray($aTempY) Then
						$aCoordArray[0][0] = _ArrayMin($aTempX) ; X coord.
						$aCoordArray[0][1] = $aTempY[_ArrayMinIndex($aTempX)] ; Y coord.
					Else
						$aCoordArray[0][0] = -1
						$aCoordArray[0][1] = -1
					EndIf

					_ArraySort($aTempX) ; Fix detect 2 Haste Spell for 1 slot - Demen
					If UBound($aTempX) > 1 Then
						For $j = 1 To UBound($aTempX) - 1
							If Abs($aTempX[$j] - $aTempX[$j-1]) >= 30 Then $iCCSpell += 1
						Next
					EndIf

				EndIf
				; Store the coords array as a sub-array
				$aResult[$i][1] = Number($aCoordArray[0][0])
				$aResult[$i][2] = Number($aCoordArray[0][1])
			Next

			_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

			For $i = 0 To UBound($aResult) - 1
				If $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Then
					$CheckSlotwHero2 = True
				EndIf
			Next

			Local $iSlotExtended = 0
			Static $iFirstExtendedSlot = 0	; Location of 1st extended troop after drag
			If Not $Remaining Then $iFirstExtendedSlot = 0 ; Reset value for 1st time detecting troop bar

			For $i = 0 To UBound($aResult) - 1
				Local $Slottemp
				If $aResult[$i][1] > 0 Then
					If $g_bDebugSetlog Then SetLog("SLOT : " & $i, $COLOR_DEBUG) ;Debug
					If $g_bDebugSetlog Then SetLog("Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG) ;Debug

					; Check if troop is already in 1st page
					Local $iDublicateSlot = _ArraySearch($aTroop1stPage, $aResult[$i][0], 0, 0, 0, 0, 1, 0)
					If $iDublicateSlot <> -1 Then
						If $g_bDebugSetlog Then Setlog($aResult[$i][0] & " is already found in 1st page at Slot: " & $aTroop1stPage[$iDublicateSlot][1])
						ContinueLoop
					EndIf

					$Slottemp = SlotAttack(Number($aResult[$i][1]), False, False, False, TroopIndexLookup($aResult[$i][0]))
					$Slottemp[0] += 18
					If $iFirstExtendedSlot = 0 Then $iFirstExtendedSlot = $Slottemp[1]	; flag only once
					$iSlotExtended = $Slottemp[1] - $iFirstExtendedSlot + 1

					If $CheckSlotwHero2 And StringInStr($aResult[$i][0], "Spell") = 0 Then $Slottemp[0] -= 14
					If $g_bRunState = False Then Return ; Stop function
					If _Sleep(20) Then Return ; Pause function
					If UBound($Slottemp) = 2 Then
						If $g_bDebugSetlog Then SetLog("OCR : " & $Slottemp[0] & "|SLOT: " & $Slottemp[1], $COLOR_DEBUG) ;Debug
						If $aResult[$i][0] = "Castle" Or $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Then
							$aResult[$i][3] = 1
						Else
							$aResult[$i][3] = Number(getTroopCountBig(Number($Slottemp[0]), 636)) ; For Bigg Numbers , when the troops is selected
							If $aResult[$i][3] = "" Or $aResult[$i][3] = 0 Then $aResult[$i][3] = Number(getTroopCountSmall(Number($Slottemp[0]), 641)) ; For small Numbers
						EndIf
						$aResult[$i][4] = ($Slottemp[1] + 11) - $iFirstExtendedSlot
					Else
						Setlog("Problem with Attack bar detection!", $COLOR_RED)
						SetLog("Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG)
						$aResult[$i][3] = -1
						$aResult[$i][4] = -1
					EndIf
					$strinToReturn &= "|" & TroopIndexLookup($aResult[$i][0]) & "#" & $aResult[$i][4] & "#" & $aResult[$i][3] & "#" & $aResult[$i][1] ; SWIPE - Persian MOD (#-33)
				EndIf
			Next
			If Not $Remaining Then
				Local $iTotalSlot1stPage = _ArrayMax($aTroop1stPage, 0, -1, -1, 1)
				If $g_bDebugSetlog Then SetLog("$iTotalSlot1stPage : " & $iTotalSlot1stPage, $COLOR_DEBUG) ;Debug
				$g_iTotalAttackSlot = $iSlotExtended + $iTotalSlot1stPage + $iCCSpell
			EndIf

			If $g_bDebugSetlog Then Setlog("$iSlotExtended / $iCCSpell / $g_iTotalAttackSlot: " & $iSlotExtended & "/" & $iCCSpell & "/" & $g_iTotalAttackSlot)

		EndIf
	EndIf

	If $g_bDebugSetlog Then Setlog("Extended String: " & $strinToReturn)
	Return $strinToReturn

EndFunc   ;==>AttackBarCheck

Func DragAttackBar($iTotalSlot = 20, $bBack = False)
	If $g_iTotalAttackSlot > 10 Then $iTotalSlot = $g_iTotalAttackSlot
	Local $bAlreadyDrag = False
	If $bBack = False Then
		If $g_bDebugSetlog Then Setlog("Dragging attack troop bar to 2nd page. Distance = " & $iTotalSlot - 9 & " slots")
		ClickDrag(25 + 73 * ($iTotalSlot - 9), 660, 25, 660, 1000)
		If _Sleep(1000 + $iTotalSlot * 25) Then Return
		$bAlreadyDrag = True
	Else
		If $g_bDebugSetlog Then Setlog("Dragging attack troop bar back to 1st page. Distance = " & $iTotalSlot - 9 & " slots")
		ClickDrag(25, 660, 25 + 73 * ($iTotalSlot - 9), 660, 1000)
		If _Sleep(800 + $iTotalSlot * 25) Then Return
		$bAlreadyDrag = False
	EndIf
	$g_bDraggedAttackBar = $bAlreadyDrag
	$g_iCSVLastTroopPositionDropTroopFromINI = -1 ; after drag attack bar, need to clear last troop selected
	Return $bAlreadyDrag
EndFunc   ;==>DragAttackBar
