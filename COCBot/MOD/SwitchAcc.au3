; #FUNCTION# ====================================================================================================================
; Name ..........: Switch CoC Account
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: DEMEN (based on original code & idea of NDTHUAN)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func InitiateSwitchAcc() ; Checking profiles setup in Mybot, First matching CoC Acc with current profile, Reset all Timers relating to Switch Acc Mode.

	$ProfileList = _GUICtrlComboBox_GetListArray($g_hCmbProfile)
	$nTotalProfile = _Min(8, _GUICtrlComboBox_GetCount($g_hCmbProfile))
	$nCurProfile = _GUICtrlComboBox_GetCurSel($g_hCmbProfile) + 1

	$aActiveProfile = _ArrayFindAll($aProfileType, $eActive)
	$aDonateProfile = _ArrayFindAll($aProfileType, $eDonate)

	Setlog($nTotalProfile & " profiles available")

	For $i = 0 To _Min($nTotalProfile - 1, 7)
		Switch $aProfileType[$i]
			Case $eActive
				Setlog("Profile [" & $i + 1 & "]: " & $ProfileList[$i + 1] & " - Active - Match with Account [" & $aMatchProfileAcc[$i] & "]")
			Case $eDonate
				Setlog("Profile [" & $i + 1 & "]: " & $ProfileList[$i + 1] & " - Donate - Match with Account [" & $aMatchProfileAcc[$i] & "]")
			Case Else
				Setlog("Profile [" & $i + 1 & "]: " & $ProfileList[$i + 1] & " - Idle   - Match with Account [" & $aMatchProfileAcc[$i] & "]")
		EndSwitch
	Next

	If $icmbTotalCoCAcc <> -1 Then
		$nTotalCoCAcc = $icmbTotalCoCAcc
		Setlog("Total CoC Account is declared: " & $nTotalCoCAcc)
	Else
		$nTotalCoCAcc = 8
		Setlog("Total CoC Account has not declared, default: " & $nTotalCoCAcc)
	EndIf

	; Locating CoC Accounts
	If _ArrayMax($aAccPosY) > 0 Then
		Local $MaxIdx = _ArrayMaxIndex($aAccPosY)
		For $i = 1 To $nTotalCoCAcc
			If $aAccPosY[$i - 1] <= 0 Then $aAccPosY[$i - 1] = $aAccPosY[$MaxIdx] + 73 * ($i - 1 - $MaxIdx)
			Setlog("  >>> Y-coordinate Acc No. " & $i & " is located at: " & $aAccPosY[$i - 1])
		Next
	EndIf

	$i = $nCurProfile
	While $aProfileType[$i - 1] = $eIdle Or $aProfileType[$i - 1] = $eNull ;	Current Profile is idle
		If $i < $nTotalProfile Then
			$i += 1
		Else
			$i = 1
		EndIf
		If $aProfileType[$i - 1] <> $eIdle And $aProfileType[$i - 1] <> $eNull Then
			Setlog("Try to avoid Idle Profile. Switching to Profile [" & $i & "] - CoC Acc [" & $aMatchProfileAcc[$i - 1] & "]")
			_GUICtrlComboBox_SetCurSel($g_hCmbProfile, $i - 1)
			cmbProfile()
			DisableGUI_AfterLoadNewProfile()
			ExitLoop
		EndIf
	WEnd

	$nCurProfile = _GUICtrlComboBox_GetCurSel($g_hCmbProfile) + 1

	For $i = 0 To _Min($nTotalProfile - 1, 7)
		$aTimerStart[$i] = 0
		$aTimerEnd[$i] = 0
		$aRemainTrainTime[$i] = 0
		$aUpdateRemainTrainTime[$i] = 0

		$g_aLabTimeAcc[$i] = 0
		$g_aLabTimerStart[$i] = 0
	Next

	If $aProfileType[$nCurProfile - 1] = $eActive Then
		GUICtrlSetData($g_lblTroopsTime[$nCurProfile - 1], "Looting")
		GUICtrlSetBkColor($g_lblTroopsTime[$nCurProfile - 1], $COLOR_GREEN)
		GUICtrlSetColor($g_lblTroopsTime[$nCurProfile - 1], $COLOR_WHITE)
	ElseIf $aProfileType[$nCurProfile - 1] = $eDonate Then
		GUICtrlSetData($g_lblTroopsTime[$nCurProfile - 1], "Donating")
		GUICtrlSetBkColor($g_lblTroopsTime[$nCurProfile - 1], $COLOR_GREEN)
		GUICtrlSetColor($g_lblTroopsTime[$nCurProfile - 1], $COLOR_WHITE)
	EndIf

	Setlog("Matching CoC Account with Bot Profile. Trying to Switch Account", $COLOR_BLUE)

	SwitchCOCAcc()
	If $bReMatchAcc = False Then runBot()

