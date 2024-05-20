#!mainFile "../../dev_main.opy"


rule "[junkrat/trap.opy]: Reduce steel trap damage and increase root duration.":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.JUNKRAT
    @Condition eventAbility == Button.ABILITY_2

    heal(victim, null, eventDamage - (eventDamage/eventPlayer._base_damage_scalar)*(OW1_JUNKRAT_STEEL_TRAP_DMG/OW2_JUNKRAT_STEEL_TRAP_DMG))
    victim.setStatusEffect(attacker, Status.ROOTED, OW1_JUNKRAT_STEEL_TRAP_DURATION) # Increase root duration
