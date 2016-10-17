; #FUNCTION# ====================================================================================================================
; Name ..........: DropTroopFromINI
; Description ...:
; Syntax ........: DropTroopFromINI($vectors, $indexStart, $indexEnd, $qtaMin, $qtaMax, $troopName, $delayPointmin,
;                  $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax[, $debug = False])
; Parameters ....: $vectors             -
;                  $indexStart          -
;                  $indexEnd            -
;                  $qtaMin              -
;                  $qtaMax              -
;                  $troopName           -
;                  $delayPointmin       -
;                  $delayPointmax       -
;                  $delayDropMin        -
;                  $delayDropMax        -
;                  $sleepafterMin       -
;                  $sleepAfterMax       -
;                  $debug               - [optional] Default is False.
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func DropTroopFromINI($vectors, $indexStart, $indexEnd, $indexArray, $qtaMin, $qtaMax, $troopName, $delayPointmin, $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax, $sleepBeforeMin, $sleepBeforeMax, $isQtyPercent, $isIndexPercent, $debug = False)
	If IsArray($indexArray) = 0 Then
		debugAttackCSV("drop using vectors " & $vectors & " index " & $indexStart & "-" & $indexEnd & " and using " & $qtaMin & "-" & $qtaMax & " of " & $troopName)
	Else
		debugAttackCSV("drop using vectors " & $vectors & " index " & _ArrayToString($indexArray, ",") & " and using " & $qtaMin & "-" & $qtaMax & " of " & $troopName)
	EndIf
	debugAttackCSV(" - delay for multiple troops in same point: " & $delayPointmin & "-" & $delayPointmax)
	debugAttackCSV(" - delay when  change deploy point : " & $delayDropMin & "-" & $delayDropMax)
	debugAttackCSV(" - delay after drop all troops : " & $sleepafterMin & "-" & $sleepAfterMax)
	;how many vectors need to manage...
	Local $vectorLetters = StringSplit($vectors, "-")
	Local $numbersOfVectors
	If UBound($vectorLetters) > 0 Then
		$numbersOfVectors = $vectorLetters[0]
	Else
		$numbersOfVectors = 0
	EndIf

	;initialize vector arrays
	Local $managedVectors[$numbersOfVectors]
	For $i = 0 To $numbersOfVectors - 1
		$managedVectors[$i] = Execute("$ATTACKVECTOR_" & $vectorLetters[$i + 1])
	Next

	Local $troopEnum = Eval("e" & $troopName)
	Local $availableTroops = 0
	Local $remainingTroopsDrop = 0
	Local $troopsDropped = 0

	For $i = 0 to Ubound($atkTroops) - 1
		If $atkTroops[$i][0] = $troopEnum Then
			$availableTroops = $atkTroops[$i][1]
		EndIf
	Next

	For $i = 0 to Ubound($remainingTroops) - 1
		If $remainingTroops[$i][0] = $troopEnum Then
			$remainingTroopsDrop = $remainingTroops[$i][1]
		EndIf
	Next

	If $troopEnum = $eKing Or $troopEnum = $eQueen Or $troopEnum = $eWarden Or $troopEnum = $eCastle Then
		$availableTroops = 1
		$remainingTroopsDrop = 1
	EndIf

	Setlog($troopName & ": " & $availableTroops & " total, " & $remainingTroopsDrop & " remaining.")

	If $isQtyPercent = 1 Then
		Local $qty = Ceiling($availableTroops * ($qtaMin / 100))
	Else
		;Qty to drop
		If $qtaMin <> $qtaMax Then
			Local $qty = Random($qtaMin, $qtaMax, 1)
		Else
			Local $qty = $qtaMin
		EndIf
	EndIf
	debugAttackCSV(">> qty to deploy: " & $qty)

	;number of troop to drop in one point...
	Local $qtyxpoint = Int($qty / ($indexEnd - $indexStart + 1))
	Local $extraunit = Mod($qty, ($indexEnd - $indexStart + 1))
	debugAttackCSV(">> qty x point: " & $qtyxpoint)
	debugAttackCSV(">> qty extra: " & $extraunit)
	;search slot where is the troop...
	Local $troopPosition = -1
	For $i = 0 To UBound($atkTroops) - 1
		If $atkTroops[$i][0] = Eval("e" & $troopName) Then
			$troopPosition = $i
		EndIf
	Next

	Local $usespell = True
	Switch Eval("e" & $troopName)
		Case $eLSpell
			If $ichkLightSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eHSpell
			If $ichkHealSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eRSpell
			If $ichkRageSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eJSpell
			If $ichkJumpSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eFSpell
			If $ichkFreezeSpell[$iMatchMode] = 0 Then $usespell = False
