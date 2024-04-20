#!mainFile "../../main.opy"


rule "Reaper":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REAPER
    
    eventPlayer.ult_change_check = 1.14
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


rule "Increase Hellfire Shotgun damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REAPER
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isUsingUltimate() == false
    
    damage(victim, attacker, eventDamage * 1.094 - eventDamage)


rule "Reduce Death Blossom damage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REAPER
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(91.891)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setDamageDealt(100)


rule "reaper backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REAPER
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2()) == true
    
    healPassiveReset()
    eventPlayer.setHealingDealt(0)
    waitUntil(not (eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2()), 99999)
    healPassiveReset()
    eventPlayer.setHealingDealt(100)
