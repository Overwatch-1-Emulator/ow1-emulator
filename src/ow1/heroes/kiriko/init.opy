#!mainFile "../../../main.opy"


rule "[kiriko/init.opy]: Initialize Kiriko":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.call_init
    
    resetHero()
    setCustomHealth(OW1_KIRIKO_HEALTH, 0, 0)
    eventPlayer.setHealingDealt(percent(OW1_KIRKIO_OFUDA_HEALING/OW2_KIRKIO_OFUDA_HEALING))
    removeSelfHealing()
    eventPlayer.call_init = false


rule "[kiriko.opy]: Allow self healing during Suzu":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility2()

    pushSelfHealing(Button.ABILITY_2)
    waitUntil(eventPlayer.isUsingAbility2() == false, Math.INFINITY)
    popSelfHealing(Button.ABILITY_2)


#!include "ow1/heroes/kiriko/suzu.opy"
#!include "ow1/heroes/kiriko/step.opy"
