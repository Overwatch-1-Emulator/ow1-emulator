#!mainFile "../../main.opy"

#!include "heroes/ramattra/nemesis.opy"


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
    
    eventPlayer.call_init = false
