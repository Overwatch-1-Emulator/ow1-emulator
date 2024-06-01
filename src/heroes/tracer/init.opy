#!mainFile "../../dev_main.opy"

#!include "heroes/tracer/pulse_pistol.opy"


def initTracer():
    @Name "[tracer/init.opy]: initTracer()"

    setUltCost(OW1_TRACER_ULT_COST)
    removeSelfHealing()


rule "[tracer/init.opy]: Initialize Tracer":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer._call_init

    initTracer()
    eventPlayer._call_init = false
