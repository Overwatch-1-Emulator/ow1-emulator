#!mainFile "../../dev_main.opy"

subroutine initEcho

#!include "heroes/echo/focusing_beam.opy"
#!include "heroes/echo/duplicate.opy"


def initEcho():
    @Name "[echo/init.opy]: initEcho()"

    setCustomHp(OW1_ECHO_HEALTH, 0, 0)
    setUltCost(OW1_ECHO_ULT_COST)
    removeSelfHealing()


rule "[echo/init.opy]: Initialize Echo":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer._call_init
    @Condition not eventPlayer.isDuplicatingAHero()

    initEcho()
    eventPlayer._call_init = false
