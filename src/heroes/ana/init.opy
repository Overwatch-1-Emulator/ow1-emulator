#!mainFile "../../main.opy"

#!include "heroes/ana/sleep.opy"
#!include "heroes/ana/nade.opy"

rule "[ana/init.opy]: Detect switch to Ana":
    @Event eachPlayer
    @Hero ana

    eventPlayer.call_init = true


rule "[ana/init.opy]: Initialize Ana":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.call_init == true
    
    newHero(OW1_ANA_HEALTH, 0, 0)
    setUltCost(OW1_ANA_ULT_COST)

    eventPlayer.setAmmo(0, OW1_ANA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ANA_CLIP_SIZE)

    removePassiveHealing()

    eventPlayer.call_init = false

    # waitUntil(eventPlayer.getCurrentHero() != Hero.ANA, Math.INFINITY)
