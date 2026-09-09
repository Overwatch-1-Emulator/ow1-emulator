#!mainFile "../../main.opy"


rule "[junkrat/trap.opy]: Reduce steel trap damage and increase root duration.":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility == Button.ABILITY_2

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_JUNKRAT_STEEL_TRAP_DMG/OW2_JUNKRAT_STEEL_TRAP_DMG) - eventDamage)/eventPlayer._base_damage_scalar)
    eventPlayer.ow1_true_damage = eventDamage/eventPlayer._base_damage_scalar*(OW1_JUNKRAT_STEEL_TRAP_DMG/OW2_JUNKRAT_STEEL_TRAP_DMG) - eventDamage
    victim.setStatusEffect(attacker, Status.ROOTED, OW1_JUNKRAT_STEEL_TRAP_DURATION) # Increase root duration
