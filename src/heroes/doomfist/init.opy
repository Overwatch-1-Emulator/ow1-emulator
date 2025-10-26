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



#rule "[doomfist/init.opy]: Track Doom Health for Best Defense":
#    @Event eachPlayer
#    @Hero doomfist
#    eventPlayer.A = eventPlayer.getHealthOfType(Health.NORMAL)
#    eventPlayer.B = eventPlayer.getHealthOfType(Health.SHIELDS)
#    wait(0.016)
#    loop()


rule "[doomfist/init.opy]: Best Defense":
    @Event playerDealtDamage
    @Hero doomfist 
    @Condition not eventPlayer.isUsingUltimate()
    @Condition eventAbility == Button.SECONDARY_FIRE or eventAbility == Button.ABILITY_2

    eventPlayer.A = victim
    eventPlayer.addHealthPool(Health.NORMAL, 9.4 * eventPlayer.A, false, false)
    wait(getLastCreatedHealthPool())
    removeHealthPool(getLastCreatedHealthPool())


    #OverHealth
    #eventPlayer.D = eventPlayer.B
    #eventPlayer.setHealth(eventPlayer.A + 30)
    #wait(0.016)
    #eventPlayer.addHealthPool(Health.SHIELDS, 30+eventPlayer.D, false, true)
    #eventPlayer.D = eventPlayer.B
    #wait(0.4)
    #wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER)
    #while eventPlayer.getHealthOfType(Health.SHIELDS):
    #    damage(eventPlayer, null, 1)
    #    wait(0.7)
    #    if not eventPlayer.getHealthOfType(Health.SHIELDS):
        

    #else:
    #    eventPlayer.addHealthPool(Health.SHIELDS, 30+eventPlayer.D, false, true)
    #    eventPlayer.D = eventPlayer.B
    #    eventPlayer.E = getTotalTimeElapsed()



