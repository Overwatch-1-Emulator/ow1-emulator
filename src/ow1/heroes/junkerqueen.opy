#!mainFile "../../main.opy"

subroutine initJunkerqueen

def initJunkerqueen():
    @Name "[junkerqueen.opy]: initJunkerqueen()"
    # [TODO]
    pass

rule "[junkerqueen.opy]: Initialize Junkerqueen":
    @Event eachPlayer
    @Hero junkerqueen
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initJunkerqueen()
    eventPlayer.initialized = true