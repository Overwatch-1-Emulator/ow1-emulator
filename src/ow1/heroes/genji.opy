#!mainFile "../../main.opy"

def initGenji():
    eventPlayer.setAmmo(0, OW1_GENJI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_GENJI_CLIP_SIZE)

    eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))

rule "[ashe.opy]: Initialize Genji":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initGenji()