#!mainFile "../../main.opy"


rule "[kiriko/suzu.opy]: Heal when using Swift Step":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility1()
    
    heal(eventPlayer, eventPlayer, OW1_KIRIKO_SWIFT_STEP_HEALING)
