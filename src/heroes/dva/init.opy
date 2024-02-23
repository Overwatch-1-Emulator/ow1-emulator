#!mainFile "../../main.opy"

#!include "heroes/dva/hp.opy"
#!include "heroes/dva/gun.opy"
#!include "heroes/dva/booster.opy"
#!include "heroes/dva/bomb.opy"


rule "[hero_switch.opy]: Detect switch to Dva":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer._hero_switched
    # Apparently Pilot DVa and Mech DVA are 2 seperate heroes but workshop considers them both dva
    # Above condition is needed because otherwise, this rule activates every time dva transitions 
    # from pilot to mech and vice versa

    eventPlayer.call_init = true


rule "[dva/init.opy]: Initialize DVa":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.call_init
    
    defaultHero()
    setUltCost(OW1_DVA_ULT_COST)
    removeTankPassive()

    setCustomHp(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)

    removePassiveHealing()

    eventPlayer.call_init = false
