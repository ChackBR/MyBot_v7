; #FUNCTION# ====================================================================================================================
; Name ..........: CheckWardenMode (#-26)
; Description ...: Check in which Mode the Warden is and switch if needed
; Author ........: MantasM (10-2017)
; Modified ......: AiO++ Team
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckWardenMode($bOpenArmyWindow = False, $bCloseArmyWindow = False)
	If Not $g_bCheckWardenMode Or $g_iCheckWardenMode = -1 Then Return
	SetLog("Checking if Warden is in the correct Mode", $COLOR_INFO)

	If $bOpenArmyWindow Then
		If Not openArmyOverview() Then
			SetError(2)
			Return
		EndIf
	EndIf

	Local $sTile = "WardenAirMode_0_89.png", $sRegionToSearch = "795,400,825,425", $bGroundMode = False

	If Not IsTrainPage() Then
		If Not openArmyOverview() Then
			SetError(2)
			Return
		EndIf
	EndIf

	If FindImageInPlace($sTile, @ScriptDir & "\imgxml\imglocbuttons\" & $sTile, $sRegionToSearch) = "" Then
		SetLog("Found Grand Warden in Ground Mode!")
		If $g_iCheckWardenMode = 1 Then
			SetLog("Switching Wardens Mode to Air", $COLOR_INFO)
			SwitchWardenMode(Not $bCloseArmyWindow)
		EndIf
	Else
		SetLog("Found Grand Warden in Air Mode!")
		If $g_iCheckWardenMode = 0 Then
			SetLog("Switching Wardens Mode to Ground", $COLOR_INFO)
			SwitchWardenMode(Not $bCloseArmyWindow)
		EndIf
	EndIf

	If $bCloseArmyWindow Then
		ClickP($aAway, 1, 0, "#0000")
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf
EndFunc   ;==>CheckWardenMode

Func SwitchWardenMode($bReopenArmyWindow = True)
	If Not $g_bCheckWardenMode Then Return

	ClickP($aAway, 1, 0, "#0000")
	If _Sleep(500) Then Return

	checkMainScreen(False)

	ClickP($g_aiWardenAltarPos, 1, 0, "#8888") ;Click Warden Altar
	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get Warden info
	Local $sInfo = BuildingInfo(242, 520 + $g_iBottomOffsetY) ; 860x780
	If @error Then SetError(0, 0, 0)
	Local $iCount = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 520 + $g_iBottomOffsetY) ; 860x780
		If @error Then SetError(0, 0, 0)
		If _Sleep(100) Then Return
		$iCount += 1
		If $iCount = 50 Then Return
	WEnd
	If $g_bDebugSetlog Then SetLog(_ArrayToString($sInfo, " "))
	If @error Then Return SetError(0, 0, 0)

	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Grand") = 0 Then
			SetLog("Bad Grand Warden Location", $COLOR_ACTION)
			Return
		Else
			Local $aBtnCoordinates = findButton("GrandWardenSwitchBtn", Default, 1)
			If IsArray($aBtnCoordinates) Then
				ClickP($aBtnCoordinates)
				If _Sleep($DELAYCHECKARMYCAMP4) Then Return
				SetLog("Switched Grand Warden Mode successfully!", $COLOR_SUCCESS)
				ClickP($aAway, 1, 0, "#0000")
				If _Sleep($DELAYCHECKARMYCAMP4) Then Return
			Else
				SetLog("Cannot find the Grand Wardens Switch Mode Button!", $COLOR_ERROR)
				Return
			EndIf
		EndIf
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	If $bReopenArmyWindow Then
		If Not openArmyOverview() Then
			SetError(2)
			Return
		EndIf
	EndIf

EndFunc   ;==>SwitchWardenMode
