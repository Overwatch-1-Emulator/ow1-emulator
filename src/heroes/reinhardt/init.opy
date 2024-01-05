#!mainFile "../../main.opy"

#!include "heroes/reinhardt/hammer.opy"
#!include "heroes/reinhardt/firestrike.opy"
#!include "heroes/reinhardt/charge.opy"
#!include "heroes/reinhardt/shatter.opy"


rule "[reinhardt/init.opy]: Initialize Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.call_init

    newHero(OW1_REINHARDT_HEALTH, OW1_REINHARDT_ARMOR, 0)
    setUltCost(OW1_REINHARDT_ULT_COST)

    eventPlayer.setDamageDealt(percent(OW1_REINHARDT_GLOBAL_DAMAGE))

    removeTankPassive()

    eventPlayer.call_init = false
