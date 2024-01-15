# #!mainFile "../../main.opy"


# rule "[lifeweaver/init.opy]: Allow self healing during Tree of Life":
#     @Event eachPlayer
#     @Hero lifeweaver
#     @Condition eventPlayer.isUsingUltimate()

#     pushSelfHealing(Button.ULTIMATE)
#     waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
#     popSelfHealing(Button.ULTIMATE)
