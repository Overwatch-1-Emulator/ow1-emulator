#!mainFile "../../dev_main.opy"

#!include "biotic_grasp.opy"
#!include "biotic_orb.opy"
#!include "coalescence.opy"


def initMoira():
    @Name "[moira/init.opy]: initMoira()"
    
    setCustomHp(OW1_MOIRA_HEALTH, 0, 0)
    setUltCost(OW1_MOIRA_ULT_COST)
    
    removePassiveHealing()



