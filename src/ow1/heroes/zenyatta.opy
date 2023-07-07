#!mainFile "../../main.opy"

def initZenyatta():
    eventPlayer.setAmmo(0, OW1_ZEN_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZEN_CLIP_SIZE)
    eventPlayer.setKnockbackDealt(5)

rule "[zenyatta.opy]: Initialize Zenyatta":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initZenyatta()
    eventPlayer.initialized = true