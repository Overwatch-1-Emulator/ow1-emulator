#!mainFile "../../main.opy"

subroutine initPharah

rule "[pharah.opy]: Detect Pharah initialization":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.call_initialize == true # without this flag, the reset code in generic.opy executes after initialization

    initPharah()
    eventPlayer.call_initialize = false


def initPharah():
    @Name "[pharah.opy]: initPharah()"
    # [TODO]
    pass