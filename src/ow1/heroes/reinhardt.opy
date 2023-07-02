#!mainFile "../../main.opy"

def initReinhardt():
    # [TODO]
    pass

rule "[reinhardt.opy]: Initialize Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initReinhardt()

rule "[reinhardt.opy]: Set default charge cooldown":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1()
    
    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_REINHARDT_CHARGE_COOLDOWN)

rule "[reinhardt.opy]: Force single firestrike":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility2() == true

    waitUntil(not eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 0)
    wait(ow1_cooldown_ability2_REINHARDT)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
