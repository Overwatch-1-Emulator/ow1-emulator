#!mainFile "../../main.opy"


rule "[illari.opy]: Initialize Illari":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization


rule "[illari.opy]: Allow self healing during Pylon":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isUsingAbility2()

    pushSelfHealing(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    popSelfHealing(Button.ABILITY_2)