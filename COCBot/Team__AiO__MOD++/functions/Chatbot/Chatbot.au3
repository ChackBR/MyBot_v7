; #FUNCTION# ====================================================================================================================
; Name ..........: ChatBot
; Description ...: This file is all related to Gaining XP by Attacking to Goblin Picninc Signle player
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: rulesss, kychera
; Modified ......: AiO++ Team
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include <Process.au3>
#include <Array.au3>
#include <WinAPIEx.au3>

Func ChatbotReadMessages()
	If IniRead($chatIni, "ChatGlobal", "Enable", "False") = "True" Then $g_iGlobalChat = True
	If IniRead($chatIni, "ChatGlobal", "Scramble", "False") = "True" Then $g_iGlobalScramble = True
	If IniRead($chatIni, "ChatGlobal", "SwitchLang", "False") = "True" Then $g_iSwitchLang = True
    $g_iRusLang = IniRead($chatIni, "Lang", "RusLang", "0")
    $g_iCmbLang = IniRead($chatIni, "Lang", "cmbLang", "8")
	If IniRead($chatIni, "ChatClan", "Enable", "False") = "True" Then $g_iClanChat = True
	If IniRead($chatIni, "ChatClan", "Responses", "False") = "True" Then $g_iUseResponses = True
	If IniRead($chatIni, "ChatClan", "Generic", "False") = "True" Then $g_iUseGeneric = True
	If IniRead($chatIni, "ChatClan", "ChatPushbullet", "False") = "True" Then $g_iChatPushbullet = True
	If IniRead($chatIni, "ChatClan", "PbSendNewChats", "False") = "True" Then $g_iPbSendNewChats = True

	$ClanMessages = StringSplit(IniRead($chatIni, "ChatClan", "GenericMessages", "Testing on Chat|Hey all"), "|", 2)
	Global $ClanResponses0 = StringSplit(IniRead($chatIni, "ChatClan", "ResponseMessages", "keyword:Response|hello:Hi, Welcome to the clan|hey:Hey, how's it going?"), "|", 2)
	Global $ClanResponses1[UBound($ClanResponses0)][2]
	For $a = 0 To UBound($ClanResponses0) - 1
		Local $TmpResp = StringSplit($ClanResponses0[$a], ":", 2)
		If UBound($TmpResp) > 0 Then
			$ClanResponses1[$a][0] = $TmpResp[0]
		Else
			$ClanResponses1[$a][0] = "<invalid>"
		EndIf
		If UBound($TmpResp) > 1 Then
			$ClanResponses1[$a][1] = $TmpResp[1]
		Else
			$ClanResponses1[$a][1] = "<undefined>"
		EndIf
	Next

	$ClanResponses = $ClanResponses1

	$GlobalMessages1 = StringSplit(IniRead($chatIni, "ChatGlobal", "GlobalMessages1", "War Clan Recruiting|Active War Clan accepting applications"), "|", 2)
	$GlobalMessages2 = StringSplit(IniRead($chatIni, "ChatGlobal", "GlobalMessages2", "Join now|Apply now"), "|", 2)
	$GlobalMessages3 = StringSplit(IniRead($chatIni, "ChatGlobal", "GlobalMessages3", "250 war stars min|Must have 250 war stars"), "|", 2)
	$GlobalMessages4 = StringSplit(IniRead($chatIni, "ChatGlobal", "GlobalMessages4", "Adults Only| 18+"), "|", 2)
EndFunc   ;==>ChatbotReadMessages

