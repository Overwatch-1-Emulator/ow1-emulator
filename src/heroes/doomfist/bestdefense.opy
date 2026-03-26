#!mainFile "../../main.opy"

playervar defense_pvar
#!defineMember ow1_best_defense_shields     defense_pvar[0]
playervar best_defense_pool_id
playervar best_defense_hit_count
playervar best_defense_processed



rule "[doomfist/defense.opy]: Count victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition (eventAbility == Button.SECONDARY_FIRE and not (victim in attacker.wall_impacted_victims)) \
            or (eventAbility == Button.ABILITY_1 and victim in attacker.ow1_slam_victims) \
            or eventAbility == Button.ULTIMATE \
            or eventPlayer.is_using_uppercut

    eventPlayer.best_defense_hit_count += 1
    eventPlayer.best_defense_processed = false


rule "[doomfist/defense.opy]: Apply shields":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.best_defense_hit_count > 0
    @Condition not eventPlayer.best_defense_processed

    wait(0.1)
    eventPlayer.best_defense_processed = true

    eventPlayer.ow1_best_defense_shields = min(
        eventPlayer.ow1_best_defense_shields + eventPlayer.best_defense_hit_count * OW1_DOOMFIST_BEST_DEFENSE,
        OW1_DOOMFIST_BEST_DEFENSE_MAX
    )
    eventPlayer.best_defense_hit_count = 0

    if eventPlayer.best_defense_pool_id != null:
        removeHealthPool(eventPlayer.best_defense_pool_id)
    wait()
    eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.ow1_best_defense_shields, false, false)
    eventPlayer.best_defense_pool_id = getLastCreatedHealthPool()


rule "[doomfist/defense.opy]: Decay Best Defense shields":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.ow1_best_defense_shields > 0

    wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER, Wait.RESTART_WHEN_TRUE)

    while eventPlayer.ow1_best_defense_shields > 0:
        eventPlayer.ow1_best_defense_shields = max(0, eventPlayer.getHealthOfType(Health.SHIELDS) - OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE)

        if eventPlayer.best_defense_pool_id != null:
            removeHealthPool(eventPlayer.best_defense_pool_id)
            eventPlayer.best_defense_pool_id = null

        if eventPlayer.ow1_best_defense_shields > 0:
            eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.ow1_best_defense_shields, false, false)
            eventPlayer.best_defense_pool_id = getLastCreatedHealthPool()

        wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER)
