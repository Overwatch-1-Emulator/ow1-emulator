#!mainFile "../../dev_main.opy"

#!include "heroes/mccree/fan_hammer.opy"
#!include "heroes/mccree/flashbang.opy"
#!include "heroes/mccree/roll.opy"
#!include "heroes/mccree/deadeye.opy"

def initMccree():
    @Name "[mccree/init.opy]: initMccree()"

    setUltCost(OW1_MCCREE_ULT_COST)

    removeSelfHealing()



