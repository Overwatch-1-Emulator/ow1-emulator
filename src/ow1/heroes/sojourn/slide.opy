#!mainFile "../../../main.opy"

rule "[sojourn/slide.opy]: Set default Power Slide cooldown":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_SOJOURN_SLIDE_COOLDOWN)


