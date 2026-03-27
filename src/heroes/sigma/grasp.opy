#!mainFile "../../main.opy"

playervar grasp_pvar
#!defineMember grasp_pool_id grasp_pvar[0]
#!defineMember grasp_shield_amount grasp_pvar[1]
#!defineMember grasp_decaying grasp_pvar[2]


rule "[sigma/grasp.opy]: Convert Kinetic Grasp overhealth to shields":
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

    # Linger duration to Kinetic Grasp
    wait(OW1_SIGMA_GRASP_LINGER, Wait.RESTART_WHEN_TRUE)
    eventPlayer.grasp_decaying = true


rule "[sigma/grasp.opy]: Decay Kinetic Grasp shields":
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
