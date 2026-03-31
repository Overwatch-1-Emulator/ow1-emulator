#!mainFile "../../main.opy"

#!include "hp.opy"
#!include "gun.opy"
#!include "booster.opy"
#!include "micro_missiles.opy"
#!include "bomb.opy"


def initDva():
    @Name "[dva/init.opy]: initDva()"


    setUltCost(OW1_DVA_ULT_COST)
    setCustomHp(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)

    setBaseDamage(eventPlayer, OW1_DVA_BOOSTERS_DAMAGE/OW2_DVA_BOOSTERS_DAMAGE)
