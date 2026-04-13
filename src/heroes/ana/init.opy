#!mainFile "../../main.opy"

#!include "nade.opy"

def initAna():
    @Name "[ana/init.opy]: initAna()"

    setCustomHp(OW1_ANA_HEALTH, 0, 0)
    setUltCost(OW1_ANA_ULT_COST)


    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)
    setBaseHealing(eventPlayer, OW1_ANA_BIOTIC_RIFLE_HEALING/OW2_ANA_BIOTIC_RIFLE_HEALING)


rule "[ana/init.opy]: OW1 Ana rifle damage":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.PRIMARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ANA_BIOTIC_RIFLE_DAMAGE_VS_ARMOR/OW2_ANA_BIOTIC_RIFLE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ANA_BIOTIC_RIFLE_DAMAGE/OW2_ANA_BIOTIC_RIFLE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)


rule "[ana/init.opy]: Compensate Ana global heal reduction":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE

    heal(healee, healer, eventHealing/eventPlayer._base_healing_scalar-eventHealing)
