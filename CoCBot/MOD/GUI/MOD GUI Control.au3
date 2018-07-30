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

Func Bridge()
    If _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropSidesDB) = 4 Then
            GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $GUI_UNCHECKED)
		    GUICtrlSetState($g_hChkRandomSpeedAtkDB, $GUI_UNCHECKED)
		    chkRandomSpeedAtkDB()
		For $i = $g_hChkRandomSpeedAtkDB To $g_hPicAttackNearDarkElixirDrillDB
			GUICtrlSetState($i, $GUI_DISABLE + $GUI_HIDE)
		Next
	Else
		For $i = $g_hChkRandomSpeedAtkDB To $g_hPicAttackNearDarkElixirDrillDB
			GUICtrlSetState($i, $GUI_ENABLE + $GUI_SHOW)
		Next
      chkSmartAttackRedAreaDB()
	EndIf

EndFunc   ;==>Bridge

; Unit/Wave Factor - Team AiO MOD++
Func cmbGiantSlot()
	If $g_iChkGiantSlot = 1 Then
		Switch _GUICtrlComboBox_GetCurSel($g_hCmbGiantSlot)
			Case 0
				$g_aiSlotsGiants = 0
			Case 1
				$g_aiSlotsGiants = 2
		EndSwitch
	Else
	LocaL $GiantComp = $g_ahTxtTrainArmyTroopCount[$eTroopGiant]
		If Number($GiantComp) >= 1 And Number($GiantComp) <= 7 Then $g_aiSlotsGiants = 1
		If Number($GiantComp) >= 8 Then $g_aiSlotsGiants = 2 ; will be split in 2 slots, when >16 or >=8 with FF
		If Number($GiantComp) >= 12 Then $g_aiSlotsGiants = 0 ; spread on vector, when >20 or >=12 with FF
	EndIf
EndFunc   ;==>cmbGiantSlot

Func chkGiantSlot()
	GUICtrlSetState($g_hCmbGiantSlot, GUICtrlRead($g_hChkGiantSlot) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkGiantSlot

Func chkUnitFactor()
	GUICtrlSetState($g_hTxtUnitFactor, GUICtrlRead($g_hChkUnitFactor) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkUnitFactor

Func chkWaveFactor()
	GUICtrlSetState($g_hTxtWaveFactor, GUICtrlRead($g_hChkWaveFactor) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkWaveFactor
