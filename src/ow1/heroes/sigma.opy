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