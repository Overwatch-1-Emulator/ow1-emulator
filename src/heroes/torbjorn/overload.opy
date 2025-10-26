#!mainFile "../../dev_main.opy"


rule "[torbjorn/overload.opy]: Correct overload hp":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.addHealthPool(Health.NORMAL, 33, false, true)
    wait(6)
    removeHealthPool(getLastCreatedHealthPool())

    #damage(eventPlayer, null, OW1_TORBJORN_OVERLOAD_OVERHEALTH*(OW1_TORBJORN_TURRET_HEALTH/OW2_TORBJORN_TURRET_HEALTH) - OW1_TORBJORN_OVERLOAD_OVERHEALTH)
