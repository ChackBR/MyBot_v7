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
	Local $OkButtom[4] = [ 380, 510 + $g_iBottomOffsetY, 0xDFF885, 10 ]
	Local $bDegug = False

	If $g_bChkBB_DropTrophies Then
		; Click attack button and find a match
		If $g_iTxtBB_DropTrophies > 0 Then
			$i = $g_aiCurrentLootBB[$eLootTrophyBB] - $g_iTxtBB_DropTrophies
		Endif
		$i = 0 ; Disable it
		If $i > 0 Then 
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			BB_PrepareAttack()

			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			BB_Attack($Nside, $SIDESNAMES)

			Setlog("Will Wait for " & String( $DELAYCHECKOBSTACLES4 * 1.5 / 60000 ) & " minutes then continue", $COLOR_INFO)
			If _Sleep($DELAYCHECKOBSTACLES4 * 1.5 ) Then Return
			ClickP($OkButtom, 1, 0, "#0000")

			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			ClickP($aAway, 1, 0, "#0000")

			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			ClickP($aAway, 1, 0, "#0000")
		Else
			Setlog("Ignore BB Drop Trophies is under delelopment [ " & String( $g_iTxtBB_DropTrophies ) & " ]", $COLOR_INFO)
		EndIf
	Else
		Setlog("Ignore BB Drop Trophies [ " & String( $g_iTxtBB_DropTrophies ) & " ]", $COLOR_INFO)
	Endif

EndFunc	;==> BB_DropTrophies

Func ChkBB_DropTrophies()
	$g_bChkBB_DropTrophies = (GUICtrlRead($g_hChkBB_DropTrophies) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>ChkBB_DropTrophies

Func TxtBB_DropTrophies()
	$g_iTxtBB_DropTrophies = GUICtrlRead($g_hTxtBB_DropTrophies)
EndFunc   ;==>TxtBB_DropTrophies
