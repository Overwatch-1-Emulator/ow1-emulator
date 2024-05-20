# #!mainFile "../../dev_main.opy"

# rule "[sojourn/slide.opy]: Set default Power Slide cooldown":
#     @Event eachPlayer
#     @Condition eventPlayer._hero_setup == Hero.SOJOURN
#     @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
#     eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_SOJOURN_SLIDE_COOLDOWN)


# rule "[sojourn/slide.opy]: Set default Power Slide cooldown":
#     @Event playerEarnedElimination
#     @Condition eventPlayer._hero_setup == Hero.SOJOURN
#     @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
#     eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - OW1_SOJOURN_SLIDE_ELIMS_CD)
