#!mainFile "../../main.opy"

subroutine initWinston

def initWinston():
    @Name "[winston.opy]: initWinston()"

    do:
        clearCustomHealth()
        setCustomHealth(OW1_WINSTON_HEALTH, OW1_WINSTON_ARMOR, 0)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_WINSTON_HEALTH + OW1_WINSTON_ARMOR)

    eventPlayer.setSecondaryFireEnabled(false)

rule "[winston.opy]: Initialize Winston":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initWinston()
    eventPlayer.initialized = true

rule "[winston.opy]: Set default leap cooldown":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingAbility1()
    @Condition not eventPlayer.isUsingUltimate()
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_WINSTON_JUMP_PACK_COOLDOWN_TIME)