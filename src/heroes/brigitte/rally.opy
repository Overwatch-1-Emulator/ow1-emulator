#!mainFile "../../dev_main.opy"

playervar ralley_hot_id


rule "[brigitte/rally.opy]: OW1 Rally":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during ralley
    damage(eventPlayer, null, OW2_BRIGITTE_RALLY_INSTANT_ARMOR + OW2_ARMOR_DAMAGE_REDUCTION) # Remove Rally instant armor
    eventPlayer.startHoT(null, Math.INFINITY, OW1_BRIGITTE_RALLY_HEAL_RATE)
    eventPlayer.ralley_hot_id = getLastHoT()

    waitUntil(not eventPlayer.isUsingUltimate(), 10)

    eventPlayer.setMoveSpeed(100)
    stopHoT(eventPlayer.ralley_hot_id)
