#!mainFile "../../main.opy"


playervar sound_barrier_pvar
#!defineMember sound_barrier_pool_id sound_barrier_pvar[0]
#!defineMember sound_barrier_gen sound_barrier_pvar[1]


playervar sound_barrier_i
playervar sound_barrier_scratch
#!defineMember sound_barrier_recipients sound_barrier_scratch[0]
#!defineMember sound_barrier_target sound_barrier_scratch[1]
#!defineMember sound_barrier_decay_gen sound_barrier_scratch[2]
#!defineMember sound_barrier_gained sound_barrier_scratch[3]


rule "[lucio/soundbarrier.opy]: OW1 Sound Barrier":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.sound_barrier_recipients = getPlayers(eventPlayer.getTeam())
    for eventPlayer.sound_barrier_i in range(len(eventPlayer.sound_barrier_recipients)):
        eventPlayer.sound_barrier_target = eventPlayer.sound_barrier_recipients[eventPlayer.sound_barrier_i]
        eventPlayer.sound_barrier_target.armor_pvar = getTempArmor(eventPlayer.sound_barrier_target)
        eventPlayer.sound_barrier_target.shield_pvar = getTempShields(eventPlayer.sound_barrier_target)
        eventPlayer.sound_barrier_target.pre_beat_health = eventPlayer.sound_barrier_target.getHealth()

    #waitUntil(eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.SHIELDS) - eventPlayer.getMaxHealthOfType(Health.ARMOR) > 499, Math.INFINITY)
    waitUntil(getCurrentOverhealth(eventPlayer.sound_barrier_target) > 499, Math.INFINITY)

    for eventPlayer.sound_barrier_i in range(len(eventPlayer.sound_barrier_recipients)):
        eventPlayer.sound_barrier_target = eventPlayer.sound_barrier_recipients[eventPlayer.sound_barrier_i]

        eventPlayer.sound_barrier_target.setHealth(eventPlayer.sound_barrier_target.pre_beat_health)

        if eventPlayer.sound_barrier_target.sound_barrier_pool_id != null:
            removeHealthPool(eventPlayer.sound_barrier_target.sound_barrier_pool_id)
        if eventPlayer.sound_barrier_target.shield_pvar_id != null:
            removeHealthPool(eventPlayer.sound_barrier_target.shield_pvar_id)
        if eventPlayer.sound_barrier_target.armor_pvar_id != null:
            removeHealthPool(eventPlayer.sound_barrier_target.armor_pvar_id)

        if eventPlayer.sound_barrier_target.shield_pvar > 0:
            eventPlayer.sound_barrier_target.addHealthPool(Health.SHIELDS, eventPlayer.sound_barrier_target.shield_pvar, false, false)
            eventPlayer.sound_barrier_target.shield_pvar_id = getLastCreatedHealthPool()

        if eventPlayer.sound_barrier_target.armor_pvar > 0:
            eventPlayer.sound_barrier_target.addHealthPool(Health.ARMOR, eventPlayer.sound_barrier_target.armor_pvar, false, false)
            eventPlayer.sound_barrier_target.armor_pvar_id = getLastCreatedHealthPool()

        eventPlayer.sound_barrier_target.sound_barrier_amount = OW1_LUCIO_SOUND_BARRIER
        eventPlayer.sound_barrier_target.addHealthPool(Health.SHIELDS, OW1_LUCIO_SOUND_BARRIER, false, false)
        eventPlayer.sound_barrier_target.sound_barrier_pool_id = getLastCreatedHealthPool()
        eventPlayer.sound_barrier_target.sound_barrier_gen += 1


rule "[lucio/soundbarrier.opy]: Decay shields":
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