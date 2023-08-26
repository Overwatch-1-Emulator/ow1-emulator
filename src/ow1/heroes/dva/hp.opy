#!mainFile "../../../main.opy"


rule "[dva/hp.opy]: Correct DVa mech health":
    @Event eachPlayer
    @Hero dva
    @Condition not eventPlayer.isInAlternateForm()

    while (eventPlayer.getMaxHealth() != OW1_DVA_HEALTH + OW1_DVA_ARMOR):
        clearCustomHealth()
        setCustomHealth(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)
        wait()