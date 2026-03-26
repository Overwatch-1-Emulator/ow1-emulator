#!mainFile "../../main.opy"

playervar defense_pvar
#!defineMember ow1_best_defense_shields     defense_pvar[0]
playervar best_defense_pool_id
playervar best_defense_hit_count


# Count all valid victims per ability:
# - Punch: direct impact only (wall slam excluded via wall_impacted_victims)
# - Slam: only victims in the 60 degree cone (via ow1_slam_victims from slam.opy)
# - Uppercut/Ult: all victims count
rule "[doomfist/defense.opy]: Best Defense - Count victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition (eventAbility == Button.SECONDARY_FIRE and not (victim in attacker.wall_impacted_victims)) \
            or (eventAbility == Button.ABILITY_1 and victim in attacker.ow1_slam_victims) \
            or eventAbility == Button.ULTIMATE \
            or eventPlayer.is_using_uppercut

    attacker.best_defense_hit_count += 1


rule "[doomfist/defense.opy]: Best Defense - Apply shields":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.best_defense_hit_count > 0

    # Wait for all simultaneous hits to register then apply
    wait(0.1, Wait.RESTART_WHEN_TRUE)

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

    if RULE_CONDITION: goto RULE_START


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
