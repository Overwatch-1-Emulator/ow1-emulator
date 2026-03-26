#!mainFile "../../main.opy"

/*
This DPS doomfist workshop script is heavily based on
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474
*/

# Semi-public scoped variables
playervar is_using_uppercut
playervar is_ultimate_locked
playervar decay_timer
playervar doom_hp

#!include "uppercut.opy"
#!include "slam.opy"
#!include "punch.opy"
#!include "meteor.opy"
#!include "cannon.opy"
#!include "bestdefense.opy"


def initDoomfist():
    @Name "[doomfist/init.opy]: initDoomfist()"

    #setCustomHp(OW1_DOOMFIST_HEALTH, 0, 0)
    eventPlayer.setMaxHealth(0)
    eventPlayer.addHealthPool(Health.NORMAL, 245, true, true)
    setUltCost(OW1_DOOMFIST_ULT_COST)
    # removeTankPassive()
    #removeSelfHealing()


    initRocketPunch()
    initSlam()


rule "[doomfist/init.opy]: Clean up Doomfist":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST

    waitUntil(eventPlayer.getCurrentHero() != Hero.DOOMFIST, Math.INFINITY)
    destroySlamIndicatorGui()
    hideSlamDamageGui()
