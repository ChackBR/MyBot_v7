; #FUNCTION# ====================================================================================================================
; Name ..........: Qt_SimpleQuickTrain
; Description ...: 
; Author ........: Chackall++
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Qt_SimpleQuickTrain( $bOpenArmyWindow = False, $nLoop = 2 )

	Local $i

	Setlog("Start: Simple Quick Train...", $COLOR_INFO)

	If $bOpenArmyWindow Then
		CheckIfArmyIsReady()
		If Not $g_bRunState Then Return
		If _Sleep(250) Then Return
	EndIf

	If Not OpenQuickTrainTab(True, "CheckCamp()") Then Return
	For $i = 1 TO $nLoop
		If _Sleep(500) Then Return
		TrainArmyNumber($g_bQuickTrainArmy)
		If _Sleep(500) Then Return
	Next

	If $bOpenArmyWindow Then
		If Not $g_bRunState Then Return
		ClickP($aAway, 2, 0, "#0346") ;Click Away
		If _Sleep(250) Then Return
	EndIf

EndFunc	;==> Qt_SimpleQuickTrain
