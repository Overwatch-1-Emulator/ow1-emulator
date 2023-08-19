#!mainFile "../../../main.opy"

rule "[doomfist/hp.opy]: Set Doomfist Hp":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.call_initialize == true

    while (eventPlayer.getMaxHealth() != OW1_DOOMFIST_HEALTH):
        clearCustomHealth()
        setCustomHealth(OW1_DOOMFIST_HEALTH, 0, 0)
        wait(1)
