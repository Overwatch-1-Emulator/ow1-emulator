#!mainFile "../../main.opy"


#!include "heroes/symmetra/orb.opy"
#!include "heroes/symmetra/teleporter.opy"


rule "[symmetra/init.opy]: Detect switch to Symmetra":
    @Event eachPlayer
    @Hero symmetra

    eventPlayer.call_init = true


rule "[symmetra/init.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.call_init

    newHero(OW1_SYMMETRA_HEALTH, 0, OW1_SYMMETRA_SHIELDS)
    setUltCost(OW1_SYMMETRA_ULT_COST)
    removePassiveHealing()

    eventPlayer.call_init = false
