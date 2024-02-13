#!mainFile "../../main.opy"


rule "[pharah/init.opy]: Detect switch to Pharah":
    @Event eachPlayer
    @Hero pharah

    eventPlayer.call_init = true


rule "[pharah/init.opy]: Initialize Pharah":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.call_init

    newHero(OW1_PHARAH_HEALTH, 0, 0)
    setUltCost(OW1_PHARAH_ULT_COST)

    removeSelfHealing()

    eventPlayer.call_init = false
