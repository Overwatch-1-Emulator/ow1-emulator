#!mainFile "../../dev_main.opy"


rule "[lifeweaver/init.opy]: Initialize Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer._call_init
    
    setCustomHp(OW1_LIFEWEAVER_HEALTH, 0, 0)
    setUltCost(OW1_LIFEWEAVER_ULT_COST)
    removeSelfHealing()
    
    eventPlayer._call_init = false
