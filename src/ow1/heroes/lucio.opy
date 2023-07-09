#!mainFile "../../main.opy"

subroutine initLucio

rule "[lucio.opy]: Initialize Lucio":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initLucio()
    eventPlayer.initialized = true


def initLucio():
    @Name "[lucio.opy]: initLucio()"
    # [TODO]
    pass