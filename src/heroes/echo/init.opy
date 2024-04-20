#!mainFile "../../main.opy"

globalvar Setting_echo_tank_hp = createWorkshopSetting(bool, "General Changes", "Full Echo Tank HP", false, 0)

playervar duplicate_leftover_health


rule "Echo":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ECHO
    
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(94.444)
    if eventPlayer.isInSpawnRoom() == false:
        damage(eventPlayer, null, eventPlayer.duplicate_leftover_health)


rule "Increase Tri-Shot and Echo melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ECHO
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.MELEE) == true
    
    damage(victim, attacker, eventDamage * 1.064 - eventDamage)


rule "Bonus Ultimate charge while in Duplicate":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero() == true
    @Condition eventPlayer.getUltCharge() == 0
    
    wait()
    eventPlayer.setUltCharge(4 + (16 * (eventPlayer.ult_change_check - 1)))


rule "Check health when exiting Duplicate":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero() == true
    
    eventPlayer.hero_setup = eventPlayer.getHeroOfDuplication()
    eventPlayer.duplicate_leftover_health = 100
    wait(15)
    eventPlayer.duplicate_leftover_health = 0


rule "(Duplicate) Seismic Slam cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DOOMFIST
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 7)


rule "(Duplicate) Power Block cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DOOMFIST
    @Condition eventPlayer.isUsingAbility2() == true
    
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 9)


rule "(Duplicate) Cardiac Overdrive cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MAUGA
    @Condition eventPlayer.isUsingAbility2() == true
    
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 16)


rule "(Duplicate) Overrun cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MAUGA
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)


rule "(Duplicate) Charge cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)


rule "(Duplicate) Kinetic Grasp cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.SIGMA
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) != 0, 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 13)


rule "(Duplicate) Storm Arrow cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.HANZO
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)


rule "(Duplicate) Concussion Mine cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.JUNKRAT
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)


/*
rule "(Duplicate) Shadow Step cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.REAPER
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 8)
*/

rule "(Duplicate) Biotic Field cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.SOLDIER
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 15)


rule "(Duplicate) Recall cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.TRACER
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 12)


rule "(Duplicate) Sleep Dart cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.ANA
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) != 0, 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 12)
