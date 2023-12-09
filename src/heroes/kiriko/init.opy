#!mainFile "../../../main.opy"


rule "[kiriko/init.opy]: Initialize Kiriko":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.call_init
    
    defaultHero()
    # removeSelfHealing()
    eventPlayer.call_init = false


rule "[kiriko.opy]: Allow self healing during Suzu":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility2()

    pushSelfHealing(Button.ABILITY_2)
    waitUntil(eventPlayer.isUsingAbility2() == false, Math.INFINITY)
    popSelfHealing(Button.ABILITY_2)