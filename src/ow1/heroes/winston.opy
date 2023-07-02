#!mainFile "../../main.opy"

def initWinston():
    eventPlayer.setSecondaryFireEnabled(false)

rule "[winston.opy]: Initialize Winston":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initWinston()

rule "[winston.opy]: Set default leap cooldown":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_WINSTON_LEAP_COOLDOWN)