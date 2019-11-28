; #FUNCTION# ====================================================================================================================
; Name ..........: applyConfig.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........: ApplyConfig_MOD()
; Parameters ....: $bRedrawAtExit = True, redraws bot window after config was applied
; Return values .: NA
; Author ........: MOD++
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;  «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»
;  MOD++
;  «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

Func ApplyConfig_MOD($TypeReadSave)
	Switch $TypeReadSave
		Case "Read"

			; --------------------------------------------
			; MOD++
			; --------------------------------------------
			; GUICtrlSetState($g_hChkBBIgnoreWalls, $g_bChkBBIgnoreWalls ? $GUI_CHECKED : $GUI_UNCHECKED)


		Case "Save"

			; --------------------------------------------
			; MOD++
			; --------------------------------------------
			; $g_bChkBBIgnoreWalls = (GUICtrlRead($g_hChkBBIgnoreWalls) = $GUI_CHECKED)

	EndSwitch
EndFunc   ;==>ApplyConfig_MOD
