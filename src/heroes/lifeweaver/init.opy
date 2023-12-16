#!mainFile "../../../main.opy"

#!include "heroes/lifeweaver/dash.opy"
#!include "heroes/lifeweaver/grip.opy"
#!include "heroes/lifeweaver/tree.opy"


rule "[lifeweaver/init.opy]: Initialize Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.call_init
    
    newHero(OW1_LIFEWEAVER_HEALTH, 0, 0)
    setUltCost(OW1_LIFEWEAVER_ULT_COST)
    removeSelfHealing()
    
    eventPlayer.call_init = false
