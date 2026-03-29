#!mainFile "../../dev_main.opy"

#!include "projector.opy"
#!include "orb.opy"
#!include "teleporter.opy"


def initSymmetra():
    @Name "[symmetra/init.opy]: initSymmetra()"

    setCustomHp(OW1_SYMMETRA_HEALTH, 0, OW1_SYMMETRA_SHIELDS)
    setUltCost(OW1_SYMMETRA_ULT_COST)
    removeSelfHealing()



