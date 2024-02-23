#!mainFile "../../main.opy"


# rule "[mei/cryo_freeze.opy]: Allow self healing during Cryo Freeze":
#     @Event eachPlayer
#     @Hero mei
#     @Condition eventPlayer.isUsingAbility1()

#     pushSelfHealing(Button.ABILITY_1)
#     waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
#     popSelfHealing(Button.ABILITY_1)