EndFunc   ;==>InitiateSwitchAcc

Func CheckWaitHero() ; get hero regen time remaining if enabled
	Local $iActiveHero
	Local $aHeroResult[3]
	$g_aiTimeTrain[2] = 0

	$aHeroResult = getArmyHeroTime("all")

	If @error Then
		Setlog("getArmyHeroTime return error, exit Check Hero's wait time!", $COLOR_RED)
		Return ; if error, then quit Check Hero's wait time
	EndIf

	If $aHeroResult = "" Then
		Setlog("You have no hero or bad TH level detection Pls manually locate TH", $COLOR_RED)
		Return
	EndIf

;	Setlog("Getting Hero's recover time, King: " & $aHeroResult[0] & " m, Queen: " & $aHeroResult[1] & " m, GW: " & $aHeroResult[2] & " m.")

	If _Sleep($DELAYRESPOND) Then Return
	If $aHeroResult[0] > 0 Or $aHeroResult[1] > 0 Or $aHeroResult[2] > 0 Then ; check if hero is enabled to use/wait and set wait time
		For $pTroopType = $eKing To $eWarden ; check all 3 hero
			For $pMatchMode = $DB To $g_iModeCount - 1 ; check all attack modes
				$iActiveHero = -1
				If IsSpecialTroopToBeUsed($pMatchMode, $pTroopType) And _
						BitOR($g_aiAttackUseHeroes[$pMatchMode], $g_aiSearchHeroWaitEnable[$pMatchMode]) = $g_aiAttackUseHeroes[$pMatchMode] Then ; check if Hero enabled to wait
					$iActiveHero = $pTroopType - $eKing ; compute array offset to active hero
				EndIf
				If $iActiveHero <> -1 And $aHeroResult[$iActiveHero] > 0 Then ; valid time?
					; check exact time & existing time is less than new time
					If $g_aiTimeTrain[2] < $aHeroResult[$iActiveHero] Then
						$g_aiTimeTrain[2] = $aHeroResult[$iActiveHero] ; use exact time
					EndIf
				EndIf
			Next
			If _Sleep($DELAYRESPOND) Then Return
		Next
	EndIf

;	Setlog("Hero recover wait time: " & $g_aiTimeTrain[2] & " minute(s)", $COLOR_BLUE)

EndFunc   ;==>CheckWaitHero

Func MinRemainTrainAcc($Writelog = True, $ExcludeProfile = 0) ; Check remain training time of all Active accounts and return the minimum remain training time

	If $ExcludeProfile = 0 Then
		$aRemainTrainTime[$nCurProfile - 1] = _ArrayMax($g_aiTimeTrain) ; remaintraintime of current account - in minutes
		$aTimerStart[$nCurProfile - 1] = TimerInit() ; start counting elapse of training time of current account
	EndIf

	For $i = 0 To $nTotalProfile - 1
		If $i = $ExcludeProfile - 1 Then ContinueLoop
		If $aProfileType[$i] = $eActive Then ;	Only check Active profiles
			If $aTimerStart[$i] <> 0 Then
				$aTimerEnd[$i] = Round(TimerDiff($aTimerStart[$i]) / 1000 / 60, 2) ; 	counting elapse of training time of an account from last army checking - in minutes
				$aUpdateRemainTrainTime[$i] = $aRemainTrainTime[$i] - $aTimerEnd[$i] ;   updated remain train time of Active accounts
				If $Writelog = True Then
					If $aUpdateRemainTrainTime[$i] >= 0 Then
						Setlog("Profile [" & $i + 1 & "] - " & $ProfileList[$i + 1] & " (Acc. " & $aMatchProfileAcc[$i] & ") will have full army in:" & $aUpdateRemainTrainTime[$i] & " minutes")
					Else
						Setlog("Profile [" & $i + 1 & "] - " & $ProfileList[$i + 1] & " (Acc. " & $aMatchProfileAcc[$i] & ") was ready:" & - $aUpdateRemainTrainTime[$i] & " minutes ago")
					EndIf
				EndIf
			Else ; for accounts first Run
				If $Writelog = True Then Setlog("Profile [" & $i + 1 & "] - " & $ProfileList[$i + 1] & " (Acc. " & $aMatchProfileAcc[$i] & ") has not been read its remain train time")
				$aUpdateRemainTrainTime[$i] = -999
			EndIf
		EndIf
	Next

	$nMinRemainTrain = _ArrayMax($aUpdateRemainTrainTime)
	For $i = 0 To $nTotalProfile - 1
		If $i = $ExcludeProfile - 1 Then ContinueLoop
		If $aProfileType[$i] = $eActive Then ;	Only check Active profiles
			If $aUpdateRemainTrainTime[$i] <= $nMinRemainTrain Then
				$nMinRemainTrain = $aUpdateRemainTrainTime[$i]
				$nNextProfile = $i + 1
			EndIf
		EndIf
	Next

	Return $nMinRemainTrain

