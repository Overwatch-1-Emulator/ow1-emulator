#!mainFile "../../../main.opy"

#!include "ow1/heroes/dva/hp.opy"
#!include "ow1/heroes/dva/booster.opy"
#!include "ow1/heroes/dva/missile.opy"
#!include "ow1/heroes/dva/bomb.opy"


rule "[dva/init.opy]: Initialize DVa":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.call_init
    
    resetHero()
    removeTankPassive()

    eventPlayer.call_init = false
