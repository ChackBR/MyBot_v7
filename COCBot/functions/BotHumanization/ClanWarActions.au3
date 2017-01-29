; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization
; Description ...: This file contains all functions of @RoroTiti's Bot Humanization feature - War Part
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: 11/11/2016
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
;				   Because this file is a part of an open-sourced project, I allow all MODders and DEVelopers to use these functions.
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: No
;================================================================================================================================

Func LookAtCurrentWar()

	Click(40, 530) ; open war menu
	randomSleep(5000)

	If IsWarMenu() Then

		If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Humanization Pics\CurrentWar", 740, 320, 830, 420) Then

			SetLog("Let's examine the map...", $COLOR_ACTION1)
			Scroll(Random(2, 5, 1)) ; scroll enemy
			randomSleep(3000)

			$LookAtHome = Random(0, 1, 1)
			If $LookAtHome = 1 Then
				SetLog("Looking at home territory...", $COLOR_ACTION1)
				Click(790, 370) ; go to home territory
				Scroll(Random(2, 5, 1)) ; scroll home
				randomSleep(3000)
			EndIf

			SetLog("Open War details menu...", $COLOR_ACTION1)
			Click(800, 670) ; go to war details
			randomSleep(1500)

			If IsClanOverview() Then

				$FirstMenu = Random(1, 2, 1)
				Switch $FirstMenu
					Case 1
						SetLog("Looking at first tab...", $COLOR_ACTION1)
						Click(180, 80) ; click first tab
					Case 2
						SetLog("Looking at second tab...", $COLOR_ACTION1)
						Click(360, 80) ; click second tab
				EndSwitch
				randomSleep(1500)

				Scroll(Random(1, 3, 1)) ; scroll the tab

				$SecondMenu = Random(1, 2, 1)
				Switch $SecondMenu
					Case 1
						SetLog("Looking at third tab...", $COLOR_ACTION1)
						Click(530, 80) ; click the third tab
					Case 2
						SetLog("Looking at fourth tab...", $COLOR_ACTION1)
						Click(700, 80) ; click the fourth tab
				EndSwitch
				randomSleep(1500)

				Scroll(Random(2, 4, 1)) ; scroll the tab

				Click(830, 80) ; close window
				randomSleep(1500)
				Click(70, 680) ; return home

			Else
				SetLog("Error when trying to open War Details window... skipping...", $COLOR_WARNING)
			EndIf

		Else
			SetLog("Your Clan is not in active war yet... skipping...", $COLOR_WARNING)
			randomSleep(1500)
			Click(70, 680) ; return home
		EndIf

	Else
		SetLog("Error when trying to open War window... skipping...", $COLOR_WARNING)
	EndIf

EndFunc   ;==>LookAtCurrentWar

Func WatchWarReplays()

	Click(40, 530) ; open war menu
	randomSleep(5000)

	If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Humanization Pics\WarDetails", 740, 620, 850, 720) And QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Humanization Pics\CurrentWar", 740, 320, 830, 420) Then

		SetLog("Open War details menu...", $COLOR_ACTION1)
		Click(800, 670) ; go to war details
		randomSleep(1500)

		If IsClanOverview() Then

			SetLog("Looking at second tab...", $COLOR_ACTION1)
			Click(360, 80) ; go to replays tab
			randomSleep(1500)

			If IsBestClans() Then

				Local $ReplayNumber = QuickMIS("Q1", @ScriptDir & "\imgxml\Resources\Humanization Pics\Replay", 780, 240, 840, 670)

				If $ReplayNumber > 0 Then

					SetLog("There are " & $ReplayNumber & " replays to watch... We will choose one of them...", $COLOR_INFO)
					$ReplayToLaunch = Random(1, $ReplayNumber, 1)

					Click(810, 269 + 74 * ($ReplayToLaunch - 1)) ; click on the choosen replay

					WaitForReplayWindow()

					If IsReplayWindow() Then

						GetReplayDuration()
						randomSleep(1000)

						If IsReplayWindow() Then
							AccelerateReplay(0)
						EndIf

						randomSleep($ReplayDuration[1] / 3)

						If IsReplayWindow() Then
							DoAPauseDuringReplay(0)
						EndIf

						randomSleep($ReplayDuration[1] / 3)

						If IsReplayWindow() And $ReplayDuration[0] <> 0 Then
							DoAPauseDuringReplay(0)
						EndIf

						Setlog("Waiting for replay end...", $COLOR_ACTION)

						While IsReplayWindow()
							Sleep(2000)
						WEnd

						randomSleep(1000)
						Click(70, 680) ; return home

					EndIf

				Else
					SetLog("No replay to watch yet... skipping...", $COLOR_WARNING)
				EndIf

			Else
				SetLog("Error when trying to open Replays menu... skipping...", $COLOR_WARNING)
			EndIf

		Else
			SetLog("Error when trying to open War Details window... skipping...", $COLOR_WARNING)
		EndIf

		Click(830, 80) ; close window
		randomSleep(2500)
		Click(70, 680) ; return home

	Else

		SetLog("Your Clan is not in active war yet... skipping...", $COLOR_WARNING)
		randomSleep(1500)
		Click(70, 680) ; return home

	EndIf

EndFunc   ;==>WatchWarReplays
