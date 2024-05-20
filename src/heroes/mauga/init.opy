#!mainFile "../../dev_main.opy"


rule "[mauga/init.opy]: Initialize Mauga":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer._call_init
    
    setCustomHp(OW1_MAUGA_HEALTH, OW1_MAUGA_ARMOR, 0)
    setUltCost(OW1_MAUGA_ULT_COST)

    removeTankPassive()
    removeSelfHealing()
    
    eventPlayer._call_init = false
