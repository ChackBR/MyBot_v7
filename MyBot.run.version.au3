; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot Version
; Description ...: This file contains the initialization and main loop sequences f0r the MBR Bot
; Author ........:  (2014)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; AutoIt version pragmas
#Au3Stripper_Off
#pragma compile(Icon, "Images\MyBot.ico")
#pragma compile(FileDescription, Clash of Clans Bot - A Free Clash of Clans bot - https://mybot.run)
#pragma compile(ProductVersion, 7.6)
#pragma compile(FileVersion, 7.6.5)
#pragma compile(LegalCopyright, © https://mybot.run)
#Au3Stripper_On

Global $g_sBotVersion = "v7.6.5" ;~ Don't add more here, but below. Version can't be longer than vX.y.z because it is also use on Checkversion()

Global $g_sModversion

; "0001" ; MyBot v6.0.0
; "1001" ; MyBot v6.1.0
; "2001" ; MyBot v6.2.0
; "2101" ; MyBot v6.2.1
; "2201" ; MyBot v6.2.2
; "2301" ; MyBot v6.3.0
; "2401" ; MyBot v6.4.0 ( FFC, Multi Finger, SmartZap, ... )
; "2501" ; MyBot v6.5
; "2601" ; MyBot v6.5.2
; "2602" ; MyBot v6.5.2 + SmartZap Fix
; "2603" ; MyBot v6.5.2 + SmartZap Fix
; "2604" ; MyBot v6.5.2 + QuickTrain Update
; "2605" ; MyBot v6.5.2 + Sinc with Samkie MultiFinger
; "2611" ; MyBot v6.5.3
; "2614" ; MyBot v6.5.3 + Doc Octopus v3.5.5 + Collectors Outside
; "2701" ; MyBot v7.0.1
; "2702" ; MyBot v7.0.1 + Add CSV Test Button
; "2801" ; MyBot v7.1.3 + Demen SwitchAcc
; "2811" ; MyBot v7.1.4 + Demen SwitchAcc
; "2812" ; MyBot v7.1.4 + Add: Multi-Finger
; "2901" ; MyBot v7.2.0 + Demen SwitchAcc + MF
; "2902" ; MyBot v7.2.0 + SwitchAcc + MF + Speed Mod
; "2903" ; MyBot v7.2.0 + SwitchAcc + MF + Speed Mod + Fix Profile
; "2921" ; MyBot v7.2.1 + SwitchAcc + MF + Speed Mod
; "2923" ; MyBot v7.2.2 + SwitchAcc + MF + Fix Speed Mod
; "r01" - MyBot v7.2.3 + SwitchAcc + MF + Fix Speed Mod
; "r01" - MyBot v7.2.4 + SwitchAcc + MF + Speed Mod
; "r01" - MyBot v7.2.5 + SwitchAcc + MF + Speed Mod
; "r01" - MyBot v7.3.4 + SwitchAcc + FF + HotFix + MOD Coordinates + SmartZap Fix
; "r01" - MyBot v7.3.5 + S&E MOD
; "r01" - MyBot v7.4.1 + S&E MOD 
; "r01" - MyBot v7.4.2 + S&E MOD 
; "r01" ; MyBot v7.4.3 + S&E: FFC + DEB + SartTrain + Fast Click Donate ( while using QuickTrain )
; "r01" ; MyBot v7.4.4 + S&E: FFC + DEB + SartTrain + Fast Click Donate ( while using QuickTrain ) + CCO
; "r01" ; MyBot v7.5.0 + S&E: FFC + DEB + SartTrain + Fast Click Donate ( while using QuickTrain ) + CCO
; "r01" ; MyBot v7.5.1 + S&E: FFC + DEB + SartTrain + Fast Click Donate ( while using QuickTrain ) + CCO
; "r01" ; MyBot v7.5.2 + S&E: FFC + DEB + SamrtTrain + Fast Click Donate ( while using QuickTrain ) + CCO
; "r01" ; MyBot v7.5.3 + S&E: FFC + DEB + SamrtTrain + Fast Click Donate ( while using QuickTrain ) + CCO
; "r01" ; MyBot v7.5.4 + S&E: FFC + DEB + SamrtTrain + Fast Click Donate ( while using QuickTrain ) + CCO + ...
; "r01" ; MyBot v7.6.0 Light: FFC + DEB + Fast Click Donate ( while using QuickTrain ) + Bot Fixes
; "r01" ; MyBot v7.6.1 Light: FFC + DEB + Fast Click Donate ( while using QuickTrain ) + Siege Fix + Don't retype txt + BH Drop Trophy
; "r01" ; MyBot v7.6.2 Light: FFC + DEB + Fast Click Donate ( while using QuickTrain ) + Siege Fix + Don't retype txt + BH Drop Trophy
; "r01" ; MyBot v7.6.3 Light: DEB + DRRTxt + BB Play + Fixes
; "r01" ; MyBot v7.6.4 Light: DEB + DRRTxt + BB Play + Fixes
$g_sModversion = "r02" ; MyBot v7.6.5 Light: DEB + DRRTxt + BB Play + Fixes Request and Donate Siege
