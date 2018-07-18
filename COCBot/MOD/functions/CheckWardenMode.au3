; #FUNCTION# ====================================================================================================================
; Name ..........: CheckWardenMode
; Description ...: Check in which Mode the Warden is and switch if needed
; Author ........: MantasM (10-2017), NguyenAnhHD (04-2018)
; Modified ......: Team AiO MOD++ (2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckWardenMode($bOpenArmyWindow = False, $bCloseArmyWindow = False)
	If Not $g_bCheckWardenMode Or $g_iCheckWardenMode = -1 Then Return
	SetLog("Checking if Warden is in the correct Mode", $COLOR_INFO)

	If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
		SetError(1)
		Return; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "CheckWardenMode()") Then
			SetError(2)
			Return; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	If QuickMIS("BC1", $g_sImgGrandWardenHeal, 800, 341, 829, 369) Then
		SetLog("Grand Warden not available, skip check....!", $COLOR_ACTION)
		If $bCloseArmyWindow Then ClickP($aAway, 2, $DELAYCHECKARMYCAMP4, "#0000")
		Return
	EndIf

	If QuickMIS("BC1", $g_sImgGrandWardenMode, 795, 403, 825, 426) Then
		SetLog("Found Grand Warden in Air Mode!")
		If $g_iCheckWardenMode = 0 Then
			SetLog("Switching Wardens Mode to Ground", $COLOR_INFO)
			SwitchWardenMode(Not $bCloseArmyWindow)
		EndIf
	Else
		SetLog("Found Grand Warden in Ground Mode!")
		If $g_iCheckWardenMode = 1 Then
			SetLog("Switching Wardens Mode to Air", $COLOR_INFO)
			SwitchWardenMode(Not $bCloseArmyWindow)
		EndIf
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
	While Not IsArray($sInfo)
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
			SetLog("Bad Grand Warden location, please reposition again!", $COLOR_ACTION)
			Return
		Else
			Local $aBtnCoordinates = findButton("GrandWarden", Default, 1, True)
			If IsArray($aBtnCoordinates) Then
				ClickP($aBtnCoordinates, 1, 0, "#0000")
				If _Sleep($DELAYCHECKARMYCAMP4) Then Return
				SetLog("Switched Grand Warden Mode successfully!", $COLOR_SUCCESS)
				ClickP($aAway, 1, 0, "#0000")
				If _Sleep($DELAYCHECKARMYCAMP4) Then Return
			Else
				SetLog("Cannot find the Grand Wardens Switch Mode button!", $COLOR_ERROR)
				Return
			EndIf
		EndIf
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	If $bReopenArmyWindow Then
		If Not OpenArmyOverview(True, "SwitchWardenMode()") Then
			SetError(2)
			Return
		EndIf
	EndIf

EndFunc   ;==>SwitchWardenMode
