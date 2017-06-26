; #FUNCTION# ====================================================================================================================
; Name ..........: Attack Now Button
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: 
; Modified ......: 
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Live Bases
Func AttackNowLB()
	Setlog("Begin Live Base Attack TEST")
	$g_iMatchMode = $LB										; Select Live Base As Attack Type
	$g_aiAttackAlgorithm[$LB] = 1							; Select Scripted Attack
	; $cmbScriptNameLB = $g_sAttackScrScriptName[$AB]		; Select Scripted Attack File From The Combo Box, Cos it wasn't refreshing until pressing Start button
	$g_iMatchMode = 1											; Select Live Base As Attack Type
	$g_bRunState = True

	ForceCaptureRegion()
	_CaptureRegion2()

	If CheckZoomOut("VillageSearch", True, False) = False Then
		$i = 0
		Local $bMeasured
		Do
			$i += 1
			If _Sleep($DELAYPREPARESEARCH3) Then Return 	; wait 500 ms
			ForceCaptureRegion()
			$bMeasured = CheckZoomOut("VillageSearch", $i < 2, True)
		Until $bMeasured = True Or $i >= 2
		If $bMeasured = False Then Return 					; exit func
	EndIf

	PrepareAttack($g_iMatchMode)							; lol I think it's not needed for Scripted attack, But i just Used this to be sure of my code
	Attack()			; Fire xD
	Setlog("End Live Base Attack TEST")
EndFunc   ;==>AttackNowLB

; Dead Bases
Func AttackNowDB()
	Setlog("Begin Dead Base Attack TEST")
	$g_iMatchMode = $DB										; Select Dead Base As Attack Type
	$g_aiAttackAlgorithm[$DB] = 1							; Select Scripted Attack
	; $cmbScriptNameDB = $g_sAttackScrScriptName[$DB]		; Select Scripted Attack File From The Combo Box, Cos it wasn't refreshing until pressing Start button
	$g_iMatchMode = 0										; Select Dead Base As Attack Type
	$g_bRunState = True
	ForceCaptureRegion()
	_CaptureRegion2()

	If CheckZoomOut("VillageSearch", True, False) = False Then
		$i = 0
		Local $bMeasured
		Do
			$i += 1
			If _Sleep($DELAYPREPARESEARCH3) Then Return 	; wait 500 ms
			ForceCaptureRegion()
			$bMeasured = CheckZoomOut("VillageSearch", $i < 2, True)
		Until $bMeasured = True Or $i >= 2
		If $bMeasured = False Then Return 					; exit func
	EndIf

	PrepareAttack($g_iMatchMode)							; lol I think it's not needed for Scripted attack, But i just Used this to be sure of my code
	Attack()			; Fire xD
	Setlog("End Dead Base Attack TEST")
EndFunc   ;==>AttackNowLB
