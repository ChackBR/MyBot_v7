; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization
; Description ...: This file contains all functions of @RoroTiti's Bot Humanization feature
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti 11/11/2016
; Modified ......: TheRevenor 22/10/2016, RoroTiti 04/12/2016
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
;				   Because this file is a part of an open-sourced project, I allow all MODders and DEVelopers to use these functions.
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: No
;================================================================================================================================

#cs

Func Click($x, $y, $times = 1, $speed = 0, $debugtxt = "")

	; !!! Not original function but randomization calculation which is linked to original function renamed FClick !!!
	; !!! Still compatible with all original function parameters !!!

	If $ichkUseAltRClick = 1 Then

		$xclick = Random($x - 5, $x, 1)
		$yclick = Random($y, $y + 5, 1)
		If $xclick <= 0 Or $xclick >= 860 Then $xclick = $x ; Out Of Screen protection
		If $yclick <= 0 Or $yclick >= 680 + ($bottomOffsetY) Then $yclick = $y ; Out Of Screen protection
		FClick($xclick, $yclick, $times, $speed, $debugtxt)

	Else
		FClick($x, $y, $times, $speed, $debugtxt)
	EndIf

EndFunc   ;==>_Click

Func PureClick($x, $y, $times = 1, $speed = 0, $debugtxt = "")

	; !!! Not original function but randomization calculation which is linked to original function renamed FPureClick !!!
	; !!! Still compatible with all original function parameters !!!

	If $ichkUseAltRClick = 1 Then

		$xclick = Random($x - 5, $x, 1)
		$yclick = Random($y, $y + 5, 1)
		If $xclick <= 0 Or $xclick >= 860 Then $xclick = $x ; Out Of Screen protection
		If $yclick <= 0 Or $yclick >= 680 + ($bottomOffsetY) Then $yclick = $y ; Out Of Screen protection
		FPureClick($xclick, $yclick, $times, $speed, $debugtxt)

	Else
		FPureClick($x, $y, $times, $speed, $debugtxt)
	EndIf

EndFunc   ;==>_PureClick

Func GemClick($x, $y, $times = 1, $speed = 0, $debugtxt = "")

	; !!! Not original function but randomization calculation which is linked to original function renamed FGemClick !!!
	; !!! Still compatible with all original function parameters !!!

	If $ichkUseAltRClick = 1 Then

		$xclick = Random($x - 5, $x, 1)
		$yclick = Random($y, $y + 5, 1)
		If $xclick <= 0 Or $xclick >= 860 Then $xclick = $x ; Out Of Screen protection
		If $yclick <= 0 Or $yclick >= 680 + ($bottomOffsetY) Then $yclick = $y ; Out Of Screen protection
		FGemClick($xclick, $yclick, $times, $speed, $debugtxt)

	Else
		FGemClick($x, $y, $times, $speed, $debugtxt)
	EndIf

EndFunc   ;==>_GemClick

#ce

Func randomSleep($SleepTime, $Range = 0)

	If $RunState = False Then Return
	If $Range = 0 Then $Range = Round($SleepTime / 5)
	$SleepTimeF = Random($SleepTime - $Range, $SleepTime + $Range, 1)
	If $debugClick = 1 Then Setlog("Default sleep : " & $SleepTime & " - Random sleep : " & $SleepTimeF, $COLOR_ORANGE)
	If _Sleep($SleepTimeF) Then Return

EndFunc   ;==>randomSleep

#cs

; ================================================== QuickMIS PART ================================================== ;

