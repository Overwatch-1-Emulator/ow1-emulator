#!mainFile "../../main.opy"

playervar sound_barrier_pvar
#!defineMember sound_barrier_pool_id sound_barrier_pvar[0]
#!defineMember sound_barrier_gen sound_barrier_pvar[1]

playervar sound_barrier_i
playervar sound_barrier_scratch
#!defineMember sound_barrier_recipients sound_barrier_scratch[0]
#!defineMember sound_barrier_target sound_barrier_scratch[1]
#!defineMember sound_barrier_decay_gen sound_barrier_scratch[2]



rule "[lucio/barrier.opy]: Remove OW2 Beat":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()
    @Condition not eventPlayer.isOnGround()

    #wait(0.16)
    waitUntil(eventPlayer.isOnGround(), Math.INFINITY)
    eventPlayer.setHealth(eventPlayer.getHealth() - OW2_LUCIO_SOUND_BARRIER_HEALTH * eventPlayer._hp_scalar) #0.4 is a SafeGuard
    wait(5)
    #eventPlayer.cancelPrimaryAction()


rule "[lucio/barrier.opy]: OW1 Sound Barrier - grant shields to allies in radius":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.sound_barrier_recipients = getPlayers(eventPlayer.getTeam())
    waitUntil(eventPlayer.getAltitude() < 0.05, Math.INFINITY)
    for eventPlayer.sound_barrier_i in range(len(eventPlayer.sound_barrier_recipients)):
        eventPlayer.sound_barrier_target = eventPlayer.sound_barrier_recipients[eventPlayer.sound_barrier_i]

        if distance(eventPlayer.sound_barrier_target, eventPlayer) > OW1_LUCIO_SOUND_BARRIER_RADIUS: continue
        if not isInLoS(eventPlayer.sound_barrier_target, eventPlayer, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS): continue

        if eventPlayer.sound_barrier_target.sound_barrier_pool_id != null:
            removeHealthPool(eventPlayer.sound_barrier_target.sound_barrier_pool_id)

        eventPlayer.sound_barrier_target.sound_barrier_amount = OW1_LUCIO_SOUND_BARRIER
        eventPlayer.sound_barrier_target.addHealthPool(Health.SHIELDS, OW1_LUCIO_SOUND_BARRIER, false, false)
        eventPlayer.sound_barrier_target.sound_barrier_pool_id = getLastCreatedHealthPool()
        eventPlayer.sound_barrier_target.sound_barrier_gen += 1


rule "[lucio/barrier.opy]: Decay shields":
    @Event eachPlayer
    @Condition eventPlayer.sound_barrier_amount > 0

    eventPlayer.sound_barrier_decay_gen = eventPlayer.sound_barrier_gen

    while eventPlayer.sound_barrier_amount > 0 and eventPlayer.sound_barrier_decay_gen == eventPlayer.sound_barrier_gen:
        eventPlayer.sound_barrier_amount = min(eventPlayer.sound_barrier_amount, max(0, eventPlayer.getHealthOfType(Health.SHIELDS)))
        eventPlayer.sound_barrier_amount = max(0, eventPlayer.sound_barrier_amount - OW1_LUCIO_SOUND_BARRIER_DECAY_RATE * OW1_LUCIO_SOUND_BARRIER_TICK)
        removeHealthPool(eventPlayer.sound_barrier_pool_id)
        if eventPlayer.sound_barrier_amount > 0:
            eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.sound_barrier_amount, false, false)
            eventPlayer.sound_barrier_pool_id = getLastCreatedHealthPool()
        wait(OW1_LUCIO_SOUND_BARRIER_TICK, Wait.ABORT_WHEN_FALSE)

    if eventPlayer.sound_barrier_decay_gen == eventPlayer.sound_barrier_gen:
        eventPlayer.sound_barrier_pool_id = null
        eventPlayer.sound_barrier_amount = 0


rule "[lucio/soundbarrier.opy]: Track event damage dealt to beat":
    @Event playerTookDamage
    @Condition eventPlayer.sound_barrier_amount > 0

    eventPlayer.sound_barrier_amount -= eventDamage