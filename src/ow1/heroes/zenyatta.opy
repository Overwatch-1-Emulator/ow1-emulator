#!mainFile "../../main.opy"

subroutine initZenyatta

rule "[zenyatta.opy]: Detect Zenyatta initialization":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    initZenyatta()
    eventPlayer.call_init = false


def initZenyatta():
    @Name "[zenyatta.opy]: initZenyatta()"
    eventPlayer.setAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setKnockbackDealt(5)

    removeSelfHealing()


rule "[zenyatta.opy]: Allow self healing during Transcendence":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isUsingUltimate() == false, 9999)
    eventPlayer.self_healing_percent = 0
