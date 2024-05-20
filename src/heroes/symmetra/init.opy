#!mainFile "../../dev_main.opy"

#!include "heroes/symmetra/projector.opy"
#!include "heroes/symmetra/orb.opy"
#!include "heroes/symmetra/teleporter.opy"


rule "[symmetra/init.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.SYMMETRA
    @Condition eventPlayer._call_init

    setCustomHp(OW1_SYMMETRA_HEALTH, 0, OW1_SYMMETRA_SHIELDS)
    setUltCost(OW1_SYMMETRA_ULT_COST)
    removeSelfHealing()

    eventPlayer._call_init = false
