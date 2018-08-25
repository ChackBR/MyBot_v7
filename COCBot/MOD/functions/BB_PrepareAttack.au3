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

	SetLog("BH: Going to Attack... [ " & String( $g_iTxtBB_DropTrophies ) & " ]", $COLOR_INFO)

	If IsMainPageBuilderBase() Then
		If $g_bUseRandomClick = False Then
			ClickP($aAttackButton, 1, 0, "#0149") ; Click Attack Button
		Else
			ClickR($aAttackButtonRND, $aAttackButton[0], $aAttackButton[1], 1, 0)
		EndIf
	EndIf
	If _Sleep($DELAYPREPARESEARCH1) Then Return

	If $g_bUseRandomClick = False Then
		ClickP($aBB_FindMatchButton, 1, 0, "#0150") ;Click Find a Match Button
	Else
		ClickR($aBB_FindMatchButtonRND, $aFindMatchButton[0], $aFindMatchButton[1], 1, 0)
	EndIf
	If _Sleep($DELAYPREPARESEARCH2) Then Return

	checkAttackDisable($g_iTaBChkAttack, $Result) ;See If TakeABreak msg on screen

	If $g_bDebugSetlog Then SetDebugLog("BB: PrepareAttack exit check $g_bRestart= " & $g_bRestart, $COLOR_DEBUG)

	If $g_bRestart Then ; If we errors, then return
		$g_bIsClientSyncError = False ; reset fast restart flag to stop OOS mode, and rearm, collecting resources etc.
		Return
	EndIf

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

Func BB_Attack($Nside = 1, $SIDESNAMES = "TR|TL" )

	Local $aBB_DiamondTop[4]    = [390, 140 + $g_iBottomOffsetY, 0x294949, 10]
	Local $aBB_DiamondBottom[4] = [390, 610 + $g_iBottomOffsetY, 0x2B4847, 10]
	Local $aBB_DiamondLeft[4]   = [ 65, 380 + $g_iBottomOffsetY, 0x213E3E, 10]
	Local $aBB_DiamondRight[4]  = [700, 380 + $g_iBottomOffsetY, 0x2F5351, 10]
	Local $aBB_LineCenter[2]    = [  0,   0]
	Local $i                    = 0
	Local $iTroopToDeploy       = 16
	Local $aDropCoord[2]        = [  0,   0]
	Local $aDropPointX[4]       = [  0,   0, 0x294949, 10]
	Local $aDropPointY[4]       = [  0,   0, 0x294949, 10]
	Local $iBB_MaxDrop          = 20

	Setlog(" ====== BB Attack ====== ", $COLOR_INFO)

	SetLog("BB: Attacking on a single side", $COLOR_INFO)

	$aBB_LineCenter[0] = INT( ( $aBB_DiamondTop[0] + $aBB_DiamondRight[0] ) / ( $iTroopToDeploy / 2 ) )
	$aBB_LineCenter[1] = INT( ( $aBB_DiamondTop[1] + $aBB_DiamondRight[1] ) / ( $iTroopToDeploy / 2 ) )
	$aDropCoord[0]     = INT( ( ( $aBB_LineCenter[0] - $aBB_DiamondTop[0] ) * 0.9 ) / $iTroopToDeploy )
	$aDropCoord[1]     = INT( ( ( $aBB_LineCenter[1] - $aBB_DiamondTop[1] ) * 0.9 ) / $iTroopToDeploy )

	For $i = $iTroopToDeploy To 1 Step -1
		$aDropPointX[0] = $aBB_LineCenter[0] + ( $i * $aDropCoord[0] )
		$aDropPointX[1] = $aBB_LineCenter[1] + ( $i * $aDropCoord[1] )
		$aDropPointY[0] = $aBB_LineCenter[0] - ( $i * $aDropCoord[0] )
		$aDropPointY[1] = $aBB_LineCenter[1] - ( $i * $aDropCoord[1] )
		ClickP($aDropPointX, 1, 0, "#0000") ; Drop Troop
		If _Sleep($DELAYDROPTROOP1) Then Return
		ClickP($aDropPointY, 1, 0, "#0000") ; Drop Troop
		If _Sleep($DELAYDROPTROOP2) Then Return
	Next

	If _Sleep($DELAYALGORITHM_ALLTROOPS4) Then Return

	SetLog("Finished Attacking, waiting for the battle to end")

EndFunc   ;==>BB_Attack
