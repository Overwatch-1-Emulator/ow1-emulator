#!mainFile "../../main.opy"

playervar ralley_hot_id


rule "[brigitte/rally.opy]: Rally 30% speed boost":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during ralley
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    eventPlayer.setMoveSpeed(100)


rule "[brigitte/rally.opy]: Remove Rally instant armor":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    damage(eventPlayer, null, OW2_BRIGITTE_RALLY_INSTANT_ARMOR/(1-OW2_ARMOR_DAMAGE_REDUCTION))
    eventPlayer.startHoT(null, Math.INFINITY, OW1_BRIGITTE_RALLY_HEAL_RATE)
    eventPlayer.ralley_hot_id = getLastHoT()
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    stopHoT(eventPlayer.ralley_hot_id)
