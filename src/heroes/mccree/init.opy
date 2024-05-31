#!mainFile "../../dev_main.opy"

#!include "heroes/mccree/peacekeeper.opy"
#!include "heroes/mccree/flashbang.opy"
#!include "heroes/mccree/roll.opy"
#!include "heroes/mccree/deadeye.opy"

rule "[mccree/init.opy]: Initialize Cassidy":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.MCCREE
    @Condition eventPlayer._call_init

    setUltCost(OW1_MCCREE_ULT_COST)

    eventPlayer.disallowButton(Button.ABILITY_2)
    removeSelfHealing()

    eventPlayer._call_init = false
