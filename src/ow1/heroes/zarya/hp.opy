#!mainFile "../../../main.opy"


rule "[zarya/hp.opy]: Initialize Zarya HP":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    wait()
    setCustomHealth(OW1_ZARYA_HEALTH, 0, OW1_ZARYA_SHIELDS)
