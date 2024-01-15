# #!mainFile "../../main.opy"

# rule "[junkerqueen/shout.opy]: Set default Carnage cooldown":
#     @Event eachPlayer
#     @Hero junkerQueen
#     @Condition eventPlayer.isUsingAbility2()
    
#     waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
#     waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, Math.INFINITY)
#     eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_JUNKERQUEEN_CARNAGE_COOLDOWN_TIME)
