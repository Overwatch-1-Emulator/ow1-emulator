#!mainFile "../../dev_main.opy"

#!include "focusing_beam.opy"
#!include "duplicate.opy"


def initEcho():
    @Name "[echo/init.opy]: initEcho()"

    setCustomHp(OW1_ECHO_HEALTH, 0, 0)
    setUltCost(OW1_ECHO_ULT_COST)
    #removeSelfHealing()
