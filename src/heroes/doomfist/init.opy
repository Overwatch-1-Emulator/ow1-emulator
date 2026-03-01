#!mainFile "../../main.opy"

/*
This DPS doomfist workshop script is heavily based on
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474
*/

globalvar OW1_DOOMFIST_PUNCH_COOLDOWN = createWorkshopSettingFloat('Doomfist', 'Rocket Punch Cooldown', OW1_DOOMFIST_PUNCH_COOLDOWN_DEFAULT, 0, 12)
globalvar OW1_DOOM_PUNCH_IMPACT_DAMAGE_MIN = createWorkshopSettingFloat('Doomfist', 'Rocket Punch Impact Min Damage', 50, 0, 500)
globalvar OW1_DOOM_PUNCH_IMPACT_DAMAGE_MAX = createWorkshopSettingFloat('Doomfist', 'Rocket Punch Impact Max Damage', 100, 0, 1000)
globalvar OW1_DOOM_PUNCH_KNOCKBACK_MIN = createWorkshopSettingFloat('Doomfist', 'Rocket Punch Impact Min Knockback', 15, 0, 150)
globalvar OW1_DOOM_PUNCH_KNOCKBACK_MAX = createWorkshopSettingFloat('Doomfist', 'Rocket Punch Impact Max Knockback', 30, 0, 300)
globalvar OW1_DOOM_PUNCH_WALL_DAMAGE_MIN = createWorkshopSettingFloat('Doomfist', 'Rocket Punch Wall Slam Min Damage', 50, 0, 500)
globalvar OW1_DOOM_PUNCH_WALL_DAMAGE_MAX = createWorkshopSettingFloat('Doomfist', 'Rocket Punch Wall Slam Max Damage', 150, 0, 1500)
globalvar OW1_DOOMFIST_SLAM_DAMAGE_MAX = createWorkshopSettingInt('Doomfist', 'Seismic Slam Max Damage', 125, 0, 10000)
# Slamming on flat ground should deal 49 damage
# Frame by frame analysis of Youtube videos indicate that slam damage increases at a rate of 100 damage/second
globalvar OW1_DOOMFIST_SLAM_DAMAGE_RATE = createWorkshopSettingInt('Doomfist', 'Seismic Slam Damage Rate', 100, 0, 1000)
globalvar OW1_DOOM_SLAM_INDIC_BEAM_COUNT = createWorkshopSettingInt('Doomfist', 'Seismic Slam Indicator GUI Beam Count', 0, 0, 10)
globalvar OW1_DOOMFIST_SLAM_INDIC_PITCH = createWorkshopSettingFloat('Doomfist', 'Seismic Slam Indicator Pitch', 10, -90, 90)
globalvar OW1_DOOMFIST_SLAM_INDIC_RANGE = createWorkshopSettingFloat('Doomfist', 'Seismic Slam Indicator Range', 15, 0, 30)
globalvar OW1_DOOM_SLAM_INDIC_RING_COUNT = createWorkshopSettingInt('Doomfist', 'Seismic Slam Indicator GUI Ring Count', 3, 0, 12)
globalvar OW1_DOOMFIST_UPPERCUT_COOLDOWN = createWorkshopSettingFloat('Doomfist', 'Uppercut Cooldown', OW1_DOOMFIST_UPPERCUT_COOLDOWN_DEFAULT, 0, 12)
globalvar OW1_DOOMFIST_UPPERCUT_DAMAGE = createWorkshopSettingInt('Doomfist', 'Uppercut Damage', 50, 0, 500)
globalvar OW1_DOOMFIST_UPPERCUT_RADIUS = createWorkshopSettingFloat('Doomfist', 'Uppercut Radius', 5, 0, 50)

# Semi-public scoped variables
playervar is_using_uppercut
playervar is_ultimate_locked
playervar decay_timer

#!include "uppercut.opy"
#!include "slam.opy"
#!include "punch.opy"
#!include "meteor.opy"
#!include "cannon.opy"
#!include "bestdefense.opy"


def initDoomfist():
    @Name "[doomfist/init.opy]: initDoomfist()"

    setCustomHp(OW1_DOOMFIST_HEALTH, 0, 0)
    setUltCost(OW1_DOOMFIST_ULT_COST)
    # removeTankPassive()
    #removeSelfHealing()


    initRocketPunch()
    initSlam()
    eventPlayer.uppercut_shields = 0


rule "[doomfist/init.opy]: Clean up Doomfist":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST

    waitUntil(eventPlayer.getCurrentHero() != Hero.DOOMFIST, Math.INFINITY)
    destroySlamIndicatorGui()
    hideSlamDamageGui()