Func ChatbotGUICheckbox()
	$g_iGlobalChat = GUICtrlRead($g_hChkGlobalChat) = $GUI_CHECKED
	$g_iGlobalScramble = GUICtrlRead($g_hChkGlobalScramble) = $GUI_CHECKED
	$g_iSwitchLang = GUICtrlRead($g_hChkSwitchLang) = $GUI_CHECKED

	$g_iClanChat = GUICtrlRead($g_hChkClanChat) = $GUI_CHECKED
	$g_iUseResponses = GUICtrlRead($g_hChkUseResponses) = $GUI_CHECKED
	$g_iUseGeneric = GUICtrlRead($g_hChkUseGeneric) = $GUI_CHECKED
	$g_iChatPushbullet = GUICtrlRead($g_hChkChatPushbullet) = $GUI_CHECKED
	$g_iPbSendNewChats = GUICtrlRead($g_hChkPbSendNewChats) = $GUI_CHECKED
    If GUICtrlRead($g_hChkRusLang) = $GUI_CHECKED Then
		$g_iRusLang = 1
	Else
		$g_iRusLang = 0
	EndIf
	$g_iCmbLang = _GUICtrlComboBox_GetCurSel($g_hCmbLang)

	IniWrite($chatIni, "Lang", "cmbLang", $g_iCmbLang)
	IniWrite($chatIni, "ChatGlobal", "Enable", $g_iGlobalChat)
	IniWrite($chatIni, "ChatGlobal", "Scramble", $g_iGlobalScramble)
	IniWrite($chatIni, "ChatGlobal", "SwitchLang", $g_iSwitchLang)

	IniWrite($chatIni, "ChatClan", "Enable", $g_iClanChat)
	IniWrite($chatIni, "ChatClan", "Responses", $g_iUseResponses)
	IniWrite($chatIni, "ChatClan", "Generic", $g_iUseGeneric)
	IniWrite($chatIni, "ChatClan", "ChatPushbullet", $g_iChatPushbullet)
	IniWrite($chatIni, "ChatClan", "PbSendNewChats", $g_iPbSendNewChats)
    IniWrite($chatIni, "Lang", "RusLang", $g_iRusLang)
	ChatbotGUICheckboxControl()

EndFunc   ;==>ChatbotGUICheckbox

Func ChatbotGUICheckboxControl()
	If GUICtrlRead($g_hChkGlobalChat) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkGlobalScramble, $GUI_ENABLE)
		GUICtrlSetState($g_hChkSwitchLang, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbLang, $GUI_SHOW)
		GUICtrlSetState($g_hEditGlobalMessages1, $GUI_ENABLE)
		GUICtrlSetState($g_hEditGlobalMessages2, $GUI_ENABLE)
		GUICtrlSetState($g_hEditGlobalMessages3, $GUI_ENABLE)
		GUICtrlSetState($g_hEditGlobalMessages4, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkGlobalScramble, $GUI_DISABLE)
		GUICtrlSetState($g_hChkSwitchLang, $GUI_DISABLE)
	    GUICtrlSetState($g_hCmbLang, $GUI_INDETERMINATE)
		GUICtrlSetState($g_hEditGlobalMessages1, $GUI_DISABLE)
		GUICtrlSetState($g_hEditGlobalMessages2, $GUI_DISABLE)
		GUICtrlSetState($g_hEditGlobalMessages3, $GUI_DISABLE)
		GUICtrlSetState($g_hEditGlobalMessages4, $GUI_DISABLE)
	EndIf
	If GUICtrlRead($g_hChkClanChat) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkUseResponses, $GUI_ENABLE)
		GUICtrlSetState($g_hChkUseGeneric, $GUI_ENABLE)
		GUICtrlSetState($g_hChkChatPushbullet, $GUI_ENABLE)
		GUICtrlSetState($g_hChkPbSendNewChats, $GUI_ENABLE)
		GUICtrlSetState($g_hEditResponses, $GUI_ENABLE)
		GUICtrlSetState($g_hEditGeneric, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkUseResponses, $GUI_DISABLE)
		GUICtrlSetState($g_hChkUseGeneric, $GUI_DISABLE)
		GUICtrlSetState($g_hChkChatPushbullet, $GUI_DISABLE)
		GUICtrlSetState($g_hChkPbSendNewChats, $GUI_DISABLE)
		GUICtrlSetState($g_hEditResponses, $GUI_DISABLE)
		GUICtrlSetState($g_hEditGeneric, $GUI_DISABLE)
	EndIf
	If  GUICtrlRead($g_hChkGlobalChat) = $GUI_CHECKED And GUICtrlRead($g_hChkSwitchLang) = $GUI_CHECKED Then
	    GUICtrlSetState($g_hCmbLang, $GUI_ENABLE)
	Else
     	GUICtrlSetState($g_hCmbLang, $GUI_DISABLE)
	EndIf

	If $g_iRusLang = 1 Then
		GUICtrlSetState($g_hChkRusLang, $GUI_CHECKED)

	ElseIf $g_iRusLang = 0 Then
		GUICtrlSetState($g_hChkRusLang, $GUI_UNCHECKED)

	EndIf
	_GUICtrlComboBox_SetCurSel($g_hCmbLang, $g_iCmbLang)
	$g_iCmbLang = _GUICtrlComboBox_GetCurSel($g_hCmbLang)
