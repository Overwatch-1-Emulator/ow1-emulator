#!mainFile "../../main.opy"

rule "[tracer.opy]: Initialize Tracer":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization


rule "[tracer.opy]: Deal OW1 tracer primary fire damage":
    @Event playerDealtDamage
    @Hero tracer
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_TRACER_PULSE_PISTOL_DAMAGE/OW2_TRACER_PULSE_PISTOL_DAMAGE)-eventDamage)
