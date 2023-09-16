#!mainFile "../../../main.opy"


rule "[ashe.opy]: Initialize Ashe":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.call_init == true

    wait()
    setCustomHealth(OW1_ASHE_HEALTH, 0, 0)