EndFunc   ;==>ChatbotGUICheckboxControl

Func ChatbotGUICheckboxDisable()
	For $i = $g_hChkGlobalChat To $g_hEditGeneric ; Save state of all controls on tabs
		GUICtrlSetState($i, $GUI_DISABLE)
	Next
EndFunc   ;==>ChatbotGUICheckboxDisable
Func ChatbotGUICheckboxEnable()
	For $i = $g_hChkGlobalChat To $g_hEditGeneric ; Save state of all controls on tabs
		GUICtrlSetState($i, $GUI_ENABLE)
	Next
	ChatbotGUICheckboxControl()
EndFunc   ;==>ChatbotGUICheckboxEnable

Func ChatbotGUIEditMessages()
Global $glb1 = GUICtrlRead($g_hEditGlobalMessages1)
Global $glb2 = GUICtrlRead($g_hEditGlobalMessages2)
Global $glb3 = GUICtrlRead($g_hEditGlobalMessages3)
Global $glb4 = GUICtrlRead($g_hEditGlobalMessages4)

Global $cResp = GUICtrlRead($g_hEditResponses)
Global $cGeneric = GUICtrlRead($g_hEditGeneric)


	$glb1 = StringReplace($glb1, @CRLF, "|")
	$glb2 = StringReplace($glb2, @CRLF, "|")
	$glb3 = StringReplace($glb3, @CRLF, "|")
	$glb4 = StringReplace($glb4, @CRLF, "|")

	$cResp = StringReplace($cResp, @CRLF, "|")
	$cGeneric = StringReplace($cGeneric, @CRLF, "|")

	IniWrite($chatIni, "ChatGlobal", "GlobalMessages1", $glb1)
	IniWrite($chatIni, "ChatGlobal", "GlobalMessages2", $glb2)
	IniWrite($chatIni, "ChatGlobal", "GlobalMessages3", $glb3)
	IniWrite($chatIni, "ChatGlobal", "GlobalMessages4", $glb4)

	IniWrite($chatIni, "ChatClan", "GenericMessages", $cGeneric)
	IniWrite($chatIni, "ChatClan", "ResponseMessages", $cResp)

	ChatbotReadMessages()
EndFunc   ;==>ChatbotGUIEditMessages

Func ChatbotChatOpen() ; open the chat area
	Local $aButtonChatOpen[4] = [20, 351 + $g_iMidOffsetY, 0xFFFFFF, 20]
	If _ColorCheck(_GetPixelColor($aButtonChatOpen[0], $aButtonChatOpen[1], True), Hex($aButtonChatOpen[2], 6), $aButtonChatOpen[3]) Then
		Click($aButtonChatOpen[0], $aButtonChatOpen[1], 1)
		If _Sleep(1000) Then Return
	EndIf
	Return True
EndFunc   ;==>ChatbotChatOpen

Func ChatbotSelectClanChat() ; select clan tab
	Local $aSelectClanChat[4] = [200, 22, 0x383828, 20]
	Local $aSelectClanChat2[4] = [280, 680 + $g_iMidOffsetY, 0xFDFFFF, 20]
	If _ColorCheck(_GetPixelColor($aSelectClanChat[0], $aSelectClanChat[1], True), Hex($aSelectClanChat[2], 6), $aSelectClanChat[3]) Then
		Click($aSelectClanChat[0], $aSelectClanChat[1], 1)
		If _Sleep(1000) Then Return
	EndIf
	If _ColorCheck(_GetPixelColor($aSelectClanChat2[0], $aSelectClanChat2[1], True), Hex($aSelectClanChat2[2], 6), $aSelectClanChat2[3]) Then
		Click($aSelectClanChat2[0], $aSelectClanChat2[1], 1)
		If _Sleep(1000) Then Return
	EndIf
	Return True
EndFunc   ;==>ChatbotSelectClanChat

