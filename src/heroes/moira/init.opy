#!mainFile "../../main.opy"

#!include "biotic_grasp.opy"
#!include "coalescence.opy"


def initMoira():
    @Name "[moira/init.opy]: initMoira()"

    setCustomHp(OW1_MOIRA_HEALTH, 0, 0)
    setUltCost(OW1_MOIRA_ULT_COST)

    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)


rule "[moira/init.opy]: Compensate Moira orb damage reduction":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.ABILITY_2

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)