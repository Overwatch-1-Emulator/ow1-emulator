#!mainFile "../../main.opy"


rule "Wrecking Ball":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    
    eventPlayer.ult_change_check = 1.05
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(75)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 399 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 449, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 50 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 100, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    #eventPlayer.startScalingSize(0.9, true)
    #eventPlayer.setJumpVerticalSpeed(104)


rule "Force Grappling Hook cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0.1, 999999986991104)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 5)


/*
rule "Correct Adaptive Shields overhealth while outside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.overhealth_check == false
    
    damage(eventPlayer, null, 100)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility2() == false, 99999)
    eventPlayer.overhealth_check = false
*/

/*
rule "Correct Adaptive Shields overhealth while inside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition eventPlayer.overhealth_check == false
    
    eventPlayer.setHealth(eventPlayer.getMaxHealth() - 100)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility2() == false, 99999)
    eventPlayer.overhealth_check = false
*/

/*
rule "Enable Adaptive Shields when near enemy players":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition getPlayersInRadius(eventPlayer, 8.9, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF) >= 1
    
    eventPlayer.setAbility2Enabled(true)
*/

/*
rule "Disable Adaptive Shields when not near enemy players":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition getPlayersInRadius(eventPlayer, 8.9, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF) <= 0
    
    eventPlayer.setAbility2Enabled(false)
*/

rule "Remove Adaptive Shields overhealth transfer":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.setAbility2Enabled(false)
    waitUntil(not eventPlayer.isUsingAbility2(), 999999986991104)
    enableAllAbilities()
    eventPlayer.allowButton(Button.ABILITY_2)


/*
rule "(Duplicate) pile cooldown":
*/