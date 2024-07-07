#!mainFile "../../dev_main.opy"

#!include "heroes/symmetra/projector.opy"
#!include "heroes/symmetra/orb.opy"
#!include "heroes/symmetra/teleporter.opy"


def initSymmetra():
    @Name "[symmetra/init.opy]: initSymmetra()"

    setCustomHp(OW1_SYMMETRA_HEALTH, 0, OW1_SYMMETRA_SHIELDS)
    setUltCost(OW1_SYMMETRA_ULT_COST)
    removeSelfHealing()



