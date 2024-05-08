#!mainFile "../../dev_main.opy"

#!include "heroes/moira/biotic_grasp.opy"
#!include "heroes/moira/biotic_orb.opy"
#!include "heroes/moira/coalescence.opy"


rule "[moira/init.opy]: Initialize Moira":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.call_init
    
    setCustomHp(OW1_MOIRA_HEALTH, 0, 0)
    setUltCost(OW1_MOIRA_ULT_COST)
    
    removePassiveHealing()

    eventPlayer.call_init = false
