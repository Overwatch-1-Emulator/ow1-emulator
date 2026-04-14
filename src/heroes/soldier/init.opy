#!mainFile "../../main.opy"

#!include "pulse_rifle.opy"
# !include "biotic_field.opy"


def initSoldier():
    @Name "[soldier/init.opy]: initSoldier()"

    setCustomHp(OW1_SOLDIER_HEALTH, 0, 0)
    setUltCost(OW1_SOLDIER_ULT_COST)
    eventPlayer.setHealingDealt(percent(OW1_SOLDIER_BIOTIC_FIELD_HEAL/OW2_SOLDIER_BIOTIC_FIELD_HEAL))
    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)
    #removeSelfHealing()

rule "[soldier/init.opy]: Compensate Damage Reduction":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.SECONDARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)