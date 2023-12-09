#!mainFile "../../../main.opy"

#!include "heroes/zarya/self_bubble.opy"
#!include "heroes/zarya/ally_bubble.opy"

rule "[zarya/init.opy]: Initialize Zarya":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.call_init

    newHero(OW1_ZARYA_HEALTH, 0, OW1_ZARYA_SHIELDS)

    initSelfBubble()
    initAllyBubble()
    removeTankPassive()

    eventPlayer.call_init = false
    

rule "[zarya/init.opy]: Clean up Zarya":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.ZARYA

    hideSelfBubbleCD()
    hideAllyBubbleCD()
