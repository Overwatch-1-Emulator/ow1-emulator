#!mainFile "../../main.opy"

subroutine initHanzo

rule "[hanzo.opy]: Initialize Hanzo":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initHanzo()
    eventPlayer.initialized = true

def initHanzo():
    @Name "[hanzo.opy]: initHanzo()"
    # [TODO]
    pass
