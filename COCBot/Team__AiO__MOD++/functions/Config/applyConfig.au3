; #FUNCTION# ====================================================================================================================
; Name ..........: applyConfig.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........: applyConfig()
; Parameters ....: $bRedrawAtExit = True, redraws bot window after config was applied
; Return values .: NA
; Author ........: AiO++ Team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;  «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»
;  AiO++ Team
;  «»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

Func ApplyConfig_MOD($TypeReadSave)
	Switch $TypeReadSave
		Case "Read"

			; Classic 4Fingers - AiO++ Team
			cmbStandardDropSidesAB()
			Bridge()

			; Unit/Wave Factor - AiO++ Team
			GUICtrlSetState($g_hChkGiantSlot, $g_iChkGiantSlot = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbGiantSlot, $g_iCmbGiantSlot)
			chkGiantSlot()

			GUICtrlSetState($g_hChkUnitFactor, $g_iChkUnitFactor = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtUnitFactor, $g_iTxtUnitFactor)
			chkUnitFactor()

			GUICtrlSetState($g_hChkWaveFactor, $g_iChkWaveFactor = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtWaveFactor, $g_iTxtWaveFactor)
			chkWaveFactor()

			; Auto Dock, Hide Emulator & Bot - AiO++ Team
			GUICtrlSetState($g_hChkEnableAuto, $g_bEnableAuto = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkEnableAuto()
			If $g_iChkAutoDock Then
				GUICtrlSetState($g_hChkAutoDock, $GUI_CHECKED)
				GUICtrlSetState($g_hChkAutoHideEmulator, $GUI_UNCHECKED)
			EndIf
			If $g_iChkAutoHideEmulator Then
				GUICtrlSetState($g_hChkAutoHideEmulator, $GUI_CHECKED)
				GUICtrlSetState($g_hChkAutoDock, $GUI_UNCHECKED)
			EndIf
			btnEnableAuto()
			GUICtrlSetState($g_hChkAutoMinimizeBot, $g_iChkAutoMinimizeBot = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkHideWhenMinimized()

			; Check Collector Outside - AiO++ Team
			GUICtrlSetState($g_hChkDBMeetCollOutside, $g_bDBMeetCollOutside = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtDBMinCollOutsidePercent, $g_iTxtDBMinCollOutsidePercent)

			GUICtrlSetState($g_hChkDBCollectorsNearRedline, $g_bDBCollectorsNearRedline = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbRedlineTiles, $g_iCmbRedlineTiles)

			GUICtrlSetState($g_hChkSkipCollectorCheck, $g_bSkipCollectorCheck = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtSkipCollectorGold, $g_iTxtSkipCollectorGold)
			GUICtrlSetData($g_hTxtSkipCollectorElixir, $g_iTxtSkipCollectorElixir)
			GUICtrlSetData($g_hTxtSkipCollectorDark, $g_iTxtSkipCollectorDark)

			GUICtrlSetState($g_hChkSkipCollectorCheckTH, $g_bSkipCollectorCheckTH = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbSkipCollectorCheckTH, $g_iCmbSkipCollectorCheckTH)
			chkDBMeetCollOutside()

			; CSV Speed Deployment - AiO++ Team
			_GUICtrlComboBox_SetCurSel($cmbCSVSpeed[$LB], $icmbCSVSpeed[$LB])
			_GUICtrlComboBox_SetCurSel($cmbCSVSpeed[$DB], $icmbCSVSpeed[$DB])

			; Switch Accounts - Demen - AiO++ Team
			GUICtrlSetState($g_hChkSwitchAcc, $g_bChkSwitchAcc ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSmartSwitch, $g_bChkSmartSwitch ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbTotalAccount, $g_iTotalAcc - 1)
			For $i = 0 To 7
				GUICtrlSetState($g_ahChkAccount[$i], $g_abAccountNo[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_ahCmbProfile[$i], $g_aiProfileNo[$i])
				GUICtrlSetState($g_ahChkDonate[$i], $g_abDonateOnly[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			_GUICtrlComboBox_SetCurSel($g_hCmbTrainTimeToSkip, $g_iTrainTimeToSkip)
			chkSwitchAcc()

			; Smart Train - Demen - AiO++ Team
			GUICtrlSetState($g_hchkSmartTrain, $ichkSmartTrain = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hchkPreciseTroops, $ichkPreciseTroops = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hchkFillArcher, $ichkFillArcher = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_htxtFillArcher, $iFillArcher)
			GUICtrlSetState($g_hchkFillEQ, $ichkFillEQ = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkSmartTrain()
			GUICtrlSetState($g_hChkMultiClick, $g_bChkMultiClick ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkUseQTrain()

			; Bot Humanization - AiO++ Team
			GUICtrlSetState($g_chkUseBotHumanization, $g_ichkUseBotHumanization = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkUseAltRClick, $g_ichkUseAltRClick = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkCollectAchievements, $g_ichkCollectAchievements = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_chkLookAtRedNotifications, $g_ichkLookAtRedNotifications = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkUseBotHumanization()
			For $i = 0 To 12
				_GUICtrlComboBox_SetCurSel($g_acmbPriority[$i], $g_iacmbPriority[$i])
			Next
			For $i = 0 To 1
				_GUICtrlComboBox_SetCurSel($g_acmbMaxSpeed[$i], $g_iacmbMaxSpeed[$i])
			Next
			For $i = 0 To 1
				_GUICtrlComboBox_SetCurSel($g_acmbPause[$i], $g_iacmbPause[$i])
			Next
			For $i = 0 To 1
				GUICtrlSetData($g_ahumanMessage[$i], $g_iahumanMessage[$i])
			Next
			_GUICtrlComboBox_SetCurSel($g_cmbMaxActionsNumber, $g_icmbMaxActionsNumber)
			GUICtrlSetData($g_challengeMessage, $g_ichallengeMessage)
			cmbStandardReplay()
			cmbWarReplay()

			; Request CC Troops at first - AiO++ Team
			GUICtrlSetState($chkReqCCFirst, $g_bReqCCFirst = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)

			; Goblin XP - AiO++ Team
			GUICtrlSetState($chkEnableSuperXP, $ichkEnableSuperXP = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)

			chkEnableSuperXP()

			GUICtrlSetState($chkSkipZoomOutXP, $ichkSkipZoomOutXP = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($rbSXTraining, ($irbSXTraining = 1) ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($rbSXIAttacking, ($irbSXTraining = 2) ? $GUI_CHECKED : $GUI_UNCHECKED)

			GUICtrlSetData($txtMaxXPtoGain, $itxtMaxXPtoGain)

			GUICtrlSetState($chkSXBK, $ichkSXBK = $eHeroKing ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkSXAQ, $ichkSXAQ = $eHeroQueen ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($chkSXGW, $ichkSXGW = $eHeroWarden ? $GUI_CHECKED : $GUI_UNCHECKED)

			; ClanHop - AiO++ Team
			GUICtrlSetState($g_hChkClanHop, $g_bChkClanHop ? $GUI_CHECKED : $GUI_UNCHECKED)

			; Max Logout Time - AiO++ Team
			GUICtrlSetState($g_hChkTrainLogoutMaxTime, $g_bTrainLogoutMaxTime = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkTrainLogoutMaxTime()
			GUICtrlSetData($g_hTxtTrainLogoutMaxTime, $g_iTrainLogoutMaxTime)

			; ExtendedAttackBar - Demen - AiO++ Team
			GUICtrlSetState($g_hChkExtendedAttackBarDB, $g_abChkExtendedAttackBar[$DB] ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkExtendedAttackBarLB, $g_abChkExtendedAttackBar[$LB] ? $GUI_CHECKED : $GUI_UNCHECKED)

			; CheckCC Troops - Demen - AiO++ Team
			GUICtrlSetState($g_hChkTroopsCC, $g_bChkCC ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbCastleCapacityT, $g_iCmbCastleCapacityT)
			_GUICtrlComboBox_SetCurSel($g_hCmbCastleCapacityS, $g_iCmbCastleCapacityS)
			For $i = 0 To 4
				_GUICtrlComboBox_SetCurSel($g_ahCmbCCSlot[$i], $g_aiCmbCCSlot[$i])
				GUICtrlSetData($g_ahTxtCCSlot[$i], $g_aiTxtCCSlot[$i])
			Next
			GUIControlCheckCC()

			; Switch Profile - Demen - AiO++ Team
			For $i = 0 To 3
				GUICtrlSetState($g_ahChk_SwitchMax[$i], $g_abChkSwitchMax[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				GUICtrlSetState($g_ahChk_SwitchMin[$i], $g_abChkSwitchMin[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_ahCmb_SwitchMax[$i], $g_aiCmbSwitchMax[$i])
				_GUICtrlComboBox_SetCurSel($g_ahCmb_SwitchMin[$i], $g_aiCmbSwitchMin[$i])

				GUICtrlSetState($g_ahChk_BotTypeMax[$i], $g_abChkBotTypeMax[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				GUICtrlSetState($g_ahChk_BotTypeMin[$i], $g_abChkBotTypeMin[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_ahCmb_BotTypeMax[$i], $g_aiCmbBotTypeMax[$i])
				_GUICtrlComboBox_SetCurSel($g_ahCmb_BotTypeMin[$i], $g_aiCmbBotTypeMin[$i])

				GUICtrlSetData($g_ahTxt_ConditionMax[$i], $g_aiConditionMax[$i])
				GUICtrlSetData($g_ahTxt_ConditionMin[$i], $g_aiConditionMin[$i])
			Next
			chkSwitchProfile()
			chkSwitchBotType()

			; Check Grand Warden Mode - AiO++ Team
			GUICtrlSetState($g_hChkCheckWardenMode, $g_bCheckWardenMode ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkCheckWardenMode()
			_GUICtrlComboBox_SetCurSel($g_hCmbCheckWardenMode, $g_iCheckWardenMode)

			; Farm Schedule - Demen - AiO++ Team
			For $i = 0 To 7
				GUICtrlSetState($g_ahChkSetFarm[$i], $g_abChkSetFarm[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)

				_GUICtrlComboBox_SetCurSel($g_ahCmbAction1[$i], $g_aiCmbAction1[$i])
				_GUICtrlComboBox_SetCurSel($g_ahCmbCriteria1[$i], $g_aiCmbCriteria1[$i])
				GUICtrlSetData($g_ahTxtResource1[$i], $g_aiTxtResource1[$i])
				_GUICtrlComboBox_SetCurSel($g_ahCmbTime1[$i], $g_aiCmbTime1[$i])

				_GUICtrlComboBox_SetCurSel($g_ahCmbAction2[$i], $g_aiCmbAction2[$i])
				_GUICtrlComboBox_SetCurSel($g_ahCmbCriteria2[$i], $g_aiCmbCriteria2[$i])
				GUICtrlSetData($g_ahTxtResource2[$i], $g_aiTxtResource2[$i])
				_GUICtrlComboBox_SetCurSel($g_ahCmbTime2[$i], $g_aiCmbTime2[$i])
			Next

			; Switch Accounts - Demen - AiO++ Team
			ApplyConfig_SwitchAcc("Read")

			; Restart Search Legend league - AiO++ Team
			GUICtrlSetState($g_hChkSearchTimeout, $g_bIsSearchTimeout ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtSearchTimeout, $g_iSearchTimeout)
			chkSearchTimeout()

			; Stop on Low Battery - AiO++ Team
			GUICtrlSetState($g_hChkStopOnBatt, $g_bStopOnBatt ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtStopOnBatt, $g_iStopOnBatt)
			chkStopOnBatt()

		Case "Save"

			; Unit/Wave Factor - AiO++ Team
			$g_iChkGiantSlot = GUICtrlRead($g_hChkGiantSlot) = $GUI_CHECKED ? 1 : 0
			$g_iCmbGiantSlot = _GUICtrlComboBox_GetCurSel($g_hCmbGiantSlot)

			$g_iChkUnitFactor = GUICtrlRead($g_hChkUnitFactor) = $GUI_CHECKED ? 1 : 0
			$g_iTxtUnitFactor = GUICtrlRead($g_hTxtUnitFactor)

			$g_iChkWaveFactor = GUICtrlRead($g_hChkWaveFactor) = $GUI_CHECKED ? 1 : 0
			$g_iTxtWaveFactor = GUICtrlRead($g_hTxtWaveFactor)

			; Auto Dock, Hide Emulator & Bot - AiO++ Team
			$g_bEnableAuto = (GUICtrlRead($g_hChkEnableAuto) = $GUI_CHECKED)
			$g_iChkAutoDock = (GUICtrlRead($g_hChkAutoDock) = $GUI_CHECKED)
			$g_iChkAutoHideEmulator = (GUICtrlRead($g_hChkAutoHideEmulator) = $GUI_CHECKED)
			$g_iChkAutoMinimizeBot = (GUICtrlRead($g_hChkAutoMinimizeBot) = $GUI_CHECKED)

			; Check Collector Outside - AiO++ Team
			$g_bDBMeetCollOutside = GUICtrlRead($g_hChkDBMeetCollOutside) = $GUI_CHECKED
			$g_iTxtDBMinCollOutsidePercent = GUICtrlRead($g_hTxtDBMinCollOutsidePercent)

			$g_bDBCollectorsNearRedline = GUICtrlRead($g_hChkDBCollectorsNearRedline) = $GUI_CHECKED ? 1 : 0
			$g_iCmbRedlineTiles = _GUICtrlComboBox_GetCurSel($g_hCmbRedlineTiles)

			$g_bSkipCollectorCheck = GUICtrlRead($g_hChkSkipCollectorCheck) = $GUI_CHECKED ? 1 : 0
			$g_iTxtSkipCollectorGold = GUICtrlRead($g_hTxtSkipCollectorGold)
			$g_iTxtSkipCollectorElixir = GUICtrlRead($g_hTxtSkipCollectorElixir)
			$g_iTxtSkipCollectorDark = GUICtrlRead($g_hTxtSkipCollectorDark)

			$g_bSkipCollectorCheckTH = GUICtrlRead($g_hChkSkipCollectorCheckTH) = $GUI_CHECKED ? 1 : 0
			$g_iCmbSkipCollectorCheckTH = _GUICtrlComboBox_GetCurSel($g_hCmbSkipCollectorCheckTH)

			; CSV Deploy Speed - AiO++ Team
			$icmbCSVSpeed[$LB] = _GUICtrlComboBox_GetCurSel($cmbCSVSpeed[$LB])
			$icmbCSVSpeed[$DB] = _GUICtrlComboBox_GetCurSel($cmbCSVSpeed[$DB])

			; Smart Train - AiO++ Team
			$ichkSmartTrain = GUICtrlRead($g_hchkSmartTrain) = $GUI_CHECKED ? 1 : 0
			$ichkPreciseTroops = GUICtrlRead($g_hchkPreciseTroops) = $GUI_CHECKED ? 1 : 0
			$ichkFillArcher = GUICtrlRead($g_hchkFillArcher) = $GUI_CHECKED ? 1 : 0
			$iFillArcher = GUICtrlRead($g_htxtFillArcher)
			$ichkFillEQ = GUICtrlRead($g_hchkFillEQ) = $GUI_CHECKED ? 1 : 0
			$g_bChkMultiClick = (GUICtrlRead($g_hChkMultiClick) = $GUI_CHECKED)

			; Bot Humanization - AiO++ Team
			$g_ichkUseBotHumanization = GUICtrlRead($g_chkUseBotHumanization) = $GUI_CHECKED ? 1 : 0
			$g_ichkUseAltRClick = GUICtrlRead($g_chkUseAltRClick) = $GUI_CHECKED ? 1 : 0
			$g_ichkCollectAchievements = GUICtrlRead($g_chkCollectAchievements) = $GUI_CHECKED ? 1 : 0
			$g_ichkLookAtRedNotifications = GUICtrlRead($g_chkLookAtRedNotifications) = $GUI_CHECKED ? 1 : 0
			For $i = 0 To 12
				$g_iacmbPriority[$i] = _GUICtrlComboBox_GetCurSel($g_acmbPriority[$i])
			Next
			For $i = 0 To 1
				$g_iacmbMaxSpeed[$i] = _GUICtrlComboBox_GetCurSel($g_acmbMaxSpeed[$i])
			Next
			For $i = 0 To 1
				$g_iacmbPause[$i] = _GUICtrlComboBox_GetCurSel($g_acmbPause[$i])
			Next
			For $i = 0 To 1
				$g_iahumanMessage[$i] = GUICtrlRead($g_ahumanMessage[$i])
			Next
			$g_icmbMaxActionsNumber = _GUICtrlComboBox_GetCurSel($g_icmbMaxActionsNumber)
			$g_ichallengeMessage = GUICtrlRead($g_challengeMessage)

			; Request CC Troops at first - Demen - AiO++ Team
			$g_bReqCCFirst = GUICtrlRead($chkReqCCFirst) = $GUI_CHECKED ? 1 : 0

			; Goblin XP - AiO++ Team
			$ichkEnableSuperXP = GUICtrlRead($chkEnableSuperXP) = $GUI_CHECKED ? 1 : 0
			$ichkSkipZoomOutXP = GUICtrlRead($chkSkipZoomOutXP) = $GUI_CHECKED ? 1 : 0
			$irbSXTraining = GUICtrlRead($rbSXTraining) = $GUI_CHECKED ? 1 : 2
			$ichkSXBK = (GUICtrlRead($chkSXBK) = $GUI_CHECKED) ? $eHeroKing : $eHeroNone
			$ichkSXAQ = (GUICtrlRead($chkSXAQ) = $GUI_CHECKED) ? $eHeroQueen : $eHeroNone
			$ichkSXGW = (GUICtrlRead($chkSXGW) = $GUI_CHECKED) ? $eHeroWarden : $eHeroNone
			$itxtMaxXPtoGain = Int(GUICtrlRead($txtMaxXPtoGain))

			; ClanHop - AiO++ Team
			$g_bChkClanHop = (GUICtrlRead($g_hChkClanHop) = $GUI_CHECKED)

			; Max logout time - AiO++ Team
			$g_bTrainLogoutMaxTime = GUICtrlRead($g_hChkTrainLogoutMaxTime) = $GUI_CHECKED ? True : False
			$g_iTrainLogoutMaxTime = GUICtrlRead($g_hTxtTrainLogoutMaxTime)

			; ExtendedAttackBar - Demen - AiO++ Team
			$g_abChkExtendedAttackBar[$DB] = GUICtrlRead($g_hChkExtendedAttackBarDB) = $GUI_CHECKED ? True : False
			$g_abChkExtendedAttackBar[$LB] = GUICtrlRead($g_hChkExtendedAttackBarLB) = $GUI_CHECKED ? True : False

			; CheckCC Troops - Demen - AiO++ Team
			$g_bChkCC = GUICtrlRead($g_hChkTroopsCC) = $GUI_CHECKED ? True : False
			$g_iCmbCastleCapacityT = _GUICtrlComboBox_GetCurSel($g_hCmbCastleCapacityT)
			$g_iCmbCastleCapacityS = _GUICtrlComboBox_GetCurSel($g_hCmbCastleCapacityS)
			For $i = 0 To 4
				$g_aiCmbCCSlot[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbCCSlot[$i])
				$g_aiTxtCCSlot[$i] = GUICtrlRead($g_ahTxtCCSlot[$i])
			Next

			; Switch Profile - Demen - AiO++ Team
			For $i = 0 To 3
				$g_abChkSwitchMax[$i] = GUICtrlRead($g_ahChk_SwitchMax[$i]) = $GUI_CHECKED
				$g_abChkSwitchMin[$i] = GUICtrlRead($g_ahChk_SwitchMin[$i]) = $GUI_CHECKED
				$g_aiCmbSwitchMax[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_SwitchMax[$i])
				$g_aiCmbSwitchMin[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_SwitchMin[$i])

				$g_abChkBotTypeMax[$i] = GUICtrlRead($g_ahChk_BotTypeMax[$i]) = $GUI_CHECKED
				$g_abChkBotTypeMin[$i] = GUICtrlRead($g_ahChk_BotTypeMin[$i]) = $GUI_CHECKED
				$g_aiCmbBotTypeMax[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_BotTypeMax[$i])
				$g_aiCmbBotTypeMin[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmb_BotTypeMin[$i])

				$g_aiConditionMax[$i] = GUICtrlRead($g_ahTxt_ConditionMax[$i])
				$g_aiConditionMin[$i] = GUICtrlRead($g_ahTxt_ConditionMin[$i])
			Next

			; Check Grand Warden Mode - AiO++ Team
			$g_bCheckWardenMode = (GUICtrlRead($g_hChkCheckWardenMode) = $GUI_CHECKED)
			$g_iCheckWardenMode = _GUICtrlComboBox_GetCurSel($g_hCmbCheckWardenMode)

			; Farm Schedule - Demen - AiO++ Team
			For $i = 0 To 7
				$g_abChkSetFarm[$i] = GUICtrlRead($g_ahChkSetFarm[$i]) = $GUI_CHECKED

				$g_aiCmbAction1[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbAction1[$i])
				$g_aiCmbCriteria1[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbCriteria1[$i])
				$g_aiTxtResource1[$i] = GUICtrlRead($g_ahTxtResource1[$i])
				$g_aiCmbTime1[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbTime1[$i])

				$g_aiCmbAction2[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbAction2[$i])
				$g_aiCmbCriteria2[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbCriteria2[$i])
				$g_aiTxtResource2[$i] = GUICtrlRead($g_ahTxtResource2[$i])
				$g_aiCmbTime2[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbTime2[$i])
			Next

			; Switch Accounts - Demen - AiO++ Team
			ApplyConfig_SwitchAcc("Save")

			; Restart Search Legend league - AiO++ Team
			$g_bIsSearchTimeout = (GUICtrlRead($g_hChkSearchTimeout) = $GUI_CHECKED)
			$g_iSearchTimeout = GUICtrlRead($g_hTxtSearchTimeout)

			; Stop on Low Battery - AiO++ Team
			$g_bStopOnBatt = (GUICtrlRead($g_hChkStopOnBatt) = $GUI_CHECKED)
			$g_iStopOnBatt = GUICtrlRead($g_hTxtStopOnBatt)

	EndSwitch
EndFunc   ;==>ApplyConfig_MOD

; Switch Accounts - Demen - AiO++ Team
Func ApplyConfig_SwitchAcc($TypeReadSave)
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkSwitchAcc, $g_bChkSwitchAcc ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSmartSwitch, $g_bChkSmartSwitch ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbTotalAccount, $g_iTotalAcc - 1)
			For $i = 0 To 7
				GUICtrlSetState($g_ahChkAccount[$i], $g_abAccountNo[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_ahCmbProfile[$i], $g_aiProfileNo[$i])
				GUICtrlSetState($g_ahChkDonate[$i], $g_abDonateOnly[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			_GUICtrlComboBox_SetCurSel($g_hCmbTrainTimeToSkip, $g_iTrainTimeToSkip)
			chkSwitchAcc()
		Case "Save"
			$g_bChkSwitchAcc = GUICtrlRead($g_hChkSwitchAcc) = $GUI_CHECKED
			$g_bChkSmartSwitch = GUICtrlRead($g_hChkSmartSwitch) = $GUI_CHECKED
			$g_iTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; at least 2 accounts needed
			For $i = 0 To 7
				$g_abAccountNo[$i] = GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED
				$g_aiProfileNo[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbProfile[$i])
				$g_abDonateOnly[$i] = GUICtrlRead($g_ahChkDonate[$i]) = $GUI_CHECKED
			Next
			$g_iTrainTimeToSkip = _GUICtrlComboBox_GetCurSel($g_hCmbTrainTimeToSkip)
	EndSwitch
EndFunc   ;==>ApplyConfig_SwitchAcc
