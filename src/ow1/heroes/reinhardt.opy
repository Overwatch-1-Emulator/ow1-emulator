#!mainFile "../../main.opy"

subroutine initReinhardt

rule "[reinhardt.opy]: Detect Reinhardt initialization":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initReinhardt()
    eventPlayer.initialized = true


def initReinhardt():
    @Name "[reinhardt.opy]: initReinhardt()"
    
    do:
        clearCustomHealth()
        setCustomHealth(OW1_REINHARDT_HEALTH, OW1_REINHARDT_ARMOR, 0)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_REINHARDT_HEALTH + OW1_REINHARDT_ARMOR)


rule "[reinhardt.opy]: Set default charge cooldown":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1()
    
    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_REINHARDT_CHARGE_COOLDOWN_TIME)


rule "[reinhardt.opy]: Force single firestrike":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility2() == true

    waitUntil(not eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 0) # Every time rein uses firestrike, reset the resource to 0
    wait(OW1_REINHARDT_FIRE_STRIKE_COOLDOWN_TIME)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)


rule "[reinhardt.opy]: Charge Damage":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setDamageDealt(percent(OW1_REINHARDT_CHARGE_DAMAGE/OW2_REINHARDT_CHARGE_DAMAGE))
    waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
    wait(0.2)
    eventPlayer.setDamageDealt(100)
