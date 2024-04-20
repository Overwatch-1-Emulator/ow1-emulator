#!mainFile "../../main.opy"


rule "Reinhardt":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    
    eventPlayer.ult_change_check = 1.07
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(114.3)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 150 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 250, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setKnockbackReceived(115)
    eventPlayer.stopForcingThrottle()
    eventPlayer.setDamageDealt(80)


rule "Force single Firestrike":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setDamageDealt(83.4)
    waitUntil(not eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setDamageDealt(80)
    #Every time rein uses firestrike, reset the resource to 0
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 0)
    wait(6)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)


/*
rule "Increase Firestrike damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventAbility == Button.ABILITY_2
    @Condition (not eventPlayer.isUsingAbility2()) == false
    
    damage(victim, attacker, eventDamage * 1.053 - eventDamage)
*/


rule "Increase Charge damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventAbility == Button.ABILITY_1
    #Checks for pin vs boop damage
    @Condition eventDamage > 100
    
    damage(victim, attacker, eventDamage * 1.321 - eventDamage)


rule "Reduce Charge radius":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.startForcingThrottle(0, 0.667, 0, 0.667, 0, 0.667)
    waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    eventPlayer.stopForcingThrottle()


rule "Increase Earthshatter damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 100
    
    damage(victim, attacker, eventDamage * 1.708 - eventDamage)


rule "Increase Firestrike damage (early animation)":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setDamageDealt(83.333)
    wait(1)
    eventPlayer.setDamageDealt(80)
