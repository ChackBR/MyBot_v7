; #FUNCTION# ====================================================================================================================
; Name ..........: Custom Drop Troops
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: Kychera (05-2017)
; Modified ......: NguyenAnhHD (12-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func MatchTroopDropName($Num)
	Switch _GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$Num])
		Case 0
			Return $eBarb
		Case 1
			Return $eSBarb
		Case 2
			Return $eArch
		Case 3
			Return $eSArch
		Case 4
			Return $eGiant
		Case 5
			Return $eSGiant
		Case 6
			Return $eGobl
		Case 7
			Return $eSGobl
		Case 8
			Return $eWall
		Case 9
			Return $eSWall
		Case 10
			Return $eBall
		Case 11
			Return $eRBall
		Case 12
			Return $eWiza
		Case 13
			Return $eSWiza
		Case 14
			Return $eHeal
		Case 15
			Return $eDrag
		Case 16
			Return $ePekk
		Case 17
			Return $eBabyD
		Case 18
			Return $eInfernoD
		Case 19
			Return $eMine
		Case 20
			Return $eEDrag
		Case 21
			Return $eYeti
		Case 22
			Return $eRDrag
		Case 23
			Return $eMini
		Case 24
			Return $eSMini
		Case 25
			Return $eHogs
		Case 26
			Return $eValk
		Case 27
			Return $eSValk
		Case 28
			Return $eGole
		Case 29
			Return $eWitc
		Case 30
			Return $eSWitc
		Case 31
			Return $eLava
		Case 32
			Return $eIceH
		Case 33
			Return $eBowl
		Case 34
			Return $eSBowl
		Case 35
			Return $eIceG
		Case 36
			Return $eHunt
		Case 37
			Return "CC"
		Case 38
			Return "HEROES"
	EndSwitch
EndFunc   ;==>MatchTroopDropName

Func MatchSlotsPerEdge($Num)
	; 0 = spread in all deploy points each side , 1 = one deploy point , 2 = 2 deploy points
	Switch _GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$Num])
		Case 0 ;$eBarb
			Return 0
		Case 1 ;$eSBarb
			Return 0
		Case 2 ;$eArch
			Return 0
		Case 3 ;$eSArch
			Return 0
		Case 4 ;$eGiant
			Return $g_iSlotsGiants
		Case 5 ;$eSGiant
			Return $g_iSlotsGiants
		Case 6 ;$eGobl
			Return 0
		Case 7 ;$eSGobl
			Return 0
		Case 8 ;$eWall
			Return 1
		Case 9 ;$eSWall
			Return 1
		Case 10 ;$eBall
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 11 ;$eRBall
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 12 ;$eWiza
			Return 0
		Case 13 ;$eSWiza
			Return 0
		Case 14 ;$eHeal
			Return 1
		Case 15 ;$eDrag
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 16 ;$ePekk
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 17 ;$eBabyD
			Return 1
		Case 18 ;$eInfernoD
			Return 1
		Case 19 ;$eMine
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 1
			EndIf
		Case 20 ; $eEDrag
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 21 ; $eYeti
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 22 ; $eRDrag
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 23 ;$eMini
			Return 0
		Case 24 ;$eSMini
			Return 0
		Case 25 ;$eHogs
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 26 ;$eValk
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 27 ;$eSValk
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 28 ;$eGole
			Return 2
		Case 29 ;$eWitc
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 30 ;$eSWitc
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 31 ;$eLava
			Return 2
		Case 32 ;$eIceH
			Return 2
		Case 33 ;$eBowl
			Return 0
		Case 34 ;$eSBowl
			Return 0
		Case 35 ;$eIceG
			Return 2
		Case 36 ;$eHunt
			Return 0
		Case 37 ;CC
			Return 1
		Case 38 ;HEROES
			Return 1
	EndSwitch
EndFunc   ;==>MatchSlotsPerEdge

Func MatchSidesDrop($Num)
	Switch _GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$Num])
		Case $eBarb To $eHunt
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 0 Then Return 1
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 1 Then Return 2
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 2 Then Return 3
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 3 Then Return 4
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 4 Then Return 4
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 5 Then Return 1
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 6 Then Return 1
		Case 34
			Return 1 ;CC
		Case 35
			Return 1 ;HEROES
	EndSwitch
EndFunc   ;==>MatchSidesDrop

Func MatchTroopWaveNb($Num)
	Return 1
EndFunc   ;==>MatchTroopWaveNb
