#!mainFile "../../main.opy"

def initSymmetra():
    eventPlayer.setAmmo(0, OW1_SYMMETRA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_SYMMETRA_CLIP_SIZE)

rule "[ashe.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initSymmetra()