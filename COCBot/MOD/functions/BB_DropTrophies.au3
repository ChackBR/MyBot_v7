; #FUNCTION# ====================================================================================================================
; Name ..........: BB_DropTrophies
; Description ...:
; Author ........: Chackal++
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

	Local $iSide      = 1
	Local $iBM_Pos    = -1
	Local $cPixColor  = ''
	Local $cSideNames = "TR|TL"

	Local $bDegug     = True
	Local $bContinue  = True

	Local $aOkButtom[4]      = [ 400, 495 + $g_iBottomOffsetY, 0xE2F98B, 20 ]
	Local $aOkButtomColor[2] = [ 0xE2F98B, 0xE2FA8C ]

	Local $aOkBatleEnd[4]      = [ 630, 400 + $g_iBottomOffsetY, 0xDDF685, 20 ]
	Local $aOkBatleEndColor[2] = [ 0xDDF685, 0xE2FA8C ]

	Local $aOkWaitBattle[4] = [ 400, 500 + $g_iBottomOffsetY, 0xF0F0F0, 20 ]
	Local $aTroopSlot[4]    = [  78, 580 + $g_iBottomOffsetY, 0x404040, 20 ]
	Local $aSlotActive[8]   = [0x4C92D3, 0x5198E0, 0x5298E0, 0x5498E0, 0x5598E0, 0x65ADEC, 0x66ADEC, 0x6AB4F1]
	Local $aSlotOff[2]      = [0x464646, 0x454545]

	Local $iTroopsTo = 0
	Local $iWait64   = 64
	Local $iWait128  = 128
	Local $iWait256  = 256
	Local $aAux[2]   = [ 0, 0]

	If $g_bChkBB_DropTrophies Then
		; Click attack button and find a match
		If $g_iTxtBB_DropTrophies > 0 Then
			$i = $g_aiCurrentLootBB[$eLootTrophyBB] - $g_iTxtBB_DropTrophies
		EndIf
		If $i > 0 Then

			If _Sleep($DELAYRUNBOT1) Then Return

			If BB_PrepareAttack() Then

				If _Sleep($DELAYRUNBOT1*12) Then Return

				; Deploy All Troops From Slot's
				Setlog(" ====== BB Attack ====== ", $COLOR_INFO)
				SetLog("BB: Attacking on a single side", $COLOR_INFO)

				; Check if BM is available
				Setlog("BB: Look for Battle Machine [If Exists]", $COLOR_GREEN)
				$iBM_Pos = BB_Mach_Slot()

				For $i = 0 To 5
					; Pos Next Slot
					If ($i > 0) Then
						$aTroopSlot[0] += 72
					Else
						If $iBM_Pos < 0 Then $aTroopSlot[0] += 9
					EndIf
					$cPixColor = _GetPixelColor($aTroopSlot[0], $aTroopSlot[1], True)
					If _Sleep($DELAYRUNBOT1) Then Return
					IF BB_ColorCheck( $aTroopSlot, $aSlotActive ) Then
						If $bDegug Then SetLog("BB: Click Next Slot, color: " & $cPixColor & " [ " & String( $i + 1 ) & " ]", $COLOR_DEBUG)
						ClickP($aTroopSlot, 1, 0, "#0000")
					Else
						SetLog("BB: Can't verify slot, color: " & $cPixColor & " [ " & String( $i + 1 ) & " ]", $COLOR_DEBUG)
						IF Not BB_ColorCheck( $aTroopSlot, $aSlotOff ) Then
							If ($i > 0) Then $bContinue = False
						EndIf
					EndIf
					If _Sleep($DELAYRUNBOT1) Then Return
					If $bContinue Then
						$j = 0
						$iTroopsTo = Number(getTroopCountBig($aTroopSlot[0], $aTroopSlot[1]-7))
						If $iTroopsTo < 4 Then $iTroopsTo = 4
						If $bDegug Then SetLog("BB: Drop Troops - Slot[ " & String( $i + 1 ) & " ], color: " & $cPixColor & " [ " & String( $j ) & " ] Num:[ " & $iTroopsTo & " ]", $COLOR_DEBUG)
						While Not BB_ColorCheck( $aTroopSlot, $aSlotOff )
							If _Sleep($DELAYRUNBOT1) Then Return
							If $j < 5 Then
								PureClickP($aTroopSlot, 1, 0, "#0000")
							Else
								$aAux[0] = $aTroopSlot[0] + 16
								$aAux[1] = $aTroopSlot[1] + 16
								ClickP($aAux, 1, 0, "#0000")
							EndIf
							BB_Attack($iSide, $cSideNames, $iTroopsTo)
							$j += 1
							If $j > 8 Then ExitLoop
							$cPixColor = _GetPixelColor($aTroopSlot[0], $aTroopSlot[1], True)
						WEnd
						If $bDegug Then SetLog("BB: Last Slot, color: " & $cPixColor & " [ " & String( $i + 1 ) & " ]", $COLOR_DEBUG)
					EndIf
				Next

				; *-------------------------------------------------*
				; Battle Machine Deploy
				; *-------------------------------------------------*
				BB_Mach_Deploy( $iBM_Pos )

				; BB: Wait for Battle End
				Setlog("BB: Confirm Battle End [ok]", $COLOR_INFO)
				$j = 0
				While $j < $iWait64
					If _Sleep($DELAYRUNBOT1) Then Return
					$cPixColor = _GetPixelColor($aOkWaitBattle[0], $aOkWaitBattle[1], True)
					If _ColorCheck( $cPixColor, Hex($aOkWaitBattle[2], 6), 20) Then $j = 32
					If _Sleep($DELAYRUNBOT1) Then Return
					$cPixColor = _GetPixelColor($aOkButtom[0], $aOkButtom[1], True)
					If _ColorCheck( $cPixColor, Hex($aOkButtom[2], 6), 20) Then
						$j = $iWait64
					Else
						$j += 1
					Endif
					BB_StatusMsg("Wait for Battle End" & " [ " & String( $j ) & " ]")
				WEnd

				If _Sleep($DELAYRUNBOT1) Then Return

				; If $aOkWaitBattle Exists
				$cPixColor = _GetPixelColor($aOkWaitBattle[0], $aOkWaitBattle[1], True)
				If _ColorCheck( $cPixColor, Hex($aOkWaitBattle[2], 6), 20) Then
					If $bDegug Then SetLog("BB: Okay Buttom [no wait battle end], color: " & $cPixColor, $COLOR_DEBUG)
					ClickP($aOkWaitBattle, 1, 0, "#0000")
				EndIf

				If _Sleep($DELAYRUNBOT1) Then Return

				; wait $aOkButtom to appear
				$j = 0
				$cPixColor = _GetPixelColor($aOkButtom[0], $aOkButtom[1], True)
				While Not BB_ColorCheck( $aOkButtom, $aOkButtomColor )
					If $bDegug Then BB_StatusMsg("Wait Okay Buttom. [Ok]. color: " & $cPixColor & " [ " & String( $j ) & " ]")
					If _Sleep($DELAYRUNBOT1) Then Return
					$j += 1
					If $j > $iWait128 Then ExitLoop
					$cPixColor = _GetPixelColor($aOkButtom[0], $aOkButtom[1], True)
				WEnd
				If $j < $iWait128 Then
					SetLog("BB: Click Buttom. [Ok]. color: " & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
					ClickP($aOkButtom, 1, 0, "#0000")
				Else
					SetLog("BB: Can't Find Buttom [Ok]. color: " & $cPixColor, $COLOR_ERROR)
				EndIf

				If _Sleep($DELAYRUNBOT1) Then Return

				; wait $aOkBatleEnd to appear
				If $j < $iWait64 Then
					$j = 0
					$cPixColor = _GetPixelColor($aOkBatleEnd[0], $aOkBatleEnd[1], True)
					While Not BB_ColorCheck( $aOkBatleEnd, $aOkBatleEndColor )
						If $bDegug Then BB_StatusMsg("Wait Okay Buttom. [end]. color: " & $cPixColor & " [ " & String( $j ) & " ]")
						If _Sleep($DELAYRUNBOT1) Then Return
						$j += 1
						If $j > $iWait64 Then ExitLoop
						$cPixColor = _GetPixelColor($aOkBatleEnd[0], $aOkBatleEnd[1], True)
					WEnd
					If $j < $iWait64 Then
						SetLog("BB: Click Buttom [end], color: " & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
						ClickP($aOkBatleEnd, 1, 0, "#0000")
					Else
						SetLog("BB: Can't Find Buttom [End]. color: " & $cPixColor, $COLOR_ERROR)
					EndIf
				Else

					If _Sleep($DELAYRUNBOT1) Then Return
					ClickP($aAway, 1, 0, "#0000")

				EndIf

			EndIf

			If _Sleep($DELAYRUNBOT1) Then Return
			ClickP($aAway, 1, 0, "#0000")

		Else
			Setlog("Ignore BB Drop Trophies: [Not Needed] [ " & String( $g_iTxtBB_DropTrophies ) & " ]", $COLOR_INFO)
		EndIf
	Else
		Setlog("Ignore BB Drop Trophies [ Disabled ]", $COLOR_INFO)
	EndIf

	_Sleep($DELAYRUNBOT1)

EndFunc	;==>BB_DropTrophies

; #FUNCTION# ====================================================================================================================
; Name ..........: BB_ColorCheck( $aInfo, $aColors )
; Description ...: Check an Array of Colors ( instead just one )
; Author ........: Chackal++
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BB_ColorCheck( $aInfo, $aColors )
	Local $i
	Local $cPixel
	Local $bResult = False
	Local $iLoop = UBound( $aColors ) - 1
	$cPixel = _GetPixelColor($aInfo[0], $aInfo[1], True)
	For $i = 0 to $iLoop
		If _ColorCheck( $cPixel, Hex($aColors[$i], 6), 20) Then
			$bResult = True
			ExitLoop
		EndIf
	Next
	Return $bResult
EndFunc	;==>BB_ColorCheck

Func BB_StatusMsg( $cTxt )
	_GUICtrlStatusBar_SetTextEx($g_hStatusBar, "BB Status: " & $cTxt )
EndFunc	;==>BB_StatusMsg

Func ChkBB_DropTrophies()
	$g_bChkBB_DropTrophies = (GUICtrlRead($g_hChkBB_DropTrophies) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>ChkBB_DropTrophies

Func TxtBB_DropTrophies()
	$g_iTxtBB_DropTrophies = GUICtrlRead($g_hTxtBB_DropTrophies)
EndFunc   ;==>TxtBB_DropTrophies

Func ChkBB_OnlyWithLoot()
	$g_bChkBB_OnlyWithLoot = (GUICtrlRead($g_hChkBB_OnlyWithLoot) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>ChkBB_OnlyWithLoot
