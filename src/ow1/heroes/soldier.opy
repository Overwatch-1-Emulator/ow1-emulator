#!mainFile "../../main.opy"

subroutine initSoldier

def initSoldier():
    @Name "[soldier.opy]: initSoldier()"
    # [TODO]
    pass

rule "[soldier.opy]: Initialize Soldier 76":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSoldier()
    eventPlayer.initialized = true