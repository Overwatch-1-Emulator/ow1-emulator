#!mainFile "../../main.opy"

subroutine initLifeweaver

rule "[lifeweaver.opy]: Detect Lifeweaver initialization":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initLifeweaver()
    eventPlayer.initialized = true


def initLifeweaver():
    @Name "[lifeweaver.opy]: initLifeweaver()"

    removeSelfHealing()


rule "[lifeweaver.opy]: Allow self healing during Tree of Life":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isUsingUltimate() == false, 9999)
    eventPlayer.self_healing_percent = 0
