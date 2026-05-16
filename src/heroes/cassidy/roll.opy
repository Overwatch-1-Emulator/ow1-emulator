#!mainFile "../../main.opy"


rule "[cassidy/roll.opy]: Remove damage reduction during roll":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setDamageReceived(percent(100/(100-OW2_CASSIDY_COMBAT_ROLL_DAMAGE_REDUCTION)))
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_CASSIDY_ROLL_COOLDOWN)
