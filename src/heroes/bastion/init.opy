#!mainFile "../../dev_main.opy"


rule "Bastion":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.BASTION
    
    eventPlayer.ult_change_check = 1.21
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 100, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()

    removeSelfHealing()
