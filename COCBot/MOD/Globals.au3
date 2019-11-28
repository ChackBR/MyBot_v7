; #FUNCTION# ====================================================================================================================
; Name ..........: Globals.au3
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........: MOD++
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; --------------------------------------------
; Don't retype text when request troops ( just once )
; --------------------------------------------
Global $g_iRequestTroopTypeOnce = 0
Global $g_bRequestTypeOnceEnable = False

; --------------------------------------------
; Builder Base Drop Trophies
; --------------------------------------------
Global $g_bChkBB_DropTrophies = False
Global $g_bChkBB_OnlyWithLoot = False
Global $g_iTxtBB_DropTrophies = 0

; --------------------------------------------
; Request CC Troops at first - MOD++
; --------------------------------------------
Global $g_bReqCCFirst = True
Global $chkReqCCFirst = 1

; --------------------------------------------
; AutoCamp - MOD++
; --------------------------------------------
Global $g_iChkAutoCamp = True

; --------------------------------------------
; Max logout time - MOD++
; --------------------------------------------
Global $g_bTrainLogoutMaxTime = False
Global $g_iTrainLogoutMaxTime = 12

; --------------------------------------------
; BB Suggested Upgrades, Ignore Walls
; --------------------------------------------
Global $g_hChkBBIgnoreWalls = 0
Global $g_bChkBBIgnoreWalls = 0
