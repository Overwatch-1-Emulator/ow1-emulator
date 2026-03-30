#!mainFile "../../main.opy"

playervar overload_pvar
#!defineMember _torbjorn_overload_id overload_pvar[0]

rule "[torbjorn/overload.opy]: Convert Overload overhealth to armor":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2()

    damage(eventPlayer, null, OW1_TORBJORN_OVERLOAD_OVERHEALTH*eventPlayer._hp_scalar)
    heal(eventPlayer, null, 1) # Rounding error, enjoy magic numbers!

    if eventPlayer._torbjorn_overload_id == null:
        eventPlayer.addHealthPool(Health.ARMOR, OW1_TORBJORN_OVERLOAD_OVERHEALTH, false, true)
        eventPlayer._torbjorn_overload_id = getLastCreatedHealthPool()

    wait(OW1_TORBJORN_OVERLOAD_DURATION)

    if eventPlayer._torbjorn_overload_id != null:
        removeHealthPool(eventPlayer._torbjorn_overload_id)
        eventPlayer._torbjorn_overload_id = null
