#!mainFile "../../main.opy"

#!include "heroes/wreckingball/shields.opy"

rule "[wreckingball/init.opy]: Detect switch to Wrecking Ball":
    @Event eachPlayer
    @Hero hammond

    eventPlayer.call_init = true


rule "[wreckingball/init.opy]: Initialize Wrecking Ball":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.call_init

    newHero(OW1_WRECKING_BALL_HEALTH, OW1_WRECKING_BALL_ARMOR, 0)
    setUltCost(OW1_WRECKING_BALL_ULT_COST)
    removeTankPassive()
    eventPlayer.call_init = false
