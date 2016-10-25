; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ Global $txtPresetSaveFilename, $txtSavePresetMessage, $lblLoadPresetMessage,$btnGUIPresetDeleteConf, $chkCheckDeleteConf					; Already declared in file MBR GUI Design Attack - Strategies.au3 - Deleted by DEMEN
;~ Global $cmbPresetList, $txtPresetMessage,$btnGUIPresetLoadConf,  $lblLoadPresetMessage,$btnGUIPresetDeleteConf, $chkCheckDeleteConf

;$hGUI_Profiles = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_BOT)
;GUISwitch($hGUI_Profiles)

Local $x = 25, $y = 45
	$grpProfiles = GUICtrlCreateGroup(GetTranslated(637,1, "Switch Profiles"), $x - 20, $y - 20, 440, 85)	; Resize Profile Group to make room for SwitchAcc Grp - DEMEN
		;$y -= 5
		$x -= 5
		;$lblProfile = GUICtrlCreateLabel(GetTranslated(7,27, "Current Profile") & ":", $x, $y, -1, -1)
		;$y += 15
		$cmbProfile = GUICtrlCreateCombo("", $x - 3, $y + 1, 130, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(637,2, "Use this to switch to a different profile")& @CRLF & GetTranslated(637,3, "Your profiles can be found in") & ": " & @CRLF & $sProfilePath
			_GUICtrlSetTip(-1, $txtTip)
			setupProfileComboBox()
			PopulatePresetComboBox()
			GUICtrlSetState(-1, $GUI_SHOW)
			GUICtrlSetOnEvent(-1, "cmbProfile")
		$txtVillageName = GUICtrlCreateInput(GetTranslated(637,4, "MyVillage"), $x - 3, $y, 130, 22, $ES_AUTOHSCROLL)
			GUICtrlSetLimit (-1, 100, 0)
			GUICtrlSetFont(-1, 9, 400, 1)
			_GUICtrlSetTip(-1, GetTranslated(637,5, "Your village/profile's name"))
			GUICtrlSetState(-1, $GUI_HIDE)
			; GUICtrlSetOnEvent(-1, "txtVillageName") - No longer needed

		$bIconAdd = _GUIImageList_Create(24, 24, 4)
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd_2.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd_2.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd_4.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd.bmp")
		$bIconConfirm = _GUIImageList_Create(24, 24, 4)
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm_2.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm_2.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm_4.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm.bmp")
		$bIconDelete = _GUIImageList_Create(24, 24, 4)
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete_2.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete_2.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete_4.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete.bmp")
		$bIconCancel = _GUIImageList_Create(24, 24, 4)
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel_2.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel_2.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel_4.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel.bmp")
		$bIconEdit = _GUIImageList_Create(24, 24, 4)
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit_2.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit_2.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit_4.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit.bmp")

		$btnAdd = GUICtrlCreateButton("", $x + 135, $y, 24, 24)
			_GUICtrlButton_SetImageList($btnAdd, $bIconAdd, 4)
			GUICtrlSetOnEvent(-1, "btnAddConfirm")
			GUICtrlSetState(-1, $GUI_SHOW)
			_GUICtrlSetTip(-1, GetTranslated(637,6, "Add New Profile"))
		$btnConfirmAdd = GUICtrlCreateButton("", $x + 135, $y, 24, 24)
			_GUICtrlButton_SetImageList($btnConfirmAdd, $bIconConfirm, 4)
			GUICtrlSetOnEvent(-1, "btnAddConfirm")
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, GetTranslated(637,7, "Confirm"))
		$btnConfirmRename = GUICtrlCreateButton("", $x + 135, $y, 24, 24)
			_GUICtrlButton_SetImageList($btnConfirmRename, $bIconConfirm, 4)
			GUICtrlSetOnEvent(-1, "btnRenameConfirm")
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, GetTranslated(637,7, -1))
		$btnDelete = GUICtrlCreateButton("", $x + 164, $y, 24, 24)
			_GUICtrlButton_SetImageList($btnDelete, $bIconDelete, 4)
			GUICtrlSetOnEvent(-1, "btnDeleteCancel")
			GUICtrlSetState(-1, $GUI_SHOW)
			_GUICtrlSetTip(-1, GetTranslated(637,8, "Delete Profile"))
		$btnCancel = GUICtrlCreateButton("", $x + 164, $y, 24, 24)
			_GUICtrlButton_SetImageList($btnCancel, $bIconCancel, 4)
			GUICtrlSetOnEvent(-1, "btnDeleteCancel")
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, GetTranslated(637,9, "Cancel"))
		$btnRename = GUICtrlCreateButton("", $x + 194, $y, 24, 24)
			_GUICtrlButton_SetImageList($btnRename, $bIconEdit, 4)
			GUICtrlSetOnEvent(-1, "btnRenameConfirm")
			_GUICtrlSetTip(-1, GetTranslated(637,10, "Rename Profile"))

