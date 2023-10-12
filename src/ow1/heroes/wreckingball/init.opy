#!mainFile "../../../main.opy"

#!include "ow1/heroes/wreckingball/shields.opy"

rule "[wreckingball/init.opy]: Initialize Wrecking Ball":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.call_init

    resetHero()
    setCustomHealth(OW1_WRECKING_BALL_HEALTH, OW1_WRECKING_BALL_ARMOR, 0)
    removeTankPassive()
    eventPlayer.call_init = false
