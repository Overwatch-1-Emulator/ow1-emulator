#!mainFile "../../dev_main.opy"

#!include "heroes/lucio/soundwave.opy"
#!include "heroes/lucio/aura.opy"


rule "[lucio/init.opy]: Detect switch to Lucio":
    @Event eachPlayer
    @Hero lucio

    eventPlayer.call_init = true


rule "[lucio/init.opy]: Initialize Lucio":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.call_init
    
    newHero(OW1_LUCIO_HEALTH, 0, 0)
    setUltCost(OW1_LUCIO_ULT_COST)
    removeSelfHealing()

    eventPlayer.setKnockbackDealt(percent(OW1_LUCIO_SOUNDWAVE_KNOCKBACK/OW2_LUCIO_SOUNDWAVE_KNOCKBACK))

    eventPlayer.call_init = false


rule "[lucio/init.opy]: OW1 Sonic Amplifier damage":
    @Event playerDealtDamage
    @Hero lucio
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_LUCIO_SOUND_GUN_DAMAGE/OW2_LUCIO_SOUND_GUN_DAMAGE) - eventDamage)
