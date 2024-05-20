#!mainFile "../../dev_main.opy"

rule "[orisa/fortify.opy]: Remove overhealth during fortify":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.ORISA
    @Condition eventPlayer.isUsingAbility1()

    damage(eventPlayer, null, OW2_ORISA_FORTIFY_OVERHEALTH/(1-OW2_ORISA_FORTIFY_DAMAGE_REDUCTION))
    heal(eventPlayer, null, 1) # without this, orisa is 449/450 hp due to internal rounding


rule "[orisa/fortify.opy]: Correct movement speed during fortify":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.ORISA
    @Condition eventPlayer.isUsingAbility1()

    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-OW2_ORISA_FORTIFY_MOVEMENT_PENALTY))
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-OW2_ORISA_FORTIFY_MOVEMENT_PENALTY))
