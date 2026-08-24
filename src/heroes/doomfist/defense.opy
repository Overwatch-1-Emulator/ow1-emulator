#!mainFile "../../main.opy"

playervar best_defense
playervar best_defense_linger
#!defineMember best_defense_shields best_defense[0]
#!defineMember best_defense_pool_id best_defense[1]

rule "[doomfist/defense.opy]: OW1 Best Defense":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition (eventAbility == Button.SECONDARY_FIRE and not (victim in attacker.wall_impacted_victims)) \
            or (eventAbility == Button.ABILITY_1 and victim in attacker.ow1_slam_victims) \
            or eventAbility == Button.ULTIMATE \
            or eventPlayer.is_using_uppercut

    if eventPlayer.best_defense_pool_id != null:
        removeHealthPool(eventPlayer.best_defense_pool_id)

    if eventAbility == Button.ULTIMATE:
        eventPlayer.best_defense_shields = min(eventPlayer.best_defense_shields + OW1_DOOMFIST_BEST_DEFENSE_ULT, OW1_DOOMFIST_BEST_DEFENSE_MAX)
    else:
        eventPlayer.best_defense_shields = min(eventPlayer.best_defense_shields + OW1_DOOMFIST_BEST_DEFENSE, OW1_DOOMFIST_BEST_DEFENSE_MAX)

    eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.best_defense_shields, false, false)
    eventPlayer.best_defense_pool_id = getLastCreatedHealthPool()
    eventPlayer.best_defense_linger = OW1_DOOMFIST_BEST_DEFENSE_LINGER


rule "[doomfist/bestdefense.opy]: Decay Best Defense shields":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.best_defense_shields > 0


    while eventPlayer.best_defense_shields > 0:
        waitUntil(eventPlayer.best_defense_linger == 0)
        eventPlayer.best_defense_shields = eventPlayer.getHealthOfType(Health.SHIELDS)
        eventPlayer.best_defense_shields -= OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE
        eventPlayer.setHealth(eventPlayer.getHealth() - OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE)
        wait(OW1_DOOMFIST_BEST_DEFENSE_DECAY_PER_SECOND)
    removeHealthPool(eventPlayer.best_defense_pool_id)
    eventPlayer.best_defense_pool_id = null
    eventPlayer.best_defense_shields = 0


rule "[doomfist/bestdefense.opy]: Decay Linger Start":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.best_defense_linger > 0

    chase(eventPlayer.best_defense_linger, 0, rate=1, ChaseReeval.NONE)