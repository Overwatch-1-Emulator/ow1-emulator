#!mainFile "../../dev_main.opy"

#!include "heroes/doomfist/punch.opy"


rule "Doomfist":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.DOOMFIST
    
    eventPlayer.ult_change_check = 0.97
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 349 if eventPlayer.isDuplicatingAHero() or setting_echo_tank_hp else 399, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setHealingDealt(0)
    eventPlayer.setKnockbackDealt(80)
    
    removeSelfHealing()
