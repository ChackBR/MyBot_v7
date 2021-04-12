; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot Version
; Description ...: This file contains the initialization and main loop sequences f0r the MBR Bot
; Author ........:  (2014)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; AutoIt version pragmas
#Au3Stripper_Off
#pragma compile(Icon, "Images\MyBot.ico")
#pragma compile(FileDescription, Clash of Clans Bot - A Free Clash of Clans bot - https://mybot.run)
#pragma compile(ProductVersion, 7.9)
#pragma compile(FileVersion, 7.9.1)
#pragma compile(LegalCopyright, © https://mybot.run)
#Au3Stripper_On

Global $g_sBotVersion = "v7.9.1" ;~ Don't add more here, but below. Version can't be longer than vX.y.z because it is also used in Checkversion()

Global $g_sModversion

; "0001" ; MyBot v6.0.0
; "2401" ; MyBot v6.4.0 ( FFC, Multi Finger, SmartZap, ... )
; "2501" ; MyBot v6.5
; "2605" ; MyBot v6.5.2 + Sinc with Samkie MultiFinger
; "2614" ; MyBot v6.5.3 + Doc Octopus v3.5.5 + Collectors Outside
; "2702" ; MyBot v7.0.1 + Add CSV Test Button
; "2812" ; MyBot v7.1.4 + Add: Multi-Finger
; "2901" ; MyBot v7.2.0 + Demen SwitchAcc + MF
; "2903" ; MyBot v7.2.0 + SwitchAcc + MF + Speed Mod + Fix Profile
; "2923" ; MyBot v7.2.2 + SwitchAcc + MF + Fix Speed Mod
; "r01" - MyBot v7.2.5 + SwitchAcc + MF + Speed Mod
; "r01" - MyBot v7.3.5 + S&E MOD
; "r01" ; MyBot v7.4.4 + S&E: FFC + DEB + SartTrain + Fast Click Donate ( while using QuickTrain ) + CCO
; "r01" ; MyBot v7.5.0 + S&E: FFC + DEB + SartTrain + Fast Click Donate ( while using QuickTrain ) + CCO
; "r01" ; MyBot v7.5.4 + S&E: FFC + DEB + SamrtTrain + Fast Click Donate ( while using QuickTrain ) + CCO + ...
; "r01" ; MyBot v7.6.0 Light: FFC + DEB + Fast Click Donate ( while using QuickTrain ) + Bot Fixes
; "r03" ; MyBot v7.6.6 Light: DEB + DRRTxt + BB Play + Use any siege received available + Max LogOut Time
; "r04" ; MyBot v7.7.0 Light: DEB + DRRTxt + BB Play + Use any siege received + Max Logout Time
; "r03" ; MyBot v7.7.9 Light: DEB + DRRTxt + BB Play + Max Logout Time + Temp Fix QT and SwitchAccount
; "r03" ; MyBot v7.8   Light: DEB + DRRTxt + BB Play + Max Logout Time + Temp Fix QT and SwitchAccount
; "r01" ; MyBot v7.8.7 Light: DEB + Max Logout Time + BB Loop
; "r01" ; MyBot v7.8.8 Light: DEB + Max Logout Time + BB Loop
; "r01" ; MyBot v7.8.9 Light: DEB + Max Logout Time + BB Loop
; "r01" ; MyBot v7.9.0 Light: DEB + Max Logout Time + BB Loop

$g_sModversion = "r01" ; MyBot v7.9.1 Light: DEB + Max Logout Time + BB Loop
