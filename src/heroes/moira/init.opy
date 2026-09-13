#!mainFile "../../main.opy"

#!include "biotic_grasp.opy"
#!include "coalescence.opy"
#!include "biotic_orb.opy"


def initMoira():
    @Name "[moira/init.opy]: initMoira()"

    setCustomHp(OW1_MOIRA_HEALTH, 0, 0)
    setUltCost(OW1_MOIRA_ULT_COST)

    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)
    setBaseHealing(eventPlayer, OW1_MOIRA_BIOTIC_ORB_HEALING/OW2_MOIRA_BIOTIC_ORB_HEALING)



rule "[moira/init.opy]: Compensate Global Damage Reduction":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility in [Button.SECONDARY_FIRE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[ana/init.opy]: Compensate Moira global heal reduction":
    @Event playerDealtHealing
    @Hero moira
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(healee, healer, eventHealing/eventPlayer._base_healing_scalar-eventHealing)