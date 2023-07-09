#!mainFile "../../main.opy"

subroutine initTorbjorn

rule "[torbjorn.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initTorbjorn()
    eventPlayer.initialized = true


def initTorbjorn():
    @Name "[torbjorn.opy]: initTorbjorn()"
    # [TODO]
    pass