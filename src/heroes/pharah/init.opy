#!mainFile "../../main.opy"


rule "Pharah":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.PHARAH
    
    eventPlayer.ult_change_check = 1.19
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setProjectileSpeed(87.5)


rule "Reset projectile speed for Barrage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.PHARAH
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setProjectileSpeed(100)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setProjectileSpeed(87.5)
