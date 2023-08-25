#!mainFile "../../../main.opy"

rule "[passives/tank/knockback.opy]: Correct knockback resistance":
    @Event eachPlayer
    @Condition eventPlayer.call_init == true
    @Condition eventPlayer.getCurrentHero() in getTankHeroes()
    @Condition eventPlayer.getCurrentHero() not in [Hero.REINHARDT] # Exception for Reinhardt (Steadfast passive)
    
    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))
