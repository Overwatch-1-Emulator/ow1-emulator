#!mainFile "../../main.opy"

rule "[zenyatta.opy]: Initialize Zenyatta":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    eventPlayer.setAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setKnockbackDealt(5)


rule "[zenyatta.opy]: Allow self healing during Transcendence":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isUsingUltimate() == false, Math.INFINITY)
    eventPlayer.self_healing_percent = 0
