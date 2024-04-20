#!mainFile "../../main.opy"


rule "Illari":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ILLARI
    
    eventPlayer.ult_change_check = 1.04
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxAmmo(0, 14)
    eventPlayer.setAmmo(0, 14)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(75)
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


rule "Increase Illari melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ILLARI
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.34 - eventDamage)


rule "Increase Solar Rifle damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ILLARI
    @Condition eventWasCriticalHit == false
    @Condition eventDamage < 119
    @Condition eventAbility != Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.267 - eventDamage)


rule "Increase Solar Rifle critical hit damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ILLARI
    @Condition eventWasCriticalHit == true
    
    damage(victim, attacker, eventDamage * 1.327 - eventDamage)


rule "Reduce Solar Rifle healing":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ILLARI
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.setHealingDealt(91.27)
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 99999)
    eventPlayer.setHealingDealt(100)


/*
rule "(Duplicate) Healing Pylon cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.ILLARI
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)
*/
