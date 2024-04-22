#!mainFile "../../dev_main.opy"


rule "Symmetra":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SYMMETRA
    
    eventPlayer.ult_change_check = 1.17
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(75)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 99, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 125, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    startHealingModification(eventPlayer, eventPlayer, 0, HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
    removeSelfHealing()
