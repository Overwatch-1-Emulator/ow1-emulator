#!mainFile "../../dev_main.opy"

#!include "hover_jets.opy"
#!include "rocket_launcher.opy"
#!include "concussive.opy"


def initPharah():
    @Name "[pharah/init.opy]: initPharah()"

    setCustomHp(OW1_PHARAH_HEALTH, 0, 0)
    setUltCost(OW1_PHARAH_ULT_COST)
    removeSelfHealing()

    initHoverJets()





rule "[pharah/init.opy]: Clean up Pharah":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.PHARAH
    
    waitUntil(eventPlayer.getCurrentHero() != Hero.PHARAH, Math.INFINITY)
    hideFuelGui()
