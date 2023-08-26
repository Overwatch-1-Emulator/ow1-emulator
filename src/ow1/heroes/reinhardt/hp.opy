#!mainFile "../../../main.opy"


rule "[reinhardt/hp.opy]: Initialize Reinhardt hp":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    while (eventPlayer.getMaxHealth() != OW1_REINHARDT_HEALTH + OW1_REINHARDT_ARMOR):
        clearCustomHealth()
        setCustomHealth(OW1_REINHARDT_HEALTH, OW1_REINHARDT_ARMOR, 0)
        wait()