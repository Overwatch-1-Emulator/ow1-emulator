#!mainFile "../../main.opy"

subroutine initBaptiste

def initBaptiste():
    @Name "[baptiste.opy]: initBaptiste()"
    # [TODO]
    pass

rule "[ashe.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initBaptiste()
    eventPlayer.initialized = true