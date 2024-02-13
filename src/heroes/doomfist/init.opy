#!mainFile "../../main.opy"

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


rule "[doomfist/init.opy]: Detect switch to Doomfist":
    @Event eachPlayer
    @Hero doomfist

    eventPlayer.call_init = true


rule "[doomfist/init.opy]: Initialize Doomfist":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.call_init == true

    newHero(OW1_DOOMFIST_HEALTH, 0, 0)
    setUltCost(OW1_DOOMFIST_ULT_COST)

    getPlayers(eventPlayer.getTeam()).friendly_doomfist_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_doomfist_player = eventPlayer

    initRocketPunch()
    initSlam()
    eventPlayer.uppercut_shields = 0
    removeTankPassive()

    removeSelfHealing()

    eventPlayer.call_init = false


rule "[doomfist/init.opy]: Clean up Doomfist":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.DOOMFIST

    destroySlamIndicatorGui()
    hideSlamDamageGui()
