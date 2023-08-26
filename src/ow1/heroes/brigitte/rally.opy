#!mainFile "../../../main.opy"


rule "[brigitte/rally.opy]: Rally 30% speed boost":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during ralley
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    eventPlayer.setMoveSpeed(100)
