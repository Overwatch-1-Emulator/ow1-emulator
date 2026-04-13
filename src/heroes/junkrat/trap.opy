#!mainFile "../../main.opy"


rule "[junkrat/trap.opy]: Reduce steel trap damage and increase root duration.":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility == Button.ABILITY_2

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_JUNKRAT_STEEL_TRAP_DMG_VS_ARMOR/OW2_JUNKRAT_STEEL_TRAP_DMG) - eventDamage)/eventPlayer._base_damage_scalar)
        victim.setStatusEffect(attacker, Status.ROOTED, OW1_JUNKRAT_STEEL_TRAP_DURATION) # Increase root duration
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_JUNKRAT_STEEL_TRAP_DMG/OW2_JUNKRAT_STEEL_TRAP_DMG) - eventDamage)/eventPlayer._base_damage_scalar)
        victim.setStatusEffect(attacker, Status.ROOTED, OW1_JUNKRAT_STEEL_TRAP_DURATION) # Increase root duration
