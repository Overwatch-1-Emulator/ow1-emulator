#!mainFile "../../main.opy"


rule "[illari/pylon.opy]: Allow self healing during Pylon":
    @Disabled
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isUsingAbility2()

    pushSelfHealing(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    popSelfHealing(Button.ABILITY_2)
