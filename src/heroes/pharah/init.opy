#!mainFile "../../main.opy"


rule "[pharah/init.opy]: Detect switch to Pharah":
    @Event eachPlayer
    @Hero ana

    eventPlayer.call_init = true


rule "[pharah/init.opy]: Initialize Pharah":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.call_init

    defaultHero()
    setUltCost(OW1_PHARAH_ULT_COST)

    eventPlayer.call_init = false
