#!mainFile "../../main.opy"

def initDva():
    # [TODO]
    pass

rule "[dva.opy]: Initialize Dva":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initDva()

rule "[dva.opy]: Set default missile cooldown":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingAbility2()
    
    waitUntil(not eventPlayer.isUsingAbility2(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_DVA_MISSILE_COOLDOWN)