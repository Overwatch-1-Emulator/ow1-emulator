#!mainFile "../../../main.opy"

rule "[doomfist/hp.opy]: Initialize Doomfist Hp":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.call_init == true

    setCustomHealth(OW1_DOOMFIST_HEALTH, 0, 0)
