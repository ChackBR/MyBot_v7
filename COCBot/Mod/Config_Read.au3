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
; MOD Config - Read Data
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
	IniReadS($isldSelectedCSVSpeed[$DB], $g_sProfileConfigPath, "attack", "CSVSpeedDB", 3)
	IniReadS($isldSelectedCSVSpeed[$LB], $g_sProfileConfigPath, "Attack", "CSVSpeedAB", 3)
#CE

;
; AwesomeGamer
;

	; Check Collector Outside
	IniReadS($ichkDBMeetCollOutside, $g_sProfileConfigPath, "search", "DBMeetCollOutside", 0, "int")
	IniReadS($iDBMinCollOutsidePercent, $g_sProfileConfigPath, "search", "DBMinCollOutsidePercent", 50, "int")

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
