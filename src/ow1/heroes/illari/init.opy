#!mainFile "../../../main.opy"

#!include "ow1/heroes/illari/outburst.opy"
#!include "ow1/heroes/illari/pylon.opy"


rule "[illari/init.opy]: Initialize Illari":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.call_init
    
    resetHero()
    setCustomHealth(OW1_ILLARI_HEALTH, 0, 0)
    removeSelfHealing()
    eventPlayer.call_init = false
