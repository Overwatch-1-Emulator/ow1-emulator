#!mainFile "../../dev_main.opy"

#!include "heroes/dva/hp.opy"
#!include "heroes/dva/gun.opy"
#!include "heroes/dva/booster.opy"
#!include "heroes/dva/bomb.opy"


rule "[dva/init.opy]: Initialize DVa":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.DVA
    @Condition eventPlayer._call_init
    
    setUltCost(OW1_DVA_ULT_COST)
    removeTankPassive()
    removeSelfHealing()

    eventPlayer._call_init = false
