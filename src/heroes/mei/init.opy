#!mainFile "../../dev_main.opy"

#!include "heroes/mei/blaster.opy"
#!include "heroes/mei/cryo_freeze.opy"


rule "[mei/init.opy]: Initialize Mei":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer._call_init
    
    setCustomHp(OW1_MEI_HEALTH, 0, 0)
    setUltCost(OW1_MEI_ULT_COST)
    eventPlayer.setAmmo(0, OW1_MEI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MEI_CLIP_SIZE)
    removeSelfHealing()

    eventPlayer._call_init = false
