#!mainFile "../../../main.opy"


rule "[brigitte/hp.opy]: Initialize Brigitte Hp":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    while (eventPlayer.getMaxHealth() != OW1_BRIGITTE_HEALTH + OW1_BRIGITTE_ARMOR):
        clearCustomHealth()
        setCustomHealth(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
        wait()
