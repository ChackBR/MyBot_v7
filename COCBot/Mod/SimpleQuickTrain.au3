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

Func Qt_SimpleQuickTrain( $NeedOpenArmy = False, $nLoop = 3 )
	Local $i
	Local $Num
	Setlog("Simple Quick Train")
	If $g_bRunState = False Then Return
	$Num = $g_iQuickTrainArmyNum
	If $g_bCanRequestCC = True Then RequestCC()
	If $NeedOpenArmy Then
		OpenArmyWindow()
		If _Sleep(500) Then Return
	EndIf
	If $g_bCanRequestCC = False Then
		$g_bCanRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
		If _Sleep(500) Then Return
	EndIf
	OpenTrainTabNumber($QuickTrainTAB, "CheckCamp()")
	For $i = 1 TO $nLoop
		If _Sleep(500) Then Return
		If $Num > 1 Then
			If $Num > 2 Then
				TrainArmyNumber( $Num - 2 )
				If _Sleep(250) Then Return
			EndIf
			TrainArmyNumber( $Num - 1 )
			If _Sleep(250) Then Return
		EndIf
		TrainArmyNumber($Num)
		If _Sleep(500) Then Return
	Next
	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(1000) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts
	If $g_bCanRequestCC = True Then RequestCC()

EndFunc	;==> Qt_SimpleQuickTrain
