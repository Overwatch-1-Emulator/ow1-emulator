#!mainFile "../../main.opy"


# This rule doesn't work due to workshop bug
# rule "[kiriko.opy]: Allow self healing during Suzu":
#     @Disabled
#     @Event eachPlayer
#     @Hero kiriko
#     @Condition eventPlayer.isUsingAbility2()

#     pushSelfHealing(Button.ABILITY_2)
#     waitUntil(eventPlayer.isUsingAbility2() == false, Math.INFINITY)
#     popSelfHealing(Button.ABILITY_2)
