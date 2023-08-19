#!mainFile "../../main.opy"

subroutine initPharah

rule "[pharah.opy]: Detect Pharah initialization":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initPharah()
    eventPlayer.initialized = true


def initPharah():
    @Name "[pharah.opy]: initPharah()"
    # [TODO]
    pass