#!mainFile "../../main.opy"

rule "[kiriko.opy]: Initialize Kiriko":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    removeSelfHealing()


rule "[kiriko.opy]: Allow self healing during Suzu":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isUsingAbility2() == false, 9999)
    eventPlayer.self_healing_percent = 0