Func QuickMIS($ValueReturned, $directory, $Left = 0, $Top = 0, $Right = $GAME_WIDTH, $Bottom = $GAME_HEIGHT, $Debug = False)

	If ($ValueReturned <> "BC1") And ($ValueReturned <> "CX") And ($ValueReturned <> "N1") And ($ValueReturned <> "NX") And ($ValueReturned <> "Q1") And ($ValueReturned <> "QX") Then
		SetLog("Error of parameters settings during QuickMIS call for MultiSearch...", $COLOR_RED)
		Return
	EndIf

	Sleep(1500)

	_CaptureRegion2($Left, $Top, $Right, $Bottom)
	$Res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)

	If IsArray($Res) Then
		If $Debug Then _ArrayDisplay($Res)
		If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $Res[0], $COLOR_PURPLE)

		If $Res[0] = "" Or $Res[0] = "0" Then
			If $DebugSetlog Then SetLog("No Button found")
			Switch $ValueReturned
				Case "BC1"
					Return False
				Case "CX"
					Return "-1"
				Case "N1"
					Return "none"
				Case "NX"
					Return "none"
				Case "Q1"
					Return 0
				Case "QX"
					Return 0
			EndSwitch

		ElseIf StringInStr($Res[0], "-1") <> 0 Then
			SetLog("DLL Error", $COLOR_RED)

		Else
			Switch $ValueReturned

				Case "BC1" ; coordinates of first/one image found + boolean value

					$Result = ""
					$KeyValue = StringSplit($Res[0], "|", $STR_NOCOUNT)
					For $i = 0 To UBound($KeyValue) - 1
						$DLLRes = DllCall($hImgLib, "str", "GetProperty", "str", $KeyValue[$i], "str", "objectpoints")
						$Result &= $DLLRes[0] & "|"
					Next
					If StringRight($Result, 1) = "|" Then $Result = StringLeft($Result, (StringLen($Result) - 1))
					$CoordsInArray = StringSplit($Result, ",", $STR_NOCOUNT)
					$QuickMISX = $CoordsInArray[0]
					$QuickMISY = $CoordsInArray[1]
					Return True

				Case "CX" ; coordinates of each image found - eg: $Array[0] = [X1, Y1] ; $Array[1] = [X2, Y2]

					$Result = ""
					$KeyValue = StringSplit($Res[0], "|", $STR_NOCOUNT)
					For $i = 0 To UBound($KeyValue) - 1
						$DLLRes = DllCall($hImgLib, "str", "GetProperty", "str", $KeyValue[$i], "str", "objectpoints")
						$Result &= $DLLRes[0] & "|"
					Next
					If StringRight($Result, 1) = "|" Then $Result = StringLeft($Result, (StringLen($Result) - 1))
					$CoordsInArray = StringSplit($Result, "|", $STR_NOCOUNT)
					Return $CoordsInArray


				Case "N1" ; name of first file found

					$MultiImageSearchResult = StringSplit($Res[0], "|")
					$FilenameFound = StringSplit($MultiImageSearchResult[1], "_")
					Return $FilenameFound[1]

				Case "NX" ; names of all files found

					$AllFilenamesFound = ""
					$MultiImageSearchResult = StringSplit($Res[0], "|")
					For $i = 1 To $MultiImageSearchResult[0]
						$FilenameFound = StringSplit($MultiImageSearchResult[$i], "_")
						$AllFilenamesFound &= $FilenameFound[1] & "|"
					Next
					If StringRight($AllFilenamesFound, 1) = "|" Then $AllFilenamesFound = StringLeft($AllFilenamesFound, (StringLen($AllFilenamesFound) - 1))
					Return $AllFilenamesFound

				Case "Q1" ; quantity of first/one tiles found

					$Result = ""
					$KeyValue = StringSplit($Res[0], "|", $STR_NOCOUNT)
					For $i = 0 To UBound($KeyValue) - 1
						$DLLRes = DllCall($hImgLib, "str", "GetProperty", "str", $KeyValue[$i], "str", "totalobjects")
						$Result &= $DLLRes[0] & "|"
					Next
					If StringRight($Result, 1) = "|" Then $Result = StringLeft($Result, (StringLen($Result) - 1))
					$QuantityInArray = StringSplit($Result, "|", $STR_NOCOUNT)
					Return $QuantityInArray[0]

				Case "QX" ; quantity of files found

					$MultiImageSearchResult = StringSplit($Res[0], "|", $STR_NOCOUNT)
					Return UBound($MultiImageSearchResult)

			EndSwitch
		EndIf
	EndIf

EndFunc   ;==>QuickMIS

; ================================================== HUMAN FUNCTIONS PART ================================================== ;

