#!mainFile "../../main.opy"

subroutine initJunkerqueen

rule "[junkerqueen.opy]: Detect Junkerqueen initialization":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initJunkerqueen()
    eventPlayer.initialized = true


def initJunkerqueen():
    @Name "[junkerqueen.opy]: initJunkerqueen()"
    # [TODO]
    pass
