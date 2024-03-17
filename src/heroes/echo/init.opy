#!mainFile "../../ow1pp_main.opy"

#!include "heroes/echo/focusing_beam.opy"
#!include "heroes/echo/duplicate.opy"


rule "[echo/init.opy]: Detect switch to Echo":
    @Event eachPlayer
    @Hero echo
    @Condition not eventPlayer.isDuplicatingAHero()

    eventPlayer.call_init = true


rule "[echo/init.opy]: Initialize Echo":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.call_init
    
    # newHero(OW1_ECHO_HEALTH, 0, 0)
    defaultHero()
    eventPlayer.setMaxHealth(percent(OW1_ECHO_HEALTH/eventPlayer.getMaxHealth()))
    setUltCost(OW1_ECHO_ULT_COST)
    removePassiveHealing()

    eventPlayer.call_init = false
