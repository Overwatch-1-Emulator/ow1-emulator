#!mainFile "../../dev_main.opy"

def initSigma():
    @Name "[sigma/init.opy]: initSigma()"

    #setCustomHp(OW1_SIGMA_HEALTH, 0, OW1_SIGMA_SHIELDS)
    setUltCost(OW1_SIGMA_ULT_COST)
    # removeTankPassive()
    #removeSelfHealing()

    setBaseDamage(eventPlayer, OW1_SIGMA_ACCRETION_TOTAL_DAMAGE/OW2_SIGMA_ACCRETION_TOTAL_DAMAGE)

rule "[sigma/init.opy]: OW1 accretion damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage/eventPlayer._base_damage_scalar < OW2_SIGMA_ACCRETION_DIRECT_HIT_DAMAGE # accretion is not direct hit

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_SIGMA_ACCRETION_SPLASH_DAMAGE/OW2_SIGMA_ACCRETION_SPLASH_DAMAGE)-eventDamage)/eventPlayer._base_damage_scalar)


rule "[sigma/init.opy]: Compensate Sigma global damage reduction":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility in [Button.PRIMARY_FIRE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

