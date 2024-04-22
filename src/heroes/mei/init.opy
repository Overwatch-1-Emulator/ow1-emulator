#!mainFile "../../dev_main.opy"

#!include "heroes/mei/cryo_freeze.opy"


rule "Mei":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MEI
    
    eventPlayer.ult_change_check = 1.18
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(80)
    eventPlayer.setMaxAmmo(0, 120)
    eventPlayer.setAmmo(0, 120)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeSelfHealing()
