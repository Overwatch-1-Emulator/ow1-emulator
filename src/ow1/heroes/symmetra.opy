#!mainFile "../../main.opy"

subroutine initSymmetra

rule "[symmetra.opy]: Detect Symmetra initialization":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSymmetra()
    eventPlayer.initialized = true


def initSymmetra():
    @Name "[symmetra.opy]: initSymmetra()"
    eventPlayer.setAmmo(0, OW1_SYMMETRA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_SYMMETRA_CLIP_SIZE)