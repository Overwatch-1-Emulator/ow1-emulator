#!mainFile "../../../main.opy"


rule "[dva/hp.opy]: Correct DVa pilot health":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()

    clearCustomHealth()
    waitUntil(not eventPlayer.isInAlternateForm(), Math.INFINITY)
    wait(1)
    if not eventPlayer.isInAlternateForm():
        setCustomHealth(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)
