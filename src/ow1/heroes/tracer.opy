#!mainFile "../../main.opy"

def initTracer():
    eventPlayer.setDamageDealt(percent(OW1_TRACER_PISTOL_DAMAGE/OW2_TRACER_PISTOL_DAMAGE))


rule "[ashe.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initTracer()