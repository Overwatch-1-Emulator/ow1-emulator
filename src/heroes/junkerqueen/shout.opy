# #!mainFile "../../dev_main.opy"

# rule "[junkerqueen/shout.opy]: Set default Commanding Shout cooldown":
#     @Event eachPlayer
#     @Condition eventPlayer._hero_setup == Hero.JUNKERQUEEN
#     @Condition eventPlayer.isUsingAbility1()
    
#     waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
#     eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_JUNKERQUEEN_SHOUT_COOLDOWN_TIME)