EndFunc   ;==>MinRemainTrainAcc

Func SwitchProfile($SwitchCase) ; Switch profile (1 = Active, 2 = Donate, 4 = Stay , 5 = switching continuosly) - DEMEN

	$nCurProfile = _GUICtrlComboBox_GetCurSel($g_hCmbProfile) + 1

	Switch $SwitchCase
		Case $eActive
			Setlog("Switch to active Profile [" & $nNextProfile & "] - " & $ProfileList[$nNextProfile] & " (Acc. " & $aMatchProfileAcc[$nNextProfile - 1] & ")")
			_GUICtrlComboBox_SetCurSel($g_hCmbProfile, $nNextProfile - 1)
			cmbProfile()

		Case $eDonate
			$nNextProfile = $aDonateProfile[$DonateSwitchCounter] + 1
			Setlog("Switch to Profile [" & $nNextProfile & "] - " & $ProfileList[$nNextProfile] & " (Acc. " & $aMatchProfileAcc[$nNextProfile - 1] & ") for donating")
			_GUICtrlComboBox_SetCurSel($g_hCmbProfile, $nNextProfile - 1)
			$DonateSwitchCounter += 1
			cmbProfile()

		Case $eStay
			Setlog("Staying in this profile")

		Case $eContinuous
			Setlog("Switching to next account")
			$nNextProfile = 1
			If $nCurProfile < $nTotalProfile Then
				$nNextProfile = $nCurProfile + 1
			Else
				$nNextProfile = 1
			EndIf
			While $aProfileType[$nNextProfile - 1] = $eIdle Or $aProfileType[$nNextProfile - 1] = $eNull
				If $nNextProfile < $nTotalProfile Then
					$nNextProfile += 1
				Else
					$nNextProfile = 1
				EndIf
				If $aProfileType[$nNextProfile - 1] <> $eIdle And $aProfileType[$nNextProfile - 1] <> $eNull Then ExitLoop
			WEnd
			_GUICtrlComboBox_SetCurSel($g_hCmbProfile, $nNextProfile - 1)
			cmbProfile()
	EndSwitch

	If _Sleep(1000) Then Return

	If $SwitchCase <> $eStay Then DisableGUI_AfterLoadNewProfile()

	$nCurProfile = _GUICtrlComboBox_GetCurSel($g_hCmbProfile) + 1

EndFunc   ;==>SwitchProfile

Func UpdateTrainTimeStatus($sSwitch = "After")
	If $sSwitch = "Before" Then
		;Update Stats Label GUI before switching Profile
		If $aProfileType[$nCurProfile - 1] = $eDonate Then ; Set Gui Label for Donate or Looting CurrentAccount BackGround Color Green
			GUICtrlSetData($g_lblTroopsTime[$nCurProfile - 1], "Donate")
		ElseIf $aProfileType[$nCurProfile - 1] = $eActive Then
			GUICtrlSetData($g_lblTroopsTime[$nCurProfile - 1], Round($aUpdateRemainTrainTime[$nCurProfile - 1], 2))
		EndIf
		GUICtrlSetBkColor($g_lblTroopsTime[$nCurProfile - 1], $COLOR_YELLOW)
		GUICtrlSetColor($g_lblTroopsTime[$nCurProfile - 1], $COLOR_BLACK)
	Else
		;Update Stats Label GUI of new profile
		If $aProfileType[$nCurProfile - 1] = $eDonate Then ; Set Gui Label for Donate or Looting CurrentAccount BackGround Color Green
			GUICtrlSetData($g_lblTroopsTime[$nCurProfile - 1], "Donating")
		ElseIf $aProfileType[$nCurProfile - 1] = $eActive Then
			GUICtrlSetData($g_lblTroopsTime[$nCurProfile - 1], "Looting")
		EndIf
		GUICtrlSetBkColor($g_lblTroopsTime[$nCurProfile - 1], $COLOR_GREEN)
		GUICtrlSetColor($g_lblTroopsTime[$nCurProfile - 1], $COLOR_WHITE)
	EndIf
