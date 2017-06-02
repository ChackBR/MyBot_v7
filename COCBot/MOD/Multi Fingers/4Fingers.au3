; #FUNCTION# ====================================================================================================================
; Name ..........: fourFingerSpiralLeft
; Description ...: Contains functions for four finger spiral left deployment
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: LunaEclipse(January, 2016)
; Modified ......: Samkie (27 Nov 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func fourFingerMulti($dropVectors, $waveNumber, $dropAmount, $slotsPerEdge = 0)
	Local $troopsLeft = $dropAmount
	Local $troopsPerSlot = 0

	If $slotsPerEdge = 0 Or $troopsLeft < $slotsPerEdge Then $slotsPerEdge = $troopsLeft

	For $i = 0 To $slotsPerEdge - 1
		$troopsPerSlot = Ceiling($troopsLeft / ($slotsPerEdge - $i)) ; progressively adapt the number of drops to fill at the best

		standardSideDrop($dropVectors, $waveNumber, 0, $i, $troopsPerSlot)
		standardSideDrop($dropVectors, $waveNumber, 1, $i, $troopsPerSlot)
		standardSideDrop($dropVectors, $waveNumber, 2, $i, $troopsPerSlot)
		standardSideDrop($dropVectors, $waveNumber, 3, $i, $troopsPerSlot, True)

		$troopsLeft -= ($troopsLeft < $troopsPerSlot) ? $troopsLeft : $troopsPerSlot
	Next
EndFunc   ;==>fourFingerMulti

Func fourFingerDropOnEdge($dropVectors, $waveNumber, $kind, $dropAmount, $position = 0)
	Local $troopsPerEdge = Ceiling($dropAmount / 4)

	If $dropAmount = 0 Or isProblemAffect(True) Then Return

	If _SleepAttack(100) Then Return
	SelectDropTroop($kind) ; Select Troop
	If _SleepAttack(300) Then Return

	Switch $position
		Case 1
			multiSingle($dropAmount)
		Case 2
			multiDouble($dropAmount)
		Case Else
			Switch $troopsPerEdge
				Case 1
					multiSingle($dropAmount)
				Case 2
					multiDouble($dropAmount)
				Case Else
					fourFingerMulti($dropVectors, $waveNumber, $troopsPerEdge, $position)
			EndSwitch
	EndSwitch
EndFunc   ;==>fourFingerDropOnEdge