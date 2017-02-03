; #FUNCTION# ====================================================================================================================
; Name ..........: SmartQuickTrain / QT_ClickTrain
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: Chack++
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SimpleQuickTrain( $NeedOpenArmy = False, $Num = 0, $nLoop = 3 )
	Local $i
	Setlog("Simple Quick Train")
	If $Runstate = False Then Return
	IF $Num = 0 Then
		If $iChkQuickArmy1 = 1 Then $Num = 1
		If $iChkQuickArmy2 = 1 Then $Num = 2
		If $iChkQuickArmy3 = 1 Then $Num = 3
	EndIf
	If $NeedOpenArmy Then
		OpenArmyWindow()
		If _Sleep(500) Then Return
		OpenTrainTabNumber($QuickTrainTAB)
	EndIf
	If _Sleep(1000) Then Return
	For $i = 1 TO $nLoop
		If $Num > 1 Then
			If $Num > 2 Then
				TrainArmyNumber( $Num - 2 )
				If _Sleep(250) Then Return
			EndIf
			TrainArmyNumber( $Num - 1 )
			If _Sleep(250) Then Return
		EndIf
		TrainArmyNumber($Num)
		If _Sleep(700) Then Return
	Next
	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(250) Then Return

EndFunc	;==>SimpleQuickTrain
