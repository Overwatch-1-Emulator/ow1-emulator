#!mainFile "../../../main.opy"

#!include "ow1/heroes/ana/sleep.opy"
#!include "ow1/heroes/ana/nade.opy"

rule "[ana/init.opy]: Initialize Ana":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.call_init == true
    
    defaultHero()

    eventPlayer.setAmmo(0, OW1_ANA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ANA_CLIP_SIZE)

    removeSelfHealing()

    eventPlayer.call_init = false

    # waitUntil(eventPlayer.getCurrentHero() != Hero.ANA, Math.INFINITY)
