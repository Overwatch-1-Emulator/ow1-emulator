#!mainFile "../../main.opy"

def initAshe():
    # [TODO]
    pass

rule "[ashe.opy]: Initialize Ashe":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initAshe()
    eventPlayer.initialized = true