; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization
; Description ...: This file contains all functions of @RoroTiti's Bot Humanization feature - Attack and Defenses Part
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

Func WatchDefense()

	Click(40, 150) ; open messages tab - defenses tab
	randomSleep(1500)

	If IsMessagesReplayWindow() Then

		Click(190, 130) ; open defenses tab
		randomSleep(1500)

		If IsDefensesTab() Then

			Click(710, (230 + 145 * Random(0, 2, 1))) ; click on a random replay

			WaitForReplayWindow()

			If IsReplayWindow() Then

				GetReplayDuration()
				randomSleep(1000)

				If IsReplayWindow() Then
					AccelerateReplay(0)
				EndIf

				randomSleep($ReplayDuration[1] / 3)

				Local $IsBoring = Random(1, 5, 1)
				If $IsBoring >= 4 Then

					If IsReplayWindow() Then
						SetLog("This replay is boring, let me go out... ;)", $COLOR_ACTION1)
						Click(70, 680) ; return home
					EndIf

				Else

					If IsReplayWindow() Then
						DoAPauseDuringReplay(0)
					EndIf

					randomSleep($ReplayDuration[1] / 3)

					If IsReplayWindow() And $ReplayDuration[0] <> 0 Then
						DoAPauseDuringReplay(0)
					EndIf

					If IsReplayWindow() Then Setlog("Waiting for replay end...", $COLOR_ACTION)

					While IsReplayWindow()
						Sleep(2000)
					WEnd

					randomSleep(1000)
					Click(70, 680) ; return home

				EndIf
			EndIf

		Else
			SetLog("Error when trying to open Defenses menu... skipping...", $COLOR_WARNING)
		EndIf

	Else
		SetLog("Error when trying to open Replays menu... skipping...", $COLOR_WARNING)
	EndIf

EndFunc   ;==>WatchDefense

Func WatchAttack()

	Click(40, 150) ; open messages tab - defenses tab
	randomSleep(1500)

	If IsMessagesReplayWindow() Then

		Click(380, 130) ; open attacks tab
		randomSleep(1500)

		If IsAttacksTab() Then

			Click(710, (230 + 145 * Random(0, 2, 1))) ; click on a random replay

			WaitForReplayWindow()

			If IsReplayWindow() Then

				GetReplayDuration()
				randomSleep(1000)

				If IsReplayWindow() Then
					AccelerateReplay(0)
				EndIf

				randomSleep($ReplayDuration[1] / 3)

				Local $IsBoring = Random(1, 5, 1)
				If $IsBoring >= 4 Then

					If IsReplayWindow() Then
						SetLog("This replay is boring, let me go out... ;)", $COLOR_ACTION1)
						randomSleep(1000)
						Click(70, 680) ; return home
					EndIf

				Else

					If IsReplayWindow() Then
						DoAPauseDuringReplay(0)
					EndIf

					randomSleep($ReplayDuration[1] / 3)

					If IsReplayWindow() And $ReplayDuration[0] <> 0 Then
						DoAPauseDuringReplay(0)
					EndIf

					If IsReplayWindow() Then Setlog("Waiting for replay end...", $COLOR_ACTION)

					While IsReplayWindow()
						Sleep(2000)
					WEnd

					randomSleep(1000)
					Click(70, 680) ; return home

				EndIf
			EndIf

		Else
			SetLog("Error when trying to open Defenses menu... skipping...", $COLOR_WARNING)
		EndIf

	Else
		SetLog("Error when trying to open Replays menu... skipping...", $COLOR_WARNING)
	EndIf

EndFunc   ;==>WatchAttack
