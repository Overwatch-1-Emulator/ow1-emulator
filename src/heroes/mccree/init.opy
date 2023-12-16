#!mainFile "../../../main.opy"

#!include "heroes/mccree/flashbang.opy"
#!include "heroes/mccree/roll.opy"
#!include "heroes/mccree/deadeye.opy"

rule "[mccree/init.opy]: Initialize Cassidy":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.call_init

    newHero(OW1_MCCREE_HEALTH, 0, 0)
    setUltCost(OW1_MCCREE_ULT_COST)
    
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.call_init = false
