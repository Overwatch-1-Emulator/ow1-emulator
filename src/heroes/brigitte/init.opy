#!mainFile "../../main.opy"

#!include "heroes/brigitte/bash.opy"
#!include "heroes/brigitte/whipshot.opy"
#!include "heroes/brigitte/rally.opy"
#!include "heroes/brigitte/inspire.opy"

rule "[brigitte/init.opy]: Detect switch to Brigitte":
    @Event eachPlayer
    @Hero brigitte

    eventPlayer.call_init = true


rule "[brigitte/init.opy]: Initialize Brigitte":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.call_init == true
    
    newHero(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    setUltCost(OW1_BRIGITTE_ULT_COST)
    removeSelfHealing()
    
    eventPlayer.call_init = false


rule "[brigitte/init.opy]: OW1 Flail damage":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(victim, null, eventDamage - eventDamage*(OW1_BRIGITTE_FLAIL_DAMAGE/OW2_BRIGITTE_FLAIL_DAMAGE))
