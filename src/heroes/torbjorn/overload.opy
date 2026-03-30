#!mainFile "../../main.opy"

playervar torbjorn_overload_id

rule "[torbjorn/overload.opy]: Convert Overload overhealth to shields":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2()

    damage(eventPlayer, null, OW1_TORBJORN_OVERLOAD_OVERHEALTH*eventPlayer._hp_scalar)
    heal(eventPlayer, null, 1) # Rounding error, enjoy magic numbers!

    eventPlayer.torbjorn_overload_id = getLastCreatedHealthPool()
    eventPlayer.addHealthPool(Health.ARMOR, OW1_TORBJORN_OVERLOAD_OVERHEALTH, false, true)

    wait(OW1_TORBJORN_OVERLOAD_DURATION)

    removeHealthPool(eventPlayer.torbjorn_overload_id)
