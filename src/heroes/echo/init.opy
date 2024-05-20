#!mainFile "../../dev_main.opy"

#!include "heroes/echo/focusing_beam.opy"
#!include "heroes/echo/duplicate.opy"


rule "[echo/init.opy]: Initialize Echo":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer._call_init
    @Condition not eventPlayer.isDuplicatingAHero()

    setUltCost(OW1_ECHO_ULT_COST)
    removeSelfHealing()

    eventPlayer._call_init = false
