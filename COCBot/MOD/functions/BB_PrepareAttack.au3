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
	Local $bCanAttack
	Local $cPixColor = ""
	Local $aTroopsOk[4]     = [ 310, 355 + $g_iBottomOffsetY, 0xDAF482 , 10 ]
	Local $aLootAvail[4]    = [ 515, 620 + $g_iBottomOffsetY, 0x707371, 20 ]
	Local $aLootColor[2]    = [ 0x707371, 0x585B5A ]
	Local $aBMachineWait[4] = [ 157, 337 + $g_iBottomOffsetY, 0xFFFFFF, 20 ]
	Local $Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check

	Local $bDegug = True

	SetLog("BH: Going to Attack... [ " & String( $g_iTxtBB_DropTrophies ) & " ]", $COLOR_INFO)

	If IsMainPageBuilderBase() Then
		ClickP($aAttackButton, 1, 0, "#0149") ; Click Attack Button
	EndIf
	If _Sleep($DELAYRUNBOT1) Then Return

	; If $aTroopsOk is ready
	$cPixColor = _GetPixelColor($aTroopsOk[0], $aTroopsOk[1], True)
	If _ColorCheck( $cPixColor, Hex($aTroopsOk[2], 6), 20) Then
		SetLog("BB: Troops Not Ready [Stop Attack], code: " & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
		$bCanAttack = False
	Else
		SetLog("BB: Troops Ready, code: " & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
		$bCanAttack = True
	EndIf

	If _Sleep($DELAYRUNBOT3) Then Return 

	If $bCanAttack Then 
		; If Loot Available
		If $g_bChkBB_OnlyWithLoot Then
			$cPixColor = _GetPixelColor($aLootAvail[0], $aLootAvail[1], True)
			If _ColorCheck( $cPixColor, Hex($aLootAvail[2], 6), 20) Then
				If $bDegug Then SetLog("BB: Loot available. Will continue, code: 0x" & $cPixColor, $COLOR_DEBUG)
			Else
				If $bDegug Then SetLog("BB: No Loot available for now, code: 0x" & $cPixColor, $COLOR_DEBUG)
				$bCanAttack = False
			EndIf
		Endif
	EndIf

	If $bCanAttack Then 
		; If BMachine Available
		If $g_bChkBB_OnlyWithLoot Then
			$cPixColor = _GetPixelColor($aBMachineWait[0], $aBMachineWait[1], True)
			If BB_ColorCheck( $cPixColor, $aLootColor) Then
				If $bDegug Then SetLog("BB: BM not available, wait, code: 0x" & $cPixColor, $COLOR_DEBUG)
				$bCanAttack = False
			Else
				If $bDegug Then SetLog("BB: BMachine ok [or not exists], code: 0x" & $cPixColor, $COLOR_DEBUG)
			EndIf
		Endif
	EndIf

	If _Sleep($DELAYRUNBOT1) Then Return 

	If $bCanAttack Then 

		; If $aBB_FindMatchButton appear
		$cPixColor = _GetPixelColor($aBB_FindMatchButton[0], $aBB_FindMatchButton[1], True)
		If _ColorCheck( $cPixColor, Hex($aBB_FindMatchButton[2], 6), 20) Then
			If $bDegug Then SetLog("BB: Click Find Match Button, code: [ " & $cPixColor & " ][ " & String( $j ) & " ]", $COLOR_DEBUG)
			If _Sleep($DELAYRUNBOT1) Then Return 
			If $g_bUseRandomClick = False Then
				ClickP($aBB_FindMatchButton, 1, 0, "#0000") ;Click Find a Match Button
			Else
				ClickR($aBB_FindMatchButtonRND, $aFindMatchButton[0], $aFindMatchButton[1], 1, 0)
			EndIf
		Else
			SetLog("BB: Can't Find Match Buttom. Color Was: 0x" & $cPixColor, $COLOR_ERROR)
			$bCanAttack = False
		EndIf

		If _Sleep($DELAYRUNBOT1) Then Return

		checkAttackDisable($g_iTaBChkAttack, $Result) ;See If TakeABreak msg on screen

		If $g_bDebugSetlog Then SetDebugLog("BB: PrepareAttack exit check $g_bRestart= " & $g_bRestart, $COLOR_DEBUG)

		If $g_bRestart Then ; If we errors, then return
			$g_bIsClientSyncError = False ; reset fast restart flag to stop OOS mode, and rearm, collecting resources etc.
			Return
		EndIf

	Endif

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

	Local $aBB_DiamondTop[4]    = [440,  30 + $g_iBottomOffsetY, 0x294949, 10]
	Local $aBB_DiamondBottom[4] = [440, 730 + $g_iBottomOffsetY, 0x2B4847, 10]
	Local $aBB_DiamondLeft[4]   = [ 30, 330 + $g_iBottomOffsetY, 0x213E3E, 10]
	Local $aBB_DiamondRight[4]  = [830, 330 + $g_iBottomOffsetY, 0x2F5351, 10]
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

	If _Sleep($DELAYRUNBOT3) Then Return

EndFunc   ;==>BB_Attack

; #FUNCTION# ====================================================================================================================
; Name ..........: BB_Mach_Deploy
; Description ...: Battle Machine Deploy
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

Func BB_Mach_Deploy()

	Local $i = 0
	Local $j = 0

	Local $cPixColor  = ''
	Local $cPixCheck  = ''

	Local $bBMFound
	Local $bDegug     = True

	Local $aBMachine[4]      = [ 356, 580 + $g_iBottomOffsetY, 0x486E83, 20 ]
	Local $aBMachineColor[5] = [ 0x487188, 0x486E83, 0x486B7E, 0x486F81, 0x466F84 ]
	Local $aBatleEndColor[2] = [ 0x020202, 0x020202 ]

	Local $aDropBM[4]        = [ 200, 200 + $g_iBottomOffsetY, 0x335255, 20 ]

	If _Sleep($DELAYRUNBOT3) Then Return

	Setlog("BB: Drop Battle Machine", $COLOR_GREEN)

	; Deploy Battle Machine
	For $i = 0 to 2
		; Pos Next Slot
		If ($i > 0) Then 
			$aBMachine[0] += 72
		EndIf
		$j = 0
		$cPixColor = _GetPixelColor($aBMachine[0], $aBMachine[1], True)
		If _Sleep($DELAYRUNBOT1) Then Return
		IF BB_ColorCheck( $aBMachine, $aBMachineColor ) Then
			If $bDegug Then SetLog("BB: Click BM, code: 0x" & $cPixColor & " Slot:[ " & String( $i + 5 ) & " ]", $COLOR_DEBUG)
			$bBMFound = True
		Else
			SetLog("BB: Can't Click BM, code: 0x" & $cPixColor & " Slot:[ " & String( $i + 5 ) & " ]", $COLOR_DEBUG)
			$bBMFound = False
		EndIF
		If $bBMFound Then
			KeepClicks()
			If _Sleep($DELAYDROPTROOP1) Then Return
			ClickP($aBMachine, 1, 0, "#0000")
			If _Sleep($DELAYDROPTROOP1) Then Return
			AttackClick($aDropBM[0], $aDropBM[1], 1, SetSleep(0), 0, "#0000")
			If _Sleep($DELAYDROPTROOP1) Then Return
			ReleaseClicks()
			If _Sleep($DELAYRUNBOT3) Then Return
			$j = 0
			$cPixColor = _GetPixelColor($aBMachine[0], $aBMachine[1], True)
			If _Sleep($DELAYRUNBOT3) Then Return
			While $j < 64
				$cPixCheck = _GetPixelColor($aBMachine[0], $aBMachine[1], True)
				If (  $cPixCheck = $cPixColor ) Then
					ClickP($aBMachine, 1, 0, "#0000")
					_GUICtrlStatusBar_SetTextEx($g_hStatusBar, "BB: Activate BM Power, code: 0x" & $cPixColor & " [ " & String( $j +1 ) & " ]")
				Endif
				If _ColorCheck( $cPixCheck, Hex($aBatleEndColor[0], 6), 20) Then
					If $bDegug Then SetLog("BB: Battle end detected, code: 0x" & $cPixCheck & " Slot:[ " & String( $i + 5 ) & " ]", $COLOR_DEBUG)
					$j = 64
				Else
					$j += 1
				Endif
				If _Sleep($DELAYRUNBOT3) Then Return
			WEnd
			ExitLoop
		EndIf
	Next

EndFunc   ;==>BB_Mach_Deploy
