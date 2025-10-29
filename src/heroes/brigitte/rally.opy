#!mainFile "../../dev_main.opy"

playervar ralley_hot_id

rule "[brigitte/rally.opy]: OW1 Rally":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during ralley
    damage(eventPlayer, null, 100)
    #damage(eventPlayer, null, OW2_BRIGITTE_RALLY_INSTANT_ARMOR*eventPlayer._hp_scalar + OW2_ARMOR_DAMAGE_REDUCTION) # Remove Rally instant armor


    eventPlayer.ralley_hot_id = getLastHoT()

    wait(9.9)
    eventPlayer.A = eventPlayer.getHealthOfType(Health.ARMOR)
    waitUntil(not eventPlayer.isUsingUltimate(), 10)


    if eventPlayer.A > 100:
    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.A - 50, false, false)
    else:
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.A, false, false)
    wait(30)
    removeHealthPool(getLastCreatedHealthPool())
    eventPlayer.setMoveSpeed(100)
    stopHoT(eventPlayer.ralley_hot_id)
    #eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))
    #heal(eventPlayer, null, 100)
    #wait(0.016, Wait.RESTART_WHEN_TRUE)
    #heal(eventPlayer, null, 31)
    #wait(30)
    #eventPlayer.removeAllHealthPools()
