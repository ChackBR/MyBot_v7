; #FUNCTION# ====================================================================================================================
; Name ..........: Attack Now (#-10)
; Description ...: This file creates the "Req. & Donate" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Mr.Viper
; Modified ......: AiO++ Team
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func AttackNowAB()
	; Assign the Live Bases attack
	Setlog("[TEST]Starting Live Base Scripted Attack.", $COLOR_INFO)

	$g_iMatchMode = $LB ; Select Live Base As Attack Type

	$g_aiAttackAlgorithm[$LB] = 1 ; Select Scripted Attack

	; Lets read the Scriptname and populate the variables
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameAB)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameAB, $indexofscript, $scriptname)
	$g_sAttackScrScriptName[$LB] = $scriptname

	; Getting the Run state
	Local $RuntimeA = $g_bRunState
	$g_bRunState = True

	Setlog("[NameScript]: " & $scriptname, $COLOR_INFO)

	ForceCaptureRegion()
	_CaptureRegion2()

	; Let's check the ZoomOut
	Setlog("[ZommOut]", $COLOR_INFO)
	If CheckZoomOut("VillageSearch", True, False) = False Then
		; check two more times, only required for snow theme (snow fall can make it easily fail), but don't hurt to keep it
		$i = 0
		Local $bMeasured
		Do
			$i += 1
			If _Sleep($DELAYPREPARESEARCH2) Then Return ; wait 500 ms
			ForceCaptureRegion()
			_CaptureRegion2()
			$bMeasured = CheckZoomOut("VillageSearch", $i < 2, False)
		Until $bMeasured = True Or $i >= 2
		If $bMeasured = False Then Return ; exit func
	EndIf

	; Reset the TH and Buildings detection Obj
	ResetTHsearch()
	_ObjDeleteKey($g_oBldgAttackInfo, "") ; Remove all keys from building dictionary

	; Get attack bar , troops , spells etc
	PrepareAttack($LB)

	FindTownhall(True)
	; Attack
	Attack()
	$g_bRunState = $RuntimeA
EndFunc   ;==>AttackNowAB

Func AttackNowDB()
	; Assign the Dead Bases attack
	Setlog("[TEST]Starting Dead Base Scripted Attack.", $COLOR_INFO)

	$g_iMatchMode = $DB ; Select Dead Base As Attack Type

	$g_aiAttackAlgorithm[$DB] = 1 ; Select Scripted Attack

	; Lets read the Scriptname and populate the variables
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameDB, $indexofscript, $scriptname)
	$g_sAttackScrScriptName[$DB] = $scriptname

	; Getting the Run state
	Local $RuntimeA = $g_bRunState
	$g_bRunState = True

	Setlog("[NameScript]: " & $scriptname, $COLOR_INFO)

	ForceCaptureRegion()
	_CaptureRegion2()

	; Let's check the ZoomOut
	Setlog("[ZommOut]", $COLOR_INFO)
	If CheckZoomOut("VillageSearch", True, False) = False Then
		; check two more times, only required for snow theme (snow fall can make it easily fail), but don't hurt to keep it
		$i = 0
		Local $bMeasured
		Do
			$i += 1
			If _Sleep($DELAYPREPARESEARCH2) Then Return ; wait 500 ms
			ForceCaptureRegion()
			_CaptureRegion2()
			$bMeasured = CheckZoomOut("VillageSearch", $i < 2, False)
		Until $bMeasured = True Or $i >= 2
		If $bMeasured = False Then Return ; exit func
	EndIf

	; Reset the TH and Buildings detection Obj
	ResetTHsearch()
	_ObjDeleteKey($g_oBldgAttackInfo, "") ; Remove all keys from building dictionary

	; Get attack bar , troops , spells etc
	PrepareAttack($DB)

	FindTownhall(True)
	; Attack
	Attack()
	$g_bRunState = $RuntimeA
EndFunc   ;==>AttackNowDB