Func BotHumanization()

	If $ichkUseBotHumanization = 1 Then

		$NoActionsToDo = 0

		SetLog("Now, let the DocOc Team make your BOT more human ... :)", $COLOR_SUCCESS1)

		If $ichkLookAtRedNotifications = 1 Then LookAtRedNotifications()
		If $ichkCollectAchievements = 1 Then CollectAchievements()
		ReturnAtHome()

		For $i = 0 To 12
			$ActionEnabled = _GUICtrlComboBox_GetCurSel($cmbPriority[$i])
			If $ActionEnabled = 0 Then $NoActionsToDo += 1
		Next

		If $NoActionsToDo <> 13 Then

			$MaxActionsNumber = Random(1, _GUICtrlComboBox_GetCurSel($cmbMaxActionsNumber) + 1, 1)

			SetLog("DocOc will do " & $MaxActionsNumber & " human actions during this loop...", $COLOR_INFO)

			For $i = 1 To $MaxActionsNumber
				Sleep(4000)
				ReturnAtHome()
				RandomHumanAction()
			Next

		Else
			SetLog("All actions disabled, skipping...", $COLOR_WARNING)
		EndIf

		SetLog("Bot Humanization finished !!! :)", $COLOR_SUCCESS1)

	EndIf

EndFunc   ;==>BotHumanization

Func RandomHumanAction()

	For $i = 0 To 12
		SetActionPriority($i)
	Next

	$ActionToDo = _ArrayMaxIndex($SetActionPriority)

	Switch $ActionToDo
		Case 0
			SetLog("The spirit of DocOc chose to read Clan Chat... Let's go !!! :)", $COLOR_INFO)
			ReadClanChat()
		Case 1
			SetLog("The spirit of DocOc chose to read Global Chat... Let's go !!! :)", $COLOR_INFO)
			ReadGlobalChat()
		Case 2
			SetLog("The spirit of DocOc chose to talk with your Clan... Let's go !!! :)", $COLOR_INFO)
			SaySomeChat()
		Case 3
			SetLog("The spirit of DocOc chose to Watch a Defense... Let's go !!! :)", $COLOR_INFO)
			WatchDefense()
		Case 4
			SetLog("The spirit of DocOc chose to Watch an Attack... Let's go !!! :)", $COLOR_INFO)
			WatchAttack()
		Case 5
			SetLog("The spirit of DocOc chose to Look at War Log... Let's go !!! :)", $COLOR_INFO)
			LookAtWarLog()
		Case 6
			SetLog("The spirit of DocOc chose to Visit Clanmates... Let's go !!! :)", $COLOR_INFO)
			VisitClanmates()
		Case 7
			SetLog("The spirit of DocOc chose to Visit Best Players... Let's go !!! :)", $COLOR_INFO)
			VisitBestPlayers()
		Case 8
			SetLog("The spirit of DocOc chose to Look at Best Clans... Let's go !!! :)", $COLOR_INFO)
			LookAtBestClans()
		Case 9
			SetLog("The spirit of DocOc chose to Look at Current War... Let's go !!! :)", $COLOR_INFO)
			LookAtCurrentWar()
		Case 10
			SetLog("The spirit of DocOc chose to Watch War replays... Let's go !!! :)", $COLOR_INFO)
			WatchWarReplays()
		Case 11
			SetLog("The spirit of DocOc chose to do nothing... Stupid BOT... :)", $COLOR_INFO)
			DoNothing()
		Case 12
			SetLog("The spirit of DocOc chose to launch Challenges... Let's go !!! :)", $COLOR_INFO)
			LaunchChallenges()
	EndSwitch

EndFunc   ;==>RandomHumanAction

Func SetActionPriority($ActionNumber)

	If _GUICtrlComboBox_GetCurSel($cmbPriority[$ActionNumber]) <> 0 Then
		MatchPriorityNValue($ActionNumber)
		$SetActionPriority[$ActionNumber] = Random($MinimumPriority, 100, 1)
	Else
		$SetActionPriority[$ActionNumber] = 0
	EndIf

EndFunc   ;==>SetActionPriority

Func MatchPriorityNValue($ActionNumber)

	Switch _GUICtrlComboBox_GetCurSel($cmbPriority[$ActionNumber])
		Case 1
			$MinimumPriority = 0
		Case 2
			$MinimumPriority = 25
		Case 3
			$MinimumPriority = 50
		Case 4
			$MinimumPriority = 75
	EndSwitch

EndFunc   ;==>MatchPriorityNValue

; ================================================== GUI FUNCTIONS PART ================================================== ;

