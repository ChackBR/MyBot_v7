; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control MOD
; Description ...: This file controls the "MOD" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Team AiO MOD++ (2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Smart Train - Persian MOD (#-13)
Func chkSmartTrain()
	If GUICtrlRead($g_hchkSmartTrain) = $GUI_CHECKED Then
		If GUICtrlRead($g_hChkUseQuickTrain) = $GUI_UNCHECKED Then _GUI_Value_STATE("ENABLE", $g_hchkPreciseTroops)
		_GUI_Value_STATE("ENABLE", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
		chkPreciseTroops()
		chkFillArcher()
	Else
		_GUI_Value_STATE("DISABLE", $g_hchkPreciseTroops & "#" & $g_hchkFillArcher & "#" & $g_htxtFillArcher & "#" & $g_hchkFillEQ)
		_GUI_Value_STATE("UNCHECKED", $g_hchkPreciseTroops & "#" & $g_hchkFillArcher & "#" & $g_hchkFillEQ)
	EndIf
EndFunc   ;==>chkSmartTrain

Func chkPreciseTroops()
	If GUICtrlRead($g_hchkPreciseTroops) = $GUI_CHECKED Then
		_GUI_Value_STATE("DISABLE", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
		_GUI_Value_STATE("UNCHECKED", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
		chkFillArcher()
	Else
		_GUI_Value_STATE("ENABLE", $g_hchkFillArcher & "#" & $g_hchkFillEQ)
	EndIf
EndFunc   ;==>chkPreciseTroops

Func chkFillArcher()
	If GUICtrlRead($g_hchkFillArcher) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_htxtFillArcher)
	Else
		_GUI_Value_STATE("DISABLE", $g_htxtFillArcher)
	EndIf
EndFunc   ;==>chkFillArcher
