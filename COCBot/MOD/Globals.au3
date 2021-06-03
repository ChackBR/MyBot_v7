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
; Builder Base Attack Loop
; --------------------------------------------
Global $g_bAtkBB_Loop________ = True

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
; Don't remove extra troops
; --------------------------------------------
Global $g_DEBDoubleCheck = 0
