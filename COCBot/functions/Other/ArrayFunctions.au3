; #FUNCTION# ====================================================================================================================
; Name ..........: ArrayRemoveDuplicates , _ArryRemoveBlanks
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: MR.ViPER (23-11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ArrayRemoveDuplicates(ByRef $Arr) ; Only 1D Array
	Local $iStart = 0
	Local $IndexesToDelete = ""
	For $i = $iStart To (UBound($Arr) - 1)

		For $j = $i + 1 To (UBound($Arr) - 1)

			If $Arr[$j] = $Arr[$i] Then
				$IndexesToDelete &= $j & ","
				ExitLoop
			EndIf
		Next

	Next

	If StringRight($IndexesToDelete, 1) = "," Then $IndexesToDelete = StringLeft($IndexesToDelete, (StringLen($IndexesToDelete) - 1))

	Local $splitedToDelete = StringSplit($IndexesToDelete, ",", 2)
	Local $tmpArr[UBound($Arr)]
	Local $searchResult = -1

	For $i = 0 To (UBound($Arr) - 1)
		$searchResult = _ArraySearch($splitedToDelete, $i)
		If $searchResult > -1 And StringLen($splitedToDelete[$searchResult]) > 0 Then ContinueLoop ; If The Array Index Should be Deleted
		$tmpArr[$i] = $Arr[$i]
	Next

	_ArryRemoveBlanks($tmpArr)

	$Arr = $tmpArr
EndFunc   ;==>ArrayRemoveDuplicates

Func _ArryRemoveBlanks(ByRef $Array)
	Switch (UBound($Array, 2) > 0) ; If Array Is 2D Array
		Case True
			Local $canKeep = True
			Local $2DBound = UBound($Array, 2)
			$Counter = 0
			For $i = 0 To (UBound($Array) - 1)
				For $j = 0 To (UBound($Array, 2) - 1)
					If $Array[$i][$j] = "" Then
						$canKeep = False
					Else
						$canKeep = True
						ExitLoop
					EndIf
				Next
				If $canKeep = True Then
					For $j = 0 To (UBound($Array, 2) - 1)
						$Array[$Counter][$j] = $Array[$i][$j]
					Next
					$Counter += 1
				EndIf
			Next
			ReDim $Array[$Counter][$2DBound]
		Case Else
			$Counter = 0
			For $i = 0 To (UBound($Array) - 1)
				If $Array[$i] <> "" Then
					$Array[$Counter] = $Array[$i]
					$Counter += 1
				EndIf
			Next
			ReDim $Array[$Counter]
	EndSwitch
EndFunc   ;==>_ArryRemoveBlanks

Func _StringEqualSplit($sString, $iNumChars = Default)
	If $iNumChars = Default Then $iNumChars = StringLen($sString)
	If Not IsString($sString) Or $sString = "" Then Return SetError(1, 0, 0)
	If Not IsInt($iNumChars) Or $iNumChars < 1 Then Return SetError(2, 0, 0)
	Return StringRegExp($sString, "(?s).{1," & $iNumChars & "}", 3)
EndFunc   ;==>_StringEqualSplit

Func _ArrayMerge(ByRef $a_base, ByRef $a_add, $i_start = 0)
	Local $X
	For $X = $i_start To UBound($a_add) - 1
		_ArrayAdd($a_base, $a_add[$X])
	Next
EndFunc   ;==>_ArrayMerge

Func _ArrayClear(ByRef $aArray)
    Local $iCols = UBound($aArray, 2)
    Local $iDim = UBound($aArray, 0)
    Local $iRows = UBound($aArray, 1)
    If $iDim = 1 Then
        Local $aArray1D[$iRows]
        $aArray = $aArray1D
    Else
        Local $aArray2D[$iRows][$iCols]
        $aArray = $aArray2D
    EndIf
EndFunc   ;==>_ArrayClear