#!mainFile "../../main.opy"

#!include "grapple.opy"
#!include "adaptive_shield.opy"


def initHammond():
    @Name "[wreckingball/init.opy]: initHammond()"

    setCustomHp(OW1_WRECKING_BALL_HEALTH, OW1_WRECKING_BALL_ARMOR, 0)
    setUltCost(OW1_WRECKING_BALL_ULT_COST)
    # removeTankPassive()
    # removeSelfHealing()

    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)


rule "[wreckingball/init.opy]: Correct primary fire, fireball, piledriver damage":
    @Event playerDealtDamage
    @Hero hammond
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.CROUCH]

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[wreckingball/init.opy]: Deal Correct Minefield Damage":
    @Event playerDealtDamage
    @Hero hammond
    @Condition eventAbility == Button.ULTIMATE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_WRECKING_BALL_MINEFIELD_DAMAGE_VS_ARMOR/OW2_WRECKING_BALL_MINEFIELD_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_WRECKING_BALL_MINEFIELD_DAMAGE/OW2_WRECKING_BALL_MINEFIELD_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)