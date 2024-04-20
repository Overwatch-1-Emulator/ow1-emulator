#!mainFile "../../main.opy"


rule "Sombra":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SOMBRA
    
    eventPlayer.ult_change_check = 1.14
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(1)
