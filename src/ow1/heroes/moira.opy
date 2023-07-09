#!mainFile "../../main.opy"

subroutine initMoira

rule "[moira.opy]: Detect Moira initialization":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initMoira()
    eventPlayer.initialized = true


def initMoira():
    @Name "[moira.opy]: initMoira()"
    # [TODO]
    pass


rule "[moira.opy]: Deny fade during coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setAbility1Enabled(false)
    waitUntil(not eventPlayer.isUsingUltimate(), 9999)
    eventPlayer.setAbility1Enabled(true)
