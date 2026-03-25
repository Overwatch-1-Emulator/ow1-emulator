#!mainFile "../../main.opy"

playervar rally_pvar
#!defineMember _hp_before_rally     rally_pvar[0]
#!defineMember _rally_stored_armor  rally_pvar[1]
#!defineMember _rally_armor_added   rally_pvar[2]
#!defineMember _rally_pool_id       rally_pvar[3]
playervar rally_i
playervar rally_ally_i
playervar rally_ally_ref
playervar rally_armor_amount
playervar rally_armor_ids
playervar brig_self_armor_id
playervar intro_armor
playervar shield_bash_cd

#!define getMissingHp() (eventPlayer.getMaxHealth() - eventPlayer.getHealth())
#!define getNaturalArmor() ((eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR)) - eventPlayer.getHealthOfType(Health.NORMAL) - getMissingHp())
#!define getExtraArmor() max(0, eventPlayer.getHealthOfType(Health.ARMOR) - getNaturalArmor())
#!define getExtraArmorOf(p) max(0, p.getHealthOfType(Health.ARMOR) - max(0, (p.getMaxHealthOfType(Health.NORMAL) + p.getMaxHealthOfType(Health.ARMOR)) - p.getHealthOfType(Health.NORMAL) - (p.getMaxHealth() - p.getHealth())))


rule "[brigitte/rally.opy]: Remove OW2 Rally":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, eventPlayer.shield_bash_cd)
    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF))
    eventPlayer.addHealthPool(Health.ARMOR, 25, true, false)
    eventPlayer.intro_armor = getLastCreatedHealthPool()
    damage(eventPlayer, null, OW2_BRIGITTE_RALLY_INSTANT_ARMOR*eventPlayer._hp_scalar + OW2_ARMOR_DAMAGE_REDUCTION)

    for eventPlayer.rally_i in range(len(eventPlayer.rally_armor_ids)):
        removeHealthPool(eventPlayer.rally_armor_ids[eventPlayer.rally_i])
    eventPlayer.rally_armor_ids = []

    wait(9.9)
    eventPlayer.brig_self_armor_id = eventPlayer.getMaxHealthOfType(Health.ARMOR)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setMoveSpeed(100)

    removeHealthPool(eventPlayer.intro_armor)
    if eventPlayer.brig_self_armor_id > 100:
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.brig_self_armor_id - 50, false, false)
    else:
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.brig_self_armor_id, false, false)
    eventPlayer.rally_armor_ids.append(getLastCreatedHealthPool())

    # Also do a final overhealth strip + armor restore for all allies
    for eventPlayer.rally_ally_i in range(len(getPlayers(eventPlayer.getTeam()))):
        eventPlayer.rally_ally_ref = getPlayers(eventPlayer.getTeam())[eventPlayer.rally_ally_i]
        if eventPlayer.rally_ally_ref == eventPlayer: continue
        if eventPlayer.rally_ally_ref._rally_armor_added <= 0: continue
        removeHealthPool(eventPlayer.rally_ally_ref._rally_pool_id)
        eventPlayer.rally_ally_ref.setHealth(min(
            eventPlayer.rally_ally_ref.getHealth(),
            eventPlayer.rally_ally_ref.getMaxHealthOfType(Health.NORMAL) + eventPlayer.rally_ally_ref.getMaxHealthOfType(Health.ARMOR) + eventPlayer.rally_ally_ref.getMaxHealthOfType(Health.SHIELDS)
        ))
        eventPlayer.rally_ally_ref.addHealthPool(Health.ARMOR, eventPlayer.rally_ally_ref._rally_armor_added, false, false)
        eventPlayer.rally_ally_ref._rally_pool_id = getLastCreatedHealthPool()

    wait(OW1_BRIGITTE_RALLY_ARMOR_DURATION)

    for eventPlayer.rally_i in range(len(eventPlayer.rally_armor_ids)):
        removeHealthPool(eventPlayer.rally_armor_ids[eventPlayer.rally_i])
    eventPlayer.rally_armor_ids = []

    # Remove all ally armor pools after duration
    for eventPlayer.rally_ally_i in range(len(getPlayers(eventPlayer.getTeam()))):
        eventPlayer.rally_ally_ref = getPlayers(eventPlayer.getTeam())[eventPlayer.rally_ally_i]
        if eventPlayer.rally_ally_ref == eventPlayer: continue
        if eventPlayer.rally_ally_ref._rally_armor_added > 0:
            removeHealthPool(eventPlayer.rally_ally_ref._rally_pool_id)
        eventPlayer.rally_ally_ref._rally_armor_added = 0
        eventPlayer.rally_ally_ref._rally_pool_id = 0


