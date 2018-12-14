; #FUNCTION# ====================================================================================================================
; Name ..........: BB_PrepareAttack
; Description ...:
; Syntax ........: BB_PrepareAttack()
; Author ........: Chackal++
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BB_PrepareAttack() ; Click attack button and find a match

	Local $i = 0
	Local $j = 0
	Local $iWait256  = 256
	Local $cPixColor = ""
	Local $Result    = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
	Local $aTroopsOk[4]     = [ 310, 355 + $g_iBottomOffsetY, 0xDAF482, 20 ]
	Local $aLootAvail[4]    = [ 515, 620 + $g_iBottomOffsetY, 0x707371, 20 ]
	Local $aLootColor[2]    = [ 0x707371, 0x585B5A ]
	Local $aBMachineWait[4] = [ 157, 337 + $g_iBottomOffsetY, 0xFFFFFF, 20 ] ; 9FA19F Clr Updating BM
	Local $aScrSearchEnd[4] = [ 390, 500 + $g_iBottomOffsetY, 0xCA8C94, 20 ]
	Local $aScrSearchClr[5] = [ 0xD98F95, 0xFD797D, 0xC38B93, 0xC58A93, 0xCA8C94 ]
	Local $bCanAttack
	Local $aBB_FindMatchButton[4] = [555, 240 + $g_iBottomOffsetY, 0xFFC346, 10]

	Local $bDegug = True

	SetLog("BH: Going to Attack... [ " & String( $g_iTxtBB_DropTrophies ) & " ]", $COLOR_INFO)

	If IsMainPageBuilderBase() Then
		ClickP($aAttackButton, 1, 0, "#0149") ; Click Attack Button
	EndIf
	If _Sleep($DELAYRUNBOT1) Then Return

	; If $aTroopsOk is ready
	$cPixColor = _GetPixelColor($aTroopsOk[0], $aTroopsOk[1], True)
	If _ColorCheck( $cPixColor, Hex($aTroopsOk[2], 6), 20) Then
		SetLog("BB: Troops Not Ready [Stop], code: " & $cPixColor, $COLOR_DEBUG)
		$bCanAttack = False
	Else
		SetLog("BB: Troops Ready, code: " & $cPixColor, $COLOR_DEBUG)
		$bCanAttack = True
	EndIf

	If _Sleep($DELAYRUNBOT1) Then Return

	If $bCanAttack Then
		; If Loot Available
		If $g_bChkBB_OnlyWithLoot Then
			$cPixColor = _GetPixelColor($aLootAvail[0], $aLootAvail[1], True)
			If BB_ColorCheck( $aLootAvail, $aLootColor) Then
				If $bDegug Then SetLog("BB: Loot available [Continue], color: " & $cPixColor, $COLOR_DEBUG)
			Else
				If $bDegug Then SetLog("BB: No Loot available [Stop], color: " & $cPixColor, $COLOR_DEBUG)
				$bCanAttack = False
			EndIf
		EndIf
	EndIf

	If $bCanAttack Then
		; If BMachine Available
		If $g_bChkBB_OnlyWithLoot Then
			$cPixColor = _GetPixelColor($aBMachineWait[0], $aBMachineWait[1], True)
			If _ColorCheck( $cPixColor, Hex($aBMachineWait[2], 6), 20) Then
				If $bDegug Then SetLog("BB: BM not available [Wait] color: " & $cPixColor, $COLOR_DEBUG)
				$bCanAttack = False
			Else
				If $bDegug Then SetLog("BB: BMachine ok [or not exists] color: " & $cPixColor, $COLOR_DEBUG)
			EndIf
		EndIf
	EndIf

	If _Sleep($DELAYRUNBOT1) Then Return

	If $bCanAttack Then

		; If $aBB_FindMatchButton appear
		$cPixColor = _GetPixelColor($aBB_FindMatchButton[0], $aBB_FindMatchButton[1], True)
		If _ColorCheck( $cPixColor, Hex($aBB_FindMatchButton[2], 6), 20) Then
			If $bDegug Then SetLog("BB: Click Find Match Button, color: " & $cPixColor, $COLOR_DEBUG)
			If _Sleep($DELAYRUNBOT1) Then Return
			ClickP($aBB_FindMatchButton, 1, 0, "#0000") ;Click Find a Match Button
		Else
			SetLog("BB: Can't Find Match Buttom [Stop] color: " & $cPixColor, $COLOR_ERROR)
			$bCanAttack = False
		EndIf

		If _Sleep($DELAYRUNBOT1) Then Return

		; Wait for search finish
		SetLog("BB: Screen Search for Match [Check for it]", $COLOR_DEBUG)
		If $bCanAttack Then
			While $j < $iWait256
				$cPixColor = _GetPixelColor($aScrSearchEnd[0], $aScrSearchEnd[1], True)
				If BB_ColorCheck( $aScrSearchEnd, $aScrSearchClr) Then
					$j += 1
				Else
					$j = $iWait256
				EndIf
				If _Sleep($DELAYRUNBOT2) Then Return
				BB_StatusMsg("Screen Search for Match [" & String( $j ) & "] Color: " & $cPixColor)
			WEnd
		EndIf

		If _Sleep($DELAYRUNBOT3) Then Return

		checkAttackDisable($g_iTaBChkAttack, $Result) ;See If TakeABreak msg on screen

		If $g_bDebugSetlog Then SetDebugLog("BB: PrepareAttack exit check $g_bRestart= " & $g_bRestart, $COLOR_DEBUG)

		If $g_bRestart Then ; If errors exist, then return
			$g_bIsClientSyncError = False ; reset fast restart flag to stop OOS mode, and rearm, collecting resources etc.
			Return False
		EndIf

	EndIf

	Return $bCanAttack

