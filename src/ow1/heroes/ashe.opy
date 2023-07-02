#!mainFile "../../main.opy"

def initAshe():
    # [TODO]
    pass

rule "[ashe.opy]: Initialize Ashe":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initAshe()