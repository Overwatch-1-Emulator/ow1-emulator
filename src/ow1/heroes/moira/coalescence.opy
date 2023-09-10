#!mainFile "../../../main.opy"


rule "[moira/coalescence.opy]: Prevent fading during coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setAbility1Enabled(false)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setAbility1Enabled(true)
