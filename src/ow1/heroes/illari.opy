#!mainFile "../../main.opy"

subroutine initIllari

rule "[illari.opy]: Detect Illari initialization":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    initIllari()
    eventPlayer.call_init = false


def initIllari():
    @Name "[illari.opy]: initIllari()"

    # removeSelfHealing()


rule "[illari.opy]: Allow self healing during Pylon":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isUsingAbility2() == false, 9999)
    eventPlayer.self_healing_percent = 0
