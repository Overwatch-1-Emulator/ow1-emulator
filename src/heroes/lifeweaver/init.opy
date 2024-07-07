#!mainFile "../../dev_main.opy"


def initLifeweaver():
    @Name "[lifeweaver/init.opy]: initLifeweaver()"
    
    setCustomHp(OW1_LIFEWEAVER_HEALTH, 0, 0)
    setUltCost(OW1_LIFEWEAVER_ULT_COST)
    removeSelfHealing()
    


