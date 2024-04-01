#!mainFile "../../dev_main.opy"


rule "[lucio/aura.opy]: Allow self healing during heal aura":
    @Event eachPlayer
    @Hero lucio
    @Condition not eventPlayer.isUsingAbility1()

    pushSelfHealing(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), Math.INFINITY)
    popSelfHealing(Button.ABILITY_1)
