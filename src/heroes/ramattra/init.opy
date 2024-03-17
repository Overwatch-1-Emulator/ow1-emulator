#!mainFile "../../ow1pp_main.opy"

#!include "heroes/ramattra/nemesis.opy"
#!include "heroes/ramattra/vortex.opy"


rule "[ramattra/init.opy]: Detect switch to Ramattra":
    @Event eachPlayer
    @Hero ramattra

    eventPlayer.call_init = true


rule "[ramattra/init.opy]: Initialize Ramattra":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.call_init

    newHero(OW1_RAMATTRA_HEALTH, OW1_RAMATTRA_ARMOR, OW1_RAMATTRA_SHIELDS)
    setUltCost(OW1_RAMATTRA_ULT_COST)

    removeTankPassive()
    removePassiveHealing()
    
    eventPlayer.call_init = false
