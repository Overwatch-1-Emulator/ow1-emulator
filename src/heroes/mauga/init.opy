#!mainFile "../../main.opy"


rule "Mauga":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MAUGA
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 299 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 399, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 100, true, true)
    eventPlayer.overhealth_check = false
    eventPlayer.balance_change_check = false
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setDamageDealt(87.5)
    eventPlayer.setHealingDealt(72)
    eventPlayer.startScalingSize(0.94, true)
    eventPlayer.setJumpVerticalSpeed(101)
    eventPlayer.heal_state = 1


rule "Increase Mauga melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.MAUGA
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.14 - eventDamage)


rule "Remove Cardiac Overdrive allied damage reduction and set cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MAUGA
    @Condition eventPlayer.isUsingAbility2() == true
    
    startDamageModification(getPlayersInRadius(eventPlayer, 10.5, eventPlayer.getTeam(), LosCheck.SURFACES).exclude(eventPlayer), getAllPlayers(), 142.8, DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.balance_change_check = getLastDamageModification()
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 16)
    stopDamageModification(eventPlayer.balance_change_check)


rule "Reduce Cage Fight duration":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MAUGA
    @Condition eventPlayer.isUsingUltimate() == true
    
    wait(7)
    eventPlayer.forceButtonPress(Button.ULTIMATE)