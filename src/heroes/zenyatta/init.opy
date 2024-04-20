#!mainFile "../../main.opy"


rule "Zenyatta":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZENYATTA
    
    eventPlayer.ult_change_check = 0.97
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAmmo(0, 20)
    eventPlayer.setMaxAmmo(0, 20)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 99, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 100, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setKnockbackDealt(7)
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1
