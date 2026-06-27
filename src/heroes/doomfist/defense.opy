#!mainFile "../../main.opy"

playervar best_defense
#!defineMember best_defense_shields best_defense[0]
#!defineMember best_defense_pool_id best_defense[1]
#!defineMember start_decay best_defense[2]

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
    eventPlayer.best_defense = OW1_DOOMFIST_BEST_DEFENSE_LINGER


#rule "[doomfist/bestdefense.opy]: Decay Best Defense shields":
#    @Event eachPlayer
#    @Hero doomfist
#    @Condition eventPlayer.best_defense_shields > 0

#    wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER, Wait.RESTART_WHEN_TRUE)
#    wait()

#    while eventPlayer.best_defense_shields > 0:
#        if eventPlayer.getHealth() < eventPlayer.getMaxHealth():
#            # Took damage into overhealth - sync then decay
#            eventPlayer.best_defense_shields = max(0, eventPlayer.getHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.ARMOR))
#            eventPlayer.best_defense_shields = max(0, eventPlayer.best_defense_shields - OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE)
#            removeHealthPool(eventPlayer.best_defense_pool_id)
#            eventPlayer.best_defense_pool_id = null
#            if eventPlayer.best_defense_shields > 0:
#                eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.best_defense_shields, false, false)
#                eventPlayer.best_defense_pool_id = getLastCreatedHealthPool()
#        else:
#            eventPlayer.best_defense_shields = max(0, eventPlayer.best_defense_shields - OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE)
#            removeHealthPool(eventPlayer.best_defense_pool_id)
#            eventPlayer.best_defense_pool_id = null
#            if eventPlayer.best_defense_shields > 0:
#                eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.best_defense_shields, false, false)
#                eventPlayer.best_defense_pool_id = getLastCreatedHealthPool()
#        wait(0.4)


rule "[doomfist/bestdefense.opy]: Decay Best Defense shields":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.best_defense_shields > 0
    @Condition eventPlayer.best_defense == 0


    while eventPlayer.best_defense_shields > 0:
        eventPlayer.best_defense_shields = eventPlayer.getHealthOfType(Health.SHIELDS)
        eventPlayer.best_defense_shields -= OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE
        if eventPlayer.best_defense_pool_id != null:
            removeHealthPool(eventPlayer.best_defense_pool_id)
            eventPlayer.best_defense_pool_id = null
        if eventPlayer.best_defense_shields <= 0:
            eventPlayer.best_defense_shields = 0
        if eventPlayer.best_defense_shields > 0:
            eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.best_defense_shields, false, false)
            eventPlayer.best_defense_pool_id = getLastCreatedHealthPool()
        wait(0.33)


rule "[doomfist/bestdefense.opy]: Decay Linger Start":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.best_defense == OW1_DOOMFIST_BEST_DEFENSE_LINGER

    chase(eventPlayer.best_defense, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)