# #!mainFile "../../main.opy"


# rule "[lifeweaver/grip.opy]: Set default Life Grip cooldown":
#     @Event eachPlayer
#     @Hero lifeweaver
#     @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
#     eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_LIFEWEAVER_LIFEGRIP_COOLDOWN)
