#!mainFile "../../dev_main.opy"

#!include "heroes/tracer/pulse_pistol.opy"


def initTracer():
    @Name "[tracer/init.opy]: initTracer()"

    setUltCost(OW1_TRACER_ULT_COST)
    removeSelfHealing()



