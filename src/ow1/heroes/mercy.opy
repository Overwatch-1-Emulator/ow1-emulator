#!mainFile "../../main.opy"

def initMercy():
    eventPlayer.setAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MERCY_CLIP_SIZE)

rule "[mercy.opy]: Initialize mercy":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initMercy()
    eventPlayer.initialized = true