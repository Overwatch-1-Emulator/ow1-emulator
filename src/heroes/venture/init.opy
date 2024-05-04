#!mainFile "../../dev_main.opy"

#!define OW1_VENTURE_HEALTH 200
#!define OW1_VENTURE_ULT_COST 1925


rule "[venture/init.opy]: Detect switch to Venture":
    @Event eachPlayer
    @Hero venture

    eventPlayer.call_init = true


rule "[venture/init.opy]: Initialize Venture":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.call_init

    newHero(OW1_VENTURE_HEALTH, 0, 0)
    setUltCost(OW1_VENTURE_ULT_COST)
    removeSelfHealing()

    setBaseDamage(eventPlayer, 0.8)

    eventPlayer.call_init = false