EndFunc   ;==>UpdateTrainTimeStatus

Func CheckSwitchAcc() ; Switch CoC Account with or without sleep combo - DEMEN

	Local $SwitchCase, $bReachAttackLimit

	SetLog("Start SwitchAcc")

	If IsMainPage() = False Then ClickP($aAway, 2, 250, "#0335") ; Sometimes the bot cannot open Army Overview Window, trying to click away first
	If IsMainPage() = False Then checkMainScreen() ; checkmainscreen (may restart CoC) if still fail to locate main page.
	getArmyTroopTime(True, False)

	If IsWaitforSpellsActive() Then
		getArmySpellTime()
	Else
		$g_aiTimeTrain[1] = 0
	EndIf

	If IsWaitforHeroesActive() Then
		CheckWaitHero()
	Else
		$g_aiTimeTrain[2] = 0
	EndIf

	ClickP($aAway, 1, 0, "#0000") ;Click Away

	$bReachAttackLimit = ($aAttackedCountSwitch[$nCurProfile - 1] <= $aAttackedCountAcc[$nCurProfile - 1] - 2)

	If $aProfileType[$nCurProfile - 1] = $eActive And _ArrayMax($g_aiTimeTrain) <= 0 And Not ($bReachAttackLimit) Then
		Setlog("Army is ready, skip switching account")
		If _Sleep(500) Then Return

	Else
		If _ArrayMax($g_aiTimeTrain) <= 0 And $bReachAttackLimit Then Setlog("This account has attacked twice in a row, switching account")

		MinRemainTrainAcc()

		If $ichkSmartSwitch = 1 And _ArraySearch($aProfileType, $eActive) <> -1 Then ; Smart switch and there is at least 1 active profile
			If $nMinRemainTrain <= 1 Then
				If $nCurProfile <> $nNextProfile Then
					$SwitchCase = $eActive
				Else
					$SwitchCase = $eStay
				EndIf
				$DonateSwitchCounter = 0
			Else
				If $DonateSwitchCounter < UBound($aDonateProfile) Then
					$SwitchCase = $eDonate
				Else
					If $nCurProfile <> $nNextProfile Then
						$SwitchCase = $eActive
					ElseIf $nMinRemainTrain <= 3 Then
						$SwitchCase = $eStay
					Else
						setlog("Still " & Round($nMinRemainTrain, 2) & " min until army is ready. Other accounts may need donating.")
						$SwitchCase = $eContinuous
					EndIf
					$DonateSwitchCounter = 0
				EndIf
			EndIf
		Else
			$SwitchCase = $eContinuous
		EndIf

		If $SwitchCase <> $eStay Then
			If $aProfileType[$nCurProfile - 1] = $eActive And $g_bRequestTroopsEnable = True And $g_bCanRequestCC = True Then
				Setlog("Try Request troops before switching account", $COLOR_BLUE)
				RequestCC(True)
			EndIf
			UpdateTrainTimeStatus("Before") ;Update Stats Label GUI before switching Profile
			SwitchProfile($SwitchCase)
			UpdateTrainTimeStatus() ;Update Stats Label GUI of new profile
			If IsMainPage() = False Then checkMainScreen()
			SwitchCOCAcc()
		Else
			SwitchProfile($SwitchCase)
		EndIf

		If $ichkCloseTraining >= 1 And $nMinRemainTrain > 3 And $SwitchCase <> $eDonate And $SwitchCase <> $eContinuous Then
			checkMainScreen()
			VillageReport()
            UpdateLabStatus()
            UpdateHeroStatus()
			ReArm()
			If $g_bRequestTroopsEnable = True And $g_bCanRequestCC = True Then
				Setlog("Try Request troops before going to sleep", $COLOR_BLUE)
				RequestCC(True)
			EndIf
			PoliteCloseCoC()
			$g_abNotNeedAllTime[0] = 1
			$g_abNotNeedAllTime[1] = 1
			If $ichkCloseTraining = 2 Then CloseAndroid("SwitchAcc")
			EnableGuiControls() ; enable emulator menu controls
			SetLog("Enable emulator menu controls due long wait time!")
			If $ichkCloseTraining = 1 Then
				WaitnOpenCoC(($nMinRemainTrain - 1) * 60 * 1000, True)
			Else
				If _SleepStatus(($nMinRemainTrain - 1.5) * 60 * 1000) Then Return
				OpenAndroid()
				OpenCoC()
			EndIf

			SaveConfig()
			readConfig()
			applyConfig()
			DisableGuiControls()
			checkMainScreen()
		EndIf
		If $SwitchCase <> $eStay Then runBot()
	EndIf

