#!mainFile "../../main.opy"
 
# Add to ow1_constants.opy:
# #!define OW1_SIGMA_GRASP_DECAY_RATE 7
# #!define OW1_SIGMA_GRASP_LINGER 3

playervar grasp_pool_id
playervar grasp_shield_amount
playervar grasp_decaying


rule "[sigma/kineticgrasp.opy]: Convert Kinetic Grasp overhealth to shields":
    @Event eachPlayer
    @Hero sigma
    @Condition not eventPlayer.isUsingAbility1()
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) > eventPlayer.getMaxHealthOfType(Health.NORMAL)

    eventPlayer.grasp_shield_amount = eventPlayer.getHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.NORMAL)
    eventPlayer.grasp_decaying = false

    if eventPlayer.grasp_pool_id != null:
        removeHealthPool(eventPlayer.grasp_pool_id)

    eventPlayer.setHealth(eventPlayer.getHealth() - eventPlayer.grasp_shield_amount)
    eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.grasp_shield_amount, false, false)
    eventPlayer.grasp_pool_id = getLastCreatedHealthPool()

    # Wait linger then start decay
    wait(OW1_SIGMA_GRASP_LINGER, Wait.RESTART_WHEN_TRUE)
    eventPlayer.grasp_decaying = true


rule "[sigma/kineticgrasp.opy]: Decay Kinetic Grasp shields":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.grasp_decaying == true
    @Condition eventPlayer.grasp_shield_amount > 0

    do:
        eventPlayer.grasp_shield_amount = max(0, eventPlayer.grasp_shield_amount - OW1_SIGMA_GRASP_DECAY_RATE * 0.25)

        if eventPlayer.grasp_pool_id != null:
            removeHealthPool(eventPlayer.grasp_pool_id)

        if eventPlayer.grasp_shield_amount > 0:
            eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.grasp_shield_amount, false, false)
            eventPlayer.grasp_pool_id = getLastCreatedHealthPool()
        else:
            eventPlayer.grasp_pool_id = null
            eventPlayer.grasp_decaying = false

        wait(0.25)
    while eventPlayer.grasp_shield_amount > 0