Func chkUseBotHumanization()

	If GUICtrlRead($chkUseBotHumanization) = $GUI_CHECKED Then
		$ichkUseBotHumanization = 1
		For $i = $Icon1 To $chkLookAtRedNotifications
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		cmbStandardReplay()
		cmbWarReplay()
	Else
		$ichkUseBotHumanization = 0
		For $i = $Icon1 To $chkLookAtRedNotifications
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf

EndFunc   ;==>chkUseBotHumanization

Func chkUseAltRClick()

	If GUICtrlRead($chkUseAltRClick) = $GUI_CHECKED Then
		$UserChoice = MsgBox(4 + 48, "Warning !!!", "Full random click is a good feature to be as less BOT-Like as possible because it makes ALL BOT clicks random..." & _
				@CRLF & "" & @CRLF & "The crazy @RoroTiti use it all the time an he says there is no problem with it... BUT, it still an experimental feature which may cause unpredictable problems..." & _
				@CRLF & "" & @CRLF & "So, do you want to use it ? :)" & @CRLF & "" & @CRLF & "PS : No support will be provided to you if you use this function...")
		If $UserChoice = 6 Then
			$ichkUseAltRClick = 1
		Else
			$ichkUseAltRClick = 0
			GUICtrlSetState($chkUseAltRClick, $GUI_UNCHECKED)
		EndIf
	Else
		$ichkUseAltRClick = 0
	EndIf

EndFunc   ;==>chkUseAltRClick

Func chkCollectAchievements()

	If GUICtrlRead($chkCollectAchievements) = $GUI_CHECKED Then
		$ichkCollectAchievements = 1
	Else
		$ichkCollectAchievements = 0
	EndIf

EndFunc   ;==>chkCollectAchievements

Func chkLookAtRedNotifications()

	If GUICtrlRead($chkLookAtRedNotifications) = $GUI_CHECKED Then
		$ichkLookAtRedNotifications = 1
	Else
		$ichkLookAtRedNotifications = 0
	EndIf

EndFunc   ;==>chkLookAtRedNotifications

Func cmbStandardReplay()

	If _GUICtrlComboBox_GetCurSel($cmbPriority[3]) = 0 Then
		If _GUICtrlComboBox_GetCurSel($cmbPriority[4]) = 0 Then
			For $i = $Label7 To $cmbPause[0]
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
		Else
			For $i = $Label7 To $cmbPause[0]
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
		EndIf
	ElseIf _GUICtrlComboBox_GetCurSel($cmbPriority[4]) = 0 Then
		If _GUICtrlComboBox_GetCurSel($cmbPriority[3]) = 0 Then
			For $i = $Label7 To $cmbPause[0]
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
		Else
			For $i = $Label7 To $cmbPause[0]
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
		EndIf
	EndIf

EndFunc   ;==>cmbStandardReplay

Func cmbWarReplay()

	If _GUICtrlComboBox_GetCurSel($cmbPriority[10]) = 0 Then
		For $i = $Label13 To $cmbPause[1]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	Else
		For $i = $Label13 To $cmbPause[1]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	EndIf

EndFunc   ;==>cmbWarReplay

; ================================================== ADDITIONAL FUNCTIONS PART ================================================== ;

Func WaitForReplayWindow()

	SetLog("Waiting for Replay screen...", $COLOR_ACTION)

	$CheckStep = 0

	While Not IsReplayWindow() And $CheckStep < 30
		Sleep(1000)
		$CheckStep += 1
	WEnd

	Return $OnReplayWindow

EndFunc   ;==>WaitForReplayWindow

Func IsReplayWindow()

	$OnReplayWindow = _ColorCheck(_GetPixelColor(799, 619, True), "FF5151", 20)
	Return $OnReplayWindow

EndFunc   ;==>IsReplayWindow

Func GetReplayDuration()

	$MaxSpeed = _GUICtrlComboBox_GetCurSel($cmbMaxSpeed[$ReplayToPause])
	$Result = QuickMIS("N1", @ScriptDir & "\imgxml\Resources\Humanization Pics\Duration", 380, 600, 490, 630)

	If $Result = "OneMinute" Then
		$ReplayDuration[0] = 1
		$ReplayDuration[1] = 90000
	ElseIf $Result = "TwoMinutes" Then
		$ReplayDuration[0] = 2
		$ReplayDuration[1] = 150000
	ElseIf $Result = "ThreeMinutes" Then
		$ReplayDuration[0] = 3
		$ReplayDuration[1] = 180000
	Else
		$ReplayDuration[0] = 0
		$ReplayDuration[1] = 45000
	EndIf

	Switch $MaxSpeed
		Case 1
			$ReplayDuration[1] /= 2
		Case 2
			$ReplayDuration[1] /= 4
	EndSwitch

	SetLog("Estimated Replay Duration : " & $ReplayDuration[1] / 1000 & " second(s)", $COLOR_INFO)

