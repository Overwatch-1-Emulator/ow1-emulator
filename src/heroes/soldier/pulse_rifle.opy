#!mainFile "../../main.opy"


rule "[soldier/pulse_rifle.opy]: Deal OW1 soldier primary fire damage":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.PRIMARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE_VS_ARMOR/OW2_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE/OW2_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
