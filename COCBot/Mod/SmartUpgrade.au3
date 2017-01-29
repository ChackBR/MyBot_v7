; #FUNCTION# ====================================================================================================================
; Name ..........: SmartUpgrade (v4) - January 2017
; Description ...: This file contains all functions of SmartUpgrade feature
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: 15/01/2017
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
;				   Because this file is a part of an open-sourced project, I allow all MODders and DEVelopers to use these functions.
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......:  =====================================================================================================================

Func SmartUpgrade()

	If $ichkSmartUpgrade = 1 Then ; check if SmartUpgrade is enabled
		getBuilderCount()
		If $iFreeBuilderCount <> 0 Then ; check free builders
			If ($iSaveWallBldr = 1 And $iFreeBuilderCount > 1) Or $iSaveWallBldr = 0 Then ; check if Save builder for walls is active
				SetLog("Starting SmartUpgrade...", $COLOR_BLUE)
				SetLog("Cleaning Yard before...", $COLOR_BLUE)
				CleanYard()
				SetLog("Cleaning Yard Finished !", $COLOR_BLUE)
				randomSleep(3000)
				clickUpgrade()
				updateStats()
				SetLog("SmartUpgrade Finished ! Thanks for using it :D", $COLOR_BLUE)
				randomSleep(800)
				ClickP($aAway, 1, 0, "#0167") ;Click Away
			Else
				SetLog("Only 1 builder available and he works on walls... Good Luck haha !!!", $COLOR_WARNING)
			EndIf
		Else
			SetLog("No builder available, skipping SmartUpgrade...", $COLOR_ORANGE)
		EndIf
	Else
		Return
	EndIf

EndFunc   ;==>SmartUpgrade

Func clickUpgrade()

	While $canContinueLoop

		If $iTotalBuilderCount >= 1 Then
			getBuilderCount()
			If $iFreeBuilderCount <> 0 Then ; check free builders
				If ($iSaveWallBldr = 1 And $iFreeBuilderCount > 1) Or $iSaveWallBldr = 0 Then
					If openUpgradeTab() Then
						randomSleep(1500)
						If searchZeros() Then
							Click($QuickMISX + 150, $QuickMISY + 70)
							randomSleep(1500)
							launchUpgradeProcess()
						Else
							$canContinueLoop = False
						EndIf
					EndIf
				Else
					SetLog("Only 1 builder available and he works on walls... Good Luck haha !!!", $COLOR_WARNING)
					Return
				EndIf
			Else
				SetLog("No builder available, skipping SmartUpgrade...", $COLOR_ORANGE)
				Return
			EndIf
			PureClickP($aAway, 1, 0, "#0133") ;Click away
			randomSleep(1500)
		EndIf

	WEnd

	$canContinueLoop = True

EndFunc   ;==>clickUpgrade

Func openUpgradeTab()

	If _ColorCheck(_GetPixelColor(275, 15, True), "E8E8E0", 20) = True Then
		Click(275, 15)
		randomSleep(1500)
		Return True
	Else
		Setlog("Error when trying to open Builders menu...", $COLOR_RED)
		Return False
	EndIf

EndFunc   ;==>openUpgradeTab

Func searchZeros() ; check for zeros on the builers menu - translate upgrade available

	If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\SmartUpgrade\Upgrade", 150, 70, 500, 300) Then
		SetLog("Upgrade found !", $COLOR_GREEN)
		Return True
	Else
		SetLog("No upgrade available !", $COLOR_ORANGE)
		Return False
	EndIf

EndFunc   ;==>searchZeros

Func launchUpgradeProcess()

	If locateUpgrade() Then
		upgradeInfo(242, 520 + $bottomOffsetY)
		If checkCanUpgrade() Then
			Click($QuickMISX + 200, $QuickMISY + 600)
			randomSleep(1500)
			getUpgradeInfo()
			updateSmartUpgradeLog()
			launchUpgrade()
		EndIf
	EndIf

EndFunc   ;==>launchUpgradeProcess

Func locateUpgrade() ; search for the upgrade building button

	If QuickMIS("BC1", @ScriptDir & "\imgxml\Resources\SmartUpgrade\Upgrade", 200, 600, 700, 700) Then
		Return True
	Else
		SetLog("No upgrade here !", $COLOR_RED)
		Return False
	EndIf

EndFunc   ;==>locateUpgrade

