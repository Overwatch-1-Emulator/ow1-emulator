#!mainFile "../../dev_main.opy"


rule "[lucio/amp.opy]: Increase knockback during amp":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingAbility2()
    
    eventPlayer.setKnockbackDealt(percent(1.6*OW1_LUCIO_SOUNDWAVE_KNOCKBACK/OW2_LUCIO_SOUNDWAVE_KNOCKBACK))
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    eventPlayer.setKnockbackDealt(percent(OW1_LUCIO_SOUNDWAVE_KNOCKBACK/OW2_LUCIO_SOUNDWAVE_KNOCKBACK))
