#!mainFile "../../main.opy"


rule "Moira":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MOIRA
    
    eventPlayer.ult_change_check = 0.95
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


rule "Prevent fading during coalescence":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MOIRA
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setMoveSpeed(107.143)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setAbility1Enabled(true)


rule "moira backup (up to 18 bugged heal)":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MOIRA
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.heal_state == 1
    
    eventPlayer.heal_state = 0
    healPassiveReset()
    waitUntil(eventPlayer.isUsingAbility1(), 99999)
    waitUntil(not eventPlayer.isUsingAbility1(), 9999999)
    healPassiveReset()
    eventPlayer.heal_state = 1
