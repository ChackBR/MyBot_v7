; #FUNCTION# ====================================================================================================================
; Name ..........: BB_PrepareAttack
; Description ...: 
; Syntax ........: BB_PrepareAttack()
; Author ........: Chackall++
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BB_PrepareAttack() ; Click attack button and find a match

	Local $Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
	Local $cPixColor = ""
	Local $i = 0
	Local $j = 0
	Local $bCanAttack = False
	Local $TroopsOk[4] = [ 310, 355 + $g_iBottomOffsetY, 0xDAF482 , 10 ]

	Local $bDegug = False

	SetLog("BH: Going to Attack... [ " & String( $g_iTxtBB_DropTrophies ) & " ]", $COLOR_INFO)

	If IsMainPageBuilderBase() Then
		If $g_bUseRandomClick = False Then
			ClickP($aAttackButton, 1, 0, "#0149") ; Click Attack Button
		Else
			ClickR($aAttackButtonRND, $aAttackButton[0], $aAttackButton[1], 1, 0)
		EndIf
	EndIf
	If _Sleep($DELAYPREPARESEARCH1) Then Return

	; If $TroopsOk is ready
	$cPixColor = _GetPixelColor($TroopsOk[0], $TroopsOk[1], True)
	If _ColorCheck( $cPixColor, Hex($TroopsOk[2], 6), $TroopsOk[3]) Then
		SetLog("BB: Troops Not Ready [Stop Attack], code: " & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
	Else
		SetLog("BB: Troops Ready, code: " & $cPixColor & " [ " & String( $j ) & " ]", $COLOR_DEBUG)
		$bCanAttack = True
	EndIf

	If _Sleep($DELAYCHECKFULLARMY1) Then Return 

	If $bCanAttack Then 

		; If $aBB_FindMatchButton appear
		$cPixColor = _GetPixelColor($aBB_FindMatchButton[0], $aBB_FindMatchButton[1], True)
		If _ColorCheck( $cPixColor, Hex($aBB_FindMatchButton[2], 6), $aBB_FindMatchButton[3]) Then
			If $bDegug Then SetLog("BB: aBB_FindMatchButton, code: [ " & $cPixColor & " ][ " & String( $j ) & " ]", $COLOR_DEBUG)
			If _Sleep($DELAYCHECKFULLARMY1) Then Return 
			If $g_bUseRandomClick = False Then
				ClickP($aBB_FindMatchButton, 1, 0, "#0000") ;Click Find a Match Button
			Else
				ClickR($aBB_FindMatchButtonRND, $aFindMatchButton[0], $aFindMatchButton[1], 1, 0)
			EndIf
		Else
			SetLog("BB: Can't Find Match Buttom. Color Was: 0x" & $cPixColor, $COLOR_ERROR)
			$bCanAttack = False
		EndIf

		If _Sleep($DELAYPREPARESEARCH2) Then Return

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
; Author ........: 
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

	SetLog("BB: Attacking on a single side", $COLOR_INFO)

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
		ClickP($aDropPointX, 1, 0, "#0000") ; Drop Troop
		If _Sleep($DELAYDROPTROOP1) Then Return
		AttackClick($aDropPointY[0], $aDropPointY[1], 1, SetSleep(0), 0, "#0000")
		If _Sleep($DELAYDROPTROOP2) Then Return
	Next

	ReleaseClicks()

	If _Sleep($DELAYDROPTROOP2) Then Return

EndFunc   ;==>BB_Attack
