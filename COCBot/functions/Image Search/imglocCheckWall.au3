#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         trlopes

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
Func imglocCheckWall()

	If _Sleep(500) Then Return

	Local $levelWall = $icmbWalls + 4

	_CaptureRegion2()
	SetLog("Searching for Wall(s) level: " & $levelWall & ". Using imgloc: " , $COLOR_SUCCESS)
	;name , level , coords
	Local $FoundWalls[1]
	$FoundWalls[0]="" ; empty value to make sure return value filled
	$FoundWalls = imglocFindWalls($levelWall,"DCD","DCD",10) ; lets get 10 points just to make sure we discard false positives

	ClickP($aAway, 1, 0, "#0505") ; to prevent bot 'Anyone there ?'

	If ($FoundWalls[0] = "") Then ; nothing found
		SetLog("No wall(s) level: " & $levelWall & " found.", $COLOR_ERROR)
	Else
		For $i=0 to UBound($FoundWalls)-1
			Local $WallCoordsArray = decodeMultipleCoords($FoundWalls[$i])
			for $fc = 0 to UBound( $WallCoordsArray)-1
				Local $aCoord = StringSplit($FoundWalls[$i],",",$STR_NOCOUNT )
				SetLog("Found: " & $FoundWalls[0] & " possible Wall position: " & $FoundWalls[$i], $COLOR_SUCCESS)
				SetLog("Checking if found position is a Wall and of desired level.", $COLOR_SUCCESS)
				;try click
				GemClick($aCoord[0],$aCoord[1])
				If _Sleep(500) Then Return
				$aResult = BuildingInfo(245, 520 + $bottomOffsetY) ; Get building name and level with OCR
				If $aResult[0] = 2 Then ; We found a valid building name
					If StringInStr($aResult[1], "wall") = True And Number($aResult[2]) = ($icmbWalls + 4) Then ; we found a wall
						Setlog("Position : " &  $FoundWalls[$i] & " is a Wall Level: " & $icmbWalls + 4  & ".")
						Return True
					Else
						If $debugSetlog Then
							ClickP($aAway, 1, 0, "#0931") ;Click Away
							Setlog("Position : " &  $FoundWalls[$i] & " is not a Wall Level: " & $icmbWalls + 4 & ". It was: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG) ;debug
						Else
							ClickP($aAway, 1, 0, "#0932") ;Click Away
							Setlog("Position : " &  $FoundWalls[$i] & " is not a Wall Level: " & $icmbWalls + 4 & ".", $COLOR_ERROR)
						EndIf
					EndIf
				Else
					ClickP($aAway, 1, 0, "#0933") ;Click Away
				EndIf
			Next
		Next
	EndIf
	Return False

EndFunc   ;==>imglocCheckWall




Func imglocFindWalls( $walllevel,$searcharea="DCD",$redline="",$maxreturn=0 )
	; Will find maxreturn Wall in specified diamond

	;name , level , coords
	Local $FoundWalls[1] = [""];

	Local $directory = @ScriptDir & "\imgxml\walls\"
	Local $redLines = $redline
	Local $minLevel = $walllevel
	Local $maxLevel = $walllevel
	Local $maxReturnPoints = $maxreturn

	; Capture the screen for comparison
	_CaptureRegion2()

	; Perform the search
	Local $result = DllCall($pImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", $searcharea, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	$error = @error  ; Store error values as they reset at next function call
	$extError = @extended

	If $error Then
		_logErrorDLLCall($pImgLib, $error)
		SetLog(" imgloc DLL Error imgloc " & $error & " --- "  & $extError, $COLOR_RED)
		SetError(2, $extError , $error)  ; Set external error code = 2 for DLL error
		Return
	EndIF

	If checkImglocError( $result, "imglocFindWalls" ) = True Then
		Return $FoundWalls
	EndIf


	; Process results
	If $result[0] <> "" Then
		; Get the keys for the dictionary item.
		If $DebugSetlog Then SetLog(" imglocFindMyWall search returned : " & $result[0])
		Local $aKeys = StringSplit($result[0], "|", $STR_NOCOUNT)
		; Loop through the array
		ReDim $FoundWalls[UBound($aKeys)]
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			; Loop through the found object names
			Local $aCoords = returnImglocProperty($aKeys[$i], "objectpoints")
			$FoundWalls[$i] = $aCoords
		Next
	EndIf
	return $FoundWalls
EndFunc   ;==>




