#!mainFile "../../main.opy"
 
# Add these to ow1_constants.opy:
# #!define OW1_LUCIO_SOUND_BARRIER 750
# #!define OW1_LUCIO_SOUND_BARRIER_DURATION 7
# #!define OW1_LUCIO_SOUND_BARRIER_DECAY_RATE 125
# #!define OW1_LUCIO_SOUND_BARRIER_RADIUS 30

playervar lucio_pvar
#!defineMember sb_pool_id       lucio_pvar[0]
playervar lucio_i
playervar lucio_ally_ref
playervar sb_shields


# When Sound Barrier fires, convert OW2 overhealth to OW1 shield amount
# Runs from Lucio's side to avoid getLastCreatedHealthPool() race condition
rule "[lucio/soundbarrier.opy]: Convert Sound Barrier overhealth to shields":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()

    # Wait until OW2 actually applies the overhealth rather than guessing cast time
    waitUntil(eventPlayer.getHealthOfType(Health.NORMAL) > eventPlayer.getMaxHealthOfType(Health.NORMAL), 2)
    if eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.getMaxHealthOfType(Health.NORMAL): return

    for eventPlayer.lucio_i in range(len(getPlayers(eventPlayer.getTeam()))):
        eventPlayer.lucio_ally_ref = getPlayers(eventPlayer.getTeam())[eventPlayer.lucio_i]

        # Sound Barrier requires LoS and 30m radius, doesn't affect allies behind enemy barriers
        if distance(eventPlayer.lucio_ally_ref, eventPlayer) > OW1_LUCIO_SOUND_BARRIER_RADIUS: continue
        if not isInLoS(eventPlayer.lucio_ally_ref, eventPlayer, BarrierLos.BLOCKED_BY_ALL_BARRIERS): continue

        # Strip OW2 overhealth
        if eventPlayer.lucio_ally_ref.getHealthOfType(Health.NORMAL) > eventPlayer.lucio_ally_ref.getMaxHealthOfType(Health.NORMAL):
            eventPlayer.lucio_ally_ref.setHealth(eventPlayer.lucio_ally_ref.getHealth() - (eventPlayer.lucio_ally_ref.getHealthOfType(Health.NORMAL) - eventPlayer.lucio_ally_ref.getMaxHealthOfType(Health.NORMAL)))

        # Add OW1 shield pool
        if eventPlayer.lucio_ally_ref.sb_pool_id != null:
            removeHealthPool(eventPlayer.lucio_ally_ref.sb_pool_id)
        eventPlayer.lucio_ally_ref.addHealthPool(Health.SHIELDS, OW1_LUCIO_SOUND_BARRIER, false, false)
        eventPlayer.lucio_ally_ref.sb_pool_id = getLastCreatedHealthPool()
        eventPlayer.lucio_ally_ref.sb_shields = OW1_LUCIO_SOUND_BARRIER


# Decay per ally - runs on the ally's side since each decays independently
rule "[lucio/soundbarrier.opy]: Decay Sound Barrier shields":
    @Event eachPlayer
    @Condition eventPlayer.sb_shields > 0

    # Decay rate = OW1_LUCIO_SOUND_BARRIER / OW1_LUCIO_SOUND_BARRIER_DURATION per second
    chase(eventPlayer.sb_shields, 0, rate=OW1_LUCIO_SOUND_BARRIER_DECAY_RATE, ChaseReeval.NONE)

    waitUntil(eventPlayer.sb_shields <= 0, OW1_LUCIO_SOUND_BARRIER_DURATION)
    stopChasingVariable(eventPlayer.sb_shields)

    if eventPlayer.sb_pool_id != null:
        removeHealthPool(eventPlayer.sb_pool_id)
        eventPlayer.sb_pool_id = null
    eventPlayer.sb_shields = 0


# Sync pool size to decaying sb_shields every tick
rule "[lucio/soundbarrier.opy]: Update Sound Barrier pool as shields decay":
    @Event eachPlayer
    @Condition eventPlayer.sb_shields > 0

    do:
        if eventPlayer.sb_pool_id != null:
            removeHealthPool(eventPlayer.sb_pool_id)
        eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.sb_shields, false, false)
        eventPlayer.sb_pool_id = getLastCreatedHealthPool()
        wait(0.25)
    while RULE_CONDITION
