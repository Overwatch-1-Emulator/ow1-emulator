#!mainFile "../../../main.opy"

#!include "ow1/heroes/brigitte/bash.opy"
#!include "ow1/heroes/brigitte/whipshot.opy"
#!include "ow1/heroes/brigitte/rally.opy"
#!include "ow1/heroes/brigitte/inspire.opy"

rule "[brigitte/init.opy]: Initialize Brigitte":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.call_init == true
    
    resetHero()
    setCustomHealth(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    removeSelfHealing()
    
    eventPlayer.call_init = false
