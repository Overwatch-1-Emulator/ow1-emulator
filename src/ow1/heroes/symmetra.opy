#!mainFile "../../main.opy"

def initSymmetra():
    eventPlayer.setAmmo(0, OW1_SYMMETRA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_SYMMETRA_CLIP_SIZE)

rule "[symmetra.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSymmetra()
    eventPlayer.initialized = true