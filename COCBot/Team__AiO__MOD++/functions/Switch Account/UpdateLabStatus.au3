; #FUNCTION# ====================================================================================================================
; Name ..........: UpdateLabStatus (#-12)
; Description ...: Laboratory status and researching time
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func LabStatusAndTime()

	Local $directory = @ScriptDir & "\imgxml\Lab\Research"
	Local $bResearchButtonFound, $aResearchButtonCord[2]
	Local $day = 0, $hour = 0, $min = 0
	Static $bNeedLocateLab[8] = [True, True, True, True, True, True, True, True]
	Local $Account = 0


	; locate lab
	If $g_aiLaboratoryPos[0] <= 0 Or $g_aiLaboratoryPos[1] <= 0 Then
		If $g_bChkSwitchAcc Then $Account = $g_iCurAccount	; SwitchAcc Demen_SA_#9001
		If $bNeedLocateLab[$Account] Then
			SetLog("Laboratory has not been located", $COLOR_ERROR)
			LocateLab()
			If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
				SetLog("Problem locating Laboratory", $COLOR_ERROR)
			EndIf
			$bNeedLocateLab[$Account] = False ; give only one chance to locate lab. If ignore, then skip it for good.
		Else
			Return
		EndIf
	EndIf
	If _Sleep($DELAYLABORATORY1) Then Return

	BuildingClickP($g_aiLaboratoryPos, "#0197")
	If _Sleep($DELAYLABORATORY1) Then Return

	; Find Research Button
	_CaptureRegion2(400, 610, 700, 700)
	Local $Res = DllCall($g_hLibMyBot, "str", "SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)
	If IsArray($Res) Then
		If $Res[0] = "" Or $Res[0] = "0" Then
			$bResearchButtonFound = False
		ElseIf StringInStr($Res[0], "-1") <> 0 Then
			SetLog("DLL Error", $COLOR_ERROR)
		Else ; coordinates of first/one image found + boolean value
			Local $Result = ""
			Local $KeyValue = StringSplit($Res[0], "|", $STR_NOCOUNT)
			For $i = 0 To UBound($KeyValue) - 1
				Local $DLLRes = DllCall($g_sLibImgLocPath, "str", "GetProperty", "str", $KeyValue[$i], "str", "objectpoints")
				$Result &= $DLLRes[0] & "|"
			Next
			If StringRight($Result, 1) = "|" Then $Result = StringLeft($Result, (StringLen($Result) - 1))
			$aResearchButtonCord = StringSplit($Result, ",", $STR_NOCOUNT)
			$bResearchButtonFound = True
		EndIf
	EndIf

	; Click Research Button
	If $bResearchButtonFound Then
		PureClick($aResearchButtonCord[0] + 400, $aResearchButtonCord[1] + 610)
		If _Sleep($DELAYLABORATORY1) Then Return
	Else
		Setlog("Trouble finding research button, try again...", $COLOR_WARNING)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0199")
		Return False
	EndIf

	; check for upgrade in process
	If _ColorCheck(_GetPixelColor(730, 200, True), Hex(0xA2CB6C, 6), 20) Then ; Look for light green in upper right corner of lab window.
		Local $LabTimeOCR = getRemainTLaboratory(282, 271) ; Try to read white text showing actual time left for upgrade
		Local $aArray = StringSplit($LabTimeOCR, ' ', BitOR($STR_CHRSPLIT, $STR_NOCOUNT)) ;separate days, hours, minutes, seconds
		SetLog("Laboratory research time: " & $LabTimeOCR, $COLOR_INFO)
		If IsArray($aArray) Then
			For $i = 0 To UBound($aArray) - 1 ; step through array and compute minutes remaining
				Local $sTime = ""
				Select
					Case StringInStr($aArray[$i], "d", $STR_NOCASESENSEBASIC) > 0
						$sTime = StringTrimRight($aArray[$i], 1) ; removing "d"
						$day = Int($sTime)
					Case StringInStr($aArray[$i], "h", $STR_NOCASESENSEBASIC) > 0
						$sTime = StringTrimRight($aArray[$i], 1) ; removing "h"
						$hour = Int($sTime)
					Case StringInStr($aArray[$i], "m", $STR_NOCASESENSEBASIC) > 0
						$sTime = StringTrimRight($aArray[$i], 1) ; removing "m"
						$min = Int($sTime)
				EndSelect
			Next
			$g_aLabTime[0] = $day
			$g_aLabTime[1] = $hour
			$g_aLabTime[2] = $min
			$g_aLabTime[3] = $day * 24 * 60 + $hour * 60 + $min

			If $g_bChkSwitchAcc Then
				$g_aLabTimeAcc[$g_iCurAccount] = $g_aLabTime[3]	; For SwitchAcc Mode
				$g_aLabTimerStart[$g_iCurAccount] = TimerInit() 	; start counting lab time of current account
			EndIf

		Else
			If $g_bDebugSetlog Then Setlog("Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
			ClickP($aAway, 2, $DELAYLABORATORY4, "#0199")
			Return False
		EndIf

		If _Sleep($DELAYLABORATORY2) Then Return
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
		$g_bLabReady = False
		Return True

	ElseIf _ColorCheck(_GetPixelColor(730, 200, True), Hex(0x8088B0, 6), 20) Then ; Look for light purple in upper right corner of lab window.
		SetLog("Laboratory has stopped", $COLOR_INFO)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
		$g_bLabReady = True
		Return True
	Else
		SetLog("Unable to determine Lab Status", $COLOR_INFO)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
		Return False
	EndIf
EndFunc   ;==>LabStatusAndTime

Func UpdateLabStatus()

	Local $sLabTime = ""
	Local $hLab = 0, $hLabTime = 0	; SwitchAcc Demen_SA_#9001

	If $g_bChkSwitchAcc Then
		$hLab = $g_ahLblLab[$g_iCurAccount]
		$hLabTime = $g_ahLblLabTime[$g_iCurAccount]
	EndIf

	If LabStatusAndTime() Then
		If $g_bLabReady Then
			$sLabTime = "Ready"
			GUICtrlSetColor($g_hLblLab, $COLOR_GREEN)
			GUICtrlSetColor($g_hLblLabTime, $COLOR_GREEN)
			GUICtrlSetColor($hLab, $COLOR_GREEN) 		; profile stats tab - SwitchAcc Demen_SA_#9001
			GUICtrlSetColor($hLabTime, $COLOR_GREEN) 	; profile stats tab
		ElseIf $g_aLabTime[3] > 0 Then
			GUICtrlSetColor($g_hLblLab, $COLOR_BLACK)
			GUICtrlSetColor($g_hLblLabTime, $COLOR_BLACK)
			GUICtrlSetColor($hLab, $COLOR_BLACK) 		; profile stats tab
			GUICtrlSetColor($hLabTime, $COLOR_BLACK) 	; profile stats tab
			If $g_aLabTime[0] > 0 Then
				$sLabTime = $g_aLabTime[0] & "d " & $g_aLabTime[1] & "h"
			ElseIf $g_aLabTime[1] > 0 Then
				$sLabTime = $g_aLabTime[1] & "h " & $g_aLabTime[2] & "m"
			ElseIf $g_aLabTime[2] > 0 Then
				$sLabTime = $g_aLabTime[2] & "m "
			EndIf
		Else
			GUICtrlSetColor($g_hLblLab, $COLOR_MEDGRAY)
			GUICtrlSetColor($hLab, $COLOR_MEDGRAY) 		; profile stats tab
		EndIf

	Else
		GUICtrlSetColor($g_hLblLab, $COLOR_MEDGRAY)
		GUICtrlSetColor($hLab, $COLOR_MEDGRAY) 			; profile stats tab
	EndIf

	GUICtrlSetData($g_hLblLabTime, $sLabTime)
	GUICtrlSetData($hLabTime, $sLabTime) ; profile stats tab

EndFunc   ;==>UpdateLabStatus
