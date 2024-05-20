#!mainFile "../../dev_main.opy"

/*
This DPS doomfist workshop script is heavily based on
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474
*/

# Semi-public scoped variables
playervar is_using_uppercut
playervar is_ultimate_locked

#!include "heroes/doomfist/uppercut.opy"
#!include "heroes/doomfist/slam.opy"
#!include "heroes/doomfist/punch.opy"
#!include "heroes/doomfist/meteor.opy"
#!include "heroes/doomfist/cannon.opy"


rule "[doomfist/init.opy]: Initialize Doomfist":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer._call_init == true

    setCustomHp(OW1_DOOMFIST_HEALTH, 0, 0)
    setUltCost(OW1_DOOMFIST_ULT_COST)
    removeTankPassive()
    removeSelfHealing()

    initRocketPunch()
    initSlam()
    eventPlayer.uppercut_shields = 0

    eventPlayer._call_init = false


rule "[doomfist/init.opy]: Clean up Doomfist":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST

    waitUntil(eventPlayer.getCurrentHero() != Hero.DOOMFIST, Math.INFINITY)
    destroySlamIndicatorGui()
    hideSlamDamageGui()
