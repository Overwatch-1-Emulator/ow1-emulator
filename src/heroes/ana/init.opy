#!mainFile "../../main.opy"

#!include "nade.opy"

def initAna():
    @Name "[ana/init.opy]: initAna()"

    setCustomHp(OW1_ANA_HEALTH, 0, 0)
    setUltCost(OW1_ANA_ULT_COST)


    setBaseDamage(eventPlayer, OW1_ANA_BIOTIC_GRENADE_DAMAGE/OW2_ANA_BIOTIC_GRENADE_DAMAGE)
    setBaseHealing(eventPlayer, OW1_ANA_BIOTIC_RIFLE_HEALING/OW2_ANA_BIOTIC_RIFLE_HEALING)


rule "[ana/init.opy]: OW1 Ana rifle damage":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition victim.getHealthOfType(Health.ARMOR) == 0

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ANA_BIOTIC_RIFLE_DAMAGE/OW2_ANA_BIOTIC_RIFLE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)

rule "[genji/init.opy]: Deal OW1 rifle armor damage":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility in Button.PRIMARY_FIRE
    @Condition victim.getHealthOfType(Health.ARMOR) > 0
    @Condition getTempShields(victim) == 0

    damage(victim, attacker, ow2ArmorRawFor(ow1ArmorApplied(OW1_ANA_BIOTIC_RIFLE_DAMAGE * ow2ArmorRawFor(eventDamage)/(OW2_ANA_BIOTIC_RIFLE_DAMAGE*eventPlayer._base_damage_scalar)) - eventDamage) / eventPlayer._base_damage_scalar)


rule "[ana/init.opy]: Compensate Ana global heal reduction":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE

    heal(healee, healer, eventHealing/eventPlayer._base_healing_scalar-eventHealing)

rule "[ana/init.opy]: Compensate Damage Reduction":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.getHealthOfType(Health.ARMOR) == 0

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)


rule "[ana/init.opy]: Compensate Ana global armor reduction":
    @Event playerDealtDamage
    @Hero pharah
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.getHealthOfType(Health.ARMOR) > 0
    @Condition getTempShields(victim) == 0

    damage(victim, attacker, ow2ArmorRawFor(ow1ArmorApplied(ow2ArmorRawFor(eventDamage)/eventPlayer._base_damage_scalar) - eventDamage)/eventPlayer._base_damage_scalar)
