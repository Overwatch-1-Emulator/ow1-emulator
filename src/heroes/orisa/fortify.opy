#!mainFile "../../main.opy"

rule "[orisa/fortify.opy]: Remove overhealth during fortify":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isUsingAbility1()


    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar/(1-OW2_ORISA_FORTIFY_MOVEMENT_PENALTY))
    removeTrackedPools(eventPlayer)

    if getCurrentOverhealth(eventPlayer) > 0:
        eventPlayer.setHealth(eventPlayer.getHealth() - getCurrentOverhealth(eventPlayer))

    addTrackedPools(eventPlayer)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    setBaseMovement(eventPlayer, eventPlayer._base_movement_scalar*(1-OW2_ORISA_FORTIFY_MOVEMENT_PENALTY))
