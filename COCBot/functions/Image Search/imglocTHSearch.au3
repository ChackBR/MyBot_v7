; #FUNCTION# ====================================================================================================================
; Name ..........: imglocTHSearch
; Description ...: Searches for the TH in base, and returns; X&Y location, Bldg Level
; Syntax ........: imglocTHSearch([$bReTest = False])
; Parameters ....: $bReTest - [optional] a boolean value. Default is False.
; Return values .: None , sets several global variables
; Author ........: trlopes (Oct 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $aTownHall[4] = [-1, -1, -1, -1] ; [LocX, LocY, BldgLvl, Quantity]



Func imglocTHSearch($bReTest = False,$myVillage=False)
	;set THSearch Values for multisearch
	Local $xdirectory = @ScriptDir & "\imgxml\ImgLocTH"
	Local $sCocDiamond ="ECD"
	Local $redLines = ""
	Local $minLevel=6   ; We only support TH6+
	Local $maxLevel=100
	Local $maxReturnPoints = 1
	Local $returnProps="objectname,objectlevel,objectpoints,nearpoints,farpoints,redlinedistance"
	Local $bForceCapture = True ; force CaptureScreen

	if $myVillage=False then ; these are only for OPONENT village
		ResetTHsearch() ;see below
	Else
		$redLines = "ECD" ;needed for searching your own village
	EndIf


	;aux data
	Local $propsNames = StringSplit($returnProps,",",$STR_NOCOUNT)
	If $debugsetlog = 1 Then SetLog("imgloc TH search Start", $COLOR_DEBUG)
	Local $numRetry=2 ; try to find TH twice

	for $retry=0 to $numRetry
		Local $hTimer = TimerInit()
		Local $result = findMultiple($xdirectory ,$sCocDiamond ,$redLines, $minLevel, $maxLevel, $maxReturnPoints , $returnProps, $bForceCapture )

		If IsArray($result) then
			;we got results from multisearch ; lets set $redline in case we need to perform another search
			$redLines = $IMGLOCREDLINE ; that was set by findMultiple if redline argument was ""
			If Ubound($result) = 1 then
				If $debugsetlog = 1 Then SetLog("imgloc Found TH : ", $COLOR_INFO)
				Local $propsValues = $result[0]
				For $pv=0 to ubound($propsValues)-1
					If $debugsetlog = 1 Then SetLog("imgloc Found : " & $propsNames[$pv] & " - " & $propsValues[$pv], $COLOR_INFO)
					Switch $propsNames[$pv]
						case "objectname"
							;nothing to do
						case "objectlevel"
							If $myVillage=False Then
								$IMGLOCTHLEVEL = Number($propsValues[$pv])
								$aTownHall[2] = Number($propsValues[$pv])
								$searchTH =  Number($propsValues[$pv])
							Else
								$iTownHallLevel = Number($propsValues[$pv]) ; I think this needs to be decreased
							EndIf
						case "objectpoints"
							if $propsValues[$pv]="0" then
								;there was an error inside imgloc and location is empty or error
								 DebugImageSave("imglocTHSearch_NoTHFound_", True)
								 ResetTHsearch()
								 return
							endif
							If $myVillage=False Then
								$IMGLOCTHLOCATION = decodeSingleCoord($propsValues[$pv]);array [x][y]
								$aTownHall[0] = Number($IMGLOCTHLOCATION[0])
								$aTownHall[1] = Number($IMGLOCTHLOCATION[1])
								$THx = Number($IMGLOCTHLOCATION[0]) ; backwards compatibility
								$THy = Number($IMGLOCTHLOCATION[1]) ; backwards compatibility
								$THLocation = 1  ; backwards compatibility
							Else
								$TownHallPos = decodeSingleCoord($propsValues[$pv])
								ConvertFromVillagePos($TownHallPos[0], $TownHallPos[1])
							EndIf
						case "nearpoints"
							If $myVillage=False Then
								$IMGLOCTHNEAR = $propsValues[$pv]
							EndIf
						case "farpoints"
							If $myVillage=False Then
								$IMGLOCTHFAR = $propsValues[$pv]
							EndIf
						case "redlinedistance"
							If $myVillage=False Then
								$IMGLOCTHRDISTANCE = $propsValues[$pv]
							EndIf
					EndSwitch
					If $myVillage=False Then
						$aTownHall[3]=1 ; found 1 only
					EndIf
				Next
				If $debugsetlog = 1 Then SetLog("imgloc THSearch Calculated  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
			Else
			If $debugsetlog = 1 Then SetLog("imgloc Found Multiple TH : ", $COLOR_INFO)
			;could be a multi match or another tile for same object. As TH only have 1 tile, this will never happen
			If $debugsetlog = 1 Then SetLog("imgloc THSearch Calculated  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
			EndIf

		Else
			;thnotfound
			If $debugsetlog = 1 Then SetLog("imgloc Could not find TH", $COLOR_WARNING)
			If $debugImageSave = 1 Then DebugImageSave("imglocTHSearch_NoTHFound_", True)
			If $debugsetlog = 1 Then SetLog("imgloc THSearch Calculated  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
		EndIf
		$retry = $retry +1
		If $IMGLOCTHLEVEL > 0 Then
			ExitLoop ; TH was found
		Else
			If $debugImageSave = 1 Then DebugImageSave("imglocTHSearch_NoTHFound_", True)
			If $debugsetlog = 1 Then SetLog("imgloc THSearch Notfound, Retry:  " & $retry )
		EndIf
	Next ; retry
EndFunc   ;==>imglocTHSearch

Func ResetTHsearch()
		;something not good happened
		;reset redlines and other globals
		$IMGLOCREDLINE = ""		; Redline data obtained from FindMultiple
		$IMGLOCTHLEVEL = 0		; Duhhh!!!
		$IMGLOCTHLOCATION = StringSplit(",",",",$STR_NOCOUNT)	; x,y array
		$IMGLOCTHNEAR = ""	; 5 points 5px from redline Near to TH
		$IMGLOCTHFAR = ""	; 5 points 25px from redline Near to TH
		$IMGLOCTHRDISTANCE =""		; Reline distace to TH
		;compatibility
		$aTownHall[0] = -1 ; [LocX, LocY, BldgLvl, Quantity]
		$aTownHall[1] = -1; [LocX, LocY, BldgLvl, Quantity]
		$aTownHall[2] = -1 ; [LocX, LocY, BldgLvl, Quantity]
		$aTownHall[3] = -1 ; [LocX, LocY, BldgLvl, Quantity]
		$THx = 0; backwards compatibility
		$THy = 0 ; backwards compatibility
		$searchTH = "-" ; means not found
		$THLocation = 0 ; means not found
EndFunc

;backwards compatibility
Func imgloccheckTownHallADV2($limit = 0, $tolerancefix = 0, $captureRegion = True)
	imglocTHSearch(True) ; try 2 times to get TH

	if $IMGLOCTHLEVEL = 0 then
		Return "-"
	else
		Return $IMGLOCTHLEVEL
	EndIf

EndFunc   ;==>checkTownHallADV2
