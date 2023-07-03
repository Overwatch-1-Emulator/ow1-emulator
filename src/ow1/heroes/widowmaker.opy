#!mainFile "../../main.opy"

def initWidowmaker():

    do:
        clearCustomHealth()
        setCustomHealth(OW1_WIDOWMAKER_HEALTH, 0, 0)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_WIDOWMAKER_HEALTH)

rule "[widowmaker.opy]: Initialize Widowmaker":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initWidowmaker()
    eventPlayer.initialized = true