EndFunc   ;==>BB_PrepareSearch

; #FUNCTION# ====================================================================================================================
; Name ..........: BB_Attack
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Chackal++
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BB_Attack($Nside = 1, $SIDESNAMES = "TR|TL", $iTroopToDeploy = 4 )

	Local $aBB_DiamondTop[4]    = [430,  40 + $g_iBottomOffsetY, 0x294949, 10]
	Local $aBB_DiamondBottom[4] = [430, 570 + $g_iBottomOffsetY, 0x2B4847, 10]
	Local $aBB_DiamondLeft[4]   = [ 30, 340 + $g_iBottomOffsetY, 0x213E3E, 10]
	Local $aBB_DiamondRight[4]  = [820, 340 + $g_iBottomOffsetY, 0x2F5351, 10]
	Local $aBB_LineCenter[2]    = [  0,   0]
	Local $i                    = 0
	Local $iHalf                = 0
	Local $iRest                = 0
	Local $aDropCoord[2]        = [  0,   0]
	Local $aDropPointX[4]       = [  0,   0, 0x294949, 10]
	Local $aDropPointY[4]       = [  0,   0, 0x294949, 10]
	Local $iBB_MaxDrop          = 20

	If $iTroopToDeploy < 4 Then $iTroopToDeploy = 4
	If $iTroopToDeploy > 8 Then $iTroopToDeploy = 8

	$iHalf = INT( $iTroopToDeploy / 2 )
	$iRest = $iTroopToDeploy - ( $iHalf * 2 )
	$iHalf += $iRest

	$aBB_LineCenter[0] = INT( ( $aBB_DiamondTop[0] + $aBB_DiamondRight[0] ) / 2 )
	$aBB_LineCenter[1] = INT( ( $aBB_DiamondTop[1] + $aBB_DiamondRight[1] ) / 2 )
	$aDropCoord[0]     = INT( ( ( $aBB_LineCenter[0] - $aBB_DiamondTop[0] ) * 0.9 ) / $iHalf )
	$aDropCoord[1]     = INT( ( ( $aBB_LineCenter[1] - $aBB_DiamondTop[1] ) * 0.9 ) / $iHalf )

	KeepClicks()

	For $i = $iHalf To 1 Step -1
		$aDropPointX[0] = $aBB_LineCenter[0] + ( $i * $aDropCoord[0] )
		$aDropPointX[1] = $aBB_LineCenter[1] + ( $i * $aDropCoord[1] )
		$aDropPointY[0] = $aBB_LineCenter[0] - ( $i * $aDropCoord[0] )
		$aDropPointY[1] = $aBB_LineCenter[1] - ( $i * $aDropCoord[1] )
		If _Sleep($DELAYDROPTROOP1) Then Return
		AttackClick($aDropPointX[0], $aDropPointX[1], 1, SetSleep(0), 0, "#0000")
		If _Sleep($DELAYDROPTROOP1) Then Return
		AttackClick($aDropPointY[0], $aDropPointY[1], 1, SetSleep(0), 0, "#0000")
	Next

	ReleaseClicks()

	If _Sleep($DELAYRUNBOT1) Then Return

EndFunc   ;==>BB_Attack

