#!mainFile "../../main.opy"


rule "Widowmaker":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.WIDOWMAKER
    
    eventPlayer.ult_change_check = 1.19
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 174, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
