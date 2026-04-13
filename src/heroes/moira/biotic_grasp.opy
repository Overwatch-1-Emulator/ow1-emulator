#!mainFile "../../main.opy"



rule "[moira/biotic_grasp.opy]: OW1 biotic grasp damage":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.SECONDARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_MOIRA_BIOTIC_GRASP_DAMAGE_VS_ARMOR/OW2_MOIRA_BIOTIC_GRASP_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_MOIRA_BIOTIC_GRASP_DAMAGE/OW2_MOIRA_BIOTIC_GRASP_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)