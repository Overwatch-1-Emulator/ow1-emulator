#!mainFile "../../main.opy"

def initSigma():
    @Name "[sigma.opy]: initSigma"

    do:
        clearCustomHealth()
        setCustomHealth(OW1_SIGMA_HEALTH, 0, OW1_SIGMA_SHIELDS)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_SIGMA_HEALTH + OW1_SIGMA_SHIELDS)

rule "[sigma.opy]: Initialize Sigma":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSigma()
    eventPlayer.initialized = true

rule "[sigma.opy]: Change accretion damage":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.setDamageDealt(percent(OW1_SIGMA_ROCK_DAMAGE/OW2_SIGMA_ROCK_DAMAGE))
    waitUntil(eventPlayer.isUsingAbility2() == false,9999)
    eventPlayer.setDamageDealt(100)