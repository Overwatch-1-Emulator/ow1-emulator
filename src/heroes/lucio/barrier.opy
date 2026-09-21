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
#!defineMember sound_barrier_self_rally sound_barrier_scratch[4]


subroutine applyOw1SoundBarrier


# Workshop pools on the recipient get wiped by setHealth(), so they are
# removed and re-added from their tracked amounts.
macro restoreTrackedPools(player):
    if player.sound_barrier_pool_id != null:
        removeHealthPool(player.sound_barrier_pool_id)
    if player._torbjorn_overload_id != null:
        removeHealthPool(player._torbjorn_overload_id)
    if player._rally_pool_id != null:
        removeHealthPool(player._rally_pool_id)
    if player._adaptive_shield_hp_id != null:
        removeHealthPool(player._adaptive_shield_hp_id)
    if player.best_defense_pool_id != null:
        removeHealthPool(player.best_defense_pool_id)
    if player._grasp_pool_id != null:
        removeHealthPool(player._grasp_pool_id)

    if player.overload_amount > 0:
        player.addHealthPool(Health.ARMOR, player.overload_amount, false, false)
        player._torbjorn_overload_id = getLastCreatedHealthPool()
    if player._rally_armor_added > 0:
        player.addHealthPool(Health.ARMOR, player._rally_armor_added, false, false)
        player._rally_pool_id = getLastCreatedHealthPool()
    if player.adaptive_shield_amount > 0:
        player.addHealthPool(Health.SHIELDS, player.adaptive_shield_amount, false, false)
        player._adaptive_shield_hp_id = getLastCreatedHealthPool()
    if player.best_defense_shields > 0:
        player.addHealthPool(Health.SHIELDS, player.best_defense_shields, false, false)
        player.best_defense_pool_id = getLastCreatedHealthPool()
    if player.grasp_amount > 0:
        player.addHealthPool(Health.SHIELDS, player.grasp_amount, false, false)
        player._grasp_pool_id = getLastCreatedHealthPool()


rule "[lucio/soundbarrier.opy]: OW1 Sound Barrier":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()

    # Snapshot each teammate's overhealth before the beat lands
    eventPlayer.sound_barrier_recipients = getPlayers(eventPlayer.getTeam())
    for eventPlayer.sound_barrier_i in range(len(eventPlayer.sound_barrier_recipients)):
        eventPlayer.sound_barrier_recipients[eventPlayer.sound_barrier_i].pre_beat_overhealth = getOverhealth(eventPlayer.sound_barrier_recipients[eventPlayer.sound_barrier_i])

    # Timeout: if the ult never lands (Lucio killed/stunned mid-leap), an infinite
    # wait would keep this instance alive and block every future Sound Barrier
    waitUntil(getOverhealth(eventPlayer) - eventPlayer.pre_beat_overhealth > OW2_LUCIO_SOUND_BARRIER_MIN_DETECT_GAIN, OW1_LUCIO_SOUND_BARRIER_DURATION)
    if getOverhealth(eventPlayer) - eventPlayer.pre_beat_overhealth <= OW2_LUCIO_SOUND_BARRIER_MIN_DETECT_GAIN:
        return
    wait() # let the OW2 beat reach every recipient before reading them

    # Only players the game actually gave the OW2 beat to (range + LOS decided by the engine)
    eventPlayer.sound_barrier_recipients = [player for player in getPlayers(eventPlayer.getTeam()) if getOverhealth(player) - player.pre_beat_overhealth > OW2_LUCIO_SOUND_BARRIER_MIN_DETECT_GAIN]

    for eventPlayer.sound_barrier_i in range(len(eventPlayer.sound_barrier_recipients)):
        eventPlayer.sound_barrier_target = eventPlayer.sound_barrier_recipients[eventPlayer.sound_barrier_i]
        applyOw1SoundBarrier()


def applyOw1SoundBarrier():
    @Name "[lucio/soundbarrier.opy]: applyOw1SoundBarrier()"

    # Snapshot after the beat landed: damage taken during the cast is kept,
    # and OW2 overhealth is excluded because natural health is capped at _hp_*
    eventPlayer.sound_barrier_target.pre_beat_health = getNaturalHealth(eventPlayer.sound_barrier_target)
    # Rally armor actually left (not the total ever granted), so the rebuild
    # below doesn't refill armor the player already lost
    eventPlayer.sound_barrier_target._rally_armor_added = max(0, min(eventPlayer.sound_barrier_target._rally_armor_added,
                                                                     getTempArmor(eventPlayer.sound_barrier_target) - eventPlayer.sound_barrier_target.overload_amount))
    # Brigitte's own Rally armor lives in separate pools (rally_armor_ids), not
    # _rally_pool_id; record what's left of it: temp armor minus the other sources
    eventPlayer.sound_barrier_self_rally = max(0, getTempArmor(eventPlayer.sound_barrier_target)
                                                  - eventPlayer.sound_barrier_target.overload_amount
                                                  - eventPlayer.sound_barrier_target._rally_armor_added) \
                                           if len(eventPlayer.sound_barrier_target.rally_armor_ids) > 0 else 0

    # Strip OW2 overhealth, then restore natural health (heal refills health, armor, shields)
    eventPlayer.sound_barrier_target.setStatusEffect(null, Status.UNKILLABLE, Math.INFINITY)
    eventPlayer.sound_barrier_target.setHealth(1)
    heal(eventPlayer.sound_barrier_target, null, eventPlayer.sound_barrier_target.pre_beat_health - 1)
    eventPlayer.sound_barrier_target.clearStatusEffect(Status.UNKILLABLE)

    restoreTrackedPools(eventPlayer.sound_barrier_target)

    # Give Brigitte her remaining self Rally armor back as one pool. The emptied
    # pools stay in rally_armor_ids and are removed by Rally's 30s cleanup as before.
    if eventPlayer.sound_barrier_self_rally > 0:
        eventPlayer.sound_barrier_target.addHealthPool(Health.ARMOR, eventPlayer.sound_barrier_self_rally, false, false)
        eventPlayer.sound_barrier_target.rally_armor_ids.append(getLastCreatedHealthPool())

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

