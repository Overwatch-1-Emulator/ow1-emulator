#!mainFile "../../main.opy"


rule "[illari/outburst.opy]: Set default Outburst cooldown":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_ILLARI_OUTBURST_COOLDOWN)
