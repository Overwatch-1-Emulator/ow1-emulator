#!mainFile "../../../main.opy"

#!include "heroes/ashe/bob.opy"

rule "[ashe/init.opy]: Initialize Ashe":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.call_init == true
    
    newHero(OW1_ASHE_HEALTH, 0, 0)
    setUltCost(OW1_ASHE_ULT_COST)

    eventPlayer.call_init = false
