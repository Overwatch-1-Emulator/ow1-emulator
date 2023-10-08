#!mainFile "../../../main.opy"


rule "[roadhog/breather.opy]: Remove healing buff after breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility2()

    wait(OW2_ROADHOG_BREATHER_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setHealingReceived(percent(1/(1+OW2_ROADHOG_BREATHER_HEAL_BUFF)))
    wait(OW2_ROADHOG_BREATHER_HEAL_BUFF_DURATION)
    eventPlayer.setHealingReceived(100)
