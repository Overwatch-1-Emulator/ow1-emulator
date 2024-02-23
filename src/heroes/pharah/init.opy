#!mainFile "../../main.opy"

#!include "heroes/pharah/hover_jets.opy"
#!include "heroes/pharah/rocket_launcher.opy"


rule "[pharah/init.opy]: Detect switch to Pharah":
    @Event eachPlayer
    @Hero pharah

    eventPlayer.call_init = true


rule "[pharah/init.opy]: Initialize Pharah":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.call_init

    newHero(OW1_PHARAH_HEALTH, 0, 0)
    setUltCost(OW1_PHARAH_ULT_COST)
    removeSelfHealing()

    eventPlayer.setSecondaryFireEnabled(false)

    eventPlayer.jet_fuel = 100
    showFuelGui()

    eventPlayer.call_init = false


rule "[pharah/init.opy]: Clean up Pharah":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.PHARAH
    
    hideFuelGui()
