; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design Profiles
; Description ...: This file creates the "Profiles" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: NguyenAnhHD
; Modified ......: AiO++ Team
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; Profiles
Global $g_hCmbProfile = 0, $g_hTxtVillageName = 0, $g_hBtnAddProfile = 0, $g_hBtnConfirmAddProfile = 0, $g_hBtnConfirmRenameProfile = 0, _
	   $g_hBtnDeleteProfile = 0, $g_hBtnCancelProfileChange = 0, $g_hBtnRenameProfile = 0, $g_hBtnRecycle = 0

; Switch Profiles
Global $g_ahChk_SwitchMax[4], $g_ahChk_SwitchMin[4], $g_ahCmb_SwitchMax[4], $g_ahCmb_SwitchMin[4]
Global $g_ahChk_BotTypeMax[4], $g_ahChk_BotTypeMin[4], $g_ahCmb_BotTypeMax[4], $g_ahCmb_BotTypeMin[4]
Global $g_ahTxt_ConditionMax[4], $g_ahTxt_ConditionMin[4]

Func CreateBotProfiles()
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Group_01", "Switch Profiles"), $x - 20, $y - 20, $g_iSizeWGrpTab2, 65)
		$x -= 5
		$g_hCmbProfile = GUICtrlCreateCombo("", $x - 3, $y + 1, 130, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "CmbProfile_Info_01", "Use this to switch to a different profile")& @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "CmbProfile_Info_02", "Your profiles can be found in") & ": " & @CRLF & $g_sProfilePath)
			setupProfileComboBox()
			PopulatePresetComboBox()
			GUICtrlSetState(-1, $GUI_SHOW)
			GUICtrlSetOnEvent(-1, "cmbProfile")
		$g_hTxtVillageName = GUICtrlCreateInput(GetTranslatedFileIni("MBR Popups", "MyVillage", "MyVillage"), $x - 3, $y, 130, 22, $ES_AUTOHSCROLL)
			GUICtrlSetLimit (-1, 100, 0)
			GUICtrlSetFont(-1, 9, 400, 1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "TxtVillageName_Info_01", "Your village/profile's name"))
			GUICtrlSetState(-1, $GUI_HIDE)

		; Local static to avoid GDI Handle leak
		Static $bIconAdd = 0
		If $bIconAdd = 0 Then
			$bIconAdd = _GUIImageList_Create(24, 24, 4)
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd.bmp")
		EndIf
		Static $bIconConfirm = 0
		If $bIconConfirm = 0 Then
			$bIconConfirm = _GUIImageList_Create(24, 24, 4)
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm.bmp")
		EndIf
		Static $bIconDelete = 0
		If $bIconDelete = 0 Then
			$bIconDelete = _GUIImageList_Create(24, 24, 4)
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete.bmp")
		EndIf
		Static $bIconCancel = 0
		If $bIconCancel = 0 Then
			$bIconCancel = _GUIImageList_Create(24, 24, 4)
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel.bmp")
		EndIf
		Static $bIconEdit = 0
		If $bIconEdit = 0 Then
			$bIconEdit = _GUIImageList_Create(24, 24, 4)
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit.bmp")
		EndIf
		; IceCube (Misc v1.0)
		Static $bIconRecycle = 0
		If $bIconRecycle = 0 Then
			$bIconRecycle = _GUIImageList_Create(24, 24, 4)
			_GUIImageList_AddBitmap($bIconRecycle, @ScriptDir & "\images\Button\iconRecycle.bmp")
		EndIf
		; IceCube (Misc v1.0)

		$g_hBtnAddProfile = GUICtrlCreateButton("", $x + 135, $y, 24, 24)
			_GUICtrlButton_SetImageList($g_hBtnAddProfile, $bIconAdd, 4)
			GUICtrlSetOnEvent(-1, "btnAddConfirm")
			GUICtrlSetState(-1, $GUI_SHOW)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "BtnAddProfile_Info_01", "Add New Profile"))
		$g_hBtnConfirmAddProfile = GUICtrlCreateButton("", $x + 135, $y, 24, 24)
			_GUICtrlButton_SetImageList($g_hBtnConfirmAddProfile, $bIconConfirm, 4)
			GUICtrlSetOnEvent(-1, "btnAddConfirm")
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "BtnConfirmAddProfile_Info_01", "Confirm"))
		$g_hBtnConfirmRenameProfile = GUICtrlCreateButton("", $x + 135, $y, 24, 24)
			_GUICtrlButton_SetImageList($g_hBtnConfirmRenameProfile, $bIconConfirm, 4)
			GUICtrlSetOnEvent(-1, "btnRenameConfirm")
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "BtnConfirmAddProfile_Info_01", -1))
		$g_hBtnDeleteProfile = GUICtrlCreateButton("", $x + 164, $y, 24, 24)
			_GUICtrlButton_SetImageList($g_hBtnDeleteProfile, $bIconDelete, 4)
			GUICtrlSetOnEvent(-1, "btnDeleteCancel")
			GUICtrlSetState(-1, $GUI_SHOW)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "BtnDeleteProfile_Info_01", "Delete Profile"))
		$g_hBtnCancelProfileChange = GUICtrlCreateButton("", $x + 164, $y, 24, 24)
			_GUICtrlButton_SetImageList($g_hBtnCancelProfileChange, $bIconCancel, 4)
			GUICtrlSetOnEvent(-1, "btnDeleteCancel")
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "BtnCancelProfileChange_Info_01", "Cancel"))
		$g_hBtnRenameProfile = GUICtrlCreateButton("", $x + 194, $y, 24, 24)
			_GUICtrlButton_SetImageList($g_hBtnRenameProfile, $bIconEdit, 4)
			GUICtrlSetOnEvent(-1, "btnRenameConfirm")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "BtnRenameProfile_Info_01", "Rename Profile"))

		; IceCube (Misc v1.0)
		$g_hBtnRecycle = GUICtrlCreateButton("", $x + 223, $y, 24, 24)
			_GUICtrlButton_SetImageList($g_hBtnRecycle, $bIconRecycle, 4)
			GUICtrlSetOnEvent(-1, "btnRecycle")
			GUICtrlSetState(-1, $GUI_SHOW)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "BtnRecycle_Info_01", "Recycle Profile by removing all settings no longer suported that could lead to bad behaviour"))
			If GUICtrlRead($g_hCmbProfile) = "<No Profiles>" Then
				GUICtrlSetState(-1, $GUI_DISABLE)
			Else
				GUICtrlSetState(-1, $GUI_ENABLE)
			EndIf
		; IceCube (Misc v1.0)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBotProfiles

