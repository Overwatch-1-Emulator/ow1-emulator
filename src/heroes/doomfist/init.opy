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
    eventPlayer.B = eventPlayer.getHealthOfType(Health.SHIELDS)
    wait(0.016)
    loop()


rule "[doomfist/init.opy]: Best Defense":
    @Event playerDealtDamage
    @Hero doomfist 
    @Condition eventAbility == Button.SECONDARY_FIRE
    #@Condition eventAbility == Button.ABILITY_1

    #OverHealth
    eventPlayer.D = eventPlayer.B
    eventPlayer.setHealth(eventPlayer.A)
    wait(0.016)
    if eventPlayer.C > eventPlayer.D:
        eventPlayer.addHealthPool(Health.SHIELDS, 30+eventPlayer.C, false, true)
        eventPlayer.C = 0
        eventPlayer.D = eventPlayer.B
    else:
        eventPlayer.addHealthPool(Health.SHIELDS, 30+eventPlayer.D, false, true)
        eventPlayer.D = eventPlayer.B
    eventPlayer.E = true
    wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER)
    while eventPlayer.getHealthOfType(Health.SHIELDS):
        damage(eventPlayer, null, 1)
        wait(0.7)
        if not eventPlayer.getHealthOfType(Health.SHIELDS):
            return
        #wait(0.016)
        #eventPlayer.setHealth(eventPlayer.A)
        #eventPlayer.addHealthPool(Health.SHIELDS, 30+eventPlayer.D, false, true)

        

    

#rule "[doomfist.init.opy]: Best Defense Decay":
#    @Event eachPlayer
#    @Hero doomfist
    #decay
#    while eventPlayer.B > 0:
#        wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER)
#        loop()
#        damage(eventPlayer, null, 2)
#    if eventPlayer.B >= eventPlayer.D:
#        break
        
    #if eventPlayer.D < eventPlayer.B:
    #    break


    #if eventPlayer.D < OW1_DOOMFIST_BEST_DEFENSE_MAX:
    #    damage(eventPlayer, null, )

    
    #if eventPlayer.B > OW1_DOOMFIST_BEST_DEFENSE_MAX:
    #    eventPlayer.B = OW1_DOOMFIST_BEST_DEFENSE_MAX
    

    #eventPlayer.A = eventPlayer.getHealthOfType(Health.SHIELDS)
    #if eventPlayer.getHealthOfType(Health.SHIELDS) < eventPlayer.B:
    #    break
    #wait(1)
    #chaseOverTime(eventPlayer.B, 0, 3, DESTINATION_AND_DURATION)
    #if eventPlayer.getLastCreatedHealthPool():

    #eventPlayer.B = eventPlayer.getLastCreatedHealthPool()
    #if .getMaxHealth() > 450
    #    eventPlayer.A = .getMaxHealth(eventPlayer, A)
