#!mainFile "../../main.opy"

def initTracer():
    eventPlayer.setDamageDealt(percent(OW1_TRACER_PISTOL_DAMAGE/OW2_TRACER_PISTOL_DAMAGE))


rule "[tracer.opy]: Initialize Tracer":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initTracer()
    eventPlayer.initialized = true