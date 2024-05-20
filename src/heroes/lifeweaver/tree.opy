# #!mainFile "../../dev_main.opy"


# rule "[lifeweaver/init.opy]: Allow self healing during Tree of Life":
#     @Event eachPlayer
#     @Condition eventPlayer._hero_setup == Hero.LIFEWEAVER
#     @Condition eventPlayer.isUsingUltimate()

#     pushSelfHealing(Button.ULTIMATE)
#     waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
#     popSelfHealing(Button.ULTIMATE)