EndFunc   ;==>GetReplayDuration

Func AccelerateReplay($ReplayToPause)

	$CurrentSpeed = 0
	$MaxSpeed = _GUICtrlComboBox_GetCurSel($cmbMaxSpeed[$ReplayToPause])

	If $CurrentSpeed <> $MaxSpeed Then SetLog("Let's make the replay faster...", $COLOR_ACTION1)

	While $CurrentSpeed < $MaxSpeed
		Click(820, 690) ; click on the speed button
		randomSleep(500)
		$CurrentSpeed += 1
	WEnd

EndFunc   ;==>AccelerateReplay

Func DoAPauseDuringReplay($ReplayToPause)

	Local $MinimumToPause = 0, $PauseScore = 0
	$Pause = _GUICtrlComboBox_GetCurSel($cmbPause[0])

	If $Pause <> 0 Then
		Switch $Pause
			Case 1
				$MinimumToPause = 80
			Case 2
				$MinimumToPause = 60
			Case 3
				$MinimumToPause = 40
			Case 4
				$MinimumToPause = 20
		EndSwitch

		$PauseScore = Random(0, 100, 1)
		If $PauseScore > $MinimumToPause Then
			SetLog("Let's do a small pause to see what happens...", $COLOR_ACTION1)
			Click(750, 690) ; click pause button
			randomSleep(10000, 3000)
			SetLog("Pause finished, let's relaunch replay !!!", $COLOR_ACTION1)
			Click(750, 690) ; click play button
		EndIf
	EndIf

EndFunc   ;==>DoAPauseDuringReplay

Func VisitAPlayer()

	SetLog("Let's visit player...", $COLOR_INFO)

	If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Humanization Pics\Visit") Then

		Click($QuickMISX, $QuickMISY)
		randomSleep(8000)

		For $i = 0 To Random(1, 4, 1)
			SetLog("We will click on a random builing...", $COLOR_ACTION1)
			$xInfo = Random(300, 500, 1)
			$yInfo = Random(300, 432, 1)
			Click($xInfo, $yInfo) ; click on a random builing
			randomSleep(1500)
			SetLog("... and open his Info window...", $COLOR_ACTION1)
			Click(430, 660) ; open the info window about building
			randomSleep(8000)
			Click(685, 175) ;Click Away
			randomSleep(3000)
		Next

	Else
		SetLog("Error when trying to find Visit button... skipping...", $COLOR_WARNING)
	EndIf

EndFunc   ;==>VisitAPlayer

Func DoNothing()

	SetLog("Let the BOT wait a little before continue...", $COLOR_ACTION1)
	randomSleep(8000, 3000)

EndFunc   ;==>DoNothing

