#!mainFile "../../main.opy"


rule "Junker Queen":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.JUNKER_QUEEN
    
    eventPlayer.ult_change_check = 1.07
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxAmmo(0, 6)
    eventPlayer.setAmmo(0, 6)
    eventPlayer.overhealth_check = false
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 349 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 399, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setHealingDealt(74.29)
    eventPlayer.setDamageDealt(87.5)
    eventPlayer.heal_state = 1


rule "Correct Commanding Shout overhealth while outside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.JUNKER_QUEEN
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.overhealth_check == false
    
    damage(eventPlayer, null, 50)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility1() == false, 99999)
    eventPlayer.overhealth_check = false


rule "Correct Commanding Shout overhealth while inside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.JUNKER_QUEEN
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition eventPlayer.overhealth_check == false
    
    eventPlayer.setHealth(eventPlayer.getMaxHealth() - 50)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility1() == false, 99999)
    eventPlayer.overhealth_check = false


rule "Reduce Rampage Damage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.JUNKER_QUEEN
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(66.777)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setDamageDealt(87.5)
