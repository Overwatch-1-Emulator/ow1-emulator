#!mainFile "../../main.opy"


rule "Baptiste":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    
    eventPlayer.ult_change_check = 0.93
    eventPlayer.removeAllHealthPools()
    #eventPlayer.setAmmo(1, 10)
    #eventPlayer.setMaxAmmo(1, 10)
    eventPlayer.setMaxHealth(80)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    #eventPlayer.addHealthPool(Health.SHIELDS, 25, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(100)
    eventPlayer.setHealingDealt(70)
    eventPlayer.heal_state = 1
    eventPlayer.balance_change_check = true


/*
rule "Increase Baptiste melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.045 - eventDamage)
*/

rule "Increase Biotic Launcher healing":
    @Event playerDealtHealing
    @Condition eventPlayer.balance_change_check == true
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventHealing <= 34
    
    eventPlayer.balance_change_check = false
    heal(healee, healer, eventHealing * 2.857 - eventHealing)
    wait(0.25)
    eventPlayer.balance_change_check = true


rule "Remove initial burst healing from Regenerative Burst and set cooldown for duplicate":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setHealingDealt(0)
    waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    eventPlayer.setHealingDealt(70)
    if eventPlayer.getHeroOfDuplication() == Hero.BAPTISTE:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 13)


rule "Increase Regenerative Burst self healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition healee == healer
    @Condition eventAbility == Button.ABILITY_1
    
    heal(healee, healer, eventHealing * 5.357 - eventHealing)


rule "Increase Regenerative Burst ally healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventAbility == Button.ABILITY_1
    @Condition healee != healer
    
    heal(healee, healer, eventHealing * 2.67 - eventHealing)
