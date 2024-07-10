#!mainFile "../../dev_main.opy"


rule "[dva/micro_missiles.opy]: Reduce Micro Missiles damage":
    @Event playerDealtDamage
    @Hero dva
    @Condition eventAbility == Button.ABILITY_2

    heal(victim, null, eventDamage - (eventDamage/eventPlayer._base_damage_scalar)*(OW1_DVA_MICRO_MISSILES_DAMAGE/OW2_DVA_MICRO_MISSILES_DAMAGE))
