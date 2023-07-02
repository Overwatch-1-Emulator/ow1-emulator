#!mainFile "../../main.opy"

def initBaptiste():
    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)

rule "[ashe.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initBaptiste()