#!mainFile "../../dev_main.opy"


rule "[sigma/init.opy]: Initialize Sigma":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.SIGMA
    @Condition eventPlayer._call_init

    setCustomHp(OW1_SIGMA_HEALTH, 0, OW1_SIGMA_SHIELDS)
    setUltCost(OW1_SIGMA_ULT_COST)
    removeTankPassive()
    removeSelfHealing()

    eventPlayer._call_init = false


rule "[sigma/init.opy]: Change accretion damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage > OW2_SIGMA_ACCRETION_DIRECT_HIT_DAMAGE # Checks for direct hit vs splash damage

    damage(victim, attacker, eventDamage*(OW1_SIGMA_ACCRETION_DAMAGE/OW2_SIGMA_ACCRETION_DAMAGE)-eventDamage)
