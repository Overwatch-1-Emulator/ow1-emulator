#!mainFile "../../dev_main.opy"

#!include "heroes/sojourn/railgun.opy"


def initSojourn():
    @Name "[sojourn/init.opy]: initSojourn()"

    setCustomHp(OW1_SOJOURN_HEALTH, 0, 0)
    setUltCost(OW1_SOJOURN_ULT_COST)

    removeSelfHealing()


rule "[sojourn/init.opy]: Initialize Sojourn":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer._call_init

    initSojourn()
    eventPlayer._call_init = false
