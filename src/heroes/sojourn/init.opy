#!mainFile "../../dev_main.opy"

#!include "railgun.opy"


def initSojourn():
    @Name "[sojourn/init.opy]: initSojourn()"

    setCustomHp(OW1_SOJOURN_HEALTH, 0, 0)
    setUltCost(OW1_SOJOURN_ULT_COST)

    removeSelfHealing()
