#!mainFile "../../dev_main.opy"


rule "[lifeweaver/init.opy]: Detect switch to Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver

    eventPlayer.call_init = true


rule "[lifeweaver/init.opy]: Initialize Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.call_init
    
    newHero(OW1_LIFEWEAVER_HEALTH, 0, 0)
    setUltCost(OW1_LIFEWEAVER_ULT_COST)
    removePassiveHealing()
    
    eventPlayer.call_init = false
