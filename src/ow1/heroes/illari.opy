#!mainFile "../../main.opy"


rule "[illari.opy]: Initialize Illari":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization


rule "[illari.opy]: Allow self healing during Pylon":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isUsingAbility2() == false, Math.INFINITY)
    eventPlayer.self_healing_percent = 0
