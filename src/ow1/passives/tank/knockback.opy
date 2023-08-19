rule "[passives/tank/knockback.opy]: Correct knockback resistance":
    @Event eachPlayer
    @Condition eventPlayer.initialized == false

    if eventPlayer.getCurrentHero() not in getTankHeroes(): # Do nothing for non tanks
        return
    if eventPlayer.getCurrentHero() == Hero.REINHARDT: # Do nothing for Reinhardt (Steadfast passive)
        return 
    
    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))
