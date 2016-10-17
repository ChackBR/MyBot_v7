; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSV
; Description ...:
; Syntax ........: ParseAttackCSV([$debug = False])
; Parameters ....: $debug               - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSV($debug = False)
	Global $ATTACKVECTOR_A, $ATTACKVECTOR_B, $ATTACKVECTOR_C, $ATTACKVECTOR_D, $ATTACKVECTOR_E, $ATTACKVECTOR_F
	Global $ATTACKVECTOR_G, $ATTACKVECTOR_H, $ATTACKVECTOR_I, $ATTACKVECTOR_J, $ATTACKVECTOR_K, $ATTACKVECTOR_L
	Global $ATTACKVECTOR_M, $ATTACKVECTOR_N, $ATTACKVECTOR_O, $ATTACKVECTOR_P, $ATTACKVECTOR_Q, $ATTACKVECTOR_R
	Global $ATTACKVECTOR_S, $ATTACKVECTOR_T, $ATTACKVECTOR_U, $ATTACKVECTOR_V, $ATTACKVECTOR_W, $ATTACKVECTOR_X
	Global $ATTACKVECTOR_Y, $ATTACKVECTOR_Z
	
	Local $heightTopLeft = 0, $heightTopRight = 0, $heightBottomLeft = 0, $heightBottomRight = 0
	Local $i

	;AwesomeGamer CSV Mod
	For $i = 0 to Ubound($atkTroops) - 1
		$remainingTroops[$i][0] = $atkTroops[$i][0]
		$remainingTroops[$i][1] = $atkTroops[$i][1]
	Next
	$TroopDropNumber = 0

	Local $rownum = 0
	Local $bForceSideExist = False

	;Local $filename = "attack1"
	If $iMatchMode = $DB Then
		Local $filename = $scmbDBScriptName
	Else
		Local $filename = $scmbABScriptName
	EndIf
	Setlog("execute " & $filename)

	Local $speedText = $iCSVSpeeds[$isldSelectedCSVSpeed[$iMatchMode]] & "x"
	If $iCSVSpeeds[$isldSelectedCSVSpeed[$iMatchMode]] = 1 Then 
		$speedText = "Normal"
	EndIf 

	Setlog(" - at " & $speedText & " speed")

	Local $f, $line, $acommand, $command
	Local $value1, $value2, $value3, $value4, $value5, $value6, $value7, $value8, $value9
	If FileExists($dirAttacksCSV & "\" & $filename & ".csv") Then
		$f = FileOpen($dirAttacksCSV & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			$rownum += 1
			If @error = -1 Then ExitLoop
			If $debug = True Then Setlog("parse line:<<" & $line & ">>")
			debugAttackCSV("line content: " & $line)
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)
				$value1 = StringStripWS(StringUpper($acommand[2]), $STR_STRIPTRAILING)
				$value2 = StringStripWS(StringUpper($acommand[3]), $STR_STRIPTRAILING)
				$value3 = StringStripWS(StringUpper($acommand[4]), $STR_STRIPTRAILING)
				$value4 = StringStripWS(StringUpper($acommand[5]), $STR_STRIPTRAILING)
				$value5 = StringStripWS(StringUpper($acommand[6]), $STR_STRIPTRAILING)
				$value6 = StringStripWS(StringUpper($acommand[7]), $STR_STRIPTRAILING)
				$value7 = StringStripWS(StringUpper($acommand[8]), $STR_STRIPTRAILING)
				$value8 = StringStripWS(StringUpper($acommand[9]), $STR_STRIPTRAILING)
				$value9 = StringStripWS(StringUpper($acommand[10]), $STR_STRIPTRAILING)

				Switch $command
					Case ""
						debugAttackCSV("comment line")
					Case "MAKE"
						ReleaseClicks()
						If CheckCsvValues("MAKE", 2, $value2) Then
							Local $sidex = StringReplace($value2, "-", "_")
							If $sidex = "RANDOM" Then
								Switch Random(1, 4, 1)
									Case 1
										$sidex = "FRONT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "LEFT"
										Else
											$sidex &= "RIGHT"
										EndIf
									Case 2
										$sidex = "BACK_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "LEFT"
										Else
											$sidex &= "RIGHT"
										EndIf
									Case 3
										$sidex = "LEFT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "FRONT"
										Else
											$sidex &= "BACK"
										EndIf
									Case 4
										$sidex = "RIGHT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "FRONT"
										Else
											$sidex &= "BACK"
										EndIf
								EndSwitch
							EndIf
							If CheckCsvValues("MAKE", 1, $value1) And CheckCsvValues("MAKE", 5, $value5) Then
								;AwesomeGamer CSV Mod
								If $value3 = "ALL" Then
									Switch Eval($sidex)
										Case "TOP-LEFT-DOWN"
											Local $Vector = $PixelTopLeftDOWNDropLine
										Case "TOP-LEFT-UP"
											Local $Vector = $PixelTopLeftUPDropLine
										Case "TOP-RIGHT-DOWN"
											Local $Vector = $PixelTopRightDOWNDropLine
										Case "TOP-RIGHT-UP"
											Local $Vector = $PixelTopRightUPDropLine
										Case "BOTTOM-LEFT-UP"
											Local $Vector = $PixelBottomLeftUPDropLine
										Case "BOTTOM-LEFT-DOWN"
											Local $Vector = $PixelBottomLeftDOWNDropLine
										Case "BOTTOM-RIGHT-UP"
											Local $Vector = $PixelBottomRightUPDropLine
										Case "BOTTOM-RIGHT-DOWN"
											Local $Vector = $PixelBottomRightDOWNDropLine
										Case Else
									EndSwitch
									Switch Eval($sidex) & "|" & $value5
										Case "TOP-LEFT-DOWN|INT-EXT", "TOP-LEFT-UP|EXT-INT", "TOP-RIGHT-DOWN|EXT-INT", "TOP-RIGHT-UP|INT-EXT", "BOTTOM-LEFT-DOWN|EXT-INT", "BOTTOM-LEFT-UP|INT-EXT", "BOTTOM-RIGHT-DOWN|INT-EXT", "BOTTOM-RIGHT-UP|EXT-INT"
											_ArrayReverse($Vector) ;reverse array
									EndSwitch
									Assign("ATTACKVECTOR_" & $value1, $Vector)
								Else
									Assign("ATTACKVECTOR_" & $value1, MakeDropPoints(Eval($sidex), $value3, $value4, $value5, $value6, $value7))
								EndIf
								For $i = 0 To UBound(Execute("$ATTACKVECTOR_" & $value1)) - 1
									$pixel = Execute("$ATTACKVECTOR_" & $value1 & "[" & $i & "]")
									debugAttackCSV($i & " - " & $pixel[0] & "," & $pixel[1])
								Next
							Else
								Setlog("Discard row, bad value1 or value 5 parameter: row " & $rownum)
								debugAttackCSV("Discard row, bad value1 or value5 parameter")
							EndIf
						Else
							Setlog("Discard row, bad value2 parameter:row " & $rownum)
							debugAttackCSV("Discard row, bad value2 parameter:row " & $rownum)
						EndIf
					Case "DROP"
						KeepClicks()
						;index...
						Local $index1, $index2, $indexArray, $indexvect, $isIndexPercent
						$indexvect = StringSplit($value2, "-", 2)
						
						;AwesomeGamer CSV Mod
						If StringInStr($value2, "%") > 0 Then
							$indexArray = 0
							$isIndexPercent = 1
							$index1 = Number(StringReplace($indexvect[0], "%", ""), 3)
							If UBound($indexvect) > 1 Then
								$index2 = Number(StringReplace($indexvect[1], "%", ""), 3)
							Else
								$index2 = $index1
							EndIf
						Else
							$isIndexPercent = 0
						If UBound($indexvect) > 1 Then
							$indexArray = 0
							If Int($indexvect[0]) > 0 And Int($indexvect[1]) > 0 Then
								$index1 = Int($indexvect[0])
								$index2 = Int($indexvect[1])
							Else
								$index1 = 1
								$index2 = 1
							EndIf
						Else
							$indexArray = StringSplit($value2, ",", 2)
							If UBound($indexArray) > 1 Then
								$index1 = 0
								$index2 = UBound($indexArray) - 1
							Else
								$indexArray = 0
								If Int($value2) > 0 Then
									$index1 = Int($value2)
									$index2 = Int($value2)
								Else
									$index1 = 1
									$index2 = 1
								EndIf
							EndIf
						EndIf
						EndIf
						
						;qty...
						Local $qty1, $qty2, $qtyvect, $isQtyPercent
						$qtyvect = StringSplit($value3, "-", 2)
						
						;AwesomeGamer CSV Mod
						If StringInStr($value3, "%") > 0 Then
							$isQtyPercent = 1
							$qty1 = Number(StringReplace($qtyvect[0], "%", ""), 3)
							If UBound($qtyvect) > 1 Then
								$qty2 = Number(StringReplace($qtyvect[1], "%", ""), 3)
							Else
								$qty2 = $qty1
							EndIf
						Else
							$isQtyPercent = 0
						If UBound($qtyvect) > 1 Then
							If Int($qtyvect[0]) > 0 And Int($qtyvect[1]) > 0 Then
								$qty1 = Int($qtyvect[0])
								$qty2 = Int($qtyvect[1])
							Else
								$index1 = 1
								$qty2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$qty1 = Int($value3)
								$qty2 = Int($value3)
							Else
								$qty1 = 1
								$qty2 = 1
							EndIf
						EndIf
						EndIf
						
						;delay between points
						Local $delaypoints1, $delaypoints2, $delaypointsvect
						$delaypointsvect = StringSplit($value5, "-", 2)
						If UBound($delaypointsvect) > 1 Then
							If Int($delaypointsvect[0]) > 0 And Int($delaypointsvect[1]) > 0 Then
								$delaypoints1 = Int($delaypointsvect[0])
								$delaypoints2 = Int($delaypointsvect[1])
							Else
								$delaypoints1 = 1
								$delaypoints2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$delaypoints1 = Int($value5)
								$delaypoints2 = Int($value5)
							Else
								$delaypoints1 = 1
								$delaypoints2 = 1
							EndIf
						EndIf
						;delay between  drops in same point
						Local $delaydrop1, $delaydrop2, $delaydropvect
						$delaydropvect = StringSplit($value6, "-", 2)
						If UBound($delaydropvect) > 1 Then
							If Int($delaydropvect[0]) > 0 And Int($delaydropvect[1]) > 0 Then
								$delaydrop1 = Int($delaydropvect[0])
								$delaydrop2 = Int($delaydropvect[1])
							Else
								$delaydrop1 = 1
								$delaydrop2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$delaydrop1 = Int($value6)
								$delaydrop2 = Int($value6)
							Else
								$delaydrop1 = 1
								$delaydrop2 = 1
							EndIf
						EndIf
						;sleep time after drop
						Local $sleepdrop1, $sleepdrop2, $sleepdroppvect
						$sleepdroppvect = StringSplit($value7, "-", 2)
						If UBound($sleepdroppvect) > 1 Then
							If Int($sleepdroppvect[0]) > 0 And Int($sleepdroppvect[1]) > 0 Then
								$sleepdrop1 = Int($sleepdroppvect[0])
								$sleepdrop2 = Int($sleepdroppvect[1])
							Else
								$sleepdrop1 = 1
								$sleepdrop2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$sleepdrop1 = Int($value7)
								$sleepdrop2 = Int($value7)
							Else
								$sleepdrop1 = 1
								$sleepdrop2 = 1
							EndIf
						EndIf
						;sleep time before drop
						Local $sleepbeforedrop1, $sleepbeforedrop2, $sleepbeforedroppvect
						$sleepbeforedroppvect = StringSplit($value8, "-", 2)
						If UBound($sleepbeforedroppvect) > 1 Then
							If Int($sleepbeforedroppvect[0]) > 0 And Int($sleepbeforedroppvect[1]) > 0 Then
								$sleepbeforedrop1 = Int($sleepbeforedroppvect[0])
								$sleepbeforedrop2 = Int($sleepbeforedroppvect[1])
							Else
								$sleepbeforedrop1 = 0
								$sleepbeforedrop2 = 0
							EndIf
						Else
							If Int($value3) > 0 Then
								$sleepbeforedrop1 = Int($value8)
								$sleepbeforedrop2 = Int($value8)
							Else
								$sleepbeforedrop1 = 0
								$sleepbeforedrop2 = 0
							EndIf
						EndIf
						DropTroopFromINI($value1, $index1, $index2, $indexArray, $qty1, $qty2, $value4, $delaypoints1, $delaypoints2, $delaydrop1, $delaydrop2, $sleepdrop1, $sleepdrop2, $sleepbeforedrop1, $sleepbeforedrop2, $isQtyPercent, $isIndexPercent, $debug)
						ReleaseClicks($AndroidAdbClicksTroopDeploySize)
						If _Sleep($iDelayRespond) Then ; check for pause/stop, close file before return
							FileClose($f)
							Return
						EndIf
					Case "WAIT"
						ReleaseClicks()
						;sleep time
						Local $sleep1, $sleep2, $sleepvect
						$sleepvect = StringSplit($value1, "-", 2)
						If UBound($sleepvect) > 1 Then
							If Int($sleepvect[0]) > 0 And Int($sleepvect[1]) > 0 Then
								$sleep1 = Int($sleepvect[0])
								$sleep2 = Int($sleepvect[1])
							Else
								$sleep1 = 1
								$sleep2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$sleep1 = Int($value1)
								$sleep2 = Int($value1)
							Else
								$sleep1 = 1
								$sleep2 = 1
							EndIf
						EndIf
						If $sleep1 <> $sleep2 Then
							Local $sleep = Random(Int($sleep1), Int($sleep2), 1)
						Else
							Local $sleep = Int($sleep1)
						EndIf
						debugAttackCSV("wait " & $sleep)
						;If _Sleep($sleep) Then Return
						Local $Gold = 0
						Local $Elixir = 0
						Local $DarkElixir = 0
						Local $Trophies = 0
						Local $exitOneStar = 0
						Local $exitTwoStars = 0
						Local $exitNoResources = 0
						Local $hSleepTimer = TimerInit()
						While TimerDiff($hSleepTimer) < $sleep
							;READ RESOURCES
							$Gold = getGoldVillageSearch(48, 69)
							$Elixir = getElixirVillageSearch(48, 69 + 29)
							If _Sleep($iDelayRespond) Then ; check for pause/stop, close file before return
								FileClose($f)
								Return
							EndIf
							$Trophies = getTrophyVillageSearch(48, 69 + 99)
							If $Trophies <> "" Then ; If trophy value found, then base has Dark Elixir
								$DarkElixir = getDarkElixirVillageSearch(48, 69 + 57)
							Else
								$DarkElixir = ""
								$Trophies = getTrophyVillageSearch(48, 69 + 69)
							EndIf
							If $DebugSetLog = 1 Then SetLog("detected [G]: " & $Gold & " [E]: " & $Elixir & " [DE]: " & $DarkElixir, $COLOR_INFO)
							;EXIT IF RESOURCES = 0
							If $ichkEndNoResources[$iMatchMode] = 1 And Number($Gold) = 0 And Number($Elixir) = 0 And Number($DarkElixir) = 0 Then
								If $DebugSetLog = 1 Then Setlog("From Attackcsv: Gold & Elixir & DE = 0, end battle ", $COLOR_DEBUG)
								$exitNoResources = 1
								ExitLoop
							EndIf
							;CALCULATE TWO STARS REACH
							If $ichkEndTwoStars[$iMatchMode] = 1 And _CheckPixel($aWonTwoStar, True) Then
								If $DebugSetLog = 1 Then Setlog("From Attackcsv: Two Star Reach, exit", $COLOR_SUCCESS)
								$exitTwoStars = 1
								ExitLoop
							EndIf
							;CALCULATE ONE STARS REACH
							If $ichkEndOneStar[$iMatchMode] = 1 And _CheckPixel($aWonOneStar, True) Then
								If $DebugSetLog = 1 Then Setlog("From Attackcsv: One Star Reach, exit", $COLOR_SUCCESS)
								$exitOneStar = 1
								ExitLoop
							EndIf
							If _Sleep($iDelayRespond) Then ; check for pause/stop, close file before return
								FileClose($f)
								Return
							EndIf
							CheckHeroesHealth()
						WEnd
						If $exitOneStar = 1 Or $exitTwoStars = 1 Or $exitNoResources = 1 Then ExitLoop ;stop parse CSV file, start exit battle procedure

					Case "RECALC"
						ReleaseClicks()
						PrepareAttack($iMatchMode, True)
					Case "SIDE"
                  		$heightTopLeft = 0
                  		$heightTopRight = 0
                  		$heightBottomLeft = 0
                  		$heightBottomRight = 0
						ReleaseClicks()
						Setlog("Calculate main side... ")
						If StringUpper($value8) = "TOP-LEFT" Or StringUpper($value8) = "TOP-RIGHT" Or StringUpper($value8) = "BOTTOM-LEFT" Or StringUpper($value8) = "BOTTOM-RIGHT" Then
							$MAINSIDE = StringUpper($value8)
							Setlog("Forced side: " & StringUpper($value8), $COLOR_INFO)
							$bForceSideExist = True
						Else

							For $i = 0 To UBound($PixelMine) - 1
								Local $str = ""
								Local $pixel = $PixelMine[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value1)
										Case 3, 4
											$heightTopRight += Int($value1)
										Case 5, 6
											$heightTopLeft += Int($value1)
										Case 7, 8
											$heightBottomLeft += Int($value1)
									EndSwitch
								EndIf
							Next

							For $i = 0 To UBound($PixelElixir) - 1
								Local $str = ""
								Local $pixel = $PixelElixir[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value2)
										Case 3, 4
											$heightTopRight += Int($value2)
										Case 5, 6
											$heightTopLeft += Int($value2)
										Case 7, 8
											$heightBottomLeft += Int($value2)
									EndSwitch
								EndIf
							Next

							For $i = 0 To UBound($PixelDarkElixir) - 1
								Local $str = ""
								Local $pixel = $PixelDarkElixir[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value3)
										Case 3, 4
											$heightTopRight += Int($value3)
										Case 5, 6
											$heightTopLeft += Int($value3)
										Case 7, 8
											$heightBottomLeft += Int($value3)
									EndSwitch
								EndIf
							Next

							If IsArray($GoldStoragePos) Then
								For $i = 0 To UBound($GoldStoragePos) - 1
									Local $pixel = $GoldStoragePos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value4)
											Case 3, 4
												$heightTopRight += Int($value4)
											Case 5, 6
												$heightTopLeft += Int($value4)
											Case 7, 8
												$heightBottomLeft += Int($value4)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($ElixirStoragePos) Then
								For $i = 0 To UBound($ElixirStoragePos) - 1
									Local $pixel = $ElixirStoragePos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value5)
											Case 3, 4
												$heightTopRight += Int($value5)
											Case 5, 6
												$heightTopLeft += Int($value5)
											Case 7, 8
												$heightBottomLeft += Int($value5)
										EndSwitch
									EndIf
								Next
							EndIf

							Switch StringLeft(Slice8($darkelixirStoragePos), 1)
								Case 1, 2
									$heightBottomRight += Int($value6)
								Case 3, 4
									$heightTopRight += Int($value6)
								Case 5, 6
									$heightTopLeft += Int($value6)
								Case 7, 8
									$heightBottomLeft += Int($value6)
							EndSwitch

							$pixel = StringSplit($thx & "-" & $thy, "-", 2)
							Switch StringLeft(Slice8($pixel), 1)
								Case 1, 2
									$heightBottomRight += Int($value7)
								Case 3, 4
									$heightTopRight += Int($value7)
								Case 5, 6
									$heightTopLeft += Int($value7)
								Case 7, 8
									$heightBottomLeft += Int($value7)
							EndSwitch
						EndIf

						Local $maxValue = $heightBottomRight
						Local $sidename = "BOTTOM-RIGHT"

						If $heightTopLeft > $maxValue Then
							$maxValue = $heightTopLeft
							$sidename = "TOP-LEFT"
						EndIf

						If $heightTopRight > $maxValue Then
							$maxValue = $heightTopRight
							$sidename = "TOP-RIGHT"
						EndIf

						If $heightBottomLeft > $maxValue Then
							$maxValue = $heightBottomLeft
							$sidename = "BOTTOM-LEFT"
						EndIf

						Setlog("Mainside: " & $sidename & " (top-left:" & $heightTopLeft & " top-right:" & $heightTopRight & " bottom-left:" & $heightBottomLeft & " bottom-right:" & $heightBottomRight)
						$MAINSIDE = $sidename

						Switch $MAINSIDE
							Case "BOTTOM-RIGHT"
								$FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
								$FRONT_RIGHT = "BOTTOM-RIGHT-UP"
								$RIGHT_FRONT = "TOP-RIGHT-DOWN"
								$RIGHT_BACK = "TOP-RIGHT-UP"
								$LEFT_FRONT = "BOTTOM-LEFT-DOWN"
								$LEFT_BACK = "BOTTOM-LEFT-UP"
								$BACK_LEFT = "TOP-LEFT-DOWN"
								$BACK_RIGHT = "TOP-LEFT-UP"
							Case "BOTTOM-LEFT"
								$FRONT_LEFT = "BOTTOM-LEFT-UP"
								$FRONT_RIGHT = "BOTTOM-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-RIGHT-DOWN"
								$RIGHT_BACK = "BOTTOM-RIGHT-UP"
								$LEFT_FRONT = "TOP-LEFT-DOWN"
								$LEFT_BACK = "TOP-LEFT-UP"
								$BACK_LEFT = "TOP-RIGHT-UP"
								$BACK_RIGHT = "TOP-RIGHT-DOWN"
							Case "TOP-LEFT"
								$FRONT_LEFT = "TOP-LEFT-UP"
								$FRONT_RIGHT = "TOP-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-LEFT-UP"
								$RIGHT_BACK = "BOTTOM-LEFT-DOWN"
								$LEFT_FRONT = "TOP-RIGHT-UP"
								$LEFT_BACK = "TOP-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-RIGHT-UP"
								$BACK_RIGHT = "BOTTOM-RIGHT-DOWN"
							Case "TOP-RIGHT"
								$FRONT_LEFT = "TOP-RIGHT-DOWN"
								$FRONT_RIGHT = "TOP-RIGHT-UP"
								$RIGHT_FRONT = "TOP-LEFT-UP"
								$RIGHT_BACK = "TOP-LEFT-DOWN"
								$LEFT_FRONT = "BOTTOM-RIGHT-UP"
								$LEFT_BACK = "BOTTOM-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-LEFT-DOWN"
								$BACK_RIGHT = "BOTTOM-LEFT-UP"
						EndSwitch

					Case "SIDEB"
						ReleaseClicks()
						If $bForceSideExist = False Then
							Setlog("Recalculate main side for additional defense buildings... ", $COLOR_INFO)

							Switch StringLeft(Slice8($EagleArtilleryPos), 1)
								Case 1, 2
									$heightBottomRight += Int($value1)
								Case 3, 4
									$heightTopRight += Int($value1)
								Case 5, 6
									$heightTopLeft += Int($value1)
								Case 7, 8
									$heightBottomLeft += Int($value1)
							EndSwitch

							Local $maxValue = $heightBottomRight
							Local $sidename = "BOTTOM-RIGHT"

							If $heightTopLeft > $maxValue Then
								$maxValue = $heightTopLeft
								$sidename = "TOP-LEFT"
							EndIf

							If $heightTopRight > $maxValue Then
								$maxValue = $heightTopRight
								$sidename = "TOP-RIGHT"
							EndIf

							If $heightBottomLeft > $maxValue Then
								$maxValue = $heightBottomLeft
								$sidename = "BOTTOM-LEFT"
							EndIf

							Setlog("New Mainside: " & $sidename & " (top-left:" & $heightTopLeft & " top-right:" & $heightTopRight & " bottom-left:" & $heightBottomLeft & " bottom-right:" & $heightBottomRight, $COLOR_INFO)
							$MAINSIDE = $sidename
						EndIf
						Switch $MAINSIDE
							Case "BOTTOM-RIGHT"
								$FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
								$FRONT_RIGHT = "BOTTOM-RIGHT-UP"
								$RIGHT_FRONT = "TOP-RIGHT-DOWN"
								$RIGHT_BACK = "TOP-RIGHT-UP"
								$LEFT_FRONT = "BOTTOM-LEFT-DOWN"
								$LEFT_BACK = "BOTTOM-LEFT-UP"
								$BACK_LEFT = "TOP-LEFT-DOWN"
								$BACK_RIGHT = "TOP-LEFT-UP"
							Case "BOTTOM-LEFT"
								$FRONT_LEFT = "BOTTOM-LEFT-UP"
								$FRONT_RIGHT = "BOTTOM-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-RIGHT-DOWN"
								$RIGHT_BACK = "BOTTOM-RIGHT-UP"
								$LEFT_FRONT = "TOP-LEFT-DOWN"
								$LEFT_BACK = "TOP-LEFT-UP"
								$BACK_LEFT = "TOP-RIGHT-UP"
								$BACK_RIGHT = "TOP-RIGHT-DOWN"
							Case "TOP-LEFT"
								$FRONT_LEFT = "TOP-LEFT-UP"
								$FRONT_RIGHT = "TOP-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-LEFT-UP"
								$RIGHT_BACK = "BOTTOM-LEFT-DOWN"
								$LEFT_FRONT = "TOP-RIGHT-UP"
								$LEFT_BACK = "TOP-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-RIGHT-UP"
								$BACK_RIGHT = "BOTTOM-RIGHT-DOWN"
							Case "TOP-RIGHT"
								$FRONT_LEFT = "TOP-RIGHT-DOWN"
								$FRONT_RIGHT = "TOP-RIGHT-UP"
								$RIGHT_FRONT = "TOP-LEFT-UP"
								$RIGHT_BACK = "TOP-LEFT-DOWN"
								$LEFT_FRONT = "BOTTOM-RIGHT-UP"
								$LEFT_BACK = "BOTTOM-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-LEFT-DOWN"
								$BACK_RIGHT = "BOTTOM-LEFT-UP"
						EndSwitch

					Case Else
						Setlog("attack row bad, discard :row " & $rownum, $COLOR_ERROR)
				EndSwitch
			Else
				If StringLeft($line, 7) <> "NOTE  |" And StringLeft($line, 7) <> "      |" And StringStripWS(StringUpper($line), 2) <> "" Then Setlog("attack row error, discard.: " & $line, $COLOR_ERROR)
			EndIf
			CheckHeroesHealth()
			If _Sleep($iDelayRespond) Then ; check for pause/stop after each line of CSV, close file before return
				FileClose($f)
				Return
			EndIf
		WEnd

		SetLog("Dropping left over troops", $COLOR_BLUE)
		For $x = 0 To 1
			IF PrepareAttack($iMatchMode, True) > 0 Then
				For $i = $eBarb To $eLava ; lauch all remaining troops
					LauchTroop($i, 4, 0, 1)
					CheckHeroesHealth()
					If _Sleep(50) Then Return
				Next
			EndIf
		Next

		ReleaseClicks()
		FileClose($f)
	Else
		SetLog("Cannot find attack file " & $dirAttacksCSV & "\" & $filename & ".csv", $COLOR_ERROR)
	EndIf
EndFunc   ;==>ParseAttackCSV
