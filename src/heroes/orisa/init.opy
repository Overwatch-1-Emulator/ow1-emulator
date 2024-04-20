#!mainFile "../../main.opy"


rule "Orisa":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ORISA
    
    eventPlayer.ult_change_check = 1.12
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 299, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 150 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 200, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()


rule "Correct Fortify overhealth while outside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ORISA
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.overhealth_check == false
    #@Condition eventPlayer.getHealthOfType(Health.ARMOR) >= 0.1
    
    damage(eventPlayer, null, 181.8)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility1() == false, 99999)
    eventPlayer.overhealth_check = false


rule "Correct Fortify overhealth while inside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ORISA
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition eventPlayer.overhealth_check == false
    
    eventPlayer.setHealth(eventPlayer.getMaxHealth() - 100)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility1() == false, 99999)
    eventPlayer.overhealth_check = false


rule "Reduce Terra Surge damage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ORISA
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(80)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setDamageDealt(100)
