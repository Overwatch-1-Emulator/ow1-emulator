#!mainFile "../../main.opy"

subroutine initLifeweaver

rule "[lifeweaver.opy]: Initialize Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initLifeweaver()
    eventPlayer.initialized = true


def initLifeweaver():
    @Name "[lifeweaver.opy]: initLifeweaver()"
    # [TODO]
    pass