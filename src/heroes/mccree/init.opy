#!mainFile "../../dev_main.opy"

#!include "fan_hammer.opy"
#!include "flashbang.opy"
#!include "roll.opy"
#!include "deadeye.opy"

def initMccree():
    @Name "[mccree/init.opy]: initMccree()"

    setCustomHp(OW1_MCCREE_HEALTH, 0, 0)
    setUltCost(OW1_MCCREE_ULT_COST)

    removeSelfHealing()
