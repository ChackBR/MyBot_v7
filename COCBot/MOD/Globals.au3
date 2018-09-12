; #FUNCTION# ====================================================================================================================
; Name ..........: Globals - AiO++ Team
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........: AiO++ Team
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
; Request CC Troops at first - AiO++
; --------------------------------------------
Global $g_bReqCCFirst = True
Global $chkReqCCFirst = 1

; --------------------------------------------
; AutoCamp - RK MOD
; --------------------------------------------
Global $g_iChkAutoCamp = True

; --------------------------------------------
; Unit/Wave Factor - AiO++
; --------------------------------------------
Global $g_iChkGiantSlot = 0, $g_iChkUnitFactor = 0, $g_iChkWaveFactor = 0
Global $g_iCmbGiantSlot = 0, $g_iTxtUnitFactor = 10, $g_iTxtWaveFactor = 100
Global $g_iSlotsGiants = 1, $g_aiSlotsGiants = 1
