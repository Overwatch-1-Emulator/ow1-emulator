#!mainFile "../../main.opy"

subroutine initAshe

rule "[ashe.opy]: Initialize Ashe":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initAshe()
    eventPlayer.initialized = true


def initAshe():
    @Name "[ashe.opy]: initAshe()"
    # [TODO]
    pass