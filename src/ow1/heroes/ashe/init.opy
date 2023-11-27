#!mainFile "../../../main.opy"

#!include "ow1/heroes/ashe/bob.opy"

rule "[ashe/init.opy]: Initialize Ashe":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.call_init == true
    
    newHero(OW1_ASHE_HEALTH, 0, 0)

    eventPlayer.call_init = false
