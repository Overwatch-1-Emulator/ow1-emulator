#!mainFile "../../../main.opy"


rule "[brigitte/hp.opy]: Initialize Brigitte Hp":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    setCustomHealth(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
