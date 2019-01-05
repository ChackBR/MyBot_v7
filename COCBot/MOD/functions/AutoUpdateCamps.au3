; #FUNCTION# ====================================================================================================================
; Name ..........: OCRbypass / RK Auto Update camps v.0.7 (#ID135-)
; Description ...: ByPass camps. capacity auto update
; Author ........: Boludoz (25/6/2018) Rulesss (1/7/2018)
; Modified ......: Boludoz (1/7/2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: getArmyCapacityOnTrainTroops(48, 160), _getArmyCapacityOnTrainTroops(48, 160)
; ===============================================================================================================================

Func _getArmyCapacityOnTrainTroops($x_start, $y_start) ;  -> Gets quantity of troops in army Window
    Local $aTempResult[3] = [0, 0, 0]
	Local $aResult[3] = [0, 0, 0]
	$aResult[0] = getOcrAndCapture("coc-NewCapacity", $x_start, $y_start, 67, 14, True)

	If StringInStr($aResult[0], "#") Then
		Local $aTempResult = StringSplit($aResult[0], "#", $STR_NOCOUNT)
		$aResult[1] = Number($aTempResult[0])
		$aResult[2] = Number($aTempResult[1])
		$aResult[2] = $aResult[2] / 2
		; SG Machine
		;If $aResult[2] <= 2 Then
		;GUICtrlSetData($g_hTxtTotalMachine, $aResult[2])
		;$g_iTotalMachine = $aResult[2]
		; Spell
		If $aResult[2] <= 11 Then
			If $g_iTotalSpellValue < $aResult[2] Then
				GUICtrlSetData($g_hTxtTotalCountSpell, $aResult[2])
				$g_iTotalSpellValue = $aResult[2]
			EndIf
		; Army
		ElseIf $aResult[2] >= 15 Then
			If $g_iTotalCampForcedValue < $aResult[2] Then
				GUICtrlSetData($g_hTxtTotalCampForced, $aResult[2])
				$g_iTotalCampForcedValue = $aResult[2]
			EndIf

			Local $dbg = False
			If $dbg Then 
				Setlog("AutoCamp() - Max Troops: " & String($aResult[0]), $COLOR_ERROR)
				Setlog("AutoCamp() - Max Speels: " & String($g_iTotalSpellValue), $COLOR_ERROR)
				Setlog("AutoCamp() - Max InCamp: " & String($g_iTotalCampForcedValue), $COLOR_ERROR)
			EndIf
				
			lblTotalCountTroop1()
		EndIf	
	Else
		SetLog("DEBUG | ERROR on GetCurrentArmy", $COLOR_ERROR)
	EndIf

	Return $aResult[0]
EndFunc   ;==>_getArmyCapacityOnTrainTroops

; INFO ! ======================
	;		; full & forced Total Camp values
	;		$g_iTrainArmyFullTroopPct = Int(GUICtrlRead($g_hTxtFullTroop))
	;		$g_bTotalCampForced = (GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED)
	;		$g_iTotalCampForcedValue = Int(GUICtrlRead($g_hTxtTotalCampForced))
	;		; spell capacity and forced flag
	;		$g_iTotalSpellValue = GUICtrlRead($g_hTxtTotalCountSpell)
	;		$g_bForceBrewSpells = (GUICtrlRead($g_hChkForceBrewBeforeAttack) = $GUI_CHECKED)
; ============

Func CheckAutoCamp() ; Only first Run
	Click(30, 584)
	If _Sleep(1000) Then Return
	Click(407, 132)
	If _Sleep(1000) Then return
	Local $NewSpellOCR = getArmyCapacityOnTrainTroops(48, 160) ; Check spell camps
	Click(280, 132)
	If _Sleep(1000) Then Return
	Local $NewCampOCR = getArmyCapacityOnTrainTroops(48, 160) ; Check army camps
	Click(825, 122)
	If _Sleep(1000) Then Return
EndFunc   ;==>CheckAutoCamp

Func chkAutoCamp()
	$g_iChkAutoCamp = ( GUICtrlRead($g_hChkAutoCamp) = $GUI_CHECKED )
EndFunc ;==>chkAutoCamp