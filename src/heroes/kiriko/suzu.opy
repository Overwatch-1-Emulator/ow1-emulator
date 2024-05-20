#!mainFile "../../dev_main.opy"


# This rule doesn't work due to workshop bug
# rule "[kiriko.opy]: Allow self healing during Suzu":
#     @Disabled
#     @Event eachPlayer
#     @Condition eventPlayer._hero_setup == Hero.KIRIKO
#     @Condition eventPlayer.isUsingAbility2()

#     pushSelfHealing(Button.ABILITY_2)
#     waitUntil(eventPlayer.isUsingAbility2() == false, Math.INFINITY)
#     popSelfHealing(Button.ABILITY_2)
