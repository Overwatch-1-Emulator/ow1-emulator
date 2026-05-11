#!mainFile "../../main.opy"

#!include "trap.opy"


def initJunkrat():
    @Name "[junkrat/init.opy]: initJunkrat()"

    setCustomHp(OW1_JUNKRAT_HEALTH, 0, 0)
    setUltCost(OW1_JUNKRAT_ULT_COST)

    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)
    eventPlayer.setProjectileSpeed(percent(OW1_JUNKRAT_PROJECTILE/OW2_JUNKRAT_PROJECTILE)) # Junkrat's projectile speed was changed in OW2, so we need to adjust it to match OW1 values
    eventPlayer.startScalingSize(MODEL_SIZE_PRE_SEASON_9, true)

rule "[junkrat/init.opy]: Correct Mine, Tire damage":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility in [Button.ABILITY_1, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[junkrat/init.opy]: Primary Fire":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_JUNKRAT_FRAG_DAMAGE/OW2_JUNKRAT_FRAG_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)