#!mainFile "../../main.opy"


rule "Kiriko":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 5)
    eventPlayer.setAmmo(1, 12)
    eventPlayer.setMaxAmmo(1, 12)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


rule "Heal when using Swift Step":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.startHoT(eventPlayer, 0.25, 200)


/*
rule "Heal when using Protection Suzu":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    eventPlayer.startHoT(eventPlayer, 0.65, 123)
*/

/*
rule "Unlock Swift Step while in LoS":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    @Condition isInLoS(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()), BarrierLos.PASS_THROUGH_BARRIERS) == true
    
    eventPlayer.setAbility1Enabled(true)
*/

/*
rule "Lock Swift Step while not in LoS":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    @Condition isInLoS(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()), BarrierLos.PASS_THROUGH_BARRIERS) == false
    
    eventPlayer.setAbility1Enabled(false)
*/

rule "kiri suzu backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    
    if eventPlayer.getMaxHealth() != eventPlayer.getHealth():
        healPassiveReset()
