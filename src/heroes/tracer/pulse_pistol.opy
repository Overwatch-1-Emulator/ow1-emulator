#!mainFile "../../dev_main.opy"


# rule "[tracer/pulse_pistol.opy]: Deal OW1 tracer Pulse Pistol damage":
#     @Event playerDealtDamage
#     @Hero tracer
#     @Condition eventAbility == Button.PRIMARY_FIRE

#     damage(victim, attacker, eventDamage*(OW1_TRACER_PULSE_PISTOL_DAMAGE/OW2_TRACER_PULSE_PISTOL_DAMAGE)-eventDamage)
