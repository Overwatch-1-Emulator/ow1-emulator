#!mainFile "../../main.opy"


rule "Lifeweaver":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.LIFEWEAVER
    
    eventPlayer.ult_change_check = 1.04
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxAmmo(0, 14)
    eventPlayer.setAmmo(0, 14)
    eventPlayer.setMaxAmmo(1, 60)
    eventPlayer.setAmmo(1, 60)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 149, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 50, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(120)
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


rule "Reduce Lifeweaver melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.LIFEWEAVER
    @Condition eventAbility == Button.MELEE
    
    #heal(victim, null, eventDamage / 6 - eventDamage)
    #heal(victim, null, eventDamage * 0.167 - eventDamage)
    heal(victim, null, 8)


rule "Reduce Tree of Life healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.LIFEWEAVER
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setHealingDealt(83.333)
    waitUntil(eventPlayer.getUltCharge() != 0, 99999)
    eventPlayer.setHealingDealt(100)


rule "Reduce Tree of Life duration":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.LIFEWEAVER
    @Condition eventPlayer.isUsingUltimate() == true
    
    wait(12)
    eventPlayer.forceButtonPress(Button.ULTIMATE)


/*
rule "(Duplicate) Plat cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.LIFEWEAVER
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) != 0, 99999)
*/
