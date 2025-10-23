#!mainFile "../../dev_main.opy"

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


rule "[doomfist/init.opy]: Track Doom Health for Best Defense":
    @Event eachPlayer
    @Hero doomfist
    eventPlayer.A = eventPlayer.getHealthOfType(Health.NORMAL)
    wait(0.016)
    loop()


rule "[doomfist/init.opy]: Best Defense":
    @Event playerDealtDamage
    @Hero doomfist 
    @Condition eventAbility == Button.SECONDARY_FIRE
    #@Condition eventAbility == Button.ABILITY_1

    eventPlayer.setHealth(eventPlayer.A)
    wait(0.016)
    #eventPlayer.setHealth(eventPlayer.A)
    eventPlayer.addHealthPool(Health.SHIELDS, 30, false, true)
    #eventPlayer.B = eventPlayer.getLastCreatedHealthPool()
    #if eventPlayer.getLastCreatedHealthPool():

    #eventPlayer.B = eventPlayer.getLastCreatedHealthPool()
    #if .getMaxHealth() > 450
    #    eventPlayer.A = .getMaxHealth(eventPlayer, A)
