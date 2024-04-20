#!mainFile "../../main.opy"


rule "Ramattra":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(65)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 349 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 399, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.startScalingSize(0.94, true)
    eventPlayer.setJumpVerticalSpeed(101)


rule "Correct Nemesis Form armor, movement speed, and cooldown for duplicate":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.getMaxHealthOfType(Health.ARMOR) == true
    
    eventPlayer.setMoveSpeed(83.4)
    eventPlayer.addHealthPool(Health.ARMOR, 28, true, true)
    waitUntil(eventPlayer.getMaxHealthOfType(Health.ARMOR) < 29, 99999)
    eventPlayer.setMoveSpeed(100)
    if not RULE_CONDITION:
        return
    removeHealthPool(getLastCreatedHealthPool())
    #if eventPlayer.getHeroOfDuplication() == Hero.RAMATTRA:
    #waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) != 0, 99999)
    #eventPlayer.setAbilityCooldown(Button.ABILITY_1, 9)


rule "Increase Pummel damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.getMaxHealthOfType(Health.ARMOR) == true
    @Condition eventDamage >= 50
    @Condition eventAbility != Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.169 - eventDamage)


rule "Disable Block after use":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.getMaxHealthOfType(Health.ARMOR) == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 999999986991104)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(false)
    waitUntil(eventPlayer.getMaxHealthOfType(Health.ARMOR) < 29, 99999)
    wait(0.25)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)


rule "Set Ravenous Vortex cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.isUsingAbility2() == true
    
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0, 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 12)


rule "Bonus Annihilation movement speed":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.isUsingUltimate() == true
    
    wait()
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)


/*
rule "Reset Nemesis bonus armor when going into Annihilation":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getMaxHealthOfType(Health.ARMOR) == true
    
    removeHealthPool(getLastCreatedHealthPool())
    eventPlayer.addHealthPool(Health.ARMOR, 15, true, true)
*/