Func LookAtRedNotifications()

	SetLog("Looking for notifications...", $COLOR_INFO)
	Local $NoNotif = 0

	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(55, 142, True), "D00818", 20) Then
		SetLog("You have a new message...", $COLOR_ACTION1)
		Click(40, 150) ; open Messages button
		randomSleep(8000, 3000)
		Click(760, 120) ; close window
		randomSleep(2000)
	Else
		$NoNotif += 1
	EndIf

	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(54, 83, True), "D00818", 20) Then
		SetLog("You changed of league...", $COLOR_ACTION1)
		Click(40, 80) ; open Cup button
		randomSleep(4000)
		Click(445, 610) ; click Okay
		randomSleep(1500)
		Click(830, 80) ; close window
		randomSleep(2000)
	Else
		$NoNotif += 1
	EndIf

	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(56, 511, True), "D00818", 20) Then
		SetLog("Current War to look at...", $COLOR_ACTION1)
		Click(40, 520) ; open War menu
		randomSleep(8000, 3000)
		Click(70, 680) ; return home
		randomSleep(2000)
	Else
		$NoNotif += 1
	EndIf

	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(28, 353, True), "D00818", 20) Then
		SetLog("New messages on the chat room...", $COLOR_ACTION1)
		Click(20, 380) ; open chat
		randomSleep(3000)
		Click(330, 380) ; close chat
		randomSleep(2000)
	Else
		$NoNotif += 1
	EndIf

	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(834, 512, True), "D00818", 20) Then
		SetLog("New messages or events from SC to read...", $COLOR_ACTION1)
		Click(820, 520) ; open events
		randomSleep(3000)

		If _ColorCheck(_GetPixelColor(245, 110, True), "F0F4F0", 20) Then ; check if we are on events/news tab
			Click(435, 110) ; open new tab
			randomSleep(3000)
		Else
			Click(245, 110) ; open events tab
			randomSleep(3000)
		EndIf

		Click(760, 120) ; close settings
		randomSleep(2000)
	Else
		$NoNotif += 1
	EndIf

	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(832, 638, True), "683072", 20) Or _ColorCheck(_GetPixelColor(832, 637, True), "D00818", 20) Then
		SetLog("There is something new on the shop...", $COLOR_ACTION1)
		Click(800, 670) ; open Shop
		randomSleep(2000)

		$NeedScroll = Random(0, 1, 1)
		$NeedScroll2 = Random(0, 1, 1)
		If $NeedScroll = 1 Then
			$xStart = Random(300, 800, 1)
			$xEnd = Random($xStart - 250, $xStart - 220, 1)
			$y = Random(360 - 10, 360 + 10, 1)
			ClickDrag($xStart, $y, $xEnd, $y) ; scroll the shop
			If $NeedScroll2 = 1 Then
				randomSleep(2000)
				$xEnd = Random(300, 800, 1)
				$xStart = Random($xEnd - 250, $xEnd - 220, 1)
				$y = Random(360 - 10, 360 + 10, 1)
				ClickDrag($xStart, $y, $xEnd, $y) ; scroll the shop
			EndIf
		EndIf

		randomSleep(2000)
		Click(820, 40) ; return home
		randomSleep(2000)
	Else
		$NoNotif += 1
	EndIf

	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(53, 24, True), "D00818", 20) Then
		SetLog("Maybe you have a new friend request, lemme check...", $COLOR_ACTION1)
		Click(40, 40) ; open profile
		randomSleep(2000)

		If IsClanOverview() Then
			If _ColorCheck(_GetPixelColor(772, 70, True), "D00818", 20) Then
				SetLog("It's confirmed, you have a new friend request, lemme check...", $COLOR_ACTION1)
				Click(700, 80)
				randomSleep(2000)
				If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Humanization Pics\Friend", 720, 165, 780, 600) Then
					Click($QuickMISX + 720, $QuickMISY + 165)
					randomSleep(1500)
					If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Humanization Pics\Friend", 440, 380, 590, 470) Then
						Click($QuickMISX + 440, $QuickMISY + 380)
					Else
						SetLog("Error when trying to find Okay button... skipping...", $COLOR_WARNING)
					EndIf
				Else
					SetLog("Error when trying to find friend request... skipping...", $COLOR_WARNING)
				EndIf
			Else
				SetLog("No friend request found... skipping...", $COLOR_WARNING)
			EndIf
		Else
			SetLog("Error when trying to open Social tab... skipping...", $COLOR_WARNING)
		EndIf
		randomSleep(2000)
	Else
		$NoNotif += 1
	EndIf

	If $NoNotif = 7 Then SetLog("No notification found, nothing to look at...", $COLOR_ACTION1)

EndFunc   ;==>LookAtRedNotifications

