#!mainFile "../../main.opy"

#!include "heroes/illari/outburst.opy"
#!include "heroes/illari/pylon.opy"


rule "[illari/init.opy]: Initialize Illari":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.call_init
    
    newHero(OW1_ILLARI_HEALTH, 0, 0)
    setUltCost(OW1_ILLARI_ULT_COST)
    removeSelfHealing()
    eventPlayer.call_init = false
