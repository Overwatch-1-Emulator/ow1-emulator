#!mainFile "../../dev_main.opy"


def initFreja():
    @Name "[freja/init.opy]: initFreja()"
    
    setCustomHp(OW1_FREJA_HEALTH, 0, 0)
    setUltCost(OW1_FREJA_ULT_COST)
    #removeSelfHealing()

    setBaseDamage(eventPlayer, 120/130)
