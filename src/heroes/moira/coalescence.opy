#!mainFile "../../main.opy"


rule "[moira/coalescence.opy]: Prevent fading during coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setMoveSpeed(percent(OW1_MOIRA_COALESCENCE_SPEED_BUFF/OW2_MOIRA_COALESCENCE_SPEED_BUFF))
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setAbility1Enabled(true)


# rule "[moira/coalescence.opy]: Allow self healing during Coalescence":
#     @Event eachPlayer
#     @Hero moira
#     @Condition eventPlayer.isUsingUltimate()

#     pushSelfHealing(Button.ULTIMATE)
#     waitUntil(eventPlayer.isUsingUltimate() == false, Math.INFINITY)
#     popSelfHealing(Button.ULTIMATE)
