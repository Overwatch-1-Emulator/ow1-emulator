#!mainFile "../../../main.opy"


#!include "heroes/moira/coalescence.opy"
#!include "heroes/moira/self_heal.opy"


rule "[moira/init.opy]: Initialize Moira":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.call_init
    
    defaultHero()
    setUltCost(OW1_MOIRA_ULT_COST)
    removeSelfHealing()
    eventPlayer.call_init = false
