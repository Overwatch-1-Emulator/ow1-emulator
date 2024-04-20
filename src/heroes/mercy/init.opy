#!mainFile "../../dev_main.opy"


rule "Mercy":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MERCY
    
    eventPlayer.ult_change_check = 1.04
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAmmo(0, 20)
    eventPlayer.setMaxAmmo(0, 20)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(109.1)


rule "Reduce Valkyrie healing":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MERCY
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setHealingDealt(100)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setHealingDealt(109.1)
