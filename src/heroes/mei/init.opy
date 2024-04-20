#!mainFile "../../main.opy"


rule "Mei":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MEI
    
    eventPlayer.ult_change_check = 1.18
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(80)
    eventPlayer.setMaxAmmo(0, 120)
    eventPlayer.setAmmo(0, 120)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()


rule "mei backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MEI
    @Condition eventPlayer.isUsingAbility1() == true
    
    healPassiveReset()
    eventPlayer.setHealingDealt(1)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    healPassiveReset()
    eventPlayer.setHealingDealt(0)


rule "mei heal (up to 1 bugged heal)":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.MEI
    @Condition eventAbility == Button.ABILITY_1
    
    heal(eventPlayer, eventPlayer, eventHealing * 79)
