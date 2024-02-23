#!mainFile "../../main.opy"

#!include "heroes/junkrat/trap.opy"


rule "[junkrat/init.opy]: Detect switch to Junkrat":
    @Event eachPlayer
    @Hero junkrat

    eventPlayer.call_init = true


rule "[junkrat/init.opy]: Initialize Junkrat":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.call_init
    
    defaultHero()
    eventPlayer.setMaxHealth(percent((OW1_JUNKRAT_HEALTH-OW1_JUNKRAT_TIRE_HEALTH)/(OW2_JUNKRAT_HEALTH-OW2_JUNKRAT_TIRE_HEALTH)))
    eventPlayer.addHealthPool(Health.NORMAL, 
                              OW1_JUNKRAT_HEALTH - (OW1_JUNKRAT_HEALTH-OW1_JUNKRAT_TIRE_HEALTH)/(OW2_JUNKRAT_HEALTH-OW2_JUNKRAT_TIRE_HEALTH)*OW2_JUNKRAT_HEALTH, 
                              true, 
                              false)
    setUltCost(OW1_JUNKRAT_ULT_COST)
    removePassiveHealing()

    eventPlayer.call_init = false