rule "[brigitte/rally.opy]: Doesnt reset bash on ult":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.shield_bash_cd = OW1_BRIGITTE_SHIELD_BASH_COOLDOWN
    chase(eventPlayer.shield_bash_cd, 0, rate=1, ChaseReeval.NONE)


# Runs from Brigitte's side - allies processed one at a time to avoid
# getLastCreatedHealthPool() race conditions.
# Strip + add happen in the same sequential loop with no gap between them.
# Per-ally _rally_pool_id means all allies are fully independent.
rule "[brigitte/rally.opy]: OW1 Rally Armor + strip overhealth for allies":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    do:
        for eventPlayer.rally_ally_i in range(len(getPlayers(eventPlayer.getTeam()))):
            eventPlayer.rally_ally_ref = getPlayers(eventPlayer.getTeam())[eventPlayer.rally_ally_i]

            if eventPlayer.rally_ally_ref == eventPlayer: continue
            if distance(eventPlayer.rally_ally_ref, eventPlayer) >= OW2_BRIGITTE_RALLY_RADIUS: continue
            if not isInLoS(eventPlayer.rally_ally_ref, eventPlayer, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS): continue

            # Remove old pool
            if eventPlayer.rally_ally_ref._rally_armor_added > 0:
                removeHealthPool(eventPlayer.rally_ally_ref._rally_pool_id)

            # Strip overhealth - pool removed so ARMOR type = natural armor only
            eventPlayer.rally_ally_ref.setHealth(min(
                eventPlayer.rally_ally_ref.getHealth(),
                eventPlayer.rally_ally_ref.getMaxHealthOfType(Health.NORMAL) + eventPlayer.rally_ally_ref.getMaxHealthOfType(Health.ARMOR) + eventPlayer.rally_ally_ref.getMaxHealthOfType(Health.SHIELDS)
            ))

            # Add more armor if under cap
            if eventPlayer.rally_ally_ref._rally_armor_added < OW1_BRIGITTE_RALLY_ARMOR_MAX:
                eventPlayer.rally_armor_amount = min(OW1_BRIGITTE_RALLY_ARMOR, OW1_BRIGITTE_RALLY_ARMOR_MAX - eventPlayer.rally_ally_ref._rally_armor_added)
                eventPlayer.rally_ally_ref._rally_armor_added += eventPlayer.rally_armor_amount

            eventPlayer.rally_ally_ref.addHealthPool(Health.ARMOR, eventPlayer.rally_ally_ref._rally_armor_added, false, false)
            eventPlayer.rally_ally_ref._rally_pool_id = getLastCreatedHealthPool()

        wait(OW1_BRIGITTE_RALLY_ARMOR_PERIOD, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION


# Fires when ally leaves radius/LoS - one final strip to remove any overhealth
rule "[brigitte/rally.opy]: Final overhealth check on leaving radius":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition eventPlayer._friendly_brigitte_player.isUsingUltimate()
    @Condition distance(eventPlayer, eventPlayer._friendly_brigitte_player) >= OW2_BRIGITTE_RALLY_RADIUS or not isInLoS(eventPlayer, eventPlayer._friendly_brigitte_player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)
    @Condition eventPlayer._rally_armor_added > 0

    removeHealthPool(eventPlayer._rally_pool_id)
    eventPlayer.setHealth(min(
        eventPlayer.getHealth(),
        eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR) + eventPlayer.getMaxHealthOfType(Health.SHIELDS)
    ))
    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer._rally_armor_added, false, false)
    eventPlayer._rally_pool_id = getLastCreatedHealthPool()


# Fires when ally re-enters radius - immediate strip before loop catches up
rule "[brigitte/rally.opy]: Overhealth check on re-entering radius":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition eventPlayer._friendly_brigitte_player.isUsingUltimate()
    @Condition distance(eventPlayer, eventPlayer._friendly_brigitte_player) < OW2_BRIGITTE_RALLY_RADIUS
    @Condition isInLoS(eventPlayer, eventPlayer._friendly_brigitte_player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)
    @Condition eventPlayer._rally_armor_added > 0

    wait(0.064)
    if not eventPlayer._friendly_brigitte_player.isUsingUltimate(): return
    removeHealthPool(eventPlayer._rally_pool_id)
    eventPlayer.setHealth(min(
        eventPlayer.getHealth(),
        eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR) + eventPlayer.getMaxHealthOfType(Health.SHIELDS)
    ))
    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer._rally_armor_added, false, false)
    eventPlayer._rally_pool_id = getLastCreatedHealthPool()
