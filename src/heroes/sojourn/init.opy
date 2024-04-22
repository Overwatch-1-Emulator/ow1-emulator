#!mainFile "../../dev_main.opy"


rule "Sojourn":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SOJOURN
    
    eventPlayer.ult_change_check = 1.1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    
    removeSelfHealing()
