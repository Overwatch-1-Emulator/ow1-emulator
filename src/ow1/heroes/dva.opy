#!mainFile "../../main.opy"

subroutine initDva

rule "[dva.opy]: Detect Dva initialization":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initDva()
    eventPlayer.initialized = true


def initDva():
    @Name "[dva.opy]: initDva()"
    do:
        clearCustomHealth()
        setCustomHealth(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_DVA_HEALTH + OW1_DVA_ARMOR)

    waitUntil(not eventPlayer.isInAlternateForm(), 9999)
    eventPlayer.setUltCharge(0)

    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))


rule "[dva.opy]: Set default booster cooldown":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingAbility1()

    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_DVA_BOOSTER_COOLDOWN_TIME)


rule "[dva.opy]: Set default missile cooldown":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingAbility2()
    
    waitUntil(not eventPlayer.isUsingAbility2(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_DVA_MICRO_MISSILES_COOLDOWN_TIME)


rule "[dva.opy]: Decouple melee button from activating melee animation during booster":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.disallowButton(Button.MELEE)
    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.allowButton(Button.MELEE)


rule "[dva.opy]: Cancel booster if melee pressed":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.forceButtonPress(Button.MELEE)
    eventPlayer.disallowButton(Button.MELEE)