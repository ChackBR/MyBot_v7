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
#include "functions\Config\saveConfig.au3"
#include "functions\Config\readConfig.au3"
#include "functions\Config\applyConfig.au3"

; --------------------------------------------
; Check Collector Outside - AiO++
; --------------------------------------------
#include "functions\AreCollectorsOutside.au3"

; --------------------------------------------
; CheckCC Troops - AiO++
; --------------------------------------------
#include "functions\CheckCC.au3"

; --------------------------------------------
; Check Grand Warden Mode - AiO++
; --------------------------------------------
#include "functions\CheckWardenMode.au3"

; --------------------------------------------
; Simple Quick Train ( with DEB )
; --------------------------------------------
#include "functions\SimpleQuickTrain.au3"

; --------------------------------------------
; Smart Train ( Demen )
; --------------------------------------------
#include "functions\Smart Train\SmartTrain.au3"
#include "functions\Smart Train\CheckQueue.au3"
#include "functions\Smart Train\CheckTrainingTab.au3"
#include "functions\Smart Train\CheckPreciseArmyCamp.au3"
