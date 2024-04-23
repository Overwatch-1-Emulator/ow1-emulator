#!mainFile "../../dev_main.opy"

#!include "heroes/mccree/roll.opy"
#!include "heroes/mccree/deadeye.opy"


rule "Cassidy":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MCCREE
    
    eventPlayer.ult_change_check = 1.22
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    
    removeSelfHealing()
