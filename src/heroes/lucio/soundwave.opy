#!mainFile "../../dev_main.opy"


rule "[lucio/soundwave.opy]: OW1 Soundwave damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.LUCIO
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    heal(victim, null, eventDamage - eventDamage*(OW1_LUCIO_SOUNDWAVE_DAMAGE/OW2_LUCIO_SOUNDWAVE_DAMAGE))
