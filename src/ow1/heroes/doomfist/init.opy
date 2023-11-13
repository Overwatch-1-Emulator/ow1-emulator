#!mainFile "../../../main.opy"

/*
This DPS doomfist workshop script is heavily based on
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474
*/

# Semi-public scoped variables
playervar is_using_uppercut
playervar is_ultimate_locked

#!include "ow1/heroes/doomfist/uppercut.opy"
#!include "ow1/heroes/doomfist/slam.opy"
#!include "ow1/heroes/doomfist/punch.opy"
#!include "ow1/heroes/doomfist/meteor.opy"
#!include "ow1/heroes/doomfist/cannon.opy"


rule "[doomfist/init.opy]: Initialize Doomfist":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.call_init == true

    resetHero()
    setCustomHealth(OW1_DOOMFIST_HEALTH, 0, 0)

    getPlayers(eventPlayer.getTeam()).friendly_doomfist_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_doomfist_player = eventPlayer

    initRocketPunch()
    initSlam()
    eventPlayer.uppercut_shields = 0
    removeTankPassive()

    eventPlayer.call_init = false


rule "[doomfist/init.opy]: Clean up Doomfist":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.DOOMFIST

    destroySlamIndicatorGui()
    hideSlamDamageGui()
