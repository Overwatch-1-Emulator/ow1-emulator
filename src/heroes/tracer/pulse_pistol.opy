#!mainFile "../../main.opy"


rule "[tracer/pulse_pistol.opy]: Deal OW1 tracer Pulse Pistol damage":
    @Event playerDealtDamage
    @Hero tracer
    @Condition eventAbility == Button.PRIMARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_TRACER_PULSE_PISTOL_DAMAGE_VS_ARMOR/OW2_TRACER_PULSE_PISTOL_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_TRACER_PULSE_PISTOL_DAMAGE/OW2_TRACER_PULSE_PISTOL_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
