#!mainFile "../../main.opy"

rule "[sigma.opy]: Initialize Sigma":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    wait(1)
    setCustomHealth(OW1_SIGMA_HEALTH, 0, OW1_SIGMA_SHIELDS)
    if eventPlayer.getMaxHealth() != (eventPlayer.hp_health + eventPlayer.hp_armor + eventPlayer.hp_shields):
        clearCustomHealth()
        goto RULE_START

    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))


rule "[sigma.opy]: Change accretion damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage > OW2_SIGMA_ACCRETION_DIRECT_HIT_DAMAGE # Checks for direct hit vs splash damage

    damage(victim, attacker, eventDamage*(OW1_SIGMA_ACCRETION_DAMAGE/OW2_SIGMA_ACCRETION_DAMAGE)-eventDamage)