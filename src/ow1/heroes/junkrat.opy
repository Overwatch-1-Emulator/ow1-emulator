#!mainFile "../../main.opy"

subroutine initJunkrat

rule "[junkrat.opy]: Detect Junkrat initialization":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initJunkrat()
    eventPlayer.initialized = true


def initJunkrat():
    @Name "[junkrat.opy]: initJunkrat()"
    # [TODO]
    pass
