#!mainFile "../../main.opy"

#!include "heroes/moira/biotic_grasp.opy"
#!include "heroes/moira/biotic_orb.opy"
#!include "heroes/moira/coalescence.opy"


rule "[moira/init.opy]: Detect switch to Moira":
    @Event eachPlayer
    @Hero moira

    eventPlayer.call_init = true


rule "[moira/init.opy]: Initialize Moira":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.call_init
    
    defaultHero()
    setUltCost(OW1_MOIRA_ULT_COST)
    removeSelfHealing()
    eventPlayer.call_init = false
