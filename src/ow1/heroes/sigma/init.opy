#!mainFile "../../../main.opy"


rule "[sigma/init.opy]: Initialize Sigma":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.call_init

    resetHero()
    setCustomHealth(OW1_SIGMA_HEALTH, 0, OW1_SIGMA_SHIELDS)
    removeTankPassive()
    eventPlayer.call_init = false


rule "[sigma.opy]: Change accretion damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage > OW2_SIGMA_ACCRETION_DIRECT_HIT_DAMAGE # Checks for direct hit vs splash damage

    damage(victim, attacker, eventDamage*(OW1_SIGMA_ACCRETION_DAMAGE/OW2_SIGMA_ACCRETION_DAMAGE)-eventDamage)
