#!mainFile "../../dev_main.opy"

#!include "hammer.opy"
#!include "firestrike.opy"
#!include "charge.opy"
#!include "shatter.opy"


def initReinhardt():
    @Name "[reinhardt/init.opy]: initReinhardt()"

    setCustomHp(OW1_REINHARDT_HEALTH, OW1_REINHARDT_ARMOR, 0)
    setUltCost(OW1_REINHARDT_ULT_COST)
    setBaseDamage(eventPlayer, OW1_REINHARDT_FIRESTRIKE_DAMAGE/OW2_REINHARDT_FIRESTRIKE_DAMAGE)

    removeSelfHealing()
    eventPlayer.setKnockbackReceived(percent((100 - OW1_REINHARDT_STEADFAST_KNOCKBACK_REDUCTION_PERCENT)/(100 - OW2_TANK_KNOCKBACK_REDUCTION_PERCENT)))



