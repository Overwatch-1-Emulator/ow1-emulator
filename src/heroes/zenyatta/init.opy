#!mainFile "../../../main.opy"

#!include "heroes/zenyatta/transc.opy"

rule "[zenyatta/init.opy]: Initialize Zenyatta":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.call_init
    
    newHero(OW1_ZENYATTA_HEALTH, 0, OW1_ZENYATTA_SHIELDS)
    eventPlayer.setAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZENYATTA_CLIP_SIZE)

    eventPlayer.setKnockbackDealt(5)

    removeSelfHealing()
    eventPlayer.call_init = false