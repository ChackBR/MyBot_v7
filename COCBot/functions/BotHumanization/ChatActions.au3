; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization
; Description ...: This file contains all functions of @RoroTiti's Bot Humanization feature - Chat Part
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: 04/12/2016
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
;				   Because this file is a part of an open-sourced project, I allow all MODders and DEVelopers to use these functions.
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: No
;================================================================================================================================

Func ReadClanChat()

	Click(20, 380) ; open chat
	randomSleep(3000)

	If ChatOpen() Then

		Click(230, 20) ; go to clan chat
		randomSleep(1500)

		If Not IsClanChat() Then SetLog("Warning, we will scroll Global chat...", $COLOR_WARNING)

		$MaxScroll = Random(0, 3, 1)
		SetLog("Let's scrolling the Chat...", $COLOR_ACTION1)
		For $i = 0 To $MaxScroll
			$x = Random(280 - 10, 280 + 10, 1)
			$yStart = Random(110 - 10, 110 + 10, 1)
			$yEnd = Random(660 - 10, 660 + 10, 1)
			ClickDrag($x, $yStart, $x, $yEnd) ; scroll the chat
			randomSleep(10000, 3000)
		Next

		Click(330, 380) ; close chat

	Else
		SetLog("Error when trying to open Chat... skipping...", $COLOR_WARNING)
	EndIf

EndFunc   ;==>ReadClanChat

Func ReadGlobalChat()

	Click(20, 380) ; open chat
	randomSleep(3000)

	If ChatOpen() Then

		Click(80, 20) ; go to global chat
		randomSleep(1500)

		If Not IsGlobalChat() Then SetLog("Warning, we will scroll Clan chat...", $COLOR_WARNING)

		$MaxScroll = Random(0, 3, 1)
		SetLog("Let's scrolling the Chat...", $COLOR_ACTION1)
		For $i = 0 To $MaxScroll
			$x = Random(280 - 10, 280 + 10, 1)
			$yStart = Random(110 - 10, 110 + 10, 1)
			$yEnd = Random(660 - 10, 660 + 10, 1)
			ClickDrag($x, $yStart, $x, $yEnd) ; scroll the chat
			randomSleep(10000, 3000)
		Next

		Click(330, 380) ; close chat

	Else
		SetLog("Error when trying to open Chat... skipping...", $COLOR_WARNING)
	EndIf

EndFunc   ;==>ReadGlobalChat

Func SaySomeChat()

	Click(20, 380) ; open chat
	randomSleep(3000)

	If ChatOpen() Then

		Click(230, 20) ; go to clan chat
		randomSleep(1500)

		If Not IsClanChat() Then SetLog("Warning, we will chat on Global chat...", $COLOR_WARNING)

		Click(280, 710) ; click message button
		randomSleep(2000)

		If IsTextBox() Then

			$ChatToSay = Random(0, 1, 1)
			$CleanMessage = SecureMessage(GUICtrlRead($humanMessage[$ChatToSay]))
			SetLog("Writing """ & $CleanMessage & """ to the chat box...", $COLOR_ACTION1)
			SendText($CleanMessage)

			randomSleep(500)
			Click(830, 710) ; click send message

			randomSleep(1500)
			Click(330, 380) ; close chat

		Else
			SetLog("Error when trying to open Text Box for chatting... skipping...", $COLOR_WARNING)
		EndIf

	Else
		SetLog("Error when trying to open Chat... skipping...", $COLOR_WARNING)
	EndIf

EndFunc   ;==>SaySomeChat

Func LaunchChallenges()

	Click(20, 380) ; open chat
	randomSleep(3000)

	If ChatOpen() Then

		Click(230, 20) ; go to clan chat
		randomSleep(1500)

		If IsClanChat() Then

			Click(260, 60) ; click challenge button
			randomSleep(1500)

			If IsChallengeWindow() Then

				Click(530, 110) ; click text box
				SendText(SecureMessage(GUICtrlRead($challengeMessage)))
				randomSleep(1500)

				$Layout = Random(1, 2, 1) ; choose a layout between normal or war base
				If $Layout <> $LastLayout Then
					Click(240, 250) ; click choose layout button
					randomSleep(1000)

					If IsChangeLayoutMenu() Then

						Switch $Layout
							Case 1
								$LastLayout = 1
								$y = Random(190 - 10, 190 + 10, 1)
								$xStart = Random(170 - 10, 170 + 10, 1)
								$xEnd = Random(830 - 10, 830 + 10, 1)
								ClickDrag($xStart, $y, $xEnd, $y) ; scroll the layout bar to see normal bases
							Case 2
								$LastLayout = 2
								$y = Random(190 - 10, 190 + 10, 1)
								$xStart = Random(690 - 10, 690 + 10, 1)
								$xEnd = Random(20 - 10, 20 + 10, 1)
								ClickDrag($xStart, $y, $xEnd, $y) ; scroll the layout bar to see war bases
						EndSwitch

						randomSleep(2000)
						Click(240, 180) ; click first layout
						randomSleep(1500)
						Click(180, 60) ; click top left return button

					Else
						SetLog("Error when trying to open Change Layout menu... skipping...", $COLOR_WARNING)
					EndIf
				EndIf

				If IsChallengeWindow() Then

					randomSleep(1500)
					Click(530, 250) ; click start button
					randomSleep(1500)
					Click(330, 380) ; close chat

				Else
					SetLog("We are not anymore on Start Challenge window... skipping...", $COLOR_WARNING)
				EndIf

			Else
				SetLog("Error when trying to open Start Challenge window... skipping...", $COLOR_WARNING)
			EndIf

		Else
			SetLog("Error when trying to open Clan Chat... skipping...", $COLOR_WARNING)
		EndIf

	Else
		SetLog("Error when trying to open Chat... skipping...", $COLOR_WARNING)
	EndIf

EndFunc   ;==>LaunchChallenges
