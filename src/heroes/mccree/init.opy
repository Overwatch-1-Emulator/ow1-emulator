#!mainFile "../../main.opy"


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


rule "Reduce damage reduction during Combat Roll":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MCCREE
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setDamageReceived(200)
    waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    eventPlayer.setDamageReceived(100)


rule "Remove damage reduction during Deadeye":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MCCREE
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageReceived(133.333)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setDamageReceived(100)
