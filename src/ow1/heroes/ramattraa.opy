#!mainFile "../../main.opy"

subroutine initRamattra

rule "[ramattra.opy]: Detect Ramattra initialization":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initRamattra()
    eventPlayer.initialized = true


def initRamattra():
    @Name "[ramattra.opy]: initRamattra()"
    # [TODO]
    pass