; #FUNCTION# ====================================================================================================================
; Name ..........: Profile Switch (#-25)
; Description ...: This file contains all functions of ProfileSwitch feature
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: AiO++ Team
; Modified ......: 03/09/2016
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......:  =====================================================================================================================

Func ProfileSwitch()

	For $i = 0 To 3
		If $g_abChkSwitchMax[$i] Or $g_abChkSwitchMin[$i] Or $g_abChkBotTypeMax[$i] Or $g_abChkBotTypeMin[$i] Then
			ExitLoop
		Else
			If $i = 3 Then Return
		EndIf
	Next

	Local $iSwitchToProfile = -1, $iChangeBotType = -1
	Local $asText[4] = ["Gold", "Elixir", "DarkE", "Trophy"]
	Local $bSwitchDone = False, $bChangBotTypeDone = False

	For $i = 0 To 3
		If $g_abChkSwitchMax[$i] Or $g_abChkBotTypeMax[$i] Then
			If Number($g_aiCurrentLoot[$i]) >= Number($g_aiConditionMax[$i]) Then
				SetLog("Village " & $asText[$i] & " detected above " & $asText[$i] & " Switch Condition: " & $g_aiCurrentLoot[$i] & "/" & $g_aiConditionMax[$i])
				If $g_abChkSwitchMax[$i] Then $iSwitchToProfile = $g_aiCmbSwitchMax[$i]
				If $g_abChkBotTypeMax[$i] Then $iChangeBotType = $g_aiCmbBotTypeMax[$i]
				ExitLoop
			EndIf
		EndIf
		If $g_abChkSwitchMin[$i] Or $g_abChkBotTypeMin[$i] Then
			If Number($g_aiCurrentLoot[$i]) < Number($g_aiConditionMin[$i]) And Number($g_aiCurrentLoot[$i]) > 1 Then
				SetLog("Village " & $asText[$i] & " detected below " & $asText[$i] & " Switch Condition: " & $g_aiCurrentLoot[$i] & "/" & $g_aiConditionMin[$i])
				If $g_abChkSwitchMin[$i] Then $iSwitchToProfile = $g_aiCmbSwitchMin[$i]
				If $g_abChkBotTypeMin[$i] Then $iChangeBotType = $g_aiCmbBotTypeMin[$i]
				ExitLoop
			EndIf
		EndIf
	Next

	If $iSwitchToProfile >= 0 Or $iChangeBotType >= 0 Then
		TrayTip(" Profile Switch Village Report!", "Gold: " & _NumberFormat($g_aiCurrentLoot[$eLootGold]) & "; Elixir: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & "; Dark: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir]) & "; Trophy: " & _NumberFormat($g_aiCurrentLoot[$eLootTrophy]), "", 0)

		If $iSwitchToProfile >= 0 Then
			; change profile in the account list
			If $g_bChkSwitchAcc Then
				If $iSwitchToProfile <> _GUICtrlComboBox_GetCurSel($g_ahCmbProfile[$g_iCurAccount]) Then
					_GUICtrlComboBox_SetCurSel($g_ahCmbProfile[$g_iCurAccount], $iSwitchToProfile)
					SetLog("Acc [" & $g_iCurAccount + 1 & "] is now matched with Profile: " & GUICtrlRead($g_ahCmbProfile[$g_iCurAccount]))
				EndIf
			EndIf
			; change profile in main tab bot
			If $iSwitchToProfile <> _GUICtrlComboBox_GetCurSel($g_hCmbProfile) Then
				_GUICtrlComboBox_SetCurSel($g_hCmbProfile, $iSwitchToProfile)
				SetLog("Switched to Profile: " & GUICtrlRead($g_hCmbProfile))
				$bSwitchDone = True
				If $g_bChkSwitchAcc Then $g_bReMatchAcc = True
			EndIf
		EndIf

		If $g_bChkSwitchAcc Then
			Switch $iChangeBotType
				Case 0 ; turn Off (idle)
					If GUICtrlRead($g_ahChkAccount[$g_iCurAccount]) = $GUI_CHECKED Then
						GUICtrlSetState($g_ahChkAccount[$g_iCurAccount], $GUI_UNCHECKED)
						chkAccount($g_iCurAccount)
						SetLog("Acc [" & $g_iCurAccount + 1 & "] is now turned off")
						$bChangBotTypeDone = True
					EndIf
				Case 1 ; turn Donate
					If GUICtrlRead($g_ahChkDonate[$g_iCurAccount]) = $GUI_UNCHECKED Then
						_GUI_Value_STATE("CHECKED", $g_ahChkAccount[$g_iCurAccount] & "#" & $g_ahChkDonate[$g_iCurAccount])
						SetLog("Acc [" & $g_iCurAccount + 1 & "] is now for Donating only")
						$bChangBotTypeDone = True
					EndIf
				Case 2 ; turn Active
					If GUICtrlRead($g_ahChkAccount[$g_iCurAccount]) = $GUI_UNCHECKED Or GUICtrlRead($g_ahChkDonate[$g_iCurAccount]) = $GUI_CHECKED Then
						GUICtrlSetState($g_ahChkAccount[$g_iCurAccount], $GUI_CHECKED)
						GUICtrlSetState($g_ahChkDonate[$g_iCurAccount], $GUI_UNCHECKED)
						SetLog("Acc [" & $g_iCurAccount + 1 & "] starts Farming now")
						$bChangBotTypeDone = True
					EndIf
			EndSwitch
			If $bChangBotTypeDone Then $g_bInitiateSwitchAcc = True
		EndIf

		If _Sleep(500) Then Return

		If $bSwitchDone Or $bChangBotTypeDone Then
			If $bSwitchDone Then
				cmbProfile()
				DisableGUI_AfterLoadNewProfile()
			Else
				saveConfig()
				readConfig()
				UpdateMultiStats()
			EndIf
			runBot()
		EndIf
	EndIf

EndFunc   ;==>ProfileSwitch
