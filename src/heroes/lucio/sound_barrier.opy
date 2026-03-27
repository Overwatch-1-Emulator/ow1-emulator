#!mainFile "../../main.opy"

playervar sound_barrier_pvar
#!defineMember sb_pool_id       sound_barrier_pvar[0]
#!defineMember sb_pre_normal    sound_barrier_pvar[1]
#!defineMember sb_armed         sound_barrier_pvar[2]
#!defineMember lucio_ally_ref   sound_barrier_pvar[3]
playervar lucio_i
playervar sb_shields


rule "[lucio/soundbarrier.opy]: Detect players within Sound Barrier":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()

    for eventPlayer.lucio_i in range(len(getPlayers(eventPlayer.getTeam()))): # Get players within Sound Barrier to get Health
        eventPlayer.lucio_ally_ref = getPlayers(eventPlayer.getTeam())[eventPlayer.lucio_i]
        if distance(eventPlayer.lucio_ally_ref, eventPlayer) > OW1_LUCIO_SOUND_BARRIER_RADIUS: continue
        if not isInLoS(eventPlayer.lucio_ally_ref, eventPlayer, BarrierLos.BLOCKED_BY_ALL_BARRIERS): continue
        eventPlayer.lucio_ally_ref.sb_armed = true

    # Wait for Soundbarrier to drop
    waitUntil(eventPlayer.getHealthOfType(Health.NORMAL) > eventPlayer.getMaxHealthOfType(Health.NORMAL), 2)
    if eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.getMaxHealthOfType(Health.NORMAL): return

    for eventPlayer.lucio_i in range(len(getPlayers(eventPlayer.getTeam()))): # Get players within Sound Barrier to set OW1 Sound Barrier Shields
        eventPlayer.lucio_ally_ref = getPlayers(eventPlayer.getTeam())[eventPlayer.lucio_i]
        if distance(eventPlayer.lucio_ally_ref, eventPlayer) > OW1_LUCIO_SOUND_BARRIER_RADIUS: continue
        if not isInLoS(eventPlayer.lucio_ally_ref, eventPlayer, BarrierLos.BLOCKED_BY_ALL_BARRIERS): continue
        eventPlayer.lucio_ally_ref.sb_shields = OW1_LUCIO_SOUND_BARRIER
        eventPlayer.lucio_ally_ref.sb_armed = false
    

rule "[lucio/soundbarrier.opy]: Get player health before Sound Barrier":
    @Event eachPlayer
    @Condition eventPlayer.sb_armed == true

    eventPlayer.sb_pre_normal = eventPlayer.getHealth()
    eventPlayer.sb_armed = false


rule "[lucio/soundbarrier.opy]: Apply OW1 Sound Barrier shields":
    @Event eachPlayer
    @Condition eventPlayer.sb_shields == OW1_LUCIO_SOUND_BARRIER

    # Overwrite OW2 Lucio Soundbarrier overhealth
    eventPlayer.setHealth(0) # Lowest possible health
    eventPlayer.setHealth(eventPlayer.sb_pre_normal) # Instantly set it back to correct health

    # Apply OW1 Custom Sound Barrier
    if eventPlayer.sb_pool_id != null:
        removeHealthPool(eventPlayer.sb_pool_id)
    eventPlayer.addHealthPool(Health.SHIELDS, OW1_LUCIO_SOUND_BARRIER, false, false)
    eventPlayer.sb_pool_id = getLastCreatedHealthPool()


rule "[lucio/sound_barrier_pvar.opy]: Decay Sound Barrier shields":
    @Event eachPlayer
    @Condition eventPlayer.sb_shields > 0

    chase(eventPlayer.sb_shields, 0, rate=OW1_LUCIO_SOUND_BARRIER_DECAY_RATE, ChaseReeval.NONE)
    waitUntil(eventPlayer.sb_shields <= 0, OW1_LUCIO_SOUND_BARRIER_DURATION)
    stopChasingVariable(eventPlayer.sb_shields)

    if eventPlayer.sb_pool_id != null:
        removeHealthPool(eventPlayer.sb_pool_id)
        eventPlayer.sb_pool_id = null
    eventPlayer.sb_shields = 0
        

rule "[lucio/sound_barrier_pvar.opy]: Update Sound Barrier health as shields decay":
    @Event eachPlayer
    @Condition eventPlayer.sb_shields > 0

    do:
        if eventPlayer.sb_pool_id != null:
            removeHealthPool(eventPlayer.sb_pool_id)
        eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.sb_shields, false, false)
        eventPlayer.sb_pool_id = getLastCreatedHealthPool()
        wait(0.25)
    while RULE_CONDITION