; Defining botting type of eachh profile - SwitchAcc - DEMEN
	    $lblProfile = GUICtrlCreateLabel("Profile Type:", $x + 230, $y , -1, -1)
			$txtTip = "Choosing type for this Profile" & @CRLF & "Active Profile for botting" & @CRLF & "Donate Profile for donating only" & @CRLF & "Idle Profile for staying inactive"
			GUICtrlSetTip(-1, $txtTip)

	    $radActiveProfile= GUICtrlCreateRadio("Active", $x + 245 , $y + 18, -1, 16)
			GUICtrlSetTip(-1, "Set as Active Profile for training troops & attacking")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "radProfileType")

		$radDonateProfile = GUICtrlCreateRadio("Donate", $x + 305, $y + 18, -1, 16)
			GUICtrlSetTip(-1, "Set as Donating Profile for training troops & donating only")
			GUICtrlSetOnEvent(-1, "radProfileType")

		$radIdleProfile = GUICtrlCreateRadio("Idle", $x + 375, $y + 18, -1, 16)
			GUICtrlSetTip(-1, "Set as Idle Profile. The Bot will ignore this Profile")
			GUICtrlSetOnEvent(-1, "radProfileType")

	    $lblMatchProfileAcc = GUICtrlCreateLabel("Matching Acc. No.", $x + 230 , $y + 42 , -1, 16)
			$txtTip = "Select the index of CoC Account to match with this Profile"
			GUICtrlSetTip(-1, $txtTip)

		$cmbMatchProfileAcc = GUICtrlCreateCombo("", $x + 330, $y + 38, 60, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "---" & "|" & "Acc. 1" & "|" & "Acc. 2" & "|" & "Acc. 3" & "|" & "Acc. 4" & "|" & "Acc. 5" & "|" & "Acc. 6", "---")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "cmbMatchProfileAcc")


	GUICtrlCreateGroup("", -99, -99, 1, 1)
;GUISetState()

; SwitchAcc - DEMEN
	Local $x = 25, $y = 135
	$grpSwitchAcc = GUICtrlCreateGroup("Switch Account Mode", $x - 20, $y - 20, 220, 160)

		$chkSwitchAcc = GUICtrlCreateCheckbox("Enable Switch Account", $x , $y, -1, -1)
			$txtTip = "Switch to another account & profile when troop training time is >= 3 minutes" & @CRLF & "This function supports maximum 6 CoC accounts & 6 Bot profiles" & @CRLF & "Make sure to create sufficient Profiles equal to number of CoC Accounts, and align the index of accounts order with profiles order"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSwitchAcc")

		$lblTotalAccount = GUICtrlCreateLabel("Total CoC Acc:", $x + 15, $y + 29, -1, -1)
			$txtTip = "Choose number of CoC Accounts pre-logged"
			GUICtrlSetState(-1, $GUI_DISABLE)

		$cmbTotalAccount= GUICtrlCreateCombo("", $x + 100, $y + 25, -1, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Auto detect" & "|" & "1 Account" & "|" & "2 Accounts" & "|" & "3 Accounts" & "|" & "4 Accounts" & "|" & "5 Accounts" & "|" & "6 Accounts", "Auto detect")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$radSmartSwitch= GUICtrlCreateRadio("Smart switch", $x + 15 , $y + 55, -1, 16)
			GUICtrlSetTip(-1, "Switch to account with the shortest remain training time")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$radNormalSwitch = GUICtrlCreateRadio("Normal switch", $x + 100, $y + 55, -1, 16)
			GUICtrlSetTip(-1, "Switching accounts continously")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "radNormalSwitch")

		$y += 80

		$chkUseTrainingClose = GUICtrlCreateCheckbox("Combo Sleep after Switch Account", $x, $y, -1, -1)
			$txtTip = "Close CoC combo with Switch Account when there is more than 3 mins remaining on training time of all accounts."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUseTrainingClose")

		GUIStartGroup()
		$radCloseCoC= GUICtrlCreateRadio("Close CoC", $x + 15 , $y + 30, -1, 16)
			GUICtrlSetState(-1, $GUI_CHECKED)

		$radCloseAndroid = GUICtrlCreateRadio("Close Android", $x + 100, $y + 30, -1, 16)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Profiles & Account matching

    Local $x = 250, $y = 135
	  $grpSwitchAccMapping = GUICtrlCreateGroup("Profiles", $x - 20, $y - 20, 215, 275)

		$btnUpdateProfiles = GUICtrlCreateButton("Update Profiles/ Acc matching", $x, $y - 5 , 170, 25)
		GUICtrlSetOnEvent(-1, "btnUpdateProfile")

		Global $lblProfileList[8]

	  $y += 25
		 For $i = 0 To 7
			$lblProfileList[$i] = GUICtrlCreateLabel("", $x, $y + ($i) * 25, 190, 18, $SS_LEFT)
		 Next

GUICtrlCreateGroup("", -99, -99, 1, 1)