Func upgradeInfo($iXstart, $iYstart) ; note the upgrade name and level into the log

	$sBldgText = getNameBuilding($iXstart, $iYstart) ; Get Unit name and level with OCR
	If $sBldgText = "" Then ; try a 2nd time after a short delay if slow PC
		If _Sleep($iDelayBuildingInfo1) Then Return
		$sBldgText = getNameBuilding($iXstart, $iYstart) ; Get Unit name and level with OCR
	EndIf
	If $DebugSetlog = 1 Then Setlog("Read building Name String = " & $sBldgText, $COLOR_PURPLE) ;debug
	$aString = StringSplit($sBldgText, "(") ; Spilt the name and building level
	If $aString[0] = 2 Then ; If we have name and level then use it
		If $DebugSetlog = 1 Then Setlog("1st $aString = " & $aString[0] & ", " & $aString[1] & ", " & $aString[2], $COLOR_PURPLE) ;debug
		If $aString[1] <> "" Then $upgradeName[1] = $aString[1] ; check for bad read and store name in result[]
		If $aString[2] <> "" Then ; check for bad read of level
			$sBldgLevel = $aString[2] ; store level text
			$aString = StringSplit($sBldgLevel, ")") ;split off the closing parenthesis
			If $aString[0] = 2 Then ; Check If we have "level XX" cleaned up
				If $DebugSetlog = 1 Then Setlog("2nd $aString = " & $aString[0] & ", " & $aString[1] & ", " & $aString[2], $COLOR_PURPLE) ;debug
				If $aString[1] <> "" Then $sBldgLevel = $aString[1] ; store "level XX"
			EndIf
			$aString = StringSplit($sBldgLevel, " ") ;split off the level number
			If $aString[0] = 2 Then ; If we have level number then use it
				If $DebugSetlog = 1 Then Setlog("3rd $aString = " & $aString[0] & ", " & $aString[1] & ", " & $aString[2], $COLOR_PURPLE) ;debug
				If $aString[2] <> "" Then $upgradeName[2] = Number($aString[2]) ; store bldg level
			EndIf
		EndIf
	EndIf
	If $upgradeName[1] <> "" Then $upgradeName[0] = 1
	If $upgradeName[2] <> "" Then $upgradeName[0] += 1

EndFunc   ;==>upgradeInfo

Func checkCanUpgrade()

	If StringInStr($sBldgText, "Town") And $ichkIgnoreTH = 1 Then
		SetLog("We must ignore Town Hall...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Barbar") And $ichkIgnoreKing = 1 Then
		SetLog("We must ignore Barbarian King...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Queen") And $ichkIgnoreQueen = 1 Then
		SetLog("We must ignore Archer Queen...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Warden") And $ichkIgnoreWarden = 1 Then
		SetLog("We must ignore Grand Warden...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Castle") And $ichkIgnoreCC = 1 Then
		SetLog("We must ignore Clan Castle...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Laboratory") And $ichkIgnoreLab = 1 Then
		SetLog("We must ignore Laboratory...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Barracks") And Not StringInStr($sBldgText, "Dark") And $ichkIgnoreBarrack = 1 Then
		SetLog("We must ignore Barracks...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Dark Barracks") And $ichkIgnoreDBarrack = 1 Then
		SetLog("We must ignore Drak Barracks...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Factory") And Not StringInStr($sBldgText, "Dark") And $ichkIgnoreFactory = 1 Then
		SetLog("We must ignore Spell Factory...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Dark Spell Factory") And $ichkIgnoreDFactory = 1 Then
		SetLog("We must ignore Dark Spell Factory...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Mine") And $ichkIgnoreGColl = 1 Then
		SetLog("We must ignore Gold Mines...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Collector") And $ichkIgnoreEColl = 1 Then
		SetLog("We must ignore Elixir Collectors...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Drill") And $ichkIgnoreDColl = 1 Then
		SetLog("We must ignore Dark Elixir Drills...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Laboratory") And $ichkLab = 1 Then
		SetLog("Auto Laboratory upgrade mode is active, Lab upgrade must be ignored...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Barbar") And $ichkUpgradeKing = 1 Then
		SetLog("Barabarian King upgrade selected, skipping upgrade...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Queen") And $ichkUpgradeQueen = 1 Then
		SetLog("Archer Queen upgrade selected, skipping upgrade...", $COLOR_ORANGE)
		Return False
	ElseIf StringInStr($sBldgText, "Warden") And $ichkUpgradeWarden = 1 Then
		SetLog("Grand Warden upgrade selected, skipping upgrade...", $COLOR_ORANGE)
		Return False
	Else
		SetLog("This upgrade no need to be ignored !", $COLOR_ORANGE)
		Return True
	EndIf

EndFunc   ;==>checkCanUpgrade

