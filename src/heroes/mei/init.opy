#!mainFile "../../dev_main.opy"

#!include "heroes/mei/blaster.opy"
#!include "heroes/mei/cryo_freeze.opy"


def initMei():
    @Name "[mei/init.opy]: initMei()"
    
    setCustomHp(OW1_MEI_HEALTH, 0, 0)
    setUltCost(OW1_MEI_ULT_COST)

    setBaseDamage(eventPlayer, OW1_MEI_ICICLE_DAMAGE/OW2_MEI_ICICLE_DAMAGE)

    eventPlayer.setAmmo(0, OW1_MEI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MEI_CLIP_SIZE)

    removeSelfHealing()



