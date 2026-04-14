#!mainFile "../../main.opy"


def initSigma():
    @Name "[sigma/init.opy]: initSigma()"

    setUltCost(OW1_SIGMA_ULT_COST)

    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)


rule "[sigma/init.opy]: OW1 accretion damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage/eventPlayer._base_damage_scalar < OW2_SIGMA_ACCRETION_DIRECT_HIT_DAMAGE # accretion is not direct hit

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_SIGMA_ACCRETION_SPLASH_DAMAGE_VS_ARMOR/OW2_SIGMA_ACCRETION_SPLASH_DAMAGE)-eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_SIGMA_ACCRETION_SPLASH_DAMAGE/OW2_SIGMA_ACCRETION_SPLASH_DAMAGE)-eventDamage)/eventPlayer._base_damage_scalar)


rule "[sigma/init.opy]: Compensate Sigma global damage reduction":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.PRIMARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[sigma/init.opy]: Deal OW1 Accretion direct hit damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage/eventPlayer._base_damage_scalar >= OW2_SIGMA_ACCRETION_DIRECT_HIT_DAMAGE # accretion is direct hit

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_SIGMA_ACCRETION_TOTAL_DAMAGE_VS_ARMOR/OW2_SIGMA_ACCRETION_TOTAL_DAMAGE)-eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_SIGMA_ACCRETION_TOTAL_DAMAGE/OW2_SIGMA_ACCRETION_TOTAL_DAMAGE)-eventDamage)/eventPlayer._base_damage_scalar)