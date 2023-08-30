#!mainFile "../../../main.opy"


rule "[dva/hp.opy]: Correct DVa mech health":
    @Event eachPlayer
    @Hero dva
    @Condition not eventPlayer.isInAlternateForm()

    wait()
    setCustomHealth(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)


rule "[dva/hp.opy]: Correct DVa pilot health":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()

    clearCustomHealth()