Func ChatbotSelectGlobalChat() ; select global tab
	Local $aSelectGlobalChat[4] = [48, 22, 0x383828, 20]
	Local $aSelectGlobalChat2[4] = [280, 680 + $g_iMidOffsetY, 0xFDFFFF, 20]
	If _ColorCheck(_GetPixelColor($aSelectGlobalChat[0], $aSelectGlobalChat[1], True), Hex($aSelectGlobalChat[2], 6), $aSelectGlobalChat[3]) Then
		Click($aSelectGlobalChat[0], $aSelectGlobalChat[1], 1)
		If _Sleep(1000) Then Return
	EndIf
	If _ColorCheck(_GetPixelColor($aSelectGlobalChat2[0], $aSelectGlobalChat2[1], True), Hex($aSelectGlobalChat2[2], 6), $aSelectGlobalChat2[3]) Then
		Click($aSelectGlobalChat2[0], $aSelectGlobalChat2[1], 1)
		If _Sleep(1000) Then Return
	EndIf
	Return True
EndFunc   ;==>ChatbotSelectGlobalChat

Func ChatbotChatClose() ; close chat area
	Local $aButtonChatClose[4] = [330, 352 + $g_iMidOffsetY, 0xFFFFFF, 20]
	If _ColorCheck(_GetPixelColor($aButtonChatClose[0], $aButtonChatClose[1], True), Hex($aButtonChatClose[2], 6), $aButtonChatClose[3]) Then
		Click($aButtonChatClose[0], $aButtonChatClose[1], 1)
		waitMainScreen()
	EndIf
	Return True
EndFunc   ;==>ChatbotChatClose

Func ChatbotChatClanInput() ; select the textbox for clan chat
	Local $aChatClanInput[4] = [276, 677 + $g_iMidOffsetY, 0xFFFFFF, 20]
	If _ColorCheck(_GetPixelColor($aChatClanInput[0], $aChatClanInput[1], True), Hex($aChatClanInput[2], 6), $aChatClanInput[3]) Then
		Click($aChatClanInput[0], $aChatClanInput[1], 1)
		If _Sleep(1000) Then Return
	EndIf
	Return True
EndFunc   ;==>ChatbotChatClanInput

Func ChatbotChatGlobalInput() ; select the textbox for global chat
	Local $aChatGlobalInput[4] = [276, 677 + $g_iMidOffsetY, 0xFFFFFF, 20]
	If _ColorCheck(_GetPixelColor($aChatGlobalInput[0], $aChatGlobalInput[1], True), Hex($aChatGlobalInput[2], 6), $aChatGlobalInput[3]) Then
		Click($aChatGlobalInput[0], $aChatGlobalInput[1], 1)
		If _Sleep(1000) Then Return
	EndIf
	Return True
EndFunc   ;==>ChatbotChatGlobalInput

Func ChatbotChatInput($message)
	Local $aChatInput[4] = [276, 677 + $g_iMidOffsetY, 0xFFFFFF, 20]
	If _ColorCheck(_GetPixelColor($aChatInput[0], $aChatInput[1], True), Hex($aChatInput[2], 6), $aChatInput[3]) Then
		Click($aChatInput[0], $aChatInput[1], 1)
		If _Sleep(1000) Then Return
	EndIf
	If $g_iRusLang = 1 Then
	  SetLog("Chat send in russia", $COLOR_BLUE)
	 AutoItWinSetTitle('MyAutoItTitle')
    _WinAPI_SetKeyboardLayout(WinGetHandle(AutoItWinGetTitle()), 0x0419)
		Sleep(500)
		ControlFocus($g_hAndroidWindow, "", "")
		SendKeepActive($g_hAndroidWindow)
		Sleep(500)
	;Opt("SendKeyDelay", 1000)
	AutoItSetOption("SendKeyDelay", 50)
	  _SendExEx($message)
	   SendKeepActive("")
    Else
	  Sleep(500)
 	 SendText($message)
	EndIf
	Return True
EndFunc   ;==>ChatbotChatInput

