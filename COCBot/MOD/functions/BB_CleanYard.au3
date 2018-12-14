; #FUNCTION# ====================================================================================================================
; Name ..........: SM CleanYardBB
; Description ...: This file is used to automatically clear Yard from Trees, Trunks etc. from builder base
; Author ........: Fahid.Mahmood
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CleanYardBB() ;Call this function After ClockTower So It can benfit from builder boost
	; Early exist if noting to do
	If Not $g_bRunState Then Return
	If Not $g_bChkCleanYardBB And Not TestCapture() Then Return

	Local $bBuilderBase = True

	If Not isOnBuilderBase(True) Then ; Check if already on Builder base
		ClickP($aAway, 1, 0, "#0332") ;Click Away
		If Not SwitchBetweenBases($bBuilderBase) Then Return ; Switching to Builders Base
	Else
		checkMainScreen(True, $bBuilderBase)
	EndIf
	If IsMainPageBuilderBase() Then ; Double Check to see if Bot is on builder base
		SetLog("Going to check Builder Base Yard For Obstacles!", $COLOR_INFO)
		; Timer
		Local $hObstaclesTimer = __TimerInit()

		; Get Builders available
		If Not getBuilderCount(False, $bBuilderBase) Then Return ; update builder data, return if problem

		If $g_aiCurrentLootBB[$eLootElixirBB] = 0 Then BuilderBaseReport() ; BB elixer is 0 then check builderbase report

		If _Sleep($DELAYRESPOND) Then Return

		; Obstacles function to Parallel Search , will run all pictures inside the directory

		; Setup arrays, including default return values for $return
		Local $Filename = ""
		Local $iObstacleRemoved = 0
		Local $CleanYardBBXY

		Local $sCocDiamond = $g_BBCocDiamondECD
		Local $redLines = $sCocDiamond

		Local $bNoBuilders = $g_iFreeBuilderCountBB < 1

		If $g_iFreeBuilderCountBB > 0 And $g_bChkCleanYardBB = True And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000 Then

			Local $aResult = findMultiple($g_sImgCleanYardBB, $sCocDiamond, $redLines, 0, 1000, 20, "objectname,objectlevel,objectpoints", True)

			If IsArray($aResult) Then
				For $matchedValues In $aResult
					Local $aPoints = decodeMultipleCoords($matchedValues[2])
					$Filename = $matchedValues[0] ; Filename
					For $i = 0 To UBound($aPoints) - 1
						$CleanYardBBXY = $aPoints[$i] ; Coords
						If UBound($CleanYardBBXY) > 1 And _IsPointInPoly($CleanYardBBXY[0], $CleanYardBBXY[1], $g_aaiBBPolygonPoints) Then ; Check if X,Y is inside Builderbase or outside P.S Due to wrong detection outside builderbase
							$iObstacleRemoved += 1
							SetLog("Going to remove Builder Base Obstacle : " & $iObstacleRemoved, $COLOR_SUCCESS)
							If $g_bDebugSetlog Then SetDebugLog($Filename & " found (" & $CleanYardBBXY[0] & "," & $CleanYardBBXY[1] & ")", $COLOR_SUCCESS)
							If IsMainPageBuilderBase() Then Click($CleanYardBBXY[0], $CleanYardBBXY[1], 1, 0, "#0430")
							If _Sleep($DELAYCOLLECT3) Then Return
							If IsMainPageBuilderBase() Then GemClick($aCleanYard[0], $aCleanYard[1], 1, 0, "#0431") ; Click Obstacles button to clean
							If _Sleep($DELAYCHECKTOMBS2) Then Return
							ClickP($aAway, 2, 300, "#0329") ;Click Away
							If _Sleep($DELAYCHECKTOMBS1) Then Return
							If getBuilderCount(False, $bBuilderBase) = False Then Return ; update builder data, return if problem
							If _Sleep($DELAYRESPOND) Then Return
							If $g_iFreeBuilderCountBB = 0 Then
								SetLog("No More Builders available in Builder Base to remove Obstacles!")
								If _Sleep(2000) Then Return
								ExitLoop (2)
							EndIf
						ElseIf UBound($CleanYardBBXY) > 1 Then
							If $g_bDebugSetlog Then SetDebugLog("Coordinate Outside Of Builder Base [x,y][" & $CleanYardBBXY[0] & ", " & $CleanYardBBXY[1] & "]")
						EndIf
					Next
				Next
			EndIf
		ElseIf $g_iFreeBuilderCountBB > 0 And $g_bChkCleanYardBB = True And Number($g_aiCurrentLootBB[$eLootElixirBB]) < 50000 Then
			SetLog("Sorry, Low Builder Base Elixer(" & $g_aiCurrentLootBB[$eLootElixirBB] & ") Skip remove Obstacles check!", $COLOR_INFO)
		EndIf

		If $bNoBuilders Then
			SetLog("Builder not available to remove Builder Base Obstacles!")
		Else
			If $iObstacleRemoved = 0 And $g_bChkCleanYardBB And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000 Then SetLog("No Obstacles found, Builder Base Yard is clean!", $COLOR_SUCCESS)
			If $g_bDebugSetlog Then SetDebugLog("Time: " & Round(__TimerDiff($hObstaclesTimer) / 1000, 2) & "'s", $COLOR_SUCCESS)
		EndIf
		ClickP($aAway, 1, 300, "#0329") ;Click Away
	EndIf
EndFunc   ;==>CleanYardBB

Func chkCleanYardBB()
	If GUICtrlRead($g_hChkCleanYardBB) = $GUI_CHECKED Then
		$g_bChkCleanYardBB = True
	Else
		$g_bChkCleanYardBB = False
	EndIf
EndFunc   ;==>chkCleanYardBB
