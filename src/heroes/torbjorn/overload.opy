#!mainFile "../../main.opy"



rule "[torbjorn/overload.opy]: Convert Overload overhealth to armor":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2()

    if eventPlayer.sound_barrier_pool_id != null:
        removeHealthPool(eventPlayer.sound_barrier_pool_id)

    if eventPlayer.rally_armor_ids != null:
        removeHealthPool(eventPlayer.rally_armor_ids)

    if getCurrentOverhealth(eventPlayer) > 0:
        eventPlayer.setHealth(eventPlayer.getHealth() - getCurrentOverhealth(eventPlayer))

    if eventPlayer._torbjorn_overload_id == null:
        eventPlayer.overload_amount = OW1_TORBJORN_OVERLOAD_OVERHEALTH
        eventPlayer.addHealthPool(Health.ARMOR, OW1_TORBJORN_OVERLOAD_OVERHEALTH, false, true)
        eventPlayer._torbjorn_overload_id = getLastCreatedHealthPool()

    wait(OW1_TORBJORN_OVERLOAD_DURATION)

    if eventPlayer._torbjorn_overload_id != null:
        removeHealthPool(eventPlayer._torbjorn_overload_id)
        eventPlayer._torbjorn_overload_id = null
    # Overload is over: without this, Rally keeps subtracting it from Torb's armor
    # and Sound Barrier's restore re-adds a 50 armor pool that shouldn't exist
    eventPlayer.overload_amount = 0
