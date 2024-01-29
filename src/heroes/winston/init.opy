#!mainFile "../../main.opy"

#!include "heroes/winston/leap.opy"
#!include "heroes/winston/primal.opy"


rule "[winston/init.opy]: Detect switch to Winston":
    @Event eachPlayer
    @Hero winston

    eventPlayer.call_init = true


rule "[winston/init.opy]: Initialize Winston":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.call_init

    newHero(OW1_WINSTON_HEALTH, OW1_WINSTON_ARMOR, 0)
    setUltCost(OW1_WINSTON_ULT_COST)

    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))

    removeTankPassive()
    eventPlayer.call_init = false
