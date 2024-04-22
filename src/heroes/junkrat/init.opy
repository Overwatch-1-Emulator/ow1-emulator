#!mainFile "../../dev_main.opy"


rule "Junkrat":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.JUNKRAT
    
    eventPlayer.ult_change_check = 1.18
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    #resetHealth()
    #Version or the "resetHealth" subroutine that keeps tire at 100 hp
    wait()
    eventPlayer.setHealingReceived(0)
    eventPlayer.setHealth(200)
    eventPlayer.addHealthPool(Health.NORMAL, 1, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 1, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 1, true, true)
    eventPlayer.removeAllHealthPools()
    #eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    
    removeSelfHealing()
