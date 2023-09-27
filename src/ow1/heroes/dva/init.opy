#!mainFile "../../../main.opy"

#!include "ow1/heroes/dva/hp.opy"
#!include "ow1/heroes/dva/booster.opy"
#!include "ow1/heroes/dva/missile.opy"


rule "[dva/init.opy]: Initialize DVa":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.call_init
    
    resetHero()
    waitUntil(not eventPlayer.isInAlternateForm(), 1)
    setCustomHealth(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)
    removeTankPassive()

    eventPlayer.call_init = false
