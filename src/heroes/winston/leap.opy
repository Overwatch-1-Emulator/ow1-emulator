#!mainFile "../../main.opy"


rule "[winston/leap.opy]: Override leap cooldown during primal":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_WINSTON_PRIMAL_JUMP_PACK_COOLDOWN_TIME)
