; #FUNCTION# ====================================================================================================================
; Name ..........: Qt_SimpleQuickTrain
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: Chack++
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Qt_SimpleQuickTrain( $bOpenArmyWindow = False, $nLoop = 2 )

	Local $i
	Local $bCloseArmyWindow = False

	Setlog("Simple Quick Train", $COLOR_INFO)

	If $bOpenArmyWindow Then
		OpenArmyOverview(True, "CheckCamp()")
		If _Sleep(500) Then Return
	EndIf

	; If $g_bCanRequestCC = True Then RequestCC(True)

	If Not OpenQuickTrainTab(True, "CheckCamp()") Then Return
	For $i = 1 TO $nLoop
		If _Sleep(1000) Then Return
		TrainArmyNumber($g_bQuickTrainArmy)
		If _Sleep(700) Then Return
	Next

	If $bCloseArmyWindow Then
		ClickP($aAway, 2, 0, "#0346") ;Click Away
		If _Sleep(250) Then Return
	EndIf

EndFunc	;==> Qt_SimpleQuickTrain
