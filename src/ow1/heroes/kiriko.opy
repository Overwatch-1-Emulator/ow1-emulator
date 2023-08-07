#!mainFile "../../main.opy"

subroutine initKiriko

rule "[kiriko.opy]: Detect Kiriko initialization":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initKiriko()
    eventPlayer.initialized = true


def initKiriko():
    @Name "[kiriko.opy]: initKiriko()"

    removeSelfHealing()
