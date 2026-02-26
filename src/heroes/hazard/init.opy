#!mainFile "../../dev_main.opy"


def initHazard():
    @Name "[hazard/init.opy]: initHazard()"
    
    setCustomHp(OW1_HAZARD_HEALTH, OW1_HAZARD_ARMOR, 0)
    setUltCost(OW1_HAZARD_ULT_COST)
    #removeSelfHealing()

    setBaseDamage(eventPlayer, 200/225)
