#!mainFile "../../dev_main.opy"


def initVenture():
    @Name "[venture/init.opy]: initVenture()"

    setCustomHp(OW1_VENTURE_HEALTH, 0, 0)
    setUltCost(OW1_VENTURE_ULT_COST)
    removeSelfHealing()

    setBaseDamage(eventPlayer, 0.8)



