; #FUNCTION# ====================================================================================================================
; Name ..........: readConfig.au3
; Description ...: Reads config file and sets variables
; Syntax ........: readConfig()
; Parameters ....: NA
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

Func ReadConfig_MOD()

	; Unit/Wave Factor - AiO++ Team
	IniReadS($g_iChkGiantSlot, $g_sProfileConfigPath, "SetSleep", "EnableGiantSlot", $g_iChkGiantSlot, "int")
	IniReadS($g_iCmbGiantSlot, $g_sProfileConfigPath, "SetSleep", "CmbGiantSlot", $g_iCmbGiantSlot ,"int")

	IniReadS($g_iChkUnitFactor, $g_sProfileConfigPath, "SetSleep", "EnableUnitFactor", $g_iChkUnitFactor, "int")
	IniReadS($g_iTxtUnitFactor, $g_sProfileConfigPath, "SetSleep", "UnitFactor", $g_iTxtUnitFactor, "int")

	IniReadS($g_iChkWaveFactor, $g_sProfileConfigPath, "SetSleep", "EnableWaveFactor", $g_iChkWaveFactor, "int")
	IniReadS($g_iTxtWaveFactor, $g_sProfileConfigPath, "SetSleep", "WaveFactor", $g_iTxtWaveFactor, "int")

	; Auto Dock, Hide Emulator & Bot - AiO++ Team
	IniReadS($g_bEnableAuto, $g_sProfileConfigPath, "general", "EnableAuto", $g_bEnableAuto, "Bool")
	IniReadS($g_iChkAutoDock, $g_sProfileConfigPath, "general", "AutoDock", $g_iChkAutoDock, "Bool")
	IniReadS($g_iChkAutoHideEmulator, $g_sProfileConfigPath, "general", "AutoHide", $g_iChkAutoHideEmulator, "Bool")
	IniReadS($g_iChkAutoMinimizeBot, $g_sProfileConfigPath, "general", "AutoMinimize", $g_iChkAutoMinimizeBot, "Bool")

	; Check Collector Outside - AiO++ Team
	IniReadS($g_bDBMeetCollOutside, $g_sProfileConfigPath, "search", "DBMeetCollOutside", $g_bDBMeetCollOutside, "Bool")
	IniReadS($g_iTxtDBMinCollOutsidePercent, $g_sProfileConfigPath, "search", "TxtDBMinCollOutsidePercent", $g_iTxtDBMinCollOutsidePercent, "int")

	IniReadS($g_bDBCollectorsNearRedline, $g_sProfileConfigPath, "search", "DBCollectorsNearRedline", $g_bDBCollectorsNearRedline, "int")
	IniReadS($g_iCmbRedlineTiles, $g_sProfileConfigPath, "search", "CmbRedlineTiles", $g_iCmbRedlineTiles, "int")

	IniReadS($g_bSkipCollectorCheck, $g_sProfileConfigPath, "search", "SkipCollectorCheck", $g_bSkipCollectorCheck, "int")
	IniReadS($g_iTxtSkipCollectorGold, $g_sProfileConfigPath, "search", "TxtSkipCollectorGold", $g_iTxtSkipCollectorGold, "int")
	IniReadS($g_iTxtSkipCollectorElixir, $g_sProfileConfigPath, "search", "TxtSkipCollectorElixir", $g_iTxtSkipCollectorElixir, "int")
	IniReadS($g_iTxtSkipCollectorDark, $g_sProfileConfigPath, "search", "TxtSkipCollectorDark", $g_iTxtSkipCollectorDark, "int")

	IniReadS($g_bSkipCollectorCheckTH, $g_sProfileConfigPath, "search", "SkipCollectorCheckTH", $g_bSkipCollectorCheckTH, "int")
	IniReadS($g_iCmbSkipCollectorCheckTH, $g_sProfileConfigPath, "search", "CmbSkipCollectorCheckTH", $g_iCmbSkipCollectorCheckTH, "int")

	; CSV Speed Deployment - AiO++ Team
	IniReadS($icmbCSVSpeed[$LB], $g_sProfileConfigPath, "CSV Speed", "cmbCSVSpeed[LB]", $icmbCSVSpeed[$LB], "int")
	IniReadS($icmbCSVSpeed[$DB], $g_sProfileConfigPath, "CSV Speed", "cmbCSVSpeed[DB]", $icmbCSVSpeed[$DB], "int")
	For $i = $DB To $LB
		If $icmbCSVSpeed[$i] < 5 Then
			$g_CSVSpeedDivider[$i] = 0.5 + $icmbCSVSpeed[$i] * 0.25        ; $g_CSVSpeedDivider = 0.5, 0.75, 1, 1.25, 1.5
		Else
			$g_CSVSpeedDivider[$i] = 2 + $icmbCSVSpeed[$i] - 5            ; $g_CSVSpeedDivider = 2, 3, 4, 5
		EndIf
	Next

	; Smart Train - AiO++ Team
	IniReadS($ichkSmartTrain, $g_sProfileConfigPath, "SmartTrain", "Enable", 0, "int")
	IniReadS($ichkPreciseTroops, $g_sProfileConfigPath, "SmartTrain", "PreciseTroops", 0, "int")
	IniReadS($ichkFillArcher, $g_sProfileConfigPath, "SmartTrain", "ChkFillArcher", 0, "int")
	IniReadS($iFillArcher, $g_sProfileConfigPath, "SmartTrain", "FillArcher", 5, "int")
	IniReadS($ichkFillEQ, $g_sProfileConfigPath, "SmartTrain", "FillEQ", 0, "int")
	$g_bChkMultiClick = (IniRead($g_sProfileConfigPath, "other", "ChkMultiClick", "0") = "1")

	; Bot Humanization - AiO++ Team
	IniReadS($g_ichkUseBotHumanization, $g_sProfileConfigPath, "Bot Humanization", "chkUseBotHumanization", $g_ichkUseBotHumanization, "int")
	IniReadS($g_ichkUseAltRClick, $g_sProfileConfigPath, "Bot Humanization", "chkUseAltRClick", $g_ichkUseAltRClick, "int")
	IniReadS($g_ichkCollectAchievements, $g_sProfileConfigPath, "Bot Humanization", "chkCollectAchievements", $g_ichkCollectAchievements, "int")
	IniReadS($g_ichkLookAtRedNotifications, $g_sProfileConfigPath, "Bot Humanization", "chkLookAtRedNotifications", $g_ichkLookAtRedNotifications, "int")
	For $i = 0 To 12
		IniReadS($g_iacmbPriority[$i], $g_sProfileConfigPath, "Bot Humanization", "cmbPriority[" & $i & "]", $g_iacmbPriority[$i], "int")
	Next
	For $i = 0 To 1
		IniReadS($g_iacmbMaxSpeed[$i], $g_sProfileConfigPath, "Bot Humanization", "cmbMaxSpeed[" & $i & "]", $g_iacmbMaxSpeed[$i], "int")
	Next
	For $i = 0 To 1
		IniReadS($g_iacmbPause[$i], $g_sProfileConfigPath, "Bot Humanization", "cmbPause[" & $i & "]", $g_iacmbPause[$i], "int")
	Next
	For $i = 0 To 1
		IniReadS($g_iahumanMessage[$i], $g_sProfileConfigPath, "Bot Humanization", "humanMessage[" & $i & "]", $g_iahumanMessage[$i])
	Next
	IniReadS($g_icmbMaxActionsNumber, $g_sProfileConfigPath, "Bot Humanization", "cmbMaxActionsNumber", $g_icmbMaxActionsNumber, "int")
	IniReadS($g_ichallengeMessage, $g_sProfileConfigPath, "Bot Humanization", "challengeMessage", $g_ichallengeMessage)

	; Request CC Troops at first - AiO++ Team
	$g_bReqCCFirst = (IniRead($g_sProfileConfigPath, "planned", "ReqCCFirst", 0) = 1)

	; Goblin XP - AiO++ Team
	IniReadS($ichkEnableSuperXP, $g_sProfileConfigPath, "GoblinXP", "EnableSuperXP", 0, "int")
	IniReadS($ichkSkipZoomOutXP, $g_sProfileConfigPath, "GoblinXP", "SkipZoomOutXP", 0, "int")
	IniReadS($irbSXTraining, $g_sProfileConfigPath, "GoblinXP", "SXTraining", 1, "int")
	IniReadS($itxtMaxXPtoGain, $g_sProfileConfigPath, "GoblinXP", "MaxXptoGain", 500, "int")
	IniReadS($ichkSXBK, $g_sProfileConfigPath, "GoblinXP", "SXBK", $eHeroNone)
	IniReadS($ichkSXAQ, $g_sProfileConfigPath, "GoblinXP", "SXAQ", $eHeroNone)
	IniReadS($ichkSXGW, $g_sProfileConfigPath, "GoblinXP", "SXGW", $eHeroNone)

	; ClanHop - AiO++ Team
	$g_bChkClanHop = (IniRead($g_sProfileConfigPath, "donate", "chkClanHop", "0") = "1")

	; Max Logout Time - AiO++ Team
	IniReadS($g_bTrainLogoutMaxTime, $g_sProfileConfigPath, "TrainLogout", "TrainLogoutMaxTime", False, "Bool")
	IniReadS($g_iTrainLogoutMaxTime, $g_sProfileConfigPath, "TrainLogout", "TrainLogoutMaxTimeTXT", 4, "int")

	; ExtendedAttackBar - Demen - AiO++ Team
	IniReadS($g_abChkExtendedAttackBar[$DB], $g_sProfileConfigPath, "attack", "ExtendedAttackBarDB", False, "Bool")
	IniReadS($g_abChkExtendedAttackBar[$LB], $g_sProfileConfigPath, "attack", "ExtendedAttackBarLB", False, "Bool")

	; CheckCC Troops - Demen - AiO++ Team
	IniReadS($g_bChkCC, $g_sProfileConfigPath, "CheckCC", "Enable", False, "Bool")
	IniReadS($g_iCmbCastleCapacityT, $g_sProfileConfigPath, "CheckCC", "Troop Capacity", 5, "int")
	IniReadS($g_iCmbCastleCapacityS, $g_sProfileConfigPath, "CheckCC", "Spell Capacity", 1, "int")

	For $i = 0 To $eTroopCount - 1
		$g_aiCCTroopsExpected[$i] = 0
		If $i >= $eSpellCount Then ContinueLoop
		$g_aiCCSpellsExpected[$i] = 0
	Next
	$g_bChkCCTroops = False

	For $i = 0 To 4
		Local $default = 19
		If $i > 2 Then $default = 9
		IniReadS($g_aiCmbCCSlot[$i], $g_sProfileConfigPath, "CheckCC", "ExpectSlot" & $i, $default, "int")
		IniReadS($g_aiTxtCCSlot[$i], $g_sProfileConfigPath, "CheckCC", "ExpectQty" & $i, 0, "int")
		If $g_aiCmbCCSlot[$i] > -1 And $g_aiCmbCCSlot[$i] < $default Then
			Local $j = $g_aiCmbCCSlot[$i]
			If $i <= 2 Then
				$g_aiCCTroopsExpected[$j] += $g_aiTxtCCSlot[$i]
			Else
				If $j > $eSpellFreeze Then $j += 1 ; exclude Clone Spell
				$g_aiCCSpellsExpected[$j] += $g_aiTxtCCSlot[$i]
			EndIf
			If $g_bChkCC Then $g_bChkCCTroops = True
		EndIf
	Next

	; Switch Profile - Demen - AiO++ Team
	Local $aiDefaultMax[4] = ["6000000", "6000000", "180000", "5000"]
	Local $aiDefaultMin[4] = ["1000000", "1000000", "20000", "3000"]
	For $i = 0 To 3
		IniReadS($g_abChkSwitchMax[$i], $g_sProfileConfigPath, "SwitchProfile", "SwitchProfileMax" & $i, False, "Bool")
		IniReadS($g_abChkSwitchMin[$i], $g_sProfileConfigPath, "SwitchProfile", "SwitchProfileMin" & $i, False, "Bool")
		IniReadS($g_aiCmbSwitchMax[$i], $g_sProfileConfigPath, "SwitchProfile", "TargetProfileMax" & $i, -1, "Int")
		IniReadS($g_aiCmbSwitchMin[$i], $g_sProfileConfigPath, "SwitchProfile", "TargetProfileMin" & $i, -1, "Int")

		IniReadS($g_abChkBotTypeMax[$i], $g_sProfileConfigPath, "SwitchProfile", "ChangeBotTypeMax" & $i, False, "Bool")
		IniReadS($g_abChkBotTypeMin[$i], $g_sProfileConfigPath, "SwitchProfile", "ChangeBotTypeMin" & $i, False, "Bool")
		IniReadS($g_aiCmbBotTypeMax[$i], $g_sProfileConfigPath, "SwitchProfile", "TargetBotTypeMax" & $i, 1, "Int")
		IniReadS($g_aiCmbBotTypeMin[$i], $g_sProfileConfigPath, "SwitchProfile", "TargetBotTypeMin" & $i, 2, "Int")

		IniReadS($g_aiConditionMax[$i], $g_sProfileConfigPath, "SwitchProfile", "ConditionMax" & $i, $aiDefaultMax[$i], "Int")
		IniReadS($g_aiConditionMin[$i], $g_sProfileConfigPath, "SwitchProfile", "ConditionMin" & $i, $aiDefaultMin[$i], "Int")
	Next

	; Check Grand Warden Mode - AiO++ Team
	IniReadS($g_bCheckWardenMode, $g_sProfileConfigPath, "other", "chkCheckWardenMode", False, "Bool")
	IniReadS($g_iCheckWardenMode, $g_sProfileConfigPath, "other", "cmbCheckWardenMode", 0, "int")

	; Switch Accounts - Demen - AiO++ Team
	ReadConfig_SwitchAcc()

	; Farm Schedule - Demen - AiO++ Team
	For $i = 0 To 7
		IniReadS($g_abChkSetFarm[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "ChkSetFarm" & $i, False, "Bool")

		IniReadS($g_aiCmbAction1[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbAction1" & $i, 0, "Int")
		IniReadS($g_aiCmbCriteria1[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbCriteria1" & $i, 0, "Int")
		IniReadS($g_aiTxtResource1[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "TxtResource1" & $i, "")
		IniReadS($g_aiCmbTime1[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbTime1" & $i, -1, "Int")

		IniReadS($g_aiCmbAction2[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbAction2" & $i, 0, "Int")
		IniReadS($g_aiCmbCriteria2[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbCriteria2" & $i, 0, "Int")
		IniReadS($g_aiTxtResource2[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "TxtResource2" & $i, "")
		IniReadS($g_aiCmbTime2[$i], $g_sProfilePath & "\Profile.ini", "FarmStrategy", "CmbTime2" & $i, -1, "Int")
	Next

	; Restart Search Legend league - AiO++ Team
	$g_bIsSearchTimeout = (IniRead($g_sProfileConfigPath, "other", "ChkSearchTimeout", "0") = "1")
	$g_iSearchTimeout = Int(IniRead($g_sProfileConfigPath, "other", "SearchTimeout", 10))

	; Stop on Low Battery - AiO++ Team
	$g_bStopOnBatt = (IniRead($g_sProfileConfigPath, "other", "ChkStopOnBatt", "0") = "1")
	$g_iStopOnBatt = Int(IniRead($g_sProfileConfigPath, "other", "StopOnBatt", 10))

EndFunc   ;==>ReadConfig_MOD

; Switch Accounts - Demen - AiO++ Team
Func ReadConfig_SwitchAcc()
	IniReadS($g_bChkSwitchAcc, $g_sProfilePath & "\Profile.ini", "SwitchAcc", "Enable", False, "Bool")
	IniReadS($g_bChkSmartSwitch, $g_sProfilePath & "\Profile.ini", "SwitchAcc", "SmartSwitch", False, "Bool")
	IniReadS($g_iTotalAcc, $g_sProfilePath & "\Profile.ini", "SwitchAcc", "Total Coc Account", -1, "int")
	For $i = 0 To 7
		IniReadS($g_abAccountNo[$i], $g_sProfilePath & "\Profile.ini", "SwitchAcc", "AccountNo." & $i, False, "Bool")
		IniReadS($g_aiProfileNo[$i], $g_sProfilePath & "\Profile.ini", "SwitchAcc", "ProfileNo." & $i, -1, "int")
		IniReadS($g_abDonateOnly[$i], $g_sProfilePath & "\Profile.ini", "SwitchAcc", "DonateOnly." & $i, False, "Bool")
	Next
	IniReadS($g_iTrainTimeToSkip, $g_sProfilePath & "\Profile.ini", "SwitchAcc", "Train Time To Skip", 1, "int")
EndFunc   ;==>ReadConfig_SwitchAcc