Func getUpgradeInfo()

	$Result = QuickMIS("N1", @ScriptDir & "\imgxml\Resources\SmartUpgrade\Type", 350, 500, 740, 600)

	Switch $Result
		Case "Gold"
			$TypeFound = 1
		Case "Elixir"
			$TypeFound = 2
		Case "Dark"
			$TypeFound = 3
	EndSwitch

	If StringInStr($sBldgText, "Barbar") Or StringInStr($sBldgText, "Queen") Or StringInStr($sBldgText, "Warden") Then ; search for heros, which have a different place for upgrade button
		$UpgradeCost = Number(getResourcesBonus(598, 519 + $midOffsetY)) ; Try to read white text.
	Else
		$UpgradeCost = Number(getResourcesBonus(366, 487 + $midOffsetY)) ; Try to read white text.
	EndIf

	If StringInStr($sBldgText, "Barbar") Or StringInStr($sBldgText, "Queen") Or StringInStr($sBldgText, "Warden") Then ; search for heros, which have a different place for upgrade button
		$UpgradeDuration = getHeroUpgradeTime(464, 527 + $midOffsetY) ; Try to read white text showing time for upgrade
	Else
		$UpgradeDuration = getBldgUpgradeTime(196, 304 + $midOffsetY)
	EndIf

EndFunc   ;==>getUpgradeInfo

Func launchUpgrade()

	If StringInStr($sBldgText, "Barbar") Or StringInStr($sBldgText, "Queen") Or StringInStr($sBldgText, "Warden") Then ; search for heros, which have a different place for upgrade button
		Click(710, 560)
	Else
		Click(480, 520)
	EndIf

EndFunc   ;==>launchUpgrade

Func updateSmartUpgradeLog()

	SetLog("We will upgrade " & $upgradeName[1] & "to level " & $upgradeName[2] + 1, $COLOR_GREEN)
	SetLog("Upgrade duration : " & $UpgradeDuration, $COLOR_GREEN)
	If $TypeFound = 1 Then
		SetLog("Upgrade cost : " & _NumberFormat($UpgradeCost) & " Gold", $COLOR_GREEN)
		_GUICtrlEdit_AppendText($SmartUpgradeLog, @CRLF & _NowTime(4) & " - " & "Upgrading " & $upgradeName[1] & "from level " & $upgradeName[2] & " to level " & $upgradeName[2] + 1 & " for " & _NumberFormat($UpgradeCost) & " Gold - Duration : " & $UpgradeDuration)
		_FileWriteLog($dirLogs & "\SmartUpgradeHistory.log", "Upgrading " & $upgradeName[1] & "from level " & $upgradeName[2] & " to level " & $upgradeName[2] + 1 & " for " & _NumberFormat($UpgradeCost) & " Gold - Duration : " & $UpgradeDuration)
		NotifyPushToBoth("SmartUpgrade : Upgrading " & $upgradeName[1] & "from level " & $upgradeName[2] & " to level " & $upgradeName[2] + 1 & " for " & _NumberFormat($UpgradeCost) & " Gold - Duration : " & $UpgradeDuration)
	ElseIf $TypeFound = 2 Then
		SetLog("Upgrade cost : " & _NumberFormat($UpgradeCost) & " Elixir", $COLOR_GREEN)
		_GUICtrlEdit_AppendText($SmartUpgradeLog, @CRLF & _NowTime(4) & " - " & "Upgrading " & $upgradeName[1] & "from level " & $upgradeName[2] & " to level " & $upgradeName[2] + 1 & " for " & _NumberFormat($UpgradeCost) & " Elixir - Duration : " & $UpgradeDuration)
		_FileWriteLog($dirLogs & "\SmartUpgradeHistory.log", "Upgrading " & $upgradeName[1] & "from level " & $upgradeName[2] & " to level " & $upgradeName[2] + 1 & " for " & _NumberFormat($UpgradeCost) & " Elixir - Duration : " & $UpgradeDuration)
		NotifyPushToBoth("SmartUpgrade : Upgrading " & $upgradeName[1] & "from level " & $upgradeName[2] & " to level " & $upgradeName[2] + 1 & " for " & _NumberFormat($UpgradeCost) & " Elixir - Duration : " & $UpgradeDuration)
	ElseIf $TypeFound = 3 Then
		SetLog("Upgrade cost : " & _NumberFormat($UpgradeCost) & " Dark Elixir", $COLOR_GREEN)
		_GUICtrlEdit_AppendText($SmartUpgradeLog, @CRLF & _NowTime(4) & " - " & "Upgrading " & $upgradeName[1] & "from level " & $upgradeName[2] & " to level " & $upgradeName[2] + 1 & " for " & _NumberFormat($UpgradeCost) & " Dark Elixir - Duration : " & $UpgradeDuration)
		_FileWriteLog($dirLogs & "\SmartUpgradeHistory.log", "Upgrading " & $upgradeName[1] & "from level " & $upgradeName[2] & " to level " & $upgradeName[2] + 1 & " for " & _NumberFormat($UpgradeCost) & " Dark Elixir - Duration : " & $UpgradeDuration)
		NotifyPushToBoth("SmartUpgrade : Upgrading " & $upgradeName[1] & "from level " & $upgradeName[2] & " to level " & $upgradeName[2] + 1 & " for " & _NumberFormat($UpgradeCost) & " Dark Elixir - Duration : " & $UpgradeDuration)
	EndIf

