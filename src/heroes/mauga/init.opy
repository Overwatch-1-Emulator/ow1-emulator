#!mainFile "../../dev_main.opy"


def initMauga():
    @Name "[mauga/init.opy]: initMauga()"
    
    setCustomHp(OW1_MAUGA_HEALTH, OW1_MAUGA_ARMOR, 0)
    setUltCost(OW1_MAUGA_ULT_COST)

    removeTankPassive()
    removeSelfHealing()
    

rule "[mauga/init.opy]: Initialize Mauga":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer._call_init

    initMauga()
    eventPlayer._call_init = false
