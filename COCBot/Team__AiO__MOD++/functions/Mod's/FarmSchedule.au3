; #FUNCTION# ====================================================================================================================
; Name ..........: Farm Schedule (#-27)
; Description ...:
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: Demen
; Modified ......: AiO++ Team
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......:  =====================================================================================================================

Func CheckFarmSchedule()

	If Not $g_bChkSwitchAcc Then Return

	Static $iStartHour = @HOUR
	If $g_bFirstStart And $iStartHour = -1 Then $iStartHour = @HOUR
	Local $bActionDone = False
	Local $sText = ""
	Setlog("Checking Farm Schedule...")

	For $i = 0 To 7
		If $i > $g_iTotalAcc Then ExitLoop
		If $g_abChkSetFarm[$i] Then
			Local $iAction = -1

			; Check timing schedule
			Local $iTimer1 = -1, $iTimer2 = -1
			If $g_aiCmbAction1[$i] >= 1 And $g_aiCmbCriteria1[$i] = 5 And $g_aiCmbTime1[$i] >= 0 Then
				$iTimer1 = $g_aiCmbTime1[$i]
				If $iTimer1 <= @HOUR Then $iAction = $g_aiCmbAction1[$i] - 1
			EndIf
			If $g_aiCmbAction2[$i] >= 1 And $g_aiCmbCriteria2[$i] = 5 And $g_aiCmbTime2[$i] >= 0 Then
				$iTimer2 = $g_aiCmbTime2[$i]
				If $iTimer2 <= @HOUR And ($iTimer2 > $iTimer1 Or $iAction = -1) Then $iAction = $g_aiCmbAction2[$i] - 1
			EndIf

 			If $g_bDebugSetlog Then Setlog($i + 1 & ". $iTimer1 = " & $iTimer1 & ", $iTimer2 = " & $iTimer2 & ", $iStartHour = " & $iStartHour & ", $iAction = " & $iAction, $COLOR_DEBUG)

			If $iStartHour >= 0 And $iStartHour >= _Min($iTimer1, $iTimer2) Then
				If $iStartHour < _Max($iTimer1, $iTimer2) Then
					If @HOUR >= _Max($iTimer1, $iTimer2) Then $iStartHour = -1
				Else
					If @HOUR < $iStartHour And @HOUR >= 0 Then $iStartHour = -1
				EndIf
				If $iStartHour > -1 And $iAction >= 0 Then $iAction = -1
				If $g_bDebugSetlog Then SetLog("   $iStartHour = " & $iStartHour & ", $iAction = " & $iAction, $COLOR_DEBUG)
			EndIf

			; Check resource criteria for current account
			If $i = $g_iCurAccount And $iAction = -1 Then
				Local $asText[4] = ["Gold", "Elixir", "DarkE", "Trophy"]
				While 1
					If $g_aiCmbAction1[$i] >= 1 And $g_aiCmbCriteria1[$i] >= 1 And $g_aiCmbCriteria1[$i] <= 4 Then
						For $r = 1 To 4
							If $g_aiCmbCriteria1[$i] = $r And Number($g_aiCurrentLoot[$r - 1]) >= Number($g_aiTxtResource1[$i]) Then
								Setlog("  Village " & $asText[$r - 1] & " detected above 1st criterium: " & $g_aiTxtResource1[$i])
								$iAction = $g_aiCmbAction1[$i] - 1
								ExitLoop 2
							EndIf
						Next
					EndIf
					If $g_aiCmbAction2[$i] >= 1 And $g_aiCmbCriteria2[$i] >= 1 And $g_aiCmbCriteria2[$i] <= 4 Then
						For $r = 1 To 4
							If $g_aiCmbCriteria2[$i] = $r And Number($g_aiCurrentLoot[$r - 1]) < Number($g_aiTxtResource2[$i]) And Number($g_aiCurrentLoot[$r - 1]) > 1 Then
								Setlog("  Village " & $asText[$r - 1] & " detected below 2nd criterium: " & $g_aiTxtResource2[$i])
								$iAction = $g_aiCmbAction2[$i] - 1
								ExitLoop 2
							EndIf
						Next
					EndIf
					ExitLoop
				WEnd
			EndIf

			; Action
			Switch $iAction
				Case 0 ; turn Off (idle)
					If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED Then
						GUICtrlSetState($g_ahChkAccount[$i], $GUI_UNCHECKED)
						chkAccount($i)
						$bActionDone = True
						If $i = $g_iCurAccount Then $g_bInitiateSwitchAcc = True
						SetLog("  Acc [" & $i + 1 & "] turned OFF")
						SetSwitchAccLog("   Acc. " & $i + 1 & " now Idle", $COLOR_BLUE)
					EndIf
				Case 1 ; turn Donate
					If GUICtrlRead($g_ahChkDonate[$i]) = $GUI_UNCHECKED Then
						_GUI_Value_STATE("CHECKED", $g_ahChkAccount[$i] & "#" & $g_ahChkDonate[$i])
						$bActionDone = True
						If $i = $g_iCurAccount Then $g_bInitiateSwitchAcc = True
						SetLog("  Acc [" & $i + 1 & "] turned ON for Donating")
						SetSwitchAccLog("   Acc. " & $i + 1 & " now Donate", $COLOR_BLUE)
					EndIf
				Case 2 ; turn Active
					If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_UNCHECKED Or GUICtrlRead($g_ahChkDonate[$i]) = $GUI_CHECKED Then
						GUICtrlSetState($g_ahChkAccount[$i], $GUI_CHECKED)
						GUICtrlSetState($g_ahChkDonate[$i], $GUI_UNCHECKED)
						$bActionDone = True
						If $i = $g_iCurAccount Then $g_bInitiateSwitchAcc = True
						SetLog("  Acc [" & $i + 1 & "] turned ON for Farming")
						SetSwitchAccLog("   Acc. " & $i + 1 & " now Active", $COLOR_BLUE)
					EndIf
			EndSwitch
		EndIf
	Next

	If $bActionDone Then
		SaveConfig_SwitchAcc()
		ReadConfig_SwitchAcc()
		UpdateMultiStats()
	EndIf

	If _Sleep(500) Then Return

	If $g_bInitiateSwitchAcc Then runBot()

EndFunc   ;==>CheckFarmSchedule
