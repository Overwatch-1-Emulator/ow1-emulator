#!mainFile "../../dev_main.opy"

#!define OW1_VENTURE_HEALTH 200
#!define OW1_VENTURE_ULT_COST 1925


def initVenture():
    @Name "[venture/init.opy]: initVenture()"

    setCustomHp(OW1_VENTURE_HEALTH, 0, 0)
    setUltCost(OW1_VENTURE_ULT_COST)
    removeSelfHealing()

    setBaseDamage(eventPlayer, 0.8)


rule "[venture/init.opy]: Initialize Venture":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer._call_init

    initVenture()
    eventPlayer._call_init = false
