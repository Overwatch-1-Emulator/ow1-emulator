#!mainFile "../../main.opy"

#!include "trap.opy"


def initJunkrat():
    @Name "[junkrat/init.opy]: initJunkrat()"

    setCustomHp(OW1_JUNKRAT_HEALTH, 0, 0)
    setUltCost(OW1_JUNKRAT_ULT_COST)

    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)
    eventPlayer.setProjectileSpeed(percent(OW1_JUNKRAT_PROJECTILE/OW2_JUNKRAT_PROJECTILE)) # Junkrat's projectile speed was changed in OW2, so we need to adjust it to match OW1 values


rule "[junkrat/init.opy]: Correct Mine, Tire damage":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility in [Button.ABILITY_1, Button.ULTIMATE]

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[junkrat/init.opy]: Primary Fire":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility == Button.PRIMARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_JUNKRAT_FRAG_DAMAGE_VS_ARMOR/OW2_JUNKRAT_FRAG_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_JUNKRAT_FRAG_DAMAGE/OW2_JUNKRAT_FRAG_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)