#!mainFile "../../main.opy"


rule "[lucio/soundwave.opy]: OW1 Soundwave damage":
    @Event playerDealtDamage
    @Hero lucio
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    heal(victim, null, eventDamage - eventDamage*(OW1_LUCIO_SOUNDWAVE_DAMAGE/OW2_LUCIO_SOUNDWAVE_DAMAGE))
