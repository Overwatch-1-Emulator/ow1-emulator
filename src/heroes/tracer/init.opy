#!mainFile "../../main.opy"

#!include "heroes/tracer/pulse_pistol.opy"


rule "[tracer/init.opy]: Detect switch to Tracer":
    @Event eachPlayer
    @Hero tracer

    eventPlayer.call_init = true


rule "[tracer/init.opy]: Initialize Tracer":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.call_init

    # newHero(OW1_TRACER_HEALTH, 0, 0)
    defaultHero()
    eventPlayer.setMaxHealth(percent(OW1_TRACER_HEALTH/eventPlayer.getMaxHealth()))
    setUltCost(OW1_TRACER_ULT_COST)
    removeSelfHealing()

    eventPlayer.call_init = false
