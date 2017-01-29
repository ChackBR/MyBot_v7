; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization
; Description ...: This file contains all functions of @RoroTiti's Bot Humanization feature - Clan Part
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

Func LookAtWarLog()

	Click(20, 380) ; open chat
	randomSleep(3000)

	If ChatOpen() Then

		Click(230, 20) ; go to clan chat
		randomSleep(1500)

		If IsClanChat() Then

			Click(120, 60) ; open the clan menu
			randomSleep(1500)

			If IsClanOverview() Then

				If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\Humanization Pics\WarLog", 20, 320, 70, 360) Then

					Click(100, 340) ; open war log
					randomSleep(1500)
					SetLog("Let's scrolling the War log...", $COLOR_ACTION1)
					Scroll(Random(1, 3, 1)) ; scroll the war log

				Else
					SetLog("No War log button found... skipping...", $COLOR_WARNING)
				EndIf

				Click(830, 180) ; close window
				randomSleep(1000)
				Click(330, 380) ; close chat

			Else
				SetLog("Error when trying to open Clan overview... skipping...", $COLOR_WARNING)
			EndIf

		Else
			SetLog("Error when trying to open Clan Chat... skipping...", $COLOR_WARNING)
		EndIf

	Else
		SetLog("Error when trying to open Chat... skipping...", $COLOR_WARNING)
	EndIf

EndFunc   ;==>LookAtWarLog

Func VisitClanmates()

	Click(20, 380) ; open chat
	randomSleep(3000)

	If ChatOpen() Then

		Click(230, 20) ; go to clan chat
		randomSleep(1500)

		If IsClanChat() Then

			Click(120, 60) ; open the clan menu
			randomSleep(1500)

			If IsClanOverview() Then

				SetLog("Let's visit a random Player...", $COLOR_ACTION1)
				Click(660, 400 + 52 * Random(0, 5, 1)) ; click on a random player
				randomSleep(500)
				VisitAPlayer()
				Click(70, 680) ; return home

			Else
				SetLog("Error when trying to open Clan overview... skipping...", $COLOR_WARNING)
			EndIf

		Else
			SetLog("Error when trying to open Clan Chat... skipping...", $COLOR_WARNING)
		EndIf

	Else
		SetLog("Error when trying to open Chat... skipping...", $COLOR_WARNING)
	EndIf

EndFunc   ;==>VisitClanmates