; #FUNCTION# ====================================================================================================================
; Name ..........: BB_Mach_Slot
; Description ...: Battle Machine Slot Position
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BB_Mach_Slot()

	Local $i = 0
	Local $iSlot = -1

	Local $cPixColor = ''
	Local $cPixCheck = ''
	Local $bDegug    = True

	Local $aBMachine[4]      = [ 392, 580 + $g_iBottomOffsetY, 0x486E83, 20 ]
	Local $aBMachineColor[5] = [ 0x487188, 0x486E83, 0x486B7E, 0x486F81, 0x466F84 ]

	If _Sleep($DELAYRUNBOT3) Then Return

	; Find Battle Machine
	For $i = 0 To 2
		; Pos Next Slot
		If ($i > 0) Then
			$aBMachine[0] += 72
		EndIf
		$cPixColor = _GetPixelColor($aBMachine[0], $aBMachine[1], True)
		If _Sleep($DELAYRUNBOT3) Then Return
		IF BB_ColorCheck( $aBMachine, $aBMachineColor ) Then
			If $bDegug Then SetLog("BB: BM Found, color: " & $cPixColor & " Slot:[ " & String( $i + 5 ) & " ]", $COLOR_DEBUG)
			$iSlot = $i
			$i = 2
		EndIf
	Next
	Return $iSlot
EndFunc   ;==>BB_Mach_Slot

; #FUNCTION# ====================================================================================================================
; Name ..........: BB_Mach_Deploy
; Description ...: Battle Machine Deploy
; Syntax ........:
; Parameters ....: $iSlot = Slot Positon
; Return values .:
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BB_Mach_Deploy( $iSlot = -1 )

	Local $j = 0

	Local $cPixColor  = ''
	Local $cPixCheck  = ''

	Local $bDegug     = True
	Local $iWait128   = 128

	Local $aBMachine[4]      = [ 395, 580 + $g_iBottomOffsetY, 0x486E83, 20 ]
	Local $aBMachineColor[5] = [ 0x487188, 0x486E83, 0x486B7E, 0x486F81, 0x466F84 ]
	Local $aBatleEndColor[2] = [ 0x020202, 0x020202 ]

	Local $aDropBM[4]        = [ 270, 150 + $g_iBottomOffsetY, 0x335255, 20 ]

	If _Sleep($DELAYRUNBOT3) Then Return

	; If BM Present
	If ( $iSlot + 1 ) > 0 Then
		; Slot Pos
		$aBMachine[0] += ( $iSlot * 72 )
		; Deploy Battle Machine
		If $bDegug Then SetLog("BB: Click BM, color: " & $cPixColor & " Slot:[ " & String( $iSlot + 5 ) & " ]", $COLOR_DEBUG)
		KeepClicks()
		If _Sleep($DELAYDROPTROOP1) Then Return
		ClickP($aBMachine, 1, 0, "#0000")
		If _Sleep($DELAYDROPTROOP1) Then Return
		AttackClick($aDropBM[0], $aDropBM[1], 1, SetSleep(0), 0, "#0000")
		If _Sleep($DELAYDROPTROOP1) Then Return
		ReleaseClicks()
		If _Sleep($DELAYRUNBOT3) Then Return
		$cPixColor = _GetPixelColor($aBMachine[0], $aBMachine[1], True)
		$cPixCheck = $cPixColor
		If _Sleep($DELAYRUNBOT3) Then Return
		While $j < $iWait128
			$j += 1
			If _ColorCheck( $cPixColor, $cPixCheck, 20) Then
				ClickP($aBMachine, 1, 0, "#0000")
				BB_StatusMsg("Activate BM Power, color: " & $cPixCheck & " [ " & String( $j+1 ) & " ]")
			Else
				If _ColorCheck( $cPixCheck, Hex($aBatleEndColor[0], 6), 20) Then
					If $bDegug Then SetLog("BB: Battle end detected, color: " & $cPixCheck & " Slot:[ " & String( $iSlot + 5 ) & " ]", $COLOR_DEBUG)
					$j = $iWait128
				Else
					If Mod($j, 8) = 0 Then
						ClickP($aBMachine, 1, 0, "#0000")
					EndIf
				EndIf
			EndIf
			If _Sleep($DELAYRUNBOT1) Then Return
			$cPixCheck = _GetPixelColor($aBMachine[0], $aBMachine[1], True)
		WEnd
	EndIf

EndFunc   ;==>BB_Mach_Deploy