Func ChatbotChatSendClan() ; click send
	Local $aChatSendClan[4] = [842, 690 + $g_iMidOffsetY, 0xFFFFFF, 20]
	If _ColorCheck(_GetPixelColor($aChatSendClan[0], $aChatSendClan[1], True), Hex($aChatSendClan[2], 6), $aChatSendClan[3]) Then
		Click($aChatSendClan[0], $aChatSendClan[1], 1)
		If _Sleep(2000) Then Return
	EndIf
	Return True
EndFunc   ;==>ChatbotChatSendClan

Func ChatbotChatSendGlobal() ; click send
	Local $aChatSendGlobal[4] = [842, 690 + $g_iMidOffsetY, 0xFFFFFF, 20]
	If _ColorCheck(_GetPixelColor($aChatSendGlobal[0], $aChatSendGlobal[1], True), Hex($aChatSendGlobal[2], 6), $aChatSendGlobal[3]) Then
		Click($aChatSendGlobal[0], $aChatSendGlobal[1], 1)
		If _Sleep(2000) Then Return
	EndIf
	Return True
EndFunc   ;==>ChatbotChatSendGlobal

Func ChatbotStartTimer()
	$ChatbotStartTime = TimerInit()
EndFunc   ;==>ChatbotStartTimer

Func ChatbotIsInterval()
Local $Time_Difference = TimerDiff($ChatbotStartTime)
	If $Time_Difference > $ChatbotReadInterval * 1000 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>ChatbotIsInterval

Func ChatbotIsLastChatNew() ; returns true if the last chat was not by you, false otherwise
	_CaptureRegion()
	For $x = 38 To 261
		If _ColorCheck(_GetPixelColor($x, 129), Hex(0x78BC10, 6), 5) Then Return True ; detect the green menu button
	Next
	Return False
EndFunc   ;==>ChatbotIsLastChatNew

Func ChatbotPushbulletSendChat()
   If Not $g_iChatPushbullet Then Return
   _CaptureRegion(0, 0, 320, 675)
   Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
   Local $Time = @HOUR & "." & @MIN & "." & @SEC

   Local $ChatFile = $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
   $g_sProfileLootsPath = ""
   _GDIPlus_ImageSaveToFile($g_hBitmap, $g_sProfileLootsPath & $ChatFile)
   _GDIPlus_ImageDispose($g_hBitmap)
   ;push the file
   SetLog("Chatbot: Sent chat image", $COLOR_GREEN)
   NotifyPushFileToBoth($ChatFile, "Loots", "image/jpeg", $g_sNotifyOrigin & " | Last Clan Chats" & "\n" & $ChatFile)
   ;wait a second and then delete the file
   _Sleep(500)
   Local $iDelete = FileDelete($g_sProfileLootsPath & $ChatFile)
   If Not ($iDelete) Then SetLog("Chatbot: Failed to delete temp file", $COLOR_RED)
EndFunc

Func ChatbotPushbulletQueueChat($Chat)
   If Not $g_iChatPushbullet Then Return
   _ArrayAdd($ChatbotQueuedChats, $Chat)
EndFunc

Func ChatbotPushbulletQueueChatRead()
   If Not $g_iChatPushbullet Then Return
   $ChatbotReadQueued = True
EndFunc

Func ChatbotPushbulletStopChatRead()
   If Not $g_iChatPushbullet Then Return
   $ChatbotReadInterval = 0
   $ChatbotIsOnInterval = False
EndFunc

Func ChatbotPushbulletIntervalChatRead($Interval)
   If Not $g_iChatPushbullet Then Return
   $ChatbotReadInterval = $Interval
   $ChatbotIsOnInterval = True
   ChatbotStartTimer()
EndFunc

