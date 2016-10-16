;
; Attack Variables, constants and enums - Added by LunaEclipse
;

; SmartZap GUI variables - Added by LunaEclipse
Global $ichkSmartZap = 1
Global $ichkSmartZapDB = 1
Global $ichkSmartZapSaveHeroes = 1
Global $itxtMinDE = 300

; SmartZap stats - Added by LunaEclipse
Global $smartZapGain = 0
Global $numLSpellsUsed = 0

; SmartZap Array to hold Total Amount of DE available from Drill at each level (1-6) - Added by LunaEclipse
Global Const $drillLevelHold[6] = [	120, _
												225, _
												405, _
												630, _
												960, _
												1350]

; SmartZap Array to hold Amount of DE available to steal from Drills at each level (1-6) - Added by LunaEclipse
Global Const $drillLevelSteal[6] = [59, _
                                    102, _
												172, _
												251, _
												343, _
												479]

;
; AwesomeGamer
;

; DEB
Global $iChkDontRemove = 1
Global $chkDontRemove = True

; BarrackSpell
Global $iChkBarrackSpell, $chkBarrackSpell

; CSV Mod
Global $attackcsv_use_red_line = 1
Global $TroopDropNumber = 0
Global $remainingTroops[12][2]

; No League Search
Global $chkDBNoLeague, $chkABNoLeague, $iChkNoLeague[$iModeCount]

;
; MikeCoC
;

; CSV Deployment Speed Mod
Global $isldSelectedCSVSpeed[$iModeCount], $iCSVSpeeds[13]
$isldSelectedCSVSpeed[$DB] = 5
$isldSelectedCSVSpeed[$LB] = 5
$iCSVSpeeds[0] = .1
$iCSVSpeeds[1] = .25
$iCSVSpeeds[2] = .5
$iCSVSpeeds[3] = .75
$iCSVSpeeds[4] = 1
$iCSVSpeeds[5] = 1.25
$iCSVSpeeds[6] = 1.5
$iCSVSpeeds[7] = 1.75
$iCSVSpeeds[8] = 2
$iCSVSpeeds[9] = 2.25
$iCSVSpeeds[10] = 2.5
$iCSVSpeeds[11] = 2.75
$iCSVSpeeds[12] = 3

;
; mandryd
;

; Max logout time
Global $TrainLogoutMaxTime, $TrainLogoutMaxTimeTXT