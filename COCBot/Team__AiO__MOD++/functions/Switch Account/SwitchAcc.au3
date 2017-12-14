; #FUNCTION# ====================================================================================================================
; Name ..........: SwitchAccount (#-12)
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: DEMEN (based on original idea of NDTHUAN)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func InitiateSwitchAcc() ; Checking profiles setup in Mybot, First matching CoC Acc with current profile, Reset all Timers relating to Switch Acc Mode.

	If Not $g_bChkSwitchAcc Or Not $g_bInitiateSwitchAcc Then Return
	UpdateMultiStats()
	$g_iNextAccount = -1
	Setlog("SwitchAccount enable for " & $g_iTotalAcc + 1 & " accounts")
	SetSwitchAccLog("Initiating: " & $g_iTotalAcc + 1 & " acc", $COLOR_SUCCESS)

	Local $iCurProfile = _GUICtrlComboBox_GetCurSel($g_hCmbProfile)

	For $i = 0 To $g_iTotalAcc
		; listing all accounts
		Local $sBotType = "Idle"
		If $g_abAccountNo[$i] = True Then
			$sBotType = "Active"
			If $g_abDonateOnly[$i] = True Then $sBotType = "Donate"
			If $g_iNextAccount = -1 Then $g_iNextAccount = $i
			If $g_aiProfileNo[$i] = $iCurProfile Then $g_iNextAccount = $i
		EndIf
		Setlog("  - Account [" & $i + 1 & "]: " & GUICtrlRead($g_ahCmbProfile[$i]) & " - " & $sBotType)
		SetSwitchAccLog("  - Acc. " & $i + 1 & ": " & $sBotType)

		; reset all timers
		$g_aiTimerStart[$i] = 0
		$g_aiRemainTrainTime[$i] = 0
		$g_aLabTimeAcc[$i] = 0
		$g_aLabTimerStart[$i] = 0
	Next
	$g_iCurAccount = $g_iNextAccount ; make sure no crash
	Setlog("Let's start with Account [" & $g_iNextAccount + 1 & "]")

	SwitchCOCAcc($g_iNextAccount)

EndFunc   ;==>InitiateSwitchAcc

Func CheckSwitchAcc()

	Local $aActiveAccount = _ArrayFindAll($g_abAccountNo, True)
	If UBound($aActiveAccount) <= 1 Then Return

	Local $aDonateAccount = _ArrayFindAll($g_abDonateOnly, True)
	Local $bReachAttackLimit = ($g_aiAttackedCountSwitch[$g_iCurAccount] <= $g_aiAttackedCountAcc[$g_iCurAccount] - 2)
	Local $bForceSwitch = False
	Local $nMinRemainTrain, $iWaitTime

	SetLog("Start SwitchAcc")
	If $g_bWaitForCCTroopSpell Then
		Setlog("Still waiting for CC troops/ spells, switching to another Account")
		SetSwitchAccLog(" - Waiting for CC")
		$bForceSwitch = True
	Else
		getArmyTroopTime(True, False) ; update $g_aiTimeTrain[0]

		$g_aiTimeTrain[1] = 0
		If IsWaitforSpellsActive() Then getArmySpellTime() ; update $g_aiTimeTrain[1]

		$g_aiTimeTrain[2] = 0
		If IsWaitforHeroesActive() Then CheckWaitHero() ; update $g_aiTimeTrain[2]

		ClickP($aAway, 1, 0, "#0000") ;Click Away

		$iWaitTime = _ArrayMax($g_aiTimeTrain)
		If $bReachAttackLimit And $iWaitTime <= 0 Then
			Setlog("This account has attacked twice in a row, switching to another account")
			SetSwitchAccLog(" - Reach attack limit: " & $g_aiAttackedCountAcc[$g_iCurAccount] - $g_aiAttackedCountSwitch[$g_iCurAccount])
			$bForceSwitch = True
		EndIf
	EndIf

	Local $sLogSkip = ""
	If Not $g_abDonateOnly[$g_iCurAccount] And $iWaitTime <= $g_iTrainTimeToSkip And Not $bForceSwitch Then
		If $iWaitTime > 0 Then $sLogSkip = " in " & Round($iWaitTime, 1) & "m"
		Setlog("Army is ready" & $sLogSkip & ", skip switching account")
		SetSwitchAccLog(" - Army is ready"  & $sLogSkip)
		SetSwitchAccLog("Stay at [" & $g_iNextAccount + 1 & "]", $COLOR_SUCCESS)
		If _Sleep(500) Then Return
	Else
		$nMinRemainTrain = CheckTroopTimeAllAccount($bForceSwitch)

		If $g_bChkSmartSwitch = 1 Then ; Smart switch
			If $nMinRemainTrain <= 1 And Not $bForceSwitch Then ; Active (force switch shall give priority to Donate Account)
				If $g_bDebugSetlog Then Setlog("Switch to or Stay at Active Account: " & $g_iNextAccount + 1, $COLOR_DEBUG)
				$g_iDonateSwitchCounter = 0
			Else
				If $g_iDonateSwitchCounter < UBound($aDonateAccount) Then ; Donate
					$g_iNextAccount = $aDonateAccount[$g_iDonateSwitchCounter]
					$g_iDonateSwitchCounter += 1
					If $g_bDebugSetlog Then Setlog("Switch to Donate Account " & $g_iNextAccount + 1 & ". $g_iDonateSwitchCounter = " & $g_iDonateSwitchCounter, $COLOR_DEBUG)
					SetSwitchAccLog(" - Donate Acc [" & $g_iNextAccount + 1 & "]")
				Else ; Active or Random
					$g_iDonateSwitchCounter = 0
					If $g_iCurAccount = $g_iNextAccount And $nMinRemainTrain > 3 Then ; Random
						Local $iRandomElement = Random(0, UBound($aActiveAccount) - 1, 1)
						$g_iNextAccount = $aActiveAccount[$iRandomElement]
						Setlog("Still " & Round($nMinRemainTrain, 2) & " min until army is ready. Switch to a random account: " & $g_iNextAccount + 1)
						SetSwitchAccLog(" - Random Acc [" & $g_iNextAccount + 1 & "]")
					EndIf
				EndIf
			EndIf
		Else ; Normal switch (continuous)
			$g_iNextAccount = $g_iCurAccount + 1
			If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0
			While $g_abAccountNo[$g_iNextAccount] = False
				$g_iNextAccount += 1
				If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0 ; avoid idle Account
			WEnd
		EndIf

		If $g_iNextAccount <> $g_iCurAccount Then
			If $g_bRequestTroopsEnable = True And $g_bCanRequestCC = True Then
				Setlog("Try Request troops before switching account", $COLOR_BLUE)
				RequestCC(True)
			EndIf
			If IsMainPage() = False Then checkMainScreen()
			SwitchCOCAcc($g_iNextAccount)
		Else
			Setlog("Staying in this account")
			SetSwitchAccLog("Stay at [" & $g_iNextAccount + 1 & "]", $COLOR_SUCCESS)
		EndIf
	EndIf

EndFunc   ;==>CheckSwitchAcc

Func SwitchCOCAcc($NextAccount)

	If $NextAccount < 0 And $NextAccount > $g_iTotalAcc Then $NextAccount = _ArraySearch(True, $g_abAccountNo)

	Local $aButtonSetting[4] = [820, 550 + $g_iMidOffsetY, 0xFFFFFF, 10]
	Local $aButtonConnected[4] = [430, 380 + $g_iMidOffsetY, 0xD8F480, 20]
	Local $aButtonDisconnected[4] = [430, 380 + $g_iMidOffsetY, 0xFF7C81, 20]
	Local $aListAccount[4] = [165, 350 + $g_iMidOffsetY, 0xFFFFFF, 20]
	Local $aButtonVillageLoad[4] = [515, 411 + $g_iMidOffsetY, 0x6EBD1F, 20]
	Local $aTextBox[4] = [320, 160 + $g_iMidOffsetY, 0xFFFFFF, 20]
	Local $aButtonVillageOkay[4] = [500, 170 + $g_iMidOffsetY, 0x81CA2D, 20]

	Static $iRetry = 0
	Static $StartOnlineTime = 0
	Local $bResult
	Local $YCoord = Int(373.5 - $g_iTotalAcc * 36.5 + 73 * $NextAccount)

	Setlog("Switching to Account [" & $NextAccount + 1 & "]")

	If 	$g_bInitiateSwitchAcc = True Then
		$StartOnlineTime = 0
		$g_bInitiateSwitchAcc = False
	EndIf

	If $StartOnlineTime <> 0 And Not $g_bReMatchAcc Then _
		SetSwitchAccLog(" - Acc " & $g_iCurAccount + 1 & ", online: " & Round(TimerDiff($StartOnlineTime) / 1000 / 60, 1) & "m")

	Click($aButtonSetting[0], $aButtonSetting[1], 1, 0, "Click Setting")
	If _Sleep(500) Then Return

	While 1
		For $i = 0 To 20 ; Checking Green Connect Button continuously in 20sec
			If _ColorCheck(_GetPixelColor($aButtonConnected[0], $aButtonConnected[1], True), Hex($aButtonConnected[2], 6), $aButtonConnected[3]) Then ;	Green
				Click($aButtonConnected[0], $aButtonConnected[1], 2, 1000) ; Click Connect & Disconnect
				Setlog("   1. Click Connect & Disconnect")
				If _Sleep(200) Then Return
				ExitLoop
			ElseIf _ColorCheck(_GetPixelColor($aButtonDisconnected[0], $aButtonDisconnected[1], True), Hex($aButtonDisconnected[2], 6), $aButtonDisconnected[3]) Then ; Red
				Click($aButtonDisconnected[0], $aButtonDisconnected[1]) ; Click Disconnect
				Setlog("   1. Click Disconnect")
				If _Sleep(200) Then Return
				ExitLoop
			EndIf
			If $i = 20 Then
				$bResult = False
				ExitLoop 2
			EndIf
			If _Sleep(900) Then Return
		Next

		For $i = 0 To 20 ; Checking Account List continuously in 20sec
			If _ColorCheck(_GetPixelColor($aListAccount[0], $aListAccount[1], True), Hex($aListAccount[2], 6), $aListAccount[3]) Then ;	Grey
				Click(383, $YCoord) ; Click Account
				Setlog("   2. Click Account [" & $NextAccount + 1 & "]")
				If _Sleep(600) Then Return
				ExitLoop
			ElseIf _ColorCheck(_GetPixelColor($aButtonDisconnected[0], $aButtonDisconnected[1], True), Hex($aButtonDisconnected[2], 6), $aButtonDisconnected[3]) And $i = 6 Then ; Red, double click did not work, try click Disconnect 1 more time
				Click($aButtonDisconnected[0], $aButtonDisconnected[1]) ; Click Disconnect
				Setlog("   1.5. Click Disconnect again")
				If _Sleep(600) Then Return
			EndIf
			If $i = 20 Then
				$bResult = False
				ExitLoop 2
			EndIf
			If _Sleep(900) Then Return
		Next

		For $i = 0 To 30 ; Checking Load Button continuously in 30sec
			If _ColorCheck(_GetPixelColor($aButtonConnected[0], $aButtonConnected[1], True), Hex($aButtonConnected[2], 6), $aButtonConnected[3]) Then ; Green
				Setlog("Already in current account")
				ClickP($aAway, 2, 0, "#0167") ; Click Away
				If _Sleep(500) Then Return
				$bResult = True
				ExitLoop 2 ; no more step needed
			ElseIf _ColorCheck(_GetPixelColor($aButtonVillageLoad[0], $aButtonVillageLoad[1], True), Hex($aButtonVillageLoad[2], 6), $aButtonVillageLoad[3]) Then ; Load Button
				Click($aButtonVillageLoad[0], $aButtonVillageLoad[1], 1, 0, "Click Load") ; Click Load
				Setlog("   3. Click Load button")

				For $j = 0 To 25 ; Checking Text Box continuously in 25sec
					If _ColorCheck(_GetPixelColor($aTextBox[0], $aTextBox[1], True), Hex($aTextBox[2], 6), $aTextBox[3]) Then ; Pink (close icon)
						Click($aTextBox[0], $aTextBox[1], 1, 0, "Click Text box")
						Setlog("   4. Click text box & type CONFIRM")
						If _Sleep(500) Then Return
						AndroidSendText("CONFIRM")
						ExitLoop
					EndIf
					If $j = 25 Then
						$bResult = False
						ExitLoop 3
					EndIf
					If _Sleep(900) Then Return
				Next

				For $k = 0 To 10 ; Checking OKAY Button continuously in 10sec
					If _ColorCheck(_GetPixelColor($aButtonVillageOkay[0], $aButtonVillageOkay[1], True), Hex($aButtonVillageOkay[2], 6), $aButtonVillageOkay[3]) Then
						Click($aButtonVillageOkay[0], $aButtonVillageOkay[1], 1, 0, "Click OKAY")
						Setlog("   5. Click OKAY")
						ExitLoop
					EndIf
					If $k = 10 Then
						$bResult = False
						ExitLoop 3
					EndIf
					If _Sleep(900) Then Return
				Next

				Setlog("Please wait for loading CoC")
				$bResult = True
				ExitLoop 2
			EndIf
			If $i = 30 Then
				$bResult = False
				ExitLoop 2
			EndIf
			If _Sleep(900) Then Return
		Next
		ExitLoop
	WEnd

	If _Sleep(500) Then Return
	If $bResult = True Then
		$iRetry = 0
		$g_bReMatchAcc = False
		$g_abNotNeedAllTime[0] = 1
		$g_abNotNeedAllTime[1] = 1
		$g_aiAttackedCountSwitch[$g_iCurAccount] = $g_aiAttackedCountAcc[$g_iCurAccount]
		$g_iCurAccount = $NextAccount
		If _GUICtrlComboBox_GetCurSel($g_hCmbProfile) <> $g_aiProfileNo[$g_iNextAccount] Then
			_GUICtrlComboBox_SetCurSel($g_hCmbProfile, $g_aiProfileNo[$g_iNextAccount])
			cmbProfile()
			DisableGUI_AfterLoadNewProfile()
		EndIf
		$StartOnlineTime = TimerInit()
		SetSwitchAccLog("Switched to Acc [" & $NextAccount + 1 & "]", $COLOR_SUCCESS)
	Else
		$iRetry += 1
		$g_bReMatchAcc = True
		Setlog("Switching account failed!", $COLOR_RED)
		SetSwitchAccLog("Switching to Acc " & $NextAccount + 1 & " Failed!", $COLOR_ERROR)
		If $iRetry <= 3 Then
			ClickP($aAway, 3, 500)
			checkMainScreen()
		Else
			$iRetry = 0
			UniversalCloseWaitOpenCoC()
		EndIf
	EndIf
	waitMainScreen()
	runBot()

EndFunc   ;==>SwitchCOCAcc

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

EndFunc   ;==>CheckWaitHero

Func CheckTroopTimeAllAccount($bExcludeCurrent = False) ; Return the minimum remain training time

	Local $iMinRemainTrain
	If $bExcludeCurrent = False Then
		$g_aiRemainTrainTime[$g_iCurAccount] = _ArrayMax($g_aiTimeTrain) ; remaintraintime of current account - in minutes
		$g_aiTimerStart[$g_iCurAccount] = TimerInit() ; start counting elapse of training time of current account
	EndIf

	SetSwitchAccLog(" - Train times: ")

	For $i = 0 To $g_iTotalAcc
		If $bExcludeCurrent And $i = $g_iCurAccount Then ContinueLoop
		If $g_abAccountNo[$i] And Not $g_abDonateOnly[$i] Then ;	Only check Active profiles
			If $g_aiTimerStart[$i] <> 0 Then
				$g_aiRemainTrainTime[$i] -= Round(TimerDiff($g_aiTimerStart[$i]) / 1000 / 60, 1) ;   updated remain train time of Active accounts
				$g_aiTimerStart[$i] = TimerInit() ; reset timer
				If $g_aiRemainTrainTime[$i] >= 0 Then
					Setlog("Account [" & $i + 1 & "]: " & GUICtrlRead($g_ahCmbProfile[$i]) & " will have full army in:" & $g_aiRemainTrainTime[$i] & " minutes")
				Else
					Setlog("Account [" & $i + 1 & "]: " & GUICtrlRead($g_ahCmbProfile[$i]) & " was ready:" & - $g_aiRemainTrainTime[$i] & " minutes ago")
				EndIf
				SetSwitchAccLog("    Acc " & $i + 1 & ": " & $g_aiRemainTrainTime[$i] & "m")
			Else ; for accounts first Run
				Setlog("Account [" & $i + 1 & "]: " & GUICtrlRead($g_ahCmbProfile[$i]) & " has not been read its remain train time")
				$g_aiRemainTrainTime[$i] = -999
				SetSwitchAccLog("    Acc " & $i + 1 & ": Unknown")
			EndIf
		EndIf
	Next

	$iMinRemainTrain = _ArrayMax($g_aiRemainTrainTime)
	For $i = 0 To $g_iTotalAcc
		If $bExcludeCurrent And $i = $g_iCurAccount Then ContinueLoop
		If $g_abAccountNo[$i] And Not $g_abDonateOnly[$i] Then ;	Only check Active profiles
			If $g_aiRemainTrainTime[$i] <= $iMinRemainTrain Then
				$iMinRemainTrain = $g_aiRemainTrainTime[$i]
				$g_iNextAccount = $i
			EndIf
		EndIf
	Next

	Return $iMinRemainTrain

EndFunc   ;==>CheckTroopTimeAllAccount

Func DisableGUI_AfterLoadNewProfile()
	$g_bGUIControlDisabled = True
	For $i = $g_hFirstControlToHide To $g_hLastControlToHide
		If IsAlwaysEnabledControl($i) Then ContinueLoop
		If $g_bNotifyPBEnable And $i = $g_hBtnNotifyDeleteMessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
		If BitAND(GUICtrlGetState($i), $GUI_ENABLE) Then GUICtrlSetState($i, $GUI_DISABLE)
	Next
	ControlEnable("", "", $g_hCmbGUILanguage)
	$g_bGUIControlDisabled = False
EndFunc   ;==>DisableGUI_AfterLoadNewProfile

Func CreateSwitchLogFile()
	If $g_hSwitchLogFile <> 0 Then
		FileClose($g_hSwitchLogFile)
		$g_hSwitchLogFile = 0
	EndIf
	Local $sSwitchLogFName = "SwitchAccLog" & "-" & @YEAR & "-" & @MON & ".log"
	Local $sSwitchLogPath = $g_sProfilePath & "\" & $sSwitchLogFName
	$g_hSwitchLogFile = FileOpen($sSwitchLogPath, $FO_APPEND)
	SetDebugLog("Created attack log file: " & $sSwitchLogPath)
EndFunc   ;==>CreateSwitchLogFile

Func SetSwitchAccLog($String, $Color = $COLOR_BLACK, $Font = "Verdana", $FontSize = 7.5, $time = True)
	If $time = True Then
		$time = Time()
	Else
		$time = 0
	EndIf

	If $g_hSwitchLogFile = 0 Then CreateSwitchLogFile()
	_FileWriteLog($g_hSwitchLogFile, $String)

	Dim $a[6]
	$a[0] = $String
	$a[1] = $Color
	$a[2] = $Font
	$a[3] = $FontSize
	$a[4] = 0 ; no status bar update
	$a[5] = $time
	$g_oTxtSALogInitText($g_oTxtSALogInitText.Count + 1) = $a

EndFunc   ;==>SetSwitchAccLog