Func ChangeLanguageToEN()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	ClickDrag(775, 180, 775, 440)
	If _Sleep(1000) Then Return
	Click(165, 180, 1) ;English
	If _Sleep(500) Then Return
	SetLog("Chatbot: Switching language EN", $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToEN

Func ChangeLanguageToFRA()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 230, 1) ;Franch
	If _Sleep(500) Then Return
	SetLog("Chatbot: Switching language FRA", $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToFra

Func ChangeLanguageToRU()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(173, 607, 1) ;Russian
	If _Sleep(500) Then Return
	SetLog("Chatbot: Switching language RU", $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToRU

Func ChangeLanguageToDE()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 273, 1) ;DEUTCH
	If _Sleep(500) Then Return
	SetLog("Chatbot: Switching language DE", $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToDE

Func ChangeLanguageToES()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 325, 1) ;Ispanol
	If _Sleep(500) Then Return
	SetLog("Chatbot: Switching language ES", $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToES

Func ChangeLanguageToITA()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 375, 1) ;ITALYA
	If _Sleep(500) Then Return
	SetLog("Chatbot: Switching language ITA", $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToITA

Func ChangeLanguageToNL()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 425, 1) ;NL
	If _Sleep(500) Then Return
	SetLog("Chatbot: Switching language NL", $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToNL

Func ChangeLanguageToNO()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 475, 1) ;NORSK
	If _Sleep(500) Then Return
	SetLog("Chatbot: Switching language NO", $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToNO

Func ChangeLanguageToPR()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 525, 1) ;PORTUGAL
	If _Sleep(500) Then Return
	SetLog("Chatbot: Switching language PR", $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToPR

Func ChangeLanguageToTR()
	Click(820, 585, 1) ;settings
	If _Sleep(500) Then Return
	Click(433, 120, 1) ;settings tab
	If _Sleep(500) Then Return
	Click(210, 420, 1) ;language
	If _Sleep(1000) Then Return
	Click(163, 575, 1) ;TURK
	If _Sleep(500) Then Return
	SetLog("Chatbot: Switching language TR", $COLOR_GREEN)
	Click(513, 426, 1) ;language
	If _Sleep(1000) Then Return
EndFunc   ;==>ChangeLanguageToTR

Func ChatbotMessage() ; run the chatbot
	If $g_iGlobalChat Then
		SetLog("Chatbot: Sending some chats", $COLOR_GREEN)
	ElseIf $g_iClanChat Then
		SetLog("Chatbot: Sending some chats", $COLOR_GREEN)
	EndIf
	If $g_iGlobalChat Then
		If $g_iSwitchLang = 1 Then
		Switch GUICtrlRead($g_hCmbLang)
		        Case "FR"
			ChangeLanguageToFRA()
		        Case "DE"
		    ChangeLanguageToDE()
		        Case "ES"
		    ChangeLanguageToES()
		        Case "IT"
		    ChangeLanguageToITA()
		        Case "NL"
		    ChangeLanguageToNL()
		        Case "NO"
		    ChangeLanguageToNO()
		        Case "PR"
		    ChangeLanguageToPR()
		        Case "TR"
		    ChangeLanguageToTR()
		        Case "RU"
		    ChangeLanguageToRU()
              EndSwitch
			waitMainScreen()
		EndIf
		If Not ChatbotChatOpen() Then Return
		SetLog("Chatbot: Sending chats to global", $COLOR_GREEN)
		; assemble a message
		Global $message[4]
		$message[0] = $GlobalMessages1[Random(0, UBound($GlobalMessages1) - 1, 1)]
		$message[1] = $GlobalMessages2[Random(0, UBound($GlobalMessages2) - 1, 1)]
		$message[2] = $GlobalMessages3[Random(0, UBound($GlobalMessages3) - 1, 1)]
		$message[3] = $GlobalMessages4[Random(0, UBound($GlobalMessages4) - 1, 1)]
		If $g_iGlobalScramble Then
			_ArrayShuffle($message)
		EndIf
		; Send the message
		If Not ChatbotSelectGlobalChat() Then Return
		If Not ChatbotChatGlobalInput() Then Return
		If Not ChatbotChatInput(_ArrayToString($message, " ")) Then Return
		If Not ChatbotChatSendGlobal() Then Return
		If Not ChatbotChatClose() Then Return
		If $g_iSwitchLang = 1 Then
			ChangeLanguageToEN()
			waitMainScreen()
		EndIf
	EndIf

	If $g_iClanChat Then
		If Not ChatbotChatOpen() Then Return
			SetLog("Chatbot: Sending chats to clan", $COLOR_GREEN)
		If Not ChatbotSelectClanChat() Then Return

		Local $SentClanChat = False

		If $ChatbotReadQueued Then
			ChatbotPushbulletSendChat()
			$ChatbotReadQueued = False
			$SentClanChat = True
		ElseIf $ChatbotIsOnInterval Then
			If ChatbotIsInterval() Then
				ChatbotStartTimer()
				ChatbotPushbulletSendChat()
				$SentClanChat = True
			EndIf
		EndIf

		If UBound($ChatbotQueuedChats) > 0 Then
			SetLog("Chatbot: Sending pushbullet chats", $COLOR_GREEN)

			For $a = 0 To UBound($ChatbotQueuedChats) - 1
			Local $ChatToSend = $ChatbotQueuedChats[$a]
				If Not ChatbotChatClanInput() Then Return
				If Not ChatbotChatInput(_Encoding_JavaUnicodeDecode($ChatToSend)) Then Return
				If Not ChatbotChatSendClan() Then Return
			Next

			Dim $Tmp[0] ; clear queue
			$ChatbotQueuedChats = $Tmp

			ChatbotPushbulletSendChat()

			If Not ChatbotChatClose() Then Return
			SetLog("Chatbot: Done", $COLOR_GREEN)
			Return
		EndIf

		If ChatbotIsLastChatNew() Then
			; get text of the latest message
			Local $ChatMsg = StringStripWS(getOcrAndCapture("coc-latinA", 30, 148, 270, 13, False), 7)
			SetLog("Found chat message: " & $ChatMsg, $COLOR_GREEN)
			Local $SentMessage = False

			If $ChatMsg = "" Or $ChatMsg = " " Then
				If $g_iUseGeneric Then
					If Not ChatbotChatClanInput() Then Return
					If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
					If Not ChatbotChatSendClan() Then Return
					$SentMessage = True
				EndIf
			EndIf

			If $g_iUseResponses And Not $SentMessage Then
				For $a = 0 To UBound($ClanResponses) - 1
					If StringInStr($ChatMsg, $ClanResponses[$a][0]) Then
						Local $Response = $ClanResponses[$a][1]
						SetLog("Sending response: " & $Response, $COLOR_GREEN)
						If Not ChatbotChatClanInput() Then Return
						If Not ChatbotChatInput($Response) Then Return
						If Not ChatbotChatSendClan() Then Return
						$SentMessage = True
						ExitLoop
					EndIf
				Next
			EndIf

			If Not $SentMessage Then
				If $g_iUseGeneric Then
					If Not ChatbotChatClanInput() Then Return
					If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
					If Not ChatbotChatSendClan() Then Return
				EndIf
			EndIf

			; send it via pushbullet if it's new
			; putting the code here makes sure the (cleverbot, specifically) response is sent as well :P
			If $g_iChatPushbullet And $g_iPbSendNewChats Then
				If Not $SentClanChat Then ChatbotPushbulletSendChat()
			EndIf
		ElseIf $g_iUseGeneric Then
			If Not ChatbotChatClanInput() Then Return
			If Not ChatbotChatInput($ClanMessages[Random(0, UBound($ClanMessages) - 1, 1)]) Then Return
			If Not ChatbotChatSendClan() Then Return
		EndIf

		If Not ChatbotChatClose() Then Return
	EndIf
	If $g_iGlobalChat Then
		SetLog("Chatbot: Done chatting", $COLOR_GREEN)
	ElseIf $g_iClanChat Then
		SetLog("Chatbot: Done chatting", $COLOR_GREEN)
	EndIf
EndFunc   ;==>ChatbotMessage

Func _Encoding_JavaUnicodeDecode($sString)   ;=> Decode string from Java Unicode format
	Local $iOld_Opt_EVS = Opt('ExpandVarStrings', 0)
	Local $iOld_Opt_EES = Opt('ExpandEnvStrings', 0)

	Local $sOut = "", $aString = StringRegExp($sString, "(\\\\|\\'|\\u[[:xdigit:]]{4}|[[:ascii:]])", 3)

	For $i = 0 To UBound($aString) - 1
		Switch StringLen($aString[$i])
			Case 1
				$sOut &= $aString[$i]
			Case 2
				$sOut &= StringRight($aString[$i], 1)
			Case 6
				$sOut &= ChrW(Dec(StringRight($aString[$i], 4)))
		EndSwitch
	Next

	Opt('ExpandVarStrings', $iOld_Opt_EVS)
	Opt('ExpandEnvStrings', $iOld_Opt_EES)

	Return $sOut
EndFunc ;==>_Encoding_JavaUnicodeDecode
