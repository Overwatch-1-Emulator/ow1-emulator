#!mainFile "../../main.opy"

subroutine initTracer

rule "[tracer.opy]: Detect Tracer initialization":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    initTracer()
    eventPlayer.call_init = false


def initTracer():
    @Name "[tracer.opy]: initTracer()"


rule "[tracer.opy]: Deal OW1 tracer primary fire damage":
    @Event playerDealtDamage
    @Hero tracer
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_TRACER_PULSE_PISTOL_DAMAGE/OW2_TRACER_PULSE_PISTOL_DAMAGE)-eventDamage)
