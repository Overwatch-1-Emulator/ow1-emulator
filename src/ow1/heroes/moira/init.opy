#!mainFile "../../../main.opy"


#!include "ow1/heroes/moira/coalescence.opy"
#!include "ow1/heroes/moira/self_heal.opy"


rule "[moira/init.opy]: Initialize Moira":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.call_init
    
    resetHero()
    removeSelfHealing()
    eventPlayer.call_init = false