EndFunc   ;==>CheckSwitchAcc

Func ForceSwitchAcc($AccType = $eDonate, $sSource = "")
	Local $SwitchCase
	If $sSource = "StayDonate" Then
		Setlog("Stay on Donation for: " & Round($nMinRemainTrain, 2) & "m until an Active Account is ready")
		If $DonateSwitchCounter >= UBound($aDonateProfile) Then $DonateSwitchCounter = 0
	EndIf

	If $AccType = $eDonate Then
		If UBound($aDonateProfile) > 0 And $DonateSwitchCounter < UBound($aDonateProfile) Then
			If $nCurProfile <> $aDonateProfile[$DonateSwitchCounter] + 1 Then
				$SwitchCase = $eDonate
			Else
				runBot()
			EndIf
			$eForceSwitch = $eDonate
		ElseIf $sSource = "SeachLimit" Then
			If MinRemainTrainAcc(False, $iProfileBeforeForceSwitch) > 0 Or UBound($aActiveProfile) = 1 Then
				$nNextProfile = $iProfileBeforeForceSwitch
				Setlog("Return to Active Profile: " & $ProfileList[$nNextProfile] & " to continue searching")
				$g_bRestart = True
			EndIf
			$SwitchCase = $eActive
			$eForceSwitch = $eNull
			$DonateSwitchCounter = 0
		Else
			$SwitchCase = $eActive
			MinRemainTrainAcc(False, $nCurProfile)
			$eForceSwitch = $eNull
			$DonateSwitchCounter = 0
		EndIf

	ElseIf $AccType = $eActive Then
		$SwitchCase = $eActive
		MinRemainTrainAcc(False, $nCurProfile)
		$eForceSwitch = $eNull
	Else
		Return False
	EndIf

	If $aProfileType[$nCurProfile - 1] = $eActive And $g_bRequestTroopsEnable = True And $g_bCanRequestCC = True Then
		Setlog("Try Request troops before switching account", $COLOR_BLUE)
		RequestCC(True)
	EndIf

	UpdateTrainTimeStatus("Before")
	SwitchProfile($SwitchCase)
	UpdateTrainTimeStatus()
	If IsMainPage() = False Then checkMainScreen()
	SwitchCOCAcc()
	runBot()
EndFunc   ;==>ForceSwitchAcc

