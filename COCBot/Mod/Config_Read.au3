; #FUNCTION# ====================================================================================================================
; Name ..........: Config_Read.au3
; Description ...: Reads config file and sets variables
; Syntax ........: readConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;
; MOD Config - Save Data
;
Func ReadConfig_MOD()

;
; Mandrid
;

#CS
	; Max logout time
	$TrainLogoutMaxTime = IniRead($config, "TrainLogout", "TrainLogoutMaxTime", "0")
	$TrainLogoutMaxTimeTXT = IniRead($config, "TrainLogout", "TrainLogoutMaxTimeTXT", "20")
#CE

;
; LunaEclipse
;

	; Multi Finger
	IniReadS($iMultiFingerStyle, $g_sProfileConfigPath, "MultiFinger", "Select", 2, "int")

#CS
	; CSV Deployment Speed Mod
	IniReadS($isldSelectedCSVSpeed[$DB], $config, "attack", "CSVSpeedDB", 4)
	IniReadS($isldSelectedCSVSpeed[$LB], $config, "attack", "CSVSpeedAB", 4)
#CE

;
; AwesomeGamer
;

	; Check Collector Outside
	IniReadS($ichkDBMeetCollOutside, $g_sProfileConfigPath, "search", "DBMeetCollOutside", 0, "int")
	IniReadS($iDBMinCollOutsidePercent, $g_sProfileConfigPath, "search", "DBMinCollOutsidePercent", 50, "int")

;
; Rorotiti
;

	; Smart Upgrade
	IniReadS($ichkSmartUpgrade, $g_sProfileConfigPath, "upgrade", "chkSmartUpgrade", 0, "int")
	IniReadS($ichkIgnoreTH, $g_sProfileConfigPath, "upgrade", "chkIgnoreTH", 0, "int")
	IniReadS($ichkIgnoreKing, $g_sProfileConfigPath, "upgrade", "chkIgnoreKing", 0, "int")
	IniReadS($ichkIgnoreQueen, $g_sProfileConfigPath, "upgrade", "chkIgnoreQueen", 0, "int")
	IniReadS($ichkIgnoreWarden, $g_sProfileConfigPath, "upgrade", "chkIgnoreWarden", 0, "int")
	IniReadS($ichkIgnoreCC, $g_sProfileConfigPath, "upgrade", "chkIgnoreCC", 0, "int")
	IniReadS($ichkIgnoreLab, $g_sProfileConfigPath, "upgrade", "chkIgnoreLab", 0, "int")
	IniReadS($ichkIgnoreBarrack, $g_sProfileConfigPath, "upgrade", "chkIgnoreBarrack", 0, "int")
	IniReadS($ichkIgnoreDBarrack, $g_sProfileConfigPath, "upgrade", "chkIgnoreDBarrack", 0, "int")
	IniReadS($ichkIgnoreFactory, $g_sProfileConfigPath, "upgrade", "chkIgnoreFactory", 0, "int")
	IniReadS($ichkIgnoreDFactory, $g_sProfileConfigPath, "upgrade", "chkIgnoreDFactory", 0, "int")
	IniReadS($ichkIgnoreGColl, $g_sProfileConfigPath, "upgrade", "chkIgnoreGColl", 0, "int")
	IniReadS($ichkIgnoreEColl, $g_sProfileConfigPath, "upgrade", "chkIgnoreEColl", 0, "int")
	IniReadS($ichkIgnoreDColl, $g_sProfileConfigPath, "upgrade", "chkIgnoreDColl", 0, "int")
	IniReadS($iSmartMinGold, $g_sProfileConfigPath, "upgrade", "SmartMinGold", 200000, "int")
	IniReadS($iSmartMinElixir, $g_sProfileConfigPath, "upgrade", "SmartMinElixir", 200000, "int")
	IniReadS($iSmartMinDark, $g_sProfileConfigPath, "upgrade", "SmartMinDark", 1500, "int")

EndFunc   ;==>ReadConfig_MOD

Func ReadConfig_SwitchAcc()
	IniReadS($ichkSwitchAcc, $profile, "SwitchAcc", "Enable", 0, "int")
	IniReadS($icmbTotalCoCAcc, $profile, "SwitchAcc", "Total Coc Account", -1, "int")
	IniReadS($ichkSmartSwitch, $profile, "SwitchAcc", "Smart Switch", 0, "int")
	IniReadS($ichkForceSwitch, $profile, "SwitchAcc", "Force Switch", 0, "int")
	IniReadS($iForceSwitch, $profile, "SwitchAcc", "Force Switch Search", 100, "int")
	IniReadS($ichkForceStayDonate, $profile, "SwitchAcc", "Force Stay Donate", 0, "int")
	IniReads($ichkCloseTraining, $profile, "SwitchAcc", "Sleep Combo", 0, "int") ; Sleep Combo, 1 = Close CoC, 2 = Close Android, 0 = No sleep
	For $i = 0 To 7
		IniReadS($aMatchProfileAcc[$i], $profile, "SwitchAcc", "MatchProfileAcc." & $i + 1, "-1")
		IniReadS($aProfileType[$i], $profile, "SwitchAcc", "ProfileType." & $i + 1, "-1")
		IniReadS($aAccPosY[$i], $profile, "SwitchAcc", "AccLocation." & $i + 1, "-1")
	Next
EndFunc	;==>ReadConfig_SwitchAcc
