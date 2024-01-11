#!mainFile "../../main.opy"


rule "[baptiste/immort_field.opy]: Set default immortality field cooldown":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isUsingAbility2()
    
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_BAPTISTE_IMMORTALITY_FIELD_COOLDOWN_TIME)