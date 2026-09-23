#!mainFile "../../main.opy"



rule "[torbjorn/overload.opy]: Convert Overload overhealth to armor":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2()

    if eventPlayer.sound_barrier_pool_id != null or eventPlayer.rally_armor_ids != null:
        removeTrackedPools(eventPlayer)

    if getCurrentOverhealth(eventPlayer) > 0:
        eventPlayer.setHealth(eventPlayer.getHealth() - getCurrentOverhealth(eventPlayer))
    
    addTrackedPools(eventPlayer)

    if eventPlayer._torbjorn_overload_id == null:
        eventPlayer.overload_amount = OW1_TORBJORN_OVERLOAD_OVERHEALTH
        eventPlayer.addHealthPool(Health.ARMOR, OW1_TORBJORN_OVERLOAD_OVERHEALTH, false, true)
        eventPlayer._torbjorn_overload_id = getLastCreatedHealthPool()

    wait(OW1_TORBJORN_OVERLOAD_DURATION)

    if eventPlayer._torbjorn_overload_id != null:
        removeHealthPool(eventPlayer._torbjorn_overload_id)
        eventPlayer._torbjorn_overload_id = null
    eventPlayer.overload_amount = 0