; Switch Profile - Demen
Func CreateModSwitchProfile()

	Local $asText[4] = ["Gold", "Elixir", "DarkE", "Trophy"]
	Local $aIcon[4] = [$eIcnGold, $eIcnElixir, $eIcnDark, $eIcnTrophy]
	Local $aiMax[4] = ["6000000", "6000000", "180000", "5000"]
	Local $aiMin[4] = ["1000000", "1000000", "20000", "3000"]


	Local $x = 25, $y = 41
	Local $profileString = _GUICtrlComboBox_GetList($g_hCmbProfile)

	For $i = 0 To 3
		GUICtrlCreateGroup($asText[$i] & " " & GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Group_03", "conditions"), $x - 20, $y - 16 + $i * 80, $g_iSizeWGrpTab3, 75)
			$g_ahChk_SwitchMax[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Switch", "Switch to.."), $x - 10, $y + $i * 80, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchProfile")
			$g_ahCmb_SwitchMax[$i] = GUICtrlCreateCombo("", $x + 60, $y + $i * 80, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $profileString, "<No Profiles>")
			$g_ahChk_SwitchMin[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Switch", -1), $x - 10, $y + 30 + $i * 80, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchProfile")
			$g_ahCmb_SwitchMin[$i] = GUICtrlCreateCombo("", $x + 60, $y + 30 + $i * 80, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $profileString, "<No Profiles>")

			$g_ahChk_BotTypeMax[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "BotType", "Turn.."), $x + 145, $y + $i * 80, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchBotType")
			$g_ahCmb_BotTypeMax[$i] = GUICtrlCreateCombo("", $x + 195, $y + $i * 80, 58, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Off|Donate|Active", "Donate")
			$g_ahChk_BotTypeMin[$i] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "BotType", -1), $x + 145, $y + 30 + $i * 80, -1, -1)
				GUICtrlSetOnEvent(-1, "chkSwitchBotType")
			$g_ahCmb_BotTypeMin[$i] = GUICtrlCreateCombo("", $x + 195, $y + 30 + $i * 80, 58, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Off|Donate|Active", "Active")

			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition", "when") & " " & $asText[$i] & " >", $x + 263, $y + 4 + $i * 80, -1, -1)
			$g_ahTxt_ConditionMax[$i] = GUICtrlCreateInput($aiMax[$i], $x + 340, $y + 2 + $i * 80, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition_Info_01", "Set the amount of") & " " & $asText[$i] &  " " & _
								   GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition_Info_02", "to trigger switching Profile & Bot Type."))
				GUICtrlCreateIcon($g_sLibIconPath, $aIcon[$i], $x + 393, $y + 3 + $i * 80, 16, 16)

			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition", -1) & " " & $asText[$i] & " <", $x + 263, $y + 34 + $i * 80, -1, -1)
			$g_ahTxt_ConditionMin[$i] = GUICtrlCreateInput($aiMin[$i], $x + 340, $y + 32 + $i * 80, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition_Info_01", -1) & " " & $asText[$i] & " " & _
								   GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Condition_Info_02", -1))
				GUICtrlCreateIcon($g_sLibIconPath, $aIcon[$i], $x + 393, $y + 33 + $i * 80, 16, 16)
			GUICtrlSetLimit(-1, 7)

		GUICtrlCreateGroup("", -99, -99, 1, 1)
	Next

EndFunc   ;==>CreateModSwitchProfile
