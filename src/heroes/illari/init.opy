#!mainFile "../../main.opy"

#!include "heroes/illari/sun.opy"


rule "[illari/init.opy]: Detect switch to Illari":
    @Event eachPlayer
    @Hero illari

    eventPlayer.call_init = true


rule "[illari/init.opy]: Initialize Illari":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.call_init
    
    newHero(OW1_ILLARI_HEALTH, 0, 0)
    setUltCost(OW1_ILLARI_ULT_COST)
    removePassiveHealing()
    eventPlayer.call_init = false
