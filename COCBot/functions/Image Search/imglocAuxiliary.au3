; #FUNCTION# ====================================================================================================================
; Name ..........: Imgloc Aux functions
; Description ...: auxyliary functions used by imgloc
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: Trlopes (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func decodeMultipleCoords($coords)
	;returns array of N coordinates [0=x, 1=y][0=x1, 1=y1]
	Local $retCoords[1] =[""]
	Local $p
	If $DebugSetlog = 1 Then SetLog("**decodeMultipleCoords: " & $coords, $COLOR_ORANGE)
	Local $aCoordsSplit = StringSplit($coords, "|", $STR_NOCOUNT)
	if StringInStr($aCoordsSplit[0], ",") = True then
		Redim $retCoords[ubound($aCoordsSplit)-1]
		$p=1
	else ;has total count in value
		Redim $retCoords[Number($aCoordsSplit[0])]
		$p=0
	endif

	For $p=0 to Ubound($retCoords)-1
		$retCoords[$p] = decodeSingleCoord($aCoordsSplit[$p+1])
	Next
	Return $retCoords
EndFunc   ;==>decodeMultipleCoords

Func decodeSingleCoord($coords)
	;returns array with 2 coordinates 0=x, 1=y
	Local $aCoordsSplit = StringSplit($coords, ",", $STR_NOCOUNT)
	Return $aCoordsSplit
EndFunc

Func returnImglocProperty($key, $property)
	; Get the property
	Local $aValue = DllCall($hImgLib, "str", "GetProperty", "str", $key, "str", $property)
	if checkImglocError( $aValue , "returnImglocProperty") = true then
		return ""
	EndIf
	Return $aValue[0]
EndFunc   ;==>returnImglocProperty

Func checkImglocError( $imglocvalue , $funcName)
	;Return true if there is an error in imgloc return string
	If IsArray($imglocvalue) Then  ;despite beeing a string, AutoIt receives a array[0]
		If $imglocvalue[0] = "0" or $imglocvalue[0] = "" Then
			If $DebugSetlog = 1 Then SetLog($funcName & " imgloc search returned no results!", $COLOR_RED)
			Return True
		ElseIf StringLeft($imglocvalue[0],2) = "-1" Then  ;error
			If $DebugSetlog = 1 Then SetLog($funcName & " - Imgloc DLL Error: " + $imglocvalue[0], $COLOR_RED)
			Return True
		Else
			;If $DebugSetlog Then SetLog($funcName & " imgloc search performed with results!")
			Return False
		EndIF
	Else
		If $DebugSetlog = 1 Then SetLog($funcName & " - Imgloc  Error: Not an Array Result" , $COLOR_RED)
		Return True
	EndIF
EndFunc   ;==>checkImglocError

Func findButton($sButtonName,$buttonTile, $maxReturnPoints = 1, $bForceCapture = True )

	Local $error, $extError
	Local $searchArea = GetButtonDiamond($sButtonName)
	Local $aCoords = "" ; use AutoIt mixed varaible type and initialize array of coordinates to null

	; Check function parameters
	If Not IsString($sButtonName) Or Not FileExists($buttonTile) Then
		SetError(1, "Bad Input Values", $aCoords)  ; Set external error code = 1 for bad input values
		Return
	EndIF

	; Capture the screen for comparison
	; _CaptureRegion2() or similar must be used before
	; Perform the search
	If $bForceCapture THEN _CaptureRegion2() ;to have FULL screen image to work with

	If $DebugSetlog Then SetLog(" imgloc searching for: " & $sButtonName  & " : " & $buttonTile)

	Local $result = DllCall($pImgLib, "str", "FindTile", "handle", $hHBitmap2, "str", $buttonTile, "str", $searchArea, "Int", $maxReturnPoints)
	$error = @error  ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($pImgLib, $error)
		If $DebugSetlog Then SetLog(" imgloc DLL Error imgloc " & $error & " --- "  & $extError)
		SetError(2, $extError , $aCoords)  ; Set external error code = 2 for DLL error
		Return
	EndIF

	If checkImglocError( $result, "imglocFindButton" ) = True Then
		Return $aCoords
	EndIF

	If $result[0]<>"" Then
		If $DebugSetlog Then SetLog($sButtonName & " Button Image Found in: " & $result[0])
		$aCoords = StringSplit($result[0], "|", $STR_NOCOUNT)
		;[0] - total points found
		;[1] -  coordinates
		If $maxReturnPoints = 1 then
			Return $aCoords[1]; return just X,Y coord
		Else
			Return $result[0] ; return full string with count and points
		EndIf
	Else
		If $DebugSetlog Then SetLog($sButtonName & " Button Image NOT FOUND " & $buttonTile)
		Return $aCoords
	EndIF

EndFunc   ;==>findButton

Func GetButtonDiamond($sButtonName )
	Local $btnDiamond = "FV"

	Switch $sButtonName
		Case "FindMatch" ;Find Match Screen
			$btnDiamond = "133,515|360,515|360,620|133,620"
		Case "CloseFindMatch" ;Find Match Screen
			$btnDiamond = "780,15|830,15|830,60|780,60"
		Case "CloseFindMatch"  ;Find Match Screen
			$btnDiamond = "780,15|830,15|830,60|780,60"
		Case "Attack" ;Main Window Screen
			$btnDiamond = "15,620|112,620|112,715|15,715"
		Case "OpenTrainWindow" ;Main Window Screen
			$btnDiamond = "15,560|65,560|65,610|15,610"
		Case "OK"
			$btnDiamond =  "440,395|587,395|587,460|440,460"
		Case "CANCEL"
			$btnDiamond =  "272,395|420,395|420,460|272,460"
		Case "ReturnHome"
			$btnDiamond =  "357,545|502,545|502,607|357,607"
		Case "Next" ; attackpage attackwindow
			$btnDiamond =  "697,542|850,542|850,610|697,610"
		Case "EndBattleSurrender" ;surrender - attackwindow
			$btnDiamond =  "12,577|125,577|125,615|12,615"
		Case "ExpandChat" ;mainwindow
			$btnDiamond =  "2,330|35,350|35,410|2,430"
		Case "CollapseChat" ;mainwindow
			$btnDiamond =  "315,334|350,350|350,410|315,430"
		Case "ChatOpenRequestPage" ;mainwindow - chat open
			$btnDiamond =  "5,688|65,688|65,615|5,725"
		Case "Profile" ;mainwindow - only visible if chat closed
			$btnDiamond =  "172,15|205,15|205,48|172,48"
		Case "DonateWindow" ;mainwindow - only when donate window is visible
			$btnDiamond =  "310,0|360,0|360,732|310,732"
		Case "DonateButton" ;mainwindow - only when chat window is visible
			$btnDiamond =  "200,85|305,85|305,680|200,680"
		Case "UpDonation" ;mainwindow - only when chat window is visible
			$btnDiamond =  "282,85|306,85|306,130|282,130"
		Case "DownDonation" ;mainwindow - only when chat window is visible
			$btnDiamond =  "282,635|306,635|306,680|282,680"

		Case Else
			$btnDiamond = "FV" ; use full image to locate button
	EndSwitch
	Return $btnDiamond
EndFunc   ;==>GetButtonDiamond

Func findImage($sImageName, $sImageTile ,$sImageArea , $maxReturnPoints = 1, $bForceCapture = True )
	; same has findButton, but allow custom area instead of button area decoding
	; nice for dinamic locations
	Local $error, $extError
	Local $searchArea = $sImageArea
	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null

	; Check function parameters
	If  Not FileExists($sImageTile) Then
		SetError(1, "Bad Input Values", $aCoords)  ; Set external error code = 1 for bad input values
		Return
	EndIF

	; Capture the screen for comparison
	; _CaptureRegion2() or similar must be used before
	; Perform the search
	If $bForceCapture THEN _CaptureRegion2() ;to have FULL screen image to work with

	If $DebugSetlog Then SetLog("findImage Looking for : " & $sImageName  & " : " & $sImageTile & " on " & $sImageArea)

	Local $result = DllCall($pImgLib, "str", "FindTile", "handle", $hHBitmap2, "str", $sImageTile, "str", $searchArea, "Int", $maxReturnPoints)
	$error = @error  ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($pImgLib, $error)
		If $DebugSetlog Then SetLog(" imgloc DLL Error imgloc " & $error & " --- "  & $extError)
		SetError(2, $extError , $aCoords)  ; Set external error code = 2 for DLL error
		Return
	EndIF

	If checkImglocError( $result, "findImage" ) = True Then
		If $DebugSetlog = 1 Then SetLog("findImage Returned Error or No values : ", $COLOR_DEBUG)
		If $DebugSetlog = 1 And $DebugImageSave = 1 Then DebugImageSave("findImage_" & $sImageName, True)
		Return $aCoords
	EndIF

	If $result[0] <> "" Then  ;despite being a string, AutoIt receives a array[0]
			If $DebugSetlog Then SetLog("findImage : " & $sImageName & " Found in: " & $result[0])
			$aCoords = StringSplit($result[0], "|", $STR_NOCOUNT)
			;[0] - total points found
			;[1] -  coordinates
			If $maxReturnPoints = 1 then
				Return $aCoords[1]; return just X,Y coord
			Else
				Return $result[0] ; return full string with count and points
			Endif
	Else
		If $DebugSetlog = 1 Then SetLog("findImage : " & $sImageName & " NOT FOUND " & $sImageTile)
		If $DebugSetlog = 1 And $DebugImageSave = 1 Then DebugImageSave("findImage_" & $sImageName, True)
		Return $aCoords
	EndIF

EndFunc   ;==>findImage

Func findMultiple($directory ,$sCocDiamond ,$redLines, $minLevel=0, $maxLevel=1000, $maxReturnPoints = 0, $returnProps="objectname,objectlevel,objectpoints", $bForceCapture = True )
	; same has findButton, but allow custom area instead of button area decoding
	; nice for dinamic locations
	If $DebugSetlog = 1 Then SetLog("******** findMultiple *** START ***", $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : directory : " & $directory, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : sCocDiamond : " & $sCocDiamond, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : redLines : " & $redLines, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : minLevel : " & $minLevel, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : maxLevel : " & $maxLevel, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : maxReturnPoints : " & $maxReturnPoints, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : returnProps : " & $returnProps, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("******** findMultiple *** START ***", $COLOR_ORANGE)

	Local $error, $extError

	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $returnData = StringSplit($returnProps,",",$STR_NOCOUNT)
	Local $returnLine[Ubound($returnData)]
	Local $returnValues[0]


	; Capture the screen for comparison
	; Perform the search
	If $bForceCapture THEN _CaptureRegion2() ;to have FULL screen image to work with

	Local $result = DllCall($pImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", $sCocDiamond, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	$error = @error  ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($pImgLib, $error)
		If $DebugSetlog = 1 Then SetLog(" imgloc DLL Error : " & $error & " --- "  & $extError)
		SetError(2, $extError , $aCoords)  ; Set external error code = 2 for DLL error
		Return ""
	EndIF

	;If $DebugSetlog = 1 Then SetLog(" imglocFindMultiple " &  $result[0])
	If checkImglocError( $result, "findMultiple" ) = True Then
		If $DebugSetlog = 1 Then SetLog("findMultiple Returned Error or No values : ", $COLOR_DEBUG)
		If $DebugSetlog = 1 Then SetLog("******** findMultiple *** END ***", $COLOR_ORANGE)
		Return ""
	else
		If $DebugSetlog = 1 Then SetLog("findMultiple found : " & $result[0])
	EndIF

	If $result[0] <> "" Then  ;despite being a string, AutoIt receives a array[0]
			Local $resultArr = StringSplit($result[0],"|",$STR_NOCOUNT)
			Redim $returnValues[Ubound($resultArr)]
			For $rs=0 to ubound($resultArr)-1
				For $rD=0 to Ubound($returnData)-1 ; cycle props
					$returnLine[$rD] = returnImglocProperty($resultArr[$rs],$returnData[$rD])
					If $DebugSetlog = 1 Then SetLog("findMultiple : " & $resultArr[$rs] & "->" & $returnData[$rD] & " -> " & $returnLine[$rD] )
				Next
				$returnValues[$rs] = $returnLine
			Next

			;;lets check if we should get redlinedata
			If $redLines="" Then
				$IMGLOCREDLINE = returnImglocProperty("redline","")			;global var set in imglocTHSearch
				If $DebugSetlog = 1 Then SetLog("findMultiple : Redline argument is emty, seting global Redlines" )
			EndIf
			If $DebugSetlog = 1 Then SetLog("******** findMultiple *** END ***", $COLOR_ORANGE)
			return $returnValues

	Else
		If $DebugSetlog = 1 Then SetLog(" ***  findMultiple has no result **** ", $COLOR_ORANGE)
		If $DebugSetlog = 1 Then SetLog("******** findMultiple *** END ***", $COLOR_ORANGE)
		Return ""
	EndIF

EndFunc   ;==>findMultiple

Func GetDiamondFromRect($rect)
	;receives "StartX,StartY,EndX,EndY"
	;returns "StartX,StartY|EndX,StartY|EndX,EndY|StartX,EndY"
	Local $returnvalue = ""
	If $DebugSetlog = 1 Then SetLog("GetDiamondFromRect : > " & $rect, $COLOR_INFO)
	Local $RectValues = StringSplit($rect,",",$STR_NOCOUNT)
	Local $DiamdValues[4]
	Local $X=Number($RectValues[0])
	Local $Y=Number($RectValues[1])
	Local $Ex=Number($RectValues[2])
	Local $Ey=Number($RectValues[3])
	$DiamdValues[0] = $X & "," & $Y
	$DiamdValues[1]	= $Ex & "," & $Y
	$DiamdValues[2]	= $Ex & "," & $Ey
	$DiamdValues[3] = $X & "," & $Ey
	$returnvalue = $DiamdValues[0] & "|" & $DiamdValues[1] & "|" & $DiamdValues[2] & "|" & $DiamdValues[3]
	If $DebugSetlog = 1 Then SetLog("GetDiamondFromRect : < " & $returnvalue, $COLOR_INFO)
	Return $returnvalue
EndFunc   ;==>GetDiamondFromRect

Func FindImageInPlace($sImageName, $sImageTile,$place)
	;creates a reduced capture of the place area a finds the image in that area
	;returns string with X,Y of ACTUALL FULL SCREEN coordinates or Empty if not found
	If $DebugSetlog = 1 Then SetLog("FindImageInPlace : > " & $sImageName & " - " & $sImageTile & " - " & $place, $COLOR_INFO)
	Local $returnvalue = ""
	Local $aPlaces = StringSplit($place,",",$STR_NOCOUNT)
	_CaptureRegion2(Number($aPlaces[0]),Number($aPlaces[1]),Number($aPlaces[2]),Number($aPlaces[3]))
	Local $sImageArea = GetDiamondFromRect($place)
	Local $coords =  findImage($sImageName, $sImageTile ,"FV" , 1, False ); reduce capture full image
	If $coords = "" Then
		If $DebugSetlog = 1 Then SetLog("FindImageInPlace : " & $sImageName & " NOT Found", $COLOR_INFO)
		Return ""
	EndIf
	Local $aCoords = DecodeSingleCoord($coords)
	$returnvalue = Number($aCoords[0]) + Number($aPlaces[0]) & "," & Number($aCoords[1]) + Number($aPlaces[1])
	If $DebugSetlog = 1 Then SetLog("FindImageInPlace : < " & $sImageName & " Found in " & $returnvalue , $COLOR_INFO)
	Return  $returnvalue
EndFunc   ;==>FindImageInPlace

Func decodeTroopEnum($tEnum)
Switch $tEnum
	Case $eBarb
 		Return "Barbarian"
	Case $eArch
 		Return "Archer"
	Case $eBall
 		Return "Balloon"
	Case $eDrag
 		Return "Dragon"
	Case $eGiant
 		Return "Giant"
	Case $eGobl
 		Return "Goblin"
	Case $eGole
 		Return "Golem"
	Case $eHeal
 		Return "Healer"
	Case $eHogs
 		Return "HogRider"
	Case $eKing
 		Return "King"
	Case $eLava
 		Return "LavaHound"
	Case $eMini
 		Return "Minion"
	Case $ePekk
 		Return "Pekka"
	Case $eQueen
 		Return "Queen"
	Case $eValk
 		Return "Valkyrie"
	Case $eWall
 		Return "WallBreaker"
	Case $eWarden
 		Return "Warden"
	Case $eWitc
 		Return "Witch"
	Case $eWiza
 		Return "Wizard"
	Case $eBabyD
 		Return "BabyDragon"
	Case $eMine
 		Return "Miner"
	Case $eBowl
 		Return "Bowler"
	Case $eESpell
 		Return "EarthquakeSpell"
	Case $eFSpell
 		Return "FreezeSpell"
	Case $eHaSpell
 		Return "HasteSpell"
	Case $eHSpell
 		Return "HealSpell"
	Case $eJSpell
 		Return "JumpSpell"
	Case $eLSpell
 		Return "LightningSpell"
	Case $ePSpell
 		Return "PoisonSpell"
	Case $eRSpell
 		Return "RageSpell"
	Case $eSkSpell
 		Return "SkeletonSpell" ;Missing
	Case $eCSpell
 		Return "CloneSpell" ;Missing
	Case $eCastle
 		Return "Castle"
 	EndSwitch

EndFunc   ;==>decodeTroopEnum

Func GetDummyRectangle($sCoords,$ndistance)
	;creates a dummy rectangle to be used by Reduced Image Capture
	Local $aCoords = StringSplit($sCoords,",",$STR_NOCOUNT)
	return Number($aCoords[0])-$nDistance & "," & Number($aCoords[1])-$nDistance & "," & Number($aCoords[0])+$nDistance & "," & Number($aCoords[1])+$nDistance
EndFunc   ;==>GetDummyRectangle