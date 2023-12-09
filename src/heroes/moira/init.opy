#!mainFile "../../../main.opy"


#!include "heroes/moira/coalescence.opy"
#!include "heroes/moira/self_heal.opy"


rule "[moira/init.opy]: Initialize Moira":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.call_init
    
    defaultHero()
    removeSelfHealing()
    eventPlayer.call_init = false
