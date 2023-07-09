#!mainFile "../../main.opy"

subroutine initEcho

rule "[echo.opy]: Detect Echo initialization":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initEcho()
    eventPlayer.initialized = true


def initEcho():
    @Name "[echo.opy]: initEcho()"
    # [TODO]
    pass
