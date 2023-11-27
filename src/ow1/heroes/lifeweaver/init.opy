#!mainFile "../../../main.opy"

#!include "ow1/heroes/lifeweaver/dash.opy"
#!include "ow1/heroes/lifeweaver/grip.opy"
#!include "ow1/heroes/lifeweaver/tree.opy"


rule "[lifeweaver/init.opy]: Initialize Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.call_init
    
    newHero(OW1_LIFEWEAVER_HEALTH, 0, 0)
    removeSelfHealing()
    
    eventPlayer.call_init = false
