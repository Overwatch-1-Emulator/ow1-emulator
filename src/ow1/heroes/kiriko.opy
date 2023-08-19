#!mainFile "../../main.opy"

subroutine initKiriko

rule "[kiriko.opy]: Detect Kiriko initialization":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.call_initialize == true # without this flag, the reset code in generic.opy executes after initialization

    initKiriko()
    eventPlayer.call_initialize = false


def initKiriko():
    @Name "[kiriko.opy]: initKiriko()"

    removeSelfHealing()


rule "[kiriko.opy]: Allow self healing during Suzu":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isUsingAbility2() == false, 9999)
    eventPlayer.self_healing_percent = 0
