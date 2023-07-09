#!mainFile "../../main.opy"

subroutine initSombra

rule "[sombra.opy]: Detect Sombra initialization":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSombra()
    eventPlayer.initialized = true


def initSombra():
    @Name "[sombra.opy]: initSombra()"
    # [TODO]
    pass
