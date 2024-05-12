#!mainFile "../../dev_main.opy"

#!include "heroes/echo/focusing_beam.opy"
#!include "heroes/echo/duplicate.opy"


rule "[echo/init.opy]: Initialize Echo":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.call_init
    @Condition not eventPlayer.isDuplicatingAHero()
    
    eventPlayer.setMaxHealth(percent(OW1_ECHO_HEALTH/eventPlayer.getMaxHealth()))
    setUltCost(OW1_ECHO_ULT_COST)
    removeSelfHealing()

    eventPlayer.call_init = false
