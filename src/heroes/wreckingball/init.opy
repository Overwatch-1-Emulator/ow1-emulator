#!mainFile "../../../main.opy"

#!include "heroes/wreckingball/shields.opy"

rule "[wreckingball/init.opy]: Initialize Wrecking Ball":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.call_init

    newHero(OW1_WRECKING_BALL_HEALTH, OW1_WRECKING_BALL_ARMOR, 0)
    removeTankPassive()
    eventPlayer.call_init = false