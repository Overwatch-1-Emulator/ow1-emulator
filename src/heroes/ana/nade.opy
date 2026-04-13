#!mainFile "../../main.opy"


rule "[ana/nade.opy]: Heal OW1 healing with biotic grenade":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2

    heal(healee, healer, eventHealing/eventPlayer._base_healing_scalar*(OW1_ANA_BIOTIC_GRENADE_HEALING/OW2_ANA_BIOTIC_GRENADE_HEALING)-eventHealing)

rule "[ana/nade.opy]: Damage OW1 damage with biotic grenade":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2


    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ANA_BIOTIC_GRENADE_DAMAGE_VS_ARMOR/OW2_ANA_BIOTIC_GRENADE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ANA_BIOTIC_GRENADE_DAMAGE/OW2_ANA_BIOTIC_GRENADE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)

