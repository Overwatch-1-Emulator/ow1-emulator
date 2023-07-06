#!mainFile "../../main.opy"

def initDva():
    do:
        clearCustomHealth()
        setCustomHealth(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_DVA_HEALTH + OW1_DVA_ARMOR)

    waitUntil(not eventPlayer.isInAlternateForm(), 9999)
    eventPlayer.setUltCharge(0)

rule "[dva.opy]: Initialize Dva":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initDva()
    eventPlayer.initialized = true

rule "[dva.opy]: Set default missile cooldown":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingAbility2()
    
    waitUntil(not eventPlayer.isUsingAbility2(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_DVA_MISSILE_COOLDOWN)

rule "[dva.opy]: Make melee cancel DVa boosters":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isMeleeing() == true
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)