Func CollectAchievements()

	SetLog("Looking for achievement to collect...", $COLOR_INFO)

	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(53, 24, True), "D00818", 20) Then
		SetLog("WoW, maybe an achievement to collect !!!", $COLOR_ACTION1)
		Click(40, 40) ; open profile
		randomSleep(4000)

		If IsClanOverview() Then

			If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Humanization Pics\ClaimReward", 680) Then
				Click($QuickMISX + 680, $QuickMISY)
				SetLog("Reward collected !!! Good Job Chief :D !!!", $COLOR_SUCCESS)
				randomSleep(3000)
			Else
				SetLog('No "Claim Reward" button found... Lemme retry...', $COLOR_ERROR)
				If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Humanization Pics\ClaimReward", 680) Then
					Click($QuickMISX + 680, $QuickMISY)
					SetLog("Reward collected !!! Good Job Chief :D !!!", $COLOR_SUCCESS)
					randomSleep(3000)
				Else
					SetLog('No "Claim Reward" button found... skipping...', $COLOR_ERROR)
				EndIf
			EndIf

		Else
			SetLog("Error when trying to open Profile tab... skipping...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("No achievement to collect...", $COLOR_ACTION1)
	EndIf

EndFunc   ;==>CollectAchievements

Func Scroll($MaxScroll)

	For $i = 0 To $MaxScroll
		$x = Random(430 - 20, 430 + 20, 1)
		$yStart = Random(600 - 20, 600 + 20, 1)
		$yEnd = Random(200 - 20, 200 + 20, 1)
		ClickDrag($x, $yStart, $x, $yEnd) ; generic random scroll
		randomSleep(4000)
	Next

EndFunc   ;==>Scroll

; ================================================== SECURITY PART ================================================== ;

Func SecureMessage($TextToClean)

	Return StringRegExpReplace($TextToClean, "[^\w \-\,\?\!\:]", "") ; delete dangerous characters

EndFunc   ;==>SecureMessage

Func ReturnAtHome()

	$CheckStep = 0
	While Not IsMainScreen() And $CheckStep <= 5
		AndroidBackButton()
		Sleep(3000)
		$CheckStep += 1
	WEnd
	If Not IsMainScreen() Then
		SetLog("Main screen not found, need to restart CoC app...", $COLOR_ERROR)
		RestartAndroidCoC()
		waitMainScreen()
	EndIf

EndFunc   ;==>ReturnAtHome

Func IsMainScreen()

	$Result = _ColorCheck(_GetPixelColor(22, 49, True), "04579A", 20)
	Return $Result

EndFunc   ;==>IsMainScreen

Func IsMessagesReplayWindow()

	$Result = _ColorCheck(_GetPixelColor(760, 112, True), "FFFFFF", 20)
	Return $Result

EndFunc   ;==>IsMessagesReplayWindow

Func IsDefensesTab()

	$Result = _ColorCheck(_GetPixelColor(180, 110, True), "F0F4F0", 20)
	Return $Result

EndFunc   ;==>IsDefensesTab

Func IsAttacksTab()

	$Result = _ColorCheck(_GetPixelColor(380, 110, True), "F0F4F0", 20)
	Return $Result

EndFunc   ;==>IsAttacksTab

Func IsBestPlayers()

	$Result = _ColorCheck(_GetPixelColor(530, 60, True), "F0F4F0", 20)
	Return $Result

EndFunc   ;==>IsBestPlayers

Func IsBestClans()

	$Result = _ColorCheck(_GetPixelColor(350, 60, True), "F0F4F0", 20)
	Return $Result

EndFunc   ;==>IsBestClans

Func ChatOpen()

	$Result = _ColorCheck(_GetPixelColor(330, 382, True), "FFFFFF", 20)
	Return $Result

EndFunc   ;==>ChatOpen

Func IsClanChat()

	$Result = _ColorCheck(_GetPixelColor(220, 10, True), "787458", 20)
	Return $Result

EndFunc   ;==>IsClanChat

Func IsGlobalChat()

	$Result = _ColorCheck(_GetPixelColor(80, 10, True), "787458", 20)
	Return $Result

EndFunc   ;==>IsGlobalChat

Func IsTextBox()

	$Result = _ColorCheck(_GetPixelColor(190, 710, True), "FFFFFF", 20)
	Return $Result

EndFunc   ;==>IsTextBox

Func IsChallengeWindow()

	$Result = _ColorCheck(_GetPixelColor(698, 56, True), "FFFFFF", 20)
	Return $Result

EndFunc   ;==>IsChallengeWindow

Func IsChangeLayoutMenu()

	$Result = _ColorCheck(_GetPixelColor(184, 58, True), "FFFFFF", 20)
	Return $Result

EndFunc   ;==>IsChangeLayoutMenu

Func IsClanOverview()

	$Result = _ColorCheck(_GetPixelColor(822, 70, True), "FFFFFF", 20)
	Return $Result

EndFunc   ;==>IsClanOverview

Func IsWarMenu()

	$Result = _ColorCheck(_GetPixelColor(826, 34, True), "FFFFFF", 20)
	Return $Result

EndFunc   ;==>IsWarMenu

#ce
