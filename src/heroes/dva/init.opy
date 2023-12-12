#!mainFile "../../../main.opy"

#!include "heroes/dva/hp.opy"
#!include "heroes/dva/gun.opy"
#!include "heroes/dva/booster.opy"
#!include "heroes/dva/missile.opy"
#!include "heroes/dva/bomb.opy"


rule "[dva/init.opy]: Initialize DVa":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.call_init
    
    defaultHero()
    removeTankPassive()

    setCustomHp(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)

    eventPlayer.call_init = false
