
; #FUNCTION# ====================================================================================================================
; Name ..........: BoostKing & BoostQueen
; Description ...:
; Syntax ........: BoostKing() & BoostQueen()
; Parameters ....:
; Return values .: None
; Author ........: ProMac 2015
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func BoostKing()
	If $bTrainEnabled = False Then Return

	If $icmbBoostBarbarianKing > 0 And ($boostsEnabled = 1) Then
		SetLog("Boost Barbarian King...", $COLOR_INFO)
		If $KingAltarPos[0] = -1 Then
			LocateKingAltar()
			SaveConfig()
			If _Sleep($iDelayBoostHeroes4) Then Return
		Else
			BuildingClickP($KingAltarPos, "#0462")
			If _Sleep($iDelayBoostHeroes2) Then Return
			_CaptureRegion()
			$Boost = _PixelSearch(382, 603 + $bottomOffsetY, 440, 621 + $bottomOffsetY, Hex(0xfffd70, 6), 10)
			If IsArray($Boost) Then
				If $DebugSetlog = 1 Then Setlog("Boost Button X|Y = " & $Boost[0] & "|" & $Boost[1] & ", color = " & _GetPixelColor($Boost[0], $Boost[1]), $COLOR_DEBUG)
				Click($Boost[0], $Boost[1], 1, 0, "#0463")
				If _Sleep($iDelayBoostHeroes1) Then Return
				If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then
					Click(420, 375 + $midOffsetY, 1, 0, "#0464")
					If _Sleep($iDelayBoostHeroes4) Then Return
					If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then
						$icmbBoostBarbarianKing = 0
						SetLog("Not enough gems", $COLOR_ERROR)
					Else
						$icmbBoostBarbarianKing -= 1
						SetLog('Boost completed. Remaining :' & $icmbBoostBarbarianKing, $COLOR_SUCCESS)
					EndIf
				Else
					SetLog("Barbarian King is already Boosted", $COLOR_ERROR)
				EndIf
				If _Sleep($iDelayBoostHeroes3) Then Return
				ClickP($aAway, 1, 0, "#0465")
			Else
				SetLog("Barbarian King Boost Button not found", $COLOR_ERROR)
				If _Sleep($iDelayBoostHeroes4) Then Return
			EndIf
		EndIf
	EndIf

EndFunc   ;==>BoostKing


Func BoostQueen()
	If $bTrainEnabled = False Then Return

	If $icmbBoostArcherQueen > 0 And ($boostsEnabled = 1) Then
		SetLog("Boost Archer Queen...", $COLOR_INFO)
		If $QueenAltarPos[0] = -1 Then
			LocateQueenAltar()
			SaveConfig()
			If _Sleep($iDelayBoostHeroes4) Then Return
		Else
			BuildingClickP($QueenAltarPos, "#0562")
			If _Sleep($iDelayBoostHeroes2) Then Return
			_CaptureRegion()
			$Boost = _PixelSearch(382, 603 + $bottomOffsetY, 440, 621 + $bottomOffsetY, Hex(0xfffd70, 6), 10)
			If IsArray($Boost) Then
				If $DebugSetlog = 1 Then Setlog("Boost Button X|Y = " & $Boost[0] & "|" & $Boost[1] & ", color = " & _GetPixelColor($Boost[0], $Boost[1]), $COLOR_DEBUG)
				Click($Boost[0], $Boost[1], 1, 0, "#0563")
				If _Sleep($iDelayBoostHeroes1) Then Return
				If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then
					Click(420, 375 + $midOffsetY, 1, 0, "#0564")
					If _Sleep($iDelayBoostHeroes4) Then Return
					If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then
						$icmbBoostArcherQueen = 0
						SetLog("Not enough gems", $COLOR_ERROR)
					Else
						$icmbBoostArcherQueen -= 1
						SetLog('Boost completed. Remaining :' & $icmbBoostArcherQueen, $COLOR_SUCCESS)
					EndIf
				Else
					SetLog("Archer Queen is already Boosted", $COLOR_ERROR)
				EndIf
				If _Sleep($iDelayBoostHeroes3) Then Return
				ClickP($aAway, 1, 0, "#0565")
			Else
				SetLog("Archer Queen Boost Button not found", $COLOR_ERROR)
				If _Sleep($iDelayBoostHeroes4) Then Return
			EndIf
		EndIf
	EndIf

EndFunc   ;==>BoostQueen

Func BoostWarden()
	If $bTrainEnabled = False Then Return

	If $icmbBoostWarden > 0 And ($boostsEnabled = 1) Then
		SetLog("Boost Grand Warden...", $COLOR_INFO)
		If $WardenAltarPos[0] = -1 Then
			LocateWardenAltar()
			SaveConfig()
			If _Sleep($iDelayBoostHeroes4) Then Return
		Else
			BuildingClickP($WardenAltarPos)
			If _Sleep($iDelayBoostHeroes2) Then Return
			_CaptureRegion()
			$Boost = _PixelSearch(382, 603 + $bottomOffsetY, 440, 621 + $bottomOffsetY, Hex(0xfffd70, 6), 10)
			If IsArray($Boost) Then
				If $DebugSetlog = 1 Then Setlog("Boost Button X|Y = " & $Boost[0] & "|" & $Boost[1] & ", color = " & _GetPixelColor($Boost[0], $Boost[1]), $COLOR_DEBUG)
				Click($Boost[0], $Boost[1], 1, 0, "#0463")
				If _Sleep($iDelayBoostHeroes1) Then Return
				If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then
					Click(420, 375 + $midOffsetY, 1, 0, "#0464")
					If _Sleep($iDelayBoostHeroes4) Then Return
					If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then
						$cmbBoostWarden = 0
						SetLog("Not enough gems", $COLOR_ERROR)
					Else
						$cmbBoostWarden -= 1
						SetLog('Boost completed. Remaining :' & $icmbBoostWarden, $COLOR_SUCCESS)
					EndIf
				Else
					SetLog("Grand Warden is already Boosted", $COLOR_ERROR)
				EndIf
				If _Sleep($iDelayBoostHeroes3) Then Return
				ClickP($aAway, 1, 0, "#0465")
			Else
				SetLog("Grand Warden Boost Button not found", $COLOR_ERROR)
				If _Sleep($iDelayBoostHeroes4) Then Return
			EndIf
		EndIf
	EndIf

EndFunc   ;==>BoostWarden
