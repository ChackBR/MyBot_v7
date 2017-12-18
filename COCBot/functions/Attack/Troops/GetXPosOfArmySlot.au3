; #FUNCTION# ====================================================================================================================
; Name ..........: GetXPosOfArmySlot
; Description ...:
; Syntax ........: GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot)
; Parameters ....: $slotNumber          - a string value.
;                  $xOffsetFor11Slot    - an unknown value.
; Return values .: None
; Author ........:
; Modified ......: Promac(12-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot, $bNeedNewCapture = Default)
	If $bNeedNewCapture = Default Then $bNeedNewCapture = True
	Local $CheckSlot12, $SlotPixelColorTemp, $SlotPixelColor1 , $SlotComp

	$xOffsetFor11Slot -= 8

	Switch $slotNumber
		Case 7
			$SlotComp = 1
		Case Else
			$SlotComp = 0
	EndSwitch

	If $slotNumber = $g_iKingSlot Or $slotNumber = $g_iQueenSlot Or $slotNumber = $g_iWardenSlot Then $xOffsetFor11Slot += 8

	; Extended AttackBar - Demen - AiO++ Team
	If $g_bDraggedAttackBar Then Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72) + 14

	Local $oldBitmap = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
	; check Dark color on slot 0 to verify if exists > 11 slots
	; $SlotPixelColor = _ColorCheck(_GetPixelColor(17, 580 + $g_iBottomOffsetY, True), Hex(0x07202A, 6), 20)
	If $bNeedNewCapture = True Then
		$CheckSlot12 = _ColorCheck(_GetPixelColor(17, 643, True), Hex(0x478AC6, 6), 15) Or _  	; Slot Filled / Background Blue / More than 11 Slots
					_ColorCheck(_GetPixelColor(17, 643, True), Hex(0x434343, 6), 10)   		; Slot deployed / Gray / More than 11 Slots
	Else
		$CheckSlot12 = _ColorCheck(Hex(_GDIPlus_BitmapGetPixel($oldBitmap, 17, 643), 6), Hex(0x478AC6, 6), 15) Or _  	; Slot Filled / Background Blue / More than 11 Slots
					_ColorCheck(Hex(_GDIPlus_BitmapGetPixel($oldBitmap, 17, 643), 6), Hex(0x434343, 6), 10)   		; Slot deployed / Gray / More than 11 Slots
	EndIf

	If $g_bDebugSetlog Then
		Setlog(" Slot 0  _ColorCheck 0x478AC6 at (17," & 643 & "): " & $CheckSlot12, $COLOR_DEBUG) ;Debug
		If $bNeedNewCapture = True Then
			$SlotPixelColorTemp = _GetPixelColor(17, 643, $g_bCapturePixel)
		Else
			$SlotPixelColorTemp = Hex(_GDIPlus_BitmapGetPixel($oldBitmap, 17, 643), 6) ; Get pixel color
		EndIf
		Setlog(" Slot 0  _GetPixelColo(17," & 643 & "): " & $SlotPixelColorTemp, $COLOR_DEBUG) ;Debug
	EndIf

	_GDIPlus_BitmapDispose($oldBitmap)

	If Not $CheckSlot12 Then
		Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72)
	Else
		Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72) - 13
	EndIf

EndFunc   ;==>GetXPosOfArmySlot
