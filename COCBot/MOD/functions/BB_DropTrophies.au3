; #FUNCTION# ====================================================================================================================
; Name ..........: BB_DropTrophies
; Description ...: 
; Author ........: Chackall++
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BB_DropTrophies()

	Local $i = 0
	Local $j = 0
	Local $Nside = 1
	Local $SIDESNAMES = "TR|TL"
	Local $OkButtom[4] = [ 400, 495 + $g_iBottomOffsetY, 0xE2F98B, 10 ]
	Local $OkBatleEnd[4] = [ 630, 400 + $g_iBottomOffsetY, 0xDDF685, 10 ]
	Local $OkWaitBattle[4] = [ 400, 500 + $g_iBottomOffsetY, 0xF0F0F0, 10 ]
	Local $TroopSlot1[4] = [  50, 580 + $g_iBottomOffsetY, 0x404040, 10 ]

	Local $bDegug = True
	Local $cPixColor = ''

	If $g_bChkBB_DropTrophies Then
		; Click attack button and find a match
		If $g_iTxtBB_DropTrophies > 0 Then
			$i = $g_aiCurrentLootBB[$eLootTrophyBB] - $g_iTxtBB_DropTrophies
		Endif
		If Not $bDegug Then
			$i = 0 ; Disable it
		Endif
		If $i > 0 Then 

			If _Sleep($DELAYCHECKOBSTACLES1) Then Return

			If BB_PrepareAttack() Then

				If _Sleep($DELAYCHECKOBSTACLES3 * 3) Then Return

				; Deploy All Troops From Slot1
				$j = 0
				$cPixColor = _GetPixelColor($TroopSlot1[0], $TroopSlot1[1], True)
				Setlog(" ====== BB Attack ====== ", $COLOR_INFO)
				While Not _ColorCheck( $cPixColor, Hex($TroopSlot1[2], 6), $TroopSlot1[3])
					BB_Attack($Nside, $SIDESNAMES)
					If $bDegug Then SetLog("BB: Deploy All Troops From Slot1, code: " & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
					If _Sleep($DELAYCHECKOBSTACLES3) Then Return 
					$j += 1
					If $j > 10 Then ExitLoop
					$cPixColor = _GetPixelColor($TroopSlot1[0], $TroopSlot1[1], True)
				WEnd
				Setlog("Will Wait End Battle for " & String( $DELAYCHECKOBSTACLES4 * 1.5 / 60000 ) & " minutes then continue", $COLOR_INFO)
				If _Sleep($DELAYCHECKOBSTACLES4 * 1.5) Then Return

				; If $OkWaitBattle Exists
				$cPixColor = _GetPixelColor($OkWaitBattle[0], $OkWaitBattle[1], True)
				If _ColorCheck( $cPixColor, Hex($OkWaitBattle[2], 6), $OkWaitBattle[3]) Then
					If $bDegug Then SetLog("BB: Click Okay Buttom for no wait battle end, code: " & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
					ClickP($OkWaitBattle, 1, 0, "#0000")
				EndIf

				If _Sleep($DELAYCHECKOBSTACLES3) Then Return 

				; wait $OkButtom to appear
				$j = 0
				$cPixColor = _GetPixelColor($OkButtom[0], $OkButtom[1], True)
				While Not _ColorCheck( $cPixColor, Hex($OkButtom[2], 6), $OkButtom[3])
					If $bDegug Then SetLog("BB: Click Okay Buttom. Batle End, code: " & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
					If _Sleep($DELAYCHECKOBSTACLES3) Then Return 
					$j += 1
					If $j > 10 Then ExitLoop
					$cPixColor = _GetPixelColor($OkButtom[0], $OkButtom[1], True)
				WEnd
				If $j < 10 Then
					ClickP($OkButtom, 1, 0, "#0000")
				Else
					SetLog("BB: Can't Find Okay Buttom [Ok]. code: " & $cPixColor, $COLOR_ERROR)
				EndIf

				If _Sleep($DELAYCHECKOBSTACLES3) Then Return 

				; wait $OkBatleEnd to appear
				If $j < 10 Then
					$j = 0
					$cPixColor = _GetPixelColor($OkBatleEnd[0], $OkBatleEnd[1], True)
					While Not _ColorCheck( $cPixColor, Hex($OkBatleEnd[2], 6), $OkBatleEnd[3])
						If $bDegug Then SetLog("BB: try find Okay Buttom [end], code: " & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
						If _Sleep($DELAYCHECKOBSTACLES3) Then Return 
						$j += 1
						If $j > 10 Then ExitLoop
						$cPixColor = _GetPixelColor($OkBatleEnd[0], $OkBatleEnd[1], True)
					WEnd
					If $j < 10 Then
						ClickP($OkBatleEnd, 1, 0, "#0000")
					Else
						SetLog("BB: Can't Find Okay Buttom [End]. code: " & $cPixColor, $COLOR_ERROR)
					EndIf
				Else

					If _Sleep($DELAYCHECKOBSTACLES3) Then Return
					ClickP($aAway, 1, 0, "#0000")

				EndIf

			EndIf

			If _Sleep($DELAYCHECKOBSTACLES3) Then Return
			ClickP($aAway, 1, 0, "#0000")

		Else
			Setlog("Ignore BB Drop Trophies: [Not Needed] [ " & String( $g_iTxtBB_DropTrophies ) & " ]", $COLOR_INFO)
		EndIf
	Else
		Setlog("Ignore BB Drop Trophies [ Disabled ]", $COLOR_INFO)
	Endif

EndFunc	;==> BB_DropTrophies

Func ChkBB_DropTrophies()
	$g_bChkBB_DropTrophies = (GUICtrlRead($g_hChkBB_DropTrophies) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>ChkBB_DropTrophies

Func TxtBB_DropTrophies()
	$g_iTxtBB_DropTrophies = GUICtrlRead($g_hTxtBB_DropTrophies)
EndFunc   ;==>TxtBB_DropTrophies
