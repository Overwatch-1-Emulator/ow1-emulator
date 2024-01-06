#!mainFile "../../main.opy"


rule "[tracer/init.opy]: Detect switch to Tracer":
    @Event eachPlayer
    @Hero ana

    eventPlayer.call_init = true


rule "[tracer/init.opy]: Initialize Tracer":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.call_init

    defaultHero()
    setUltCost(OW1_TRACER_ULT_COST)
    eventPlayer.call_init = false


rule "[tracer.opy]: Deal OW1 tracer primary fire damage":
    @Event playerDealtDamage
    @Hero tracer
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_TRACER_PULSE_PISTOL_DAMAGE/OW2_TRACER_PULSE_PISTOL_DAMAGE)-eventDamage)
