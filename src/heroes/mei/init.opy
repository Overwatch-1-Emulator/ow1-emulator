#!mainFile "../../main.opy"

#!include "heroes/mei/blaster.opy"


rule "[mei/init.opy]: Detect switch to Mei":
    @Event eachPlayer
    @Hero ana

    eventPlayer.call_init = true


rule "[mei/init.opy]: Initialize Mei":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.call_init
    
    defaultHero()
    setUltCost(OW1_MEI_ULT_COST)
    eventPlayer.setAmmo(0, OW1_MEI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MEI_CLIP_SIZE)
    eventPlayer.call_init = false
