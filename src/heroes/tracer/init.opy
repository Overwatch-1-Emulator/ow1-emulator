#!mainFile "../../dev_main.opy"

#!include "heroes/tracer/pulse_pistol.opy"


rule "[tracer/init.opy]: Initialize Tracer":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer._call_init

    setUltCost(OW1_TRACER_ULT_COST)
    removeSelfHealing()

    eventPlayer._call_init = false
