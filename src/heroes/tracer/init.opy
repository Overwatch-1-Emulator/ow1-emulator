#!mainFile "../../ow1pp_main.opy"

#!include "heroes/tracer/pulse_pistol.opy"


rule "[tracer/init.opy]: Detect switch to Tracer":
    @Event eachPlayer
    @Hero tracer

    eventPlayer.call_init = true


rule "[tracer/init.opy]: Initialize Tracer":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.call_init

    defaultHero()
    setUltCost(OW1_TRACER_ULT_COST)
    removePassiveHealing()

    eventPlayer.call_init = false
