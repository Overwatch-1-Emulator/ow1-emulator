#!mainFile "../../main.opy"

subroutine initSojourn

def initSojourn():
    @Name "[sojourn.opy]: initSojourn()"
    # [TODO]
    pass


rule "[sojourn.opy]: Detect Sojourn initialization":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.call_initialize == true # without this flag, the reset code in generic.opy executes after initialization

    initSojourn()
    eventPlayer.call_initialize = false
