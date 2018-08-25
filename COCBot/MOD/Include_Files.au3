; #FUNCTION# ====================================================================================================================
; Name ..........: Functions_- AiO++
; Description ...: This file Includes several files in the current script.
; Syntax ........: #include
; Parameters ....: None
; Return values .: None
; Author ........: AiO++ Team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; --------------------------------------------
; CONFIG
; --------------------------------------------
#include "Config\saveConfig.au3"
#include "Config\readConfig.au3"
#include "Config\applyConfig.au3"

; --------------------------------------------
; Simple Quick Train ( with DEB )
; --------------------------------------------
#include "functions\SimpleQuickTrain.au3"

; --------------------------------------------
; Builder Base Drop Trophies
; --------------------------------------------
#include "functions\BB_DropTrophies.au3"
#include "functions\BB_PrepareAttack.au3"

; --------------------------------------------
; AutoCamp - RK MOD
; --------------------------------------------
#include "functions\AutoUpdateCamps.au3"
