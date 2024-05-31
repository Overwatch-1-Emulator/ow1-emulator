#!mainFile "../../dev_main.opy"

#!include "heroes/tracer/pulse_pistol.opy"


rule "[tracer/init.opy]: Initialize Tracer":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.TRACER
    @Condition eventPlayer._call_init

    setUltCost(OW1_TRACER_ULT_COST)
    removeSelfHealing()

    eventPlayer._call_init = false
