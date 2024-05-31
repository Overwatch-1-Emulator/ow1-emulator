#!mainFile "../../dev_main.opy"

#!include "heroes/echo/focusing_beam.opy"
#!include "heroes/echo/duplicate.opy"


rule "[echo/init.opy]: Initialize Echo":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.ECHO
    @Condition eventPlayer._call_init

    setCustomHp(OW1_ECHO_HEALTH, 0, 0)
    setUltCost(OW1_ECHO_ULT_COST)
    removeSelfHealing()

    eventPlayer._call_init = false
