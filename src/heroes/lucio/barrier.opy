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
        eventPlayer.sound_barrier_target.armor_pvar = getNaturalArmor(eventPlayer.sound_barrier_target)
        eventPlayer.sound_barrier_target.temp_shield_pvar = getNaturalShields(eventPlayer.sound_barrier_target)
        eventPlayer.sound_barrier_target.pre_beat_health = getNaturalHealth(eventPlayer.sound_barrier_target)

    waitUntil(eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.SHIELDS) - eventPlayer.getMaxHealthOfType(Health.ARMOR) > 400, Math.INFINITY)
    #waitUntil(getCurrentOverhealth(eventPlayer.sound_barrier_target) > 499, Math.INFINITY)

    for eventPlayer.sound_barrier_i in range(len(eventPlayer.sound_barrier_recipients)):
        eventPlayer.sound_barrier_target = eventPlayer.sound_barrier_recipients[eventPlayer.sound_barrier_i]

        eventPlayer.sound_barrier_target.setHealth(1)
        heal(eventPlayer.sound_barrier_target, null, eventPlayer.sound_barrier_target.pre_beat_health-1)
        heal(eventPlayer.sound_barrier_target, null, eventPlayer.sound_barrier_target.armor_pvar)
        heal(eventPlayer.sound_barrier_target, null, eventPlayer.sound_barrier_target.shield_pvar)


        if eventPlayer.sound_barrier_pool_id != null:
            removeHealthPool(eventPlayer.sound_barrier_pool_id)
        if eventPlayer._torbjorn_overload_id != null:
            removeHealthPool(eventPlayer._torbjorn_overload_id)
        if eventPlayer._rally_pool_id != null:
            removeHealthPool(eventPlayer._rally_pool_id)
        if eventPlayer._adaptive_shield_hp_id != null:
            removeHealthPool(eventPlayer._adaptive_shield_hp_id)
        if eventPlayer.best_defense_pool_id != null:
            removeHealthPool(eventPlayer.best_defense_pool_id)
        if eventPlayer._grasp_pool_id != null:
            removeHealthPool(eventPlayer._grasp_pool_id)

        if eventPlayer.overload_amount > 0:
            eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.overload_amount, false, false)
            eventPlayer._torbjorn_overload_id = getLastCreatedHealthPool()

        if eventPlayer.rally_armor_amount > 0:
            eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.rally_armor_amount, false, false)
            eventPlayer._rally_pool_id = getLastCreatedHealthPool()

        if eventPlayer.adaptive_shield_amount > 0:
            eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.adaptive_shield_amount, false, false)
            eventPlayer._adaptive_shield_hp_id = getLastCreatedHealthPool()

        if eventPlayer.best_defense_shields > 0:
            eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.best_defense_shields, false, false)
            eventPlayer.best_defense_pool_id = getLastCreatedHealthPool()

        if eventPlayer.grasp_amount > 0:
            eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.grasp_amount, false, false)
            eventPlayer._grasp_pool_id = getLastCreatedHealthPool()

        eventPlayer.sound_barrier_target.sound_barrier_amount = OW1_LUCIO_SOUND_BARRIER
        eventPlayer.sound_barrier_target.addHealthPool(Health.SHIELDS, OW1_LUCIO_SOUND_BARRIER, false, false)
        eventPlayer.sound_barrier_target.sound_barrier_pool_id = getLastCreatedHealthPool()
        eventPlayer.sound_barrier_target.sound_barrier_gen += 1


rule "[lucio/soundbarrier.opy]: Decay shields":
    @Event eachPlayer 
    @Condition eventPlayer.sound_barrier_amount > 0

    eventPlayer.sound_barrier_decay_gen = eventPlayer.sound_barrier_gen

    while eventPlayer.sound_barrier_amount > 0 and eventPlayer.sound_barrier_decay_gen == eventPlayer.sound_barrier_gen:
        #eventPlayer.sound_barrier_amount = min(eventPlayer.sound_barrier_amount, max(0, eventPlayer.getHealthOfType(Health.SHIELDS)))
        eventPlayer.sound_barrier_amount = max(0, eventPlayer.sound_barrier_amount - OW1_LUCIO_SOUND_BARRIER_DECAY_RATE * OW1_LUCIO_SOUND_BARRIER_TICK)
        removeHealthPool(eventPlayer.sound_barrier_pool_id)
        if eventPlayer.sound_barrier_amount > 0:
            eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.sound_barrier_amount, false, false)
            eventPlayer.sound_barrier_pool_id = getLastCreatedHealthPool()
        wait(OW1_LUCIO_SOUND_BARRIER_TICK, Wait.ABORT_WHEN_FALSE)

    if eventPlayer.sound_barrier_decay_gen == eventPlayer.sound_barrier_gen:
        eventPlayer.sound_barrier_pool_id = null
        eventPlayer.sound_barrier_amount = 0

