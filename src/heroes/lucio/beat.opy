#!mainFile "../../main.opy"

playervar lucio_pvar
#!defineMember sb_pool_id       lucio_pvar[0]
#!defineMember sb_pre_normal    lucio_pvar[1]
#!defineMember sb_armed         lucio_pvar[2]
playervar lucio_i
playervar lucio_ally_ref
playervar sb_shields


# Step 1: Lucio arms allies the instant ult fires - before OW2 applies overhealth
rule "[lucio/soundbarrier.opy]: Arm allies for snapshot":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()

    for eventPlayer.lucio_i in range(len(getPlayers(eventPlayer.getTeam()))):
        eventPlayer.lucio_ally_ref = getPlayers(eventPlayer.getTeam())[eventPlayer.lucio_i]
        if distance(eventPlayer.lucio_ally_ref, eventPlayer) > OW1_LUCIO_SOUND_BARRIER_RADIUS: continue
        if not isInLoS(eventPlayer.lucio_ally_ref, eventPlayer, BarrierLos.BLOCKED_BY_ALL_BARRIERS): continue
        eventPlayer.lucio_ally_ref.sb_armed = true

    # Wait for beat drop then signal to apply
    waitUntil(eventPlayer.getHealthOfType(Health.NORMAL) > eventPlayer.getMaxHealthOfType(Health.NORMAL), 2)
    if eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.getMaxHealthOfType(Health.NORMAL): return

    for eventPlayer.lucio_i in range(len(getPlayers(eventPlayer.getTeam()))):
        eventPlayer.lucio_ally_ref = getPlayers(eventPlayer.getTeam())[eventPlayer.lucio_i]
        if distance(eventPlayer.lucio_ally_ref, eventPlayer) > OW1_LUCIO_SOUND_BARRIER_RADIUS: continue
        if not isInLoS(eventPlayer.lucio_ally_ref, eventPlayer, BarrierLos.BLOCKED_BY_ALL_BARRIERS): continue
        eventPlayer.lucio_ally_ref.sb_shields = OW1_LUCIO_SOUND_BARRIER


# Step 2: Each ally snapshots their OWN HP on their OWN thread the instant they are armed
# This fires before OW2 overhealth lands since sb_armed is set first
rule "[lucio/soundbarrier.opy]: Snapshot HP on own thread":
    @Event eachPlayer
    @Condition eventPlayer.sb_armed == true

    eventPlayer.sb_pre_normal = eventPlayer.getHealthOfType(Health.NORMAL)
    eventPlayer.sb_armed = false


# Step 3: Each ally removes overhealth via damage then adds shield pool on their OWN thread
rule "[lucio/soundbarrier.opy]: Apply Sound Barrier shields":
    @Event eachPlayer
    @Condition eventPlayer.sb_shields == OW1_LUCIO_SOUND_BARRIER

    # Damage for exactly the overhealth amount - only hits overhealth, armor/shields untouched
    damage(eventPlayer, null, eventPlayer.getHealthOfType(Health.NORMAL) - eventPlayer.sb_pre_normal)

    # Add OW1 shield pool on own thread - no race condition
    if eventPlayer.sb_pool_id != null:
        removeHealthPool(eventPlayer.sb_pool_id)
    eventPlayer.addHealthPool(Health.SHIELDS, OW1_LUCIO_SOUND_BARRIER, false, false)
    eventPlayer.sb_pool_id = getLastCreatedHealthPool()


rule "[lucio/soundbarrier.opy]: Decay Sound Barrier shields":
    @Event eachPlayer
    @Condition eventPlayer.sb_shields > 0

    chase(eventPlayer.sb_shields, 0, rate=OW1_LUCIO_SOUND_BARRIER_DECAY_RATE, ChaseReeval.NONE)
    waitUntil(eventPlayer.sb_shields <= 0, OW1_LUCIO_SOUND_BARRIER_DURATION)
    stopChasingVariable(eventPlayer.sb_shields)

    if eventPlayer.sb_pool_id != null:
        removeHealthPool(eventPlayer.sb_pool_id)
        eventPlayer.sb_pool_id = null
    eventPlayer.sb_shields = 0


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
