#!mainFile "../../main.opy"

def initWreckingball():
    @Name "[wreckingball.opy]: Initialize Wrecking Ball"

    do:
        clearCustomHealth()
        setCustomHealth(OW1_WRECKING_BALL_HEALTH, OW1_WRECKING_BALL_ARMOR, 0)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_WRECKING_BALL_HEALTH + OW1_WRECKING_BALL_ARMOR)

rule "[wreckingball.opy]: Initialize Wrecking Ball":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.initialized == true # without this flag, the reset code in generic.opy executes after initialization

    initWreckingball()