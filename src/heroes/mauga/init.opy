#!mainFile "../../main.opy"


rule "[mauga/init.opy]: Detect switch to Mauga":
    @Event eachPlayer
    @Hero mauga

    eventPlayer.call_init = true


rule "[mauga/init.opy]: Initialize Mauga":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.call_init
    
    newHero(OW1_MAUGA_HEALTH, OW1_MAUGA_ARMOR, 0)
    setUltCost(OW1_MAUGA_ULT_COST)
    removeTankPassive()
    
    eventPlayer.call_init = false
