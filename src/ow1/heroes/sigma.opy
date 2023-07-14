#!mainFile "../../main.opy"

subroutine initSigma

rule "[sigma.opy]: Detect Sigma initialization":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSigma()
    eventPlayer.initialized = true


def initSigma():
    @Name "[sigma.opy]: initSigma()"

    do:
        clearCustomHealth()
        setCustomHealth(OW1_SIGMA_HEALTH, 0, OW1_SIGMA_SHIELDS)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_SIGMA_HEALTH + OW1_SIGMA_SHIELDS)


rule "[sigma.opy]: Change accretion damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventDamage > OW2_SIGMA_ACCRETION_DIRECT_HIT_DAMAGE # Checks for direct hit vs splash damage

    damage(victim, attacker, eventDamage*(OW1_SIGMA_ACCRETION_DAMAGE/OW2_SIGMA_ACCRETION_DAMAGE)-eventDamage)