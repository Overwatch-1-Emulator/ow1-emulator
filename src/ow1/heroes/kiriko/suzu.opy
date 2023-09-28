#!mainFile "../../../main.opy"

rule "[kiriko/suzu.opy]: Set default Protection Suzu cooldown":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility2()
    
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_KIRIKO_SUZU_COOLDOWN)
