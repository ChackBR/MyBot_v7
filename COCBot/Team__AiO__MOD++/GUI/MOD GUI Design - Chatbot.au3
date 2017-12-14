; #FUNCTION# ====================================================================================================================
; Name ..........: ChatBot GUI Design
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: NguyenAnhHD
; Modified ......: AiO++ Team
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkGlobalChat = 0, $g_hChkGlobalScramble = 0, $g_hChkSwitchLang = 0, $g_hCmbLang = 0
Global $g_hChkClanChat = 0, $g_hChkRusLang = 0, $g_hChkUseResponses = 0, $g_hChkUseGeneric = 0, $g_hChkChatPushbullet = 0, $g_hChkPbSendNewChats = 0
Global $g_hEditGlobalMessages1 = "", $g_hEditGlobalMessages2 = "", $g_hEditGlobalMessages3 = "", $g_hEditGlobalMessages4 = ""
Global $g_hEditResponses = "", $g_hEditGeneric = ""

Func ChatbotGUI()
	ChatbotReadMessages()
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design - Chatbot", "Group_01", "Global Chat"), $x - 20, $y - 20, 215, $g_iSizeHGrpTab3)
	$y -= 5
		$g_hChkGlobalChat = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Chatbot", "GlobalChat", "Advertise in global"), $x - 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "GlobalChat_Info_01", "Use global chat to send messages"))
			GUICtrlSetState(-1, $g_iGlobalChat)
			GUICtrlSetOnEvent(-1, "ChatbotGUICheckbox")
	$y += 18
		$g_hChkGlobalScramble = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Chatbot", "GlobalScramble", "Scramble global chats"), $x - 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "GlobalScramble_Info_01", "Scramble the message pieces defined in the textboxes below to be in a random order"))
			GUICtrlSetState(-1, $g_iGlobalScramble)
			GUICtrlSetOnEvent(-1, "ChatbotGUICheckbox")
	$y += 18
		$g_hChkSwitchLang = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Chatbot", "SwitchLang", "Switch languages"), $x - 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "SwitchLang_Info_01", "Switch languages after spamming for a new global chatroom"))
			GUICtrlSetState(-1, $g_iSwitchLang)
			GUICtrlSetOnEvent(-1, "ChatbotGUICheckbox")
		$g_hCmbLang = GUICtrlCreateCombo("", $x + 120, $y - 3, 45, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "FR|DE|ES|IT|NL|NO|PR|TR|RU", "RU")

	$y += 25
		$g_hEditGlobalMessages1 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages1, @CRLF), $x - 15, $y, 202, 65)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "GlobalMessages", "Take one item randomly from this list (one per line) and add it to create a message to send to global"))
			GUICtrlSetOnEvent(-1, "ChatbotGUIEditMessages")
	$y += 70
		$g_hEditGlobalMessages2 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages2, @CRLF), $x - 15, $y, 202, 65)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "GlobalMessages", -1))
			GUICtrlSetOnEvent(-1, "ChatbotGUIEditMessages")
	$y += 70
		$g_hEditGlobalMessages3 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages3, @CRLF), $x - 15, $y, 202, 65)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "GlobalMessages", -1))
			GUICtrlSetOnEvent(-1, "ChatbotGUIEditMessages")
	$y += 70
		$g_hEditGlobalMessages4 = GUICtrlCreateEdit(_ArrayToString($GlobalMessages4, @CRLF), $x - 15, $y, 202, 55)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "GlobalMessages", -1))
			GUICtrlSetOnEvent(-1, "ChatbotGUIEditMessages")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 245, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MOD GUI Design - Chatbot", "Group_02", "Clan Chat"), $x - 20, $y - 20, 222, $g_iSizeHGrpTab3)
	$y -= 5
		$g_hChkClanChat = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Chatbot", "ClanChat", "Chat in clan chat"), $x - 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "ClanChat_Info_01", "Use clan chat to send messages"))
			GUICtrlSetState(-1, $g_iClanChat)
			GUICtrlSetOnEvent(-1, "ChatbotGUICheckbox")
		$g_hChkRusLang = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Chatbot", "RusLang", "Russian"), $x + 125, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "RusLang_Info_01", "On. Russian send text. Note: The input language in the Android emulator must be RUSSIAN."))
	$y += 22
		$g_hChkUseResponses = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Chatbot", "UseResponses", "Use custom responses"), $x - 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "UseResponses_Info_01", "Use the keywords and responses defined below"))
			GUICtrlSetState(-1, $g_iUseResponses)
			GUICtrlSetOnEvent(-1, "ChatbotGUICheckbox")
	$y += 22
		$g_hChkUseGeneric = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Chatbot", "UseGeneric", "Use generic chats"), $x - 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "UseGeneric_Info_01", "Use generic chats if reading the latest chat failed or there are no new chats"))
			GUICtrlSetState(-1, $g_iUseGeneric)
			GUICtrlSetOnEvent(-1, "ChatbotGUICheckbox")
	$y += 22
		$g_hChkChatPushbullet = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Chatbot", "ChatPushbullet", "Use remote for chatting"), $x - 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "ChatPushbullet_Info_01", "Send and recieve chats via pushbullet or telegram.") & @CRLF & _
							   GetTranslatedFileIni("MOD GUI Design - Chatbot", "ChatPushbullet_Info_02", "Use BOT <myvillage> GETCHATS <interval|NOW|STOP> to get the latest clan chat as an image,") & @CRLF & _
							   GetTranslatedFileIni("MOD GUI Design - Chatbot", "ChatPushbullet_Info_03", "and BOT <myvillage> SENDCHAT <chat message> to send a chat to your clan"))
			GUICtrlSetState(-1, $g_iChatPushbullet)
			GUICtrlSetOnEvent(-1, "ChatbotGUICheckbox")
	$y += 22
		$g_hChkPbSendNewChats = GUICtrlCreateCheckbox(GetTranslatedFileIni("MOD GUI Design - Chatbot", "PbSendNewChats", "Notify me new clan chat"), $x - 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "PbSendNewChats_Info_01", "Will send an image of your clan chat via pushbullet & telegram when a new chat is detected. Not guaranteed to be 100% accurate."))
			GUICtrlSetState(-1, $g_iPbSendNewChats)
			GUICtrlSetOnEvent(-1, "ChatbotGUICheckbox")

	$y += 25
		$g_hEditResponses = GUICtrlCreateEdit(_ArrayToString($ClanResponses, ":", -1, -1, @CRLF), $x - 15, $y, 206, 80)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "ClanMessages_Info_01", "Look for the specified keywords in clan messages and respond with the responses. One item per line, in the format keyword:response"))
			GUICtrlSetOnEvent(-1, "ChatbotGUIEditMessages")
	$y += 92
		$g_hEditGeneric = GUICtrlCreateEdit(_ArrayToString($ClanMessages, @CRLF), $x - 15, $y, 206, 80)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MOD GUI Design - Chatbot", "ClanMessages_Info_02", "Generic messages to send, one per line"))
			GUICtrlSetOnEvent(-1, "ChatbotGUIEditMessages")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	ChatbotGUICheckboxControl()
EndFunc   ;==>ChatbotGUI