EndFunc   ;==>updateSmartUpgradeLog

Func chkSmartUpgrade()
	If GUICtrlRead($chkSmartUpgrade) = $GUI_CHECKED Then
		$ichkSmartUpgrade = 1
		For $i = $iconIgnoreTH To $SmartUpgradeLog
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$ichkSmartUpgrade = 0
		For $i = $iconIgnoreTH To $SmartUpgradeLog
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkSmartUpgrade

Func chkIgnoreTH()
	If GUICtrlRead($chkIgnoreTH) = $GUI_CHECKED Then
		$ichkIgnoreTH = 1
	Else
		$ichkIgnoreTH = 0
	EndIf
EndFunc   ;==>chkIgnoreTH

Func chkIgnoreKing()
	If GUICtrlRead($chkIgnoreKing) = $GUI_CHECKED Then
		$ichkIgnoreKing = 1
	Else
		$ichkIgnoreKing = 0
	EndIf
EndFunc   ;==>chkIgnoreKing

Func chkIgnoreQueen()
	If GUICtrlRead($chkIgnoreQueen) = $GUI_CHECKED Then
		$ichkIgnoreQueen = 1
	Else
		$ichkIgnoreQueen = 0
	EndIf
EndFunc   ;==>chkIgnoreQueen

Func chkIgnoreWarden()
	If GUICtrlRead($chkIgnoreWarden) = $GUI_CHECKED Then
		$ichkIgnoreWarden = 1
	Else
		$ichkIgnoreWarden = 0
	EndIf
EndFunc   ;==>chkIgnoreWarden

Func chkIgnoreCC()
	If GUICtrlRead($chkIgnoreCC) = $GUI_CHECKED Then
		$ichkIgnoreCC = 1
	Else
		$ichkIgnoreCC = 0
	EndIf
EndFunc   ;==>chkIgnoreCC

Func chkIgnoreLab()
	If GUICtrlRead($chkIgnoreLab) = $GUI_CHECKED Then
		$ichkIgnoreLab = 1
	Else
		$ichkIgnoreLab = 0
	EndIf
EndFunc   ;==>chkIgnoreLab

Func chkIgnoreBarrack()
	If GUICtrlRead($chkIgnoreBarrack) = $GUI_CHECKED Then
		$ichkIgnoreBarrack = 1
	Else
		$ichkIgnoreBarrack = 0
	EndIf
EndFunc   ;==>chkIgnoreBarrack

Func chkIgnoreDBarrack()
	If GUICtrlRead($chkIgnoreDBarrack) = $GUI_CHECKED Then
		$ichkIgnoreDBarrack = 1
	Else
		$ichkIgnoreDBarrack = 0
	EndIf
EndFunc   ;==>chkIgnoreDBarrack

Func chkIgnoreFactory()
	If GUICtrlRead($chkIgnoreFactory) = $GUI_CHECKED Then
		$ichkIgnoreFactory = 1
	Else
		$ichkIgnoreFactory = 0
	EndIf
EndFunc   ;==>chkIgnoreFactory

Func chkIgnoreDFactory()
	If GUICtrlRead($chkIgnoreDFactory) = $GUI_CHECKED Then
		$ichkIgnoreDFactory = 1
	Else
		$ichkIgnoreDFactory = 0
	EndIf
EndFunc   ;==>chkIgnoreDFactory

Func chkIgnoreGColl()
	If GUICtrlRead($chkIgnoreGColl) = $GUI_CHECKED Then
		$ichkIgnoreGColl = 1
	Else
		$ichkIgnoreGColl = 0
	EndIf
EndFunc   ;==>chkIgnoreGColl

Func chkIgnoreEColl()
	If GUICtrlRead($chkIgnoreEColl) = $GUI_CHECKED Then
		$ichkIgnoreEColl = 1
	Else
		$ichkIgnoreEColl = 0
	EndIf
EndFunc   ;==>chkIgnoreEColl

Func chkIgnoreDColl()
	If GUICtrlRead($chkIgnoreDColl) = $GUI_CHECKED Then
		$ichkIgnoreDColl = 1
	Else
		$ichkIgnoreDColl = 0
	EndIf
EndFunc   ;==>chkIgnoreDColl
