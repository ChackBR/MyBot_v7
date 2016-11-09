; #FUNCTION# ====================================================================================================================
; Name ..........: GUI Control - Mod
; Description ...: Extended GUI Control for Mod
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Classic FourFingers
Func cmbDeployAB() ; avoid conflict between FourFinger and SmartAttack - DEMEN
   If _GUICtrlCombobox_GetCurSel($cmbDeployAB) = 4 Then
	  GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_UNCHECKED)
	  GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_DISABLE)
   Else
	  GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_ENABLE)
   EndIf
EndFunc

Func cmbDeployDB() ; avoid conflict between FourFinger and SmartAttack - DEMEN
   If _GUICtrlCombobox_GetCurSel($cmbDeployDB) = 4 Then
	  GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_UNCHECKED)
	  GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_DISABLE)
   Else
	  GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_ENABLE)
   EndIf
EndFunc

; SmartZap Settings
Func chkSmartLightSpell()
    If GUICtrlRead($chkSmartLightSpell) = $GUI_CHECKED Then
        GUICtrlSetState($chkSmartZapDB, $GUI_ENABLE)
        GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_ENABLE)
        GUICtrlSetState($txtMinDark, $GUI_ENABLE)
        $ichkSmartZap = 1
    Else
        GUICtrlSetState($chkSmartZapDB, $GUI_DISABLE)
        GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_DISABLE)
        GUICtrlSetState($txtMinDark, $GUI_DISABLE)
        $ichkSmartZap = 0
    EndIf
EndFunc   ;==>chkSmartLightSpell

Func chkSmartZapDB()
    If GUICtrlRead($chkSmartZapDB) = $GUI_CHECKED Then
        $ichkSmartZapDB = 1
    Else
        $ichkSmartZapDB = 0
    EndIf
EndFunc   ;==>chkSmartZapDB

Func chkSmartZapSaveHeroes()
    If GUICtrlRead($chkSmartZapSaveHeroes) = $GUI_CHECKED Then
        $ichkSmartZapSaveHeroes = 1
    Else
        $ichkSmartZapSaveHeroes = 0
    EndIf
EndFunc   ;==>chkSmartZapSaveHeroes

Func txtMinDark()
	$itxtMinDE = GUICtrlRead($txtMinDark)
EndFunc   ;==>txtMinDark

; CSV Deployment Speed Mod
Func sldSelectedSpeedDB()
	$isldSelectedCSVSpeed[$DB] = GUICtrlRead($sldSelectedSpeedDB)
	Local $speedText = $iCSVSpeeds[$isldSelectedCSVSpeed[$DB]] & "x";
	IF $isldSelectedCSVSpeed[$DB] = 4 Then $speedText = "Normal"
	GUICtrlSetData($lbltxtSelectedSpeedDB, $speedText & " speed")
EndFunc   ;==>sldSelectedSpeedDB

Func sldSelectedSpeedAB()
	$isldSelectedCSVSpeed[$LB] = GUICtrlRead($sldSelectedSpeedAB)
	Local $speedText = $iCSVSpeeds[$isldSelectedCSVSpeed[$LB]] & "x";
	IF $isldSelectedCSVSpeed[$LB] = 4 Then $speedText = "Normal"
	GUICtrlSetData($lbltxtSelectedSpeedAB, $speedText & " speed")

EndFunc   ;==>sldSelectedSpeedAB

; Attack Now Button (Useful for CSV Testing) By MR.ViPeR ;;;;
Func AttackNowDB()
	If $RunState Then Return
	Sleep(2000)
	$iMatchMode = $DB			; Select Dead Base As Attack Type
	$iAtkAlgorithm[$DB] = 1		; Select Scripted Attack
	$scmbDBScriptName = GuiCtrlRead($cmbScriptNameDB)		; Select Scripted Attack File From The Combo Box, Cos it wasn't refreshing until pressing Start button
	$iMatchMode = $DB			; Select Dead Base As Attack Type
	$RunState = True
	PrepareAttack($iMatchMode)	; lol I think it's not needed for Scripted attack, But i just Used this to be sure of my code
	Attack()					; Fire xD
	$RunState = False
EndFunc   ;==>AttackNow Dead Base

Func AttackNowAB()
	If $RunState Then Return
	Sleep(2000)
	$iMatchMode = $LB			; Select Live Base As Attack Type
	$iAtkAlgorithm[$LB] = 1		; Select Scripted Attack
	$scmbABScriptName = GuiCtrlRead($cmbScriptNameAB)		; Select Scripted Attack File From The Combo Box, Cos it wasn't refreshing until pressing Start button
	$iMatchMode = $LB			; Select Live Base As Attack Type
	$RunState = True
	PrepareAttack($iMatchMode)	; lol I think it's not needed for Scripted attack, But i just Used this to be sure of my code
	Attack()					; Fire xD
	$RunState = False
EndFunc   ;==>AttackNow Live Base
