#!mainFile "../../dev_main.opy"

#!include "heroes/mccree/flashbang.opy"
#!include "heroes/mccree/roll.opy"
#!include "heroes/mccree/deadeye.opy"

def initMccree():
    @Name "[mccree/init.opy]: initMccree()"

    setUltCost(OW1_MCCREE_ULT_COST)

    removeSelfHealing()


rule "[mccree/init.opy]: Initialize Cassidy":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer._call_init

    initMccree()
    eventPlayer._call_init = false
