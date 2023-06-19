#!include "ow1_constants.opy"

playervar self_bubbble
playervar ally_bubble

rule "set bubble variables":
    @Event eachPlayer
    @Hero zarya

    eventPlayer.self_bubbble = 1
    eventPlayer. ally_bubble = 1

rule "zarya self bubble":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.setAbility1Enabled(false)
    waitUntil(not eventPlayer.isUsingAbility1(), 2)
    wait(ow1_cooldown_ability1_ZARYA)
    eventPlayer.setAbility1Enabled(true)

rule "zarya ally bubble":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.setAbility2Enabled(false)
    waitUntil(not eventPlayer.isUsingAbility2(), 2)
    wait(ow1_cooldown_ability2_ZARYA)
    eventPlayer.setAbility2Enabled(true)