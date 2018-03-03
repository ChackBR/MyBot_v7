; #FUNCTION# ====================================================================================================================
; Name ..........: Functions_- AiO++ Team
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
#include "functions\Config\saveConfig.au3"
#include "functions\Config\readConfig.au3"
#include "functions\Config\applyConfig.au3"

; --------------------------------------------
; Four fingers
; --------------------------------------------
#include "functions\Classic 4Fingers.au3"

; --------------------------------------------
; Simple Quick Train ( with DEB )
; --------------------------------------------
#include "functions\SimpleQuickTrain.au3"

; --------------------------------------------
; Check Collector Outside - Persian MOD (#-08)
; --------------------------------------------
#include "functions\AreCollectorsOutside.au3"

; --------------------------------------------
; Smart Train
; --------------------------------------------
#include "functions\Smart Train\SmartTrain.au3"
#include "functions\Smart Train\CheckQueue.au3"
#include "functions\Smart Train\CheckTrainingTab.au3"
#include "functions\Smart Train\CheckPreciseTroop.au3"

; --------------------------------------------
; CheckCC Troops
; --------------------------------------------

#include "functions\CheckCC.au3"
