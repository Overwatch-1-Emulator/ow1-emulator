#!mainFile "../../main.opy"

rule "[kiriko/suzu.opy]: Set default Protection Suzu cooldown":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    # @Condition eventPlayer.isUsingAbility2() # For some reason, using suzu doesn't count as using ability 2
    
    # waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_KIRIKO_SUZU_COOLDOWN)


# This rule doesn't work due to workshop bug
rule "[kiriko.opy]: Allow self healing during Suzu":
    @Disabled
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility2()

    pushSelfHealing(Button.ABILITY_2)
    waitUntil(eventPlayer.isUsingAbility2() == false, Math.INFINITY)
    popSelfHealing(Button.ABILITY_2)
