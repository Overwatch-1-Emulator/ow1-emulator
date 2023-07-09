#!mainFile "../../main.opy"

subroutine initZenyatta

rule "[zenyatta.opy]: Detect Zenyatta initialization":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initZenyatta()
    eventPlayer.initialized = true


def initZenyatta():
    @Name "[zenyatta.opy]: initZenyatta()"
    eventPlayer.setAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setKnockbackDealt(5)
