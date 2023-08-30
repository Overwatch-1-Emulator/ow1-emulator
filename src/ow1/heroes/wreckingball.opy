#!mainFile "../../main.opy"

rule "[wreckingball.opy]: Initialize Wrecking Ball":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    wait()
    setCustomHealth(OW1_WRECKING_BALL_HEALTH, OW1_WRECKING_BALL_ARMOR, 0)
    
    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))
