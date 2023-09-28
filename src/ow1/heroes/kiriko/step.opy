#!mainFile "../../../main.opy"

rule "[kiriko/suzu.opy]: Set default Swift Step cooldown":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility1()
    
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_KIRIKO_SWIFT_STEP_COOLDOWN)
