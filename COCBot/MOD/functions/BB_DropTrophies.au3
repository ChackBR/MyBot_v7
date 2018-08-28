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

	Local $cPixColor  = ''
	Local $Nside      = 1
	Local $SIDESNAMES = "TR|TL"

	Local $bDegug     = False
	Local $bContinue  = True

	Local $OkButtom[4]     = [ 400, 495 + $g_iBottomOffsetY, 0xE2F98B, 10 ]
	Local $OkBatleEnd[4]   = [ 630, 400 + $g_iBottomOffsetY, 0xDDF685, 10 ]
	Local $OkWaitBattle[4] = [ 400, 500 + $g_iBottomOffsetY, 0xF0F0F0, 10 ]
	Local $TroopSlot[4]    = [  40, 580 + $g_iBottomOffsetY, 0x404040, 10 ]
	Local $NextSlotActive[6] = [0x4C92D3, 0x5298E0, 0x4C92D3, 0x5598E0, 0x5498E0, 0x5198E0]
	Local $NextSlotOff[6]  = [0x464646, 0x454545, 0x454545, 0x464646, 0x454545, 0x454545]
	Local $NextSlotAdd     = 72
	Local $TroopsToDrop    = 0

	If $g_bChkBB_DropTrophies Then
		; Click attack button and find a match
		If $g_iTxtBB_DropTrophies > 0 Then
			$i = $g_aiCurrentLootBB[$eLootTrophyBB] - $g_iTxtBB_DropTrophies
		Endif
		If $i > 0 Then 

			If _Sleep($DELAYCHECKOBSTACLES1) Then Return

			If BB_PrepareAttack() Then

				If _Sleep($DELAYCHECKOBSTACLES3 * 2) Then Return

				; Deploy All Troops From Slot's
				Setlog(" ====== BB Attack ====== ", $COLOR_INFO)
				For $i = 0 to 5
					If ($i > 0) Then 
						$TroopSlot[0] += $NextSlotAdd
						$TroopSlot[2] = $NextSlotOff[$i]
					EndIf
					$j = 0
					$cPixColor = _GetPixelColor($TroopSlot[0], $TroopSlot[1], True)
					$TroopsToDrop = getTroopCountBig( $TroopSlot[0]+20, $TroopSlot[1]-10 )
					If ($i > 0) Then 
						If _Sleep($DELAYCHECKOBSTACLES2) Then Return 
						IF _ColorCheck( $cPixColor, Hex($NextSlotActive[$i], 6), $TroopSlot[3]) Then
							If $bDegug Then SetLog("BB: Click Next Slot, code: 0x" & $cPixColor & " [ " & String( $i + 1 ) & " ]", $COLOR_DEBUG)
							ClickP($TroopSlot, 1, 0, "#0000")
						Else
							SetLog("BB: Can't Click Next Slot, code: 0x" & $cPixColor & " [ " & String( $i + 1 ) & " ]", $COLOR_DEBUG)
							If Not _ColorCheck( $cPixColor, Hex($TroopSlot[2], 6), $TroopSlot[3]) Then
								$bContinue = False
							EndIf
						EndIF
					EndIf
					If $bContinue Then
						While Not _ColorCheck( $cPixColor, Hex($TroopSlot[2], 6), $TroopSlot[3])
							BB_Attack($Nside, $SIDESNAMES, 8)
							If $bDegug Then SetLog("BB: Drop Troops - Slot[ " & String( $i + 1 ) & " ], code: 0x" & $cPixColor & " [ " & String( $j ) & " ] Num:[ " & $TroopsToDrop & " ]", $COLOR_DEBUG)
							If _Sleep($DELAYCHECKOBSTACLES2) Then Return 
							$j += 1
							If $j > 5 Then ExitLoop
							$cPixColor = _GetPixelColor($TroopSlot[0], $TroopSlot[1], True)
						WEnd
						If $bDegug Then SetLog("BB: Last Slot Color [ " & String( $i + 1 ) & " ], code: 0x" & $cPixColor & " [ " & String( $i + 1 ) & " ]", $COLOR_DEBUG)
					EndIf
				Next

				Setlog("Will Wait End Battle for " & String( $DELAYCHECKOBSTACLES4 / 60000 / 2 ) & " minutes then continue", $COLOR_INFO)
				If _Sleep($DELAYCHECKOBSTACLES4 / 2 ) Then Return

				; If $OkWaitBattle Exists
				$cPixColor = _GetPixelColor($OkWaitBattle[0], $OkWaitBattle[1], True)
				If _ColorCheck( $cPixColor, Hex($OkWaitBattle[2], 6), $OkWaitBattle[3]) Then
					If $bDegug Then SetLog("BB: Click Okay Buttom for no wait battle end, code: 0x" & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
					ClickP($OkWaitBattle, 1, 0, "#0000")
				EndIf

				If _Sleep($DELAYCHECKOBSTACLES2) Then Return 

				; wait $OkButtom to appear
				$j = 0
				$cPixColor = _GetPixelColor($OkButtom[0], $OkButtom[1], True)
				While Not _ColorCheck( $cPixColor, Hex($OkButtom[2], 6), $OkButtom[3])
					If $bDegug Then SetLog("BB: Click Okay Buttom. [Ok]. code: 0x" & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
					If _Sleep($DELAYCHECKOBSTACLES2) Then Return 
					$j += 1
					If $j > 10 Then ExitLoop
					$cPixColor = _GetPixelColor($OkButtom[0], $OkButtom[1], True)
				WEnd
				If $j < 10 Then
					SetLog("BB: Click Okay Buttom. [Ok]. code: 0x" & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
					ClickP($OkButtom, 1, 0, "#0000")
				Else
					SetLog("BB: Can't Find Okay Buttom [Ok]. code: 0x" & $cPixColor, $COLOR_ERROR)
				EndIf

				If _Sleep($DELAYCHECKOBSTACLES2) Then Return 

				; wait $OkBatleEnd to appear
				If $j < 10 Then
					$j = 0
					$cPixColor = _GetPixelColor($OkBatleEnd[0], $OkBatleEnd[1], True)
					While Not _ColorCheck( $cPixColor, Hex($OkBatleEnd[2], 6), $OkBatleEnd[3])
						If $bDegug Then SetLog("BB: Try Click Okay Buttom [end], code: 0x" & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
						If _Sleep($DELAYCHECKOBSTACLES3) Then Return
						$j += 1
						If $j > 30 Then ExitLoop
						$cPixColor = _GetPixelColor($OkBatleEnd[0], $OkBatleEnd[1], True)
					WEnd
					If $j < 30 Then
						SetLog("BB: Click Okay Buttom [end], code: 0x" & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
						ClickP($OkBatleEnd, 1, 0, "#0000")
					Else
						SetLog("BB: Can't Find Okay Buttom [End]. code: 0x" & $cPixColor, $COLOR_ERROR)
					EndIf
				Else

					If _Sleep($DELAYCHECKOBSTACLES2) Then Return
					ClickP($aAway, 1, 0, "#0000")

				EndIf

			EndIf

			If _Sleep($DELAYCHECKOBSTACLES2) Then Return
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