Func SwitchCOCAcc()

	Local $NextAccount, $YCoord, $idx, $idx2, $idx3
	$NextAccount = $aMatchProfileAcc[$nCurProfile - 1]

	If $aAccPosY[$NextAccount - 1] > 0 Then
		$YCoord = $aAccPosY[$NextAccount - 1]
	Else
		$YCoord = 373.5 - ($nTotalCoCAcc - 1) * 36.5 + 73 * ($NextAccount - 1)
	EndIf

	Setlog("Switching to Account [" & $NextAccount & "]")

	PureClick(820, 585, 1, 0, "Click Setting") ;Click setting
	If _Sleep(500) Then Return

	$idx = 0
	While $idx <= 15 ; Checking Green Connect Button continuously in 15sec
		If _ColorCheck(_GetPixelColor(408, 408, True), "D0E878", 20) Then ;	Green
			PureClick(440, 420, 2, 1000) ;	Click Connect & Disconnect
			If _Sleep(500) Then Return
			Setlog("   1. Click connect & disconnect")
			ExitLoop
		ElseIf _ColorCheck(_GetPixelColor(408, 408, True), "F07077", 20) Then ; 	Red
			PureClick(440, 420) ;	Click Disconnect
			If _Sleep(500) Then Return
			Setlog("   1. Click disconnect")
			ExitLoop
		Else
			If _Sleep(900) Then Return
			$idx += 1
			If $idx = 15 Then SwitchFail_runBot()
		EndIf
	WEnd

	$idx = 0
	While $idx <= 15 ; Checking Account List continuously in 15sec
		If _ColorCheck(_GetPixelColor(600, 310, True), "FFFFFF", 20) Then ;	Grey
			PureClick(383, $YCoord) ;	Click Account
			Setlog("   2. Click account [" & $NextAccount & "]")
			If _Sleep(1000) Then Return
			ExitLoop
		ElseIf _ColorCheck(_GetPixelColor(408, 408, True), "F07077", 20) And $idx = 6 Then ; 	Red, double click did not work, try click Disconnect 1 more time
			PureClick(440, 420) ;	Click Disconnect
			Setlog("   1.5. Click disconnect again")
			If _Sleep(500) Then Return
		Else
			If _Sleep(900) Then Return
			$idx += 1
			If $idx = 15 Then SwitchFail_runBot()
		EndIf
	WEnd

	$idx = 0
	While $idx <= 15 ; Checking Load Button continuously in 15sec
		If _ColorCheck(_GetPixelColor(408, 408, True), "D0E878", 20) Then ; Already in current account
			Setlog("Already in current account")
			PureClickP($aAway, 2, 0, "#0167") ;Click Away
			If _Sleep(1000) Then Return
			$bReMatchAcc = False
			ExitLoop

		ElseIf _ColorCheck(_GetPixelColor(480, 441, True), "60B010", 20) Then ; Load Button
			PureClick(443, 430, 1, 0, "Click Load") ;Click Load
			Setlog("   3. Click load button")

			$idx2 = 0
			While $idx2 <= 15 ; Checking Text Box continuously in 15sec
				If _ColorCheck(_GetPixelColor(585, 16, True), "F88088", 20) Then ; Pink (close icon)
					PureClick(360, 195, 1, 0, "Click Text box")
					Setlog("   4. Click text box")
					If _Sleep(500) Then Return
					AndroidSendText("CONFIRM")
					ExitLoop
				Else
					If _Sleep(900) Then Return
					$idx2 = $idx2 + 1
					If $idx2 = 15 Then SwitchFail_runBot()
				EndIf
			WEnd

			$idx3 = 0
			While $idx3 <= 10 ; Checking OKAY Button continuously in 10sec
				If _ColorCheck(_GetPixelColor(480, 200, True), "71BB1E", 20) Then
					PureClick(480, 200, 1, 0, "Click OKAY") ;Click OKAY
					Setlog("   5. Click OKAY")
					ExitLoop
				Else
					If _Sleep(900) Then Return
					$idx3 = $idx3 + 1
					If $idx2 = 10 Then SwitchFail_runBot()
				EndIf
			WEnd

			Setlog("please wait for loading CoC")
			$bReMatchAcc = False
			$g_abNotNeedAllTime[0] = 1
			$g_abNotNeedAllTime[1] = 1
			$aAttackedCountSwitch[$nCurProfile - 1] = $aAttackedCountAcc[$nCurProfile - 1]

			If IsMainPage(100) Then ExitLoop; Waiting for fully load CoC in 10 sec
			ExitLoop

		Else
			If _Sleep(900) Then Return
			$idx += 1
			If $idx = 15 Then SwitchFail_runBot()

		EndIf
	WEnd

EndFunc   ;==>SwitchCOCAcc

Func SwitchFail_runBot()
	Setlog("Switching account failed!", $COLOR_RED)
	$bReMatchAcc = True
	PureClickP($aAway, 3, 500)
	checkMainScreen()
	runBot()
EndFunc   ;==>SwitchFail_runBot

Func DisableGUI_AfterLoadNewProfile()
	For $i = $g_hFirstControlToHide To $g_hLastControlToHide
		If IsAlwaysEnabledControl($i) Then ContinueLoop
		If $g_bNotifyPBEnable And $i = $g_hBtnNotifyDeleteMessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
		If BitAND(GUICtrlGetState($i), $GUI_ENABLE) Then GUICtrlSetState($i, $GUI_DISABLE)
	Next
	ControlEnable("","",$g_hCmbGUILanguage)
EndFunc   ;==>DisableGUI_AfterLoadNewProfile
