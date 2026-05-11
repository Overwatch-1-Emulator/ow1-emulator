#!mainFile "../../main.opy"

#!include "pulse_rifle.opy"
#!include "sprint.opy"
# !include "biotic_field.opy"


def initSoldier():
    @Name "[soldier/init.opy]: initSoldier()"

    setCustomHp(OW1_SOLDIER_HEALTH, 0, 0)
    setUltCost(OW1_SOLDIER_ULT_COST)
    eventPlayer.setHealingDealt(percent(OW1_SOLDIER_BIOTIC_FIELD_HEAL/OW2_SOLDIER_BIOTIC_FIELD_HEAL))
    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)
    eventPlayer.startScalingSize(MODEL_SIZE_PRE_SEASON_9, true)
    #removeSelfHealing()

rule "[soldier/init.opy]: Compensate Damage Reduction":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