;		Case $eCSpell
;			If $ichkCloneSpell[$iMatchMode] = 0 Then $usespell = False
		Case $ePSpell
			If $ichkPoisonSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eESpell
			If $ichkEarthquakeSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eHaSpell
			If $ichkHasteSpell[$iMatchMode] = 0 Then $usespell = False
;		Case $eSkSpell
;			If $ichkSkeletonSpell[$iMatchMode] = 0 Then $usespell = False
	EndSwitch

   If $delayPointmin = 0 Then $delayPointmin = 50
   If $delayPointmax = 0 Then $delayPointmax = 50

   If $delayDropMin = 0 Then $delayDropMin = 50
   If $delayDropMax = 0 Then $delayDropMax = 50

	Local $minSize = 1000
	For $i = 0 To $numbersOfVectors - 1
		If Ubound($managedVectors[$i]) < $minSize Then $minSize = Ubound($managedVectors[$i])
		debugAttackCSV(">> vector " & $i & "=" & Ubound($managedVectors[$i]))
	Next
	debugAttackCSV(">> minSize " & "=" & $minSize)
	If $isIndexPercent = 1 Then
		$indexStart = Floor($minSize * ($indexStart / 100))
		$indexEnd = Ceiling($minSize * ($indexEnd / 100))
		if $indexStart = 0 then
			$indexStart = 1
		EndIf
	EndIf

	;number of troop to drop in one point...
	If $qty > 0 and $qty < $indexEnd - $indexStart And $isQtyPercent = 1 Then
		;there are less drop doints than indexes
		;spread out the drop points along the indexes
		Local $qtyxpoint = 1
		Local $extraunit = 0
		Local $indexJump = ($indexEnd - $indexStart) / ($qty - 1)
	Else
		Local $qtyxpoint = Int($qty / ($indexEnd - $indexStart + 1))
		Local $extraunit = Mod($qty, ($indexEnd - $indexStart + 1))
		Local $indexJump = 0
	EndIf

	If $troopPosition = -1 Or $usespell = False Then
		If $usespell = True Then
			Setlog("No troop found in your attack troops list")
			debugAttackCSV("No troop found in your attack troops list")
		Else
			If $DebugSetLog = 1 Then SetLog("discard use spell", $COLOR_DEBUG)
		EndIf
	Else
		SelectDropTroop($troopPosition) ; select the troop...
		
		If $sleepBeforeMin = 0 Then $sleepBeforeMin = 50
   		If $sleepBeforeMax = 0 Then $sleepBeforeMax = 50

		;sleep time Before deploy all troops
		Local $sleepBefore = 0
		If $sleepBeforeMin <> $sleepBeforeMax Then
			$sleepBefore = Random($sleepBeforeMin, $sleepBeforeMax, 1)
		Else
			$sleepBefore = Int($sleepBeforeMin)
		EndIf

		; CSV Deployment Speed Mod
		$sleepBefore = $sleepBefore / $iCSVSpeeds[$isldSelectedCSVSpeed[$iMatchMode]]

		If $sleepBefore > 50 And IsKeepClicksActive() = False Then
			debugAttackCSV(">> delay Before drop all troops: " & $sleepBefore)
			If $sleepBefore <= 1000 Then  ; check SLEEPBefore value is less than 1 second?
				If _Sleep($sleepBefore) Then Return
				CheckHeroesHealth()  ; check hero health == does nothing if hero not dropped
			Else  ; $sleepBefore is More than 1 second, then improve pause/stop button response with max 1 second delays
				For $z = 1 To Int($sleepBefore/1000) ; Check hero health every second while while sleeping
					If _Sleep(980) Then Return  ; sleep 1 second minus estimated herohealthcheck time when heroes not activiated
					CheckHeroesHealth()  ; check hero health == does nothing if hero not dropped
				Next
				If _Sleep(Mod($sleepBefore,1000)) Then Return  ; $sleepBefore must be integer for MOD function return correct value!
				CheckHeroesHealth() ; check hero health == does nothing if hero not dropped
			EndIf
		EndIf

		SelectDropTroop($troopPosition) ; select the troop...
		Global $lastTroopPositionDropTroopFromINI
		If $lastTroopPositionDropTroopFromINI <> $troopPosition Then ReleaseClicks()
		$lastTroopPositionDropTroopFromINI = $troopPosition
		;drop
		$TroopDropNumber += 1

		Local $currentJumpIndex
		Local $hTimer = TimerInit()

		For $i = $indexStart To $indexEnd
			If $indexJump > 0 And $isIndexPercent = 1 Then
				;check to see if we skip this index to spread out troops
				if $i = $indexStart Then
					$currentJumpIndex = $indexStart + $indexJump
				ElseIf $i = Round($currentJumpIndex) Then
					$currentJumpIndex += $indexJump
				Else
					ContinueLoop
				EndIf
			 EndIf

			Local $delayDrop = 0
			Local $index = $i
			Local $indexMax = $indexEnd
			If IsArray($indexArray) = 1 Then
				; adjust $index and $indexMax based on array
				$index = $indexArray[$i]
				$indexMax = $indexArray[$indexEnd]
			EndIf
			If $index <> $indexMax Then
				;delay time between 2 drops in different point
				If $delayDropMin <> $delayDropMax Then
					$delayDrop = Random($delayDropMin, $delayDropMax, 1)
				Else
					$delayDrop = $delayDropMin
				EndIf
				debugAttackCSV(">> delay change drop point: " & $delayDrop)
			EndIf

			For $j = 1 To $numbersOfVectors
				If $isQtyPercent = 1 Then
					If $troopsDropped >= $availableTroops Then
						ExitLoop
					EndIf
				EndIf

				;delay time between 2 drops in different point
				Local $delayDropLast = 0
				If $j = $numbersOfVectors Then $delayDropLast = $delayDrop
				If $index <= UBound($managedVectors[$j - 1]) Then
					$pixel = ($managedVectors[$j - 1])[$index - 1]
					Local $qty2 = $qtyxpoint
					If $index < $indexStart + $extraunit Then $qty2 += 1

					If $isQtyPercent = 1 Then
					   If $remainingTroopsDrop = 0 Then
						  ExitLoop
					   EndIf

						If $qty2 > $remainingTroopsDrop Then
							$qty2 = $remainingTroopsDrop
						EndIf
					 EndIf

					;delay time between 2 drops in same point
					If $delayPointmin <> $delayPointmax Then
						Local $delayPoint = Random($delayPointmin, $delayPointmax, 1)
					Else
						Local $delayPoint = $delayPointmin
					EndIf

					$remainingTroopsDrop -= $qty2
					$troopsDropped += 1 ;$qty2

					; CSV Deployment Speed Mod
					$delayPoint = $delayPoint / $iCSVSpeeds[$isldSelectedCSVSpeed[$iMatchMode]]
					$delayDropLast = $delayDropLast / $iCSVSpeeds[$isldSelectedCSVSpeed[$iMatchMode]]

					Switch Eval("e" & $troopName)
						Case $eBarb To $eBowl ; drop normal troops
							If $debug = True Then
								Setlog("AttackClick( " & $pixel[0] & ", " & $pixel[1] & " , " & $qty2 & ", " & $delayPoint & ",#0666)")
							Else
								If ( $Android = "BlueStacks" ) Or ( $Android = "BlueStacks2" ) Then
									PureClick($pixel[0], $pixel[1], $qty2, $delayPoint)
								Else
									If $AndroidAdbClicksEnabled Then 
										;AttackClick($pixel[0], $pixel[1], $qty2, SetSleep(0), 0, "#0667")
										AttackClick($pixel[0], $pixel[1], $qty2, Int($delayPoint/2), 0, "#0666")
									Else
										;AttackClick($pixel[0], $pixel[1], $qty2, $delayPoint, $delayDropLast, "#0667")
										AttackClick($pixel[0], $pixel[1], $qty2, $delayPoint, 0, "#0666")
									EndIf
								EndIf
							EndIf
						Case $eKing
							If $debug = True Then
								Setlog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ", " & $King & ", -1, -1) ")
							Else
								dropHeroes($pixel[0], $pixel[1], $King, -1, -1)
							EndIf
						Case $eQueen
							If $debug = True Then
								Setlog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ",-1," & $Queen & ", -1) ")
							Else
								dropHeroes($pixel[0], $pixel[1], -1, $Queen, -1)
							EndIf
						Case $eWarden
							If $debug = True Then
								Setlog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ", -1, -1," & $Warden & ") ")
							Else
								dropHeroes($pixel[0], $pixel[1], -1, -1, $Warden)
							EndIf
						Case $eCastle
							If $debug = True Then
								Setlog("dropCC(" & $pixel[0] & ", " & $pixel[1] & ", " & $CC & ")")
							Else
								dropCC($pixel[0], $pixel[1], $CC)
							EndIf
						Case $eLSpell To $eSkSpell
							If $debug = True Then
								Setlog("Drop Spell AttackClick( " & $pixel[0] & ", " & $pixel[1] & " , " & $qty2 & ", " & $delayPoint & ",#0666)")
							Else
								AttackClick($pixel[0], $pixel[1], $qty2, $delayPoint, $delayDropLast, "#0667")
							EndIf
						Case Else
							Setlog("Error parsing line")
					EndSwitch
					debugAttackCSV($troopName & " qty " & $qty2 & " in (" & $pixel[0] & "," & $pixel[1] & ") delay " & $delayPoint)
				EndIf
				;;;;if $j <> $numbersOfVectors Then _sleep(5) ;little delay by passing from a vector to another vector
				If $i <> $indexEnd Then
					;delay time between 2 drops in different point
					If $delayDropMin <> $delayDropMax Then
						$delayDrop = Random($delayDropMin, $delayDropMax, 1)
					Else
						$delayDrop = $delayDropMin
					EndIf

					$delayDrop = $delayDrop / $iCSVSpeeds[$isldSelectedCSVSpeed[$iMatchMode]]

					;debugAttackCSV(">> delay change drop point: " & $delayDrop)
					If $delayDrop >= 50 Then ;Not worth sleeping if lower than 50ms
						ReleaseClicks()
						If _Sleep($delayDrop) Then
							Return
						EndIf
						KeepClicks()
					EndIf
				EndIf
			Next
		Next
		
		Local $htimerDrop = Round(TimerDiff($hTimer) / 1000, 2)
		Setlog("Dropped " & $troopsDropped & " " & $troopName & " in " & $htimerDrop & " seconds.  Remaining: " & $remainingTroopsDrop)
		
		For $i = 0 to Ubound($remainingTroops) - 1
			If $remainingTroops[$i][0] = $troopEnum Then
				$remainingTroops[$i][1] = $remainingTroopsDrop
			EndIf
		Next 

		ReleaseClicks()
	    ;~ SuspendAndroid($SuspendMode)   
		
		If $sleepafterMin = 0 Then $sleepafterMin = 50
   		If $sleepAfterMax = 0 Then $sleepAfterMax = 50

		;sleep time after deploy all troops
		Local $sleepafter = 0
		If $sleepafterMin <> $sleepAfterMax Then
			$sleepafter = Random($sleepafterMin, $sleepAfterMax, 1)
		Else
			$sleepafter = Int($sleepafterMin)
		EndIf

		; CSV Deployment Speed Mod
		$sleepafter = $sleepafter / $iCSVSpeeds[$isldSelectedCSVSpeed[$iMatchMode]]
		
		If $sleepafter > 50 And IsKeepClicksActive() = False Then
			debugAttackCSV(">> delay after drop all troops: " & $sleepafter)
			If $sleepafter <= 1000 Then  ; check SLEEPAFTER value is less than 1 second?
				If _Sleep($sleepafter) Then Return
				CheckHeroesHealth()  ; check hero health == does nothing if hero not dropped
			Else  ; $sleepafter is More than 1 second, then improve pause/stop button response with max 1 second delays
				For $z = 1 To Int($sleepafter/1000) ; Check hero health every second while while sleeping
					If _Sleep(980) Then Return  ; sleep 1 second minus estimated herohealthcheck time when heroes not activiated
					CheckHeroesHealth()  ; check hero health == does nothing if hero not dropped
				Next
				If _Sleep(Mod($sleepafter,1000)) Then Return  ; $sleepafter must be integer for MOD function return correct value!
				CheckHeroesHealth() ; check hero health == does nothing if hero not dropped
			EndIf
		EndIf
	EndIf

EndFunc   ;==>DropTroopFromINI
