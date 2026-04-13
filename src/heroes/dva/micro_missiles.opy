#!mainFile "../../main.opy"


rule "[dva/micro_missiles.opy]: Reduce Micro Missiles damage":
    @Event playerDealtDamage
    @Hero dva
    @Condition eventAbility == Button.ABILITY_2

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_DVA_MICRO_MISSILES_DAMAGE_VS_ARMOR/OW2_DVA_MICRO_MISSILES_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:    
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_DVA_MICRO_MISSILES_DAMAGE/OW2_DVA_MICRO_MISSILES_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)

