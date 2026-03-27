#!mainFile "../../main.opy"

/*
This DPS doomfist workshop script is heavily based on
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474
*/

# Semi-public scoped variables
playervar is_using_uppercut
playervar is_ultimate_locked

#!include "uppercut.opy"
#!include "slam.opy"
#!include "punch.opy"
#!include "meteor.opy"
#!include "cannon.opy"
#!include "defense.opy"


def initDoomfist():
    @Name "[doomfist/init.opy]: initDoomfist()"

    eventPlayer.setMaxHealth(0) # As long as possible to get lowest amount of best defense
    eventPlayer.addHealthPool(Health.NORMAL, 245, true, true) # Manually apply healthpool
    setUltCost(OW1_DOOMFIST_ULT_COST)
    # removeTankPassive()
    # removeSelfHealing()


    initRocketPunch()
    initSlam()


rule "[doomfist/init.opy]: Clean up Doomfist":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST

    waitUntil(eventPlayer.getCurrentHero() != Hero.DOOMFIST, Math.INFINITY)
    destroySlamIndicatorGui()
    hideSlamDamageGui()
