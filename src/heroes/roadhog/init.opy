#!mainFile "../../dev_main.opy"

#!include "heroes/roadhog/breather.opy"


rule "Roadhog":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    
    eventPlayer.ult_change_check = 1.07
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAmmo(0, 5)
    eventPlayer.setMaxAmmo(0, 5)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 499 if eventPlayer.isDuplicatingAHero() or setting_echo_tank_hp else 599, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    removeSelfHealing()
    
    eventPlayer.setDamageDealt(87.5)
    eventPlayer.setHealingDealt(percent(ADJ_ROADHOG_BREATHER_HEAL_TOTAL/OW2_ROADHOG_BREATHER_HEAL_TOTAL))


rule "Increase Roadhog melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.138 - eventDamage)


rule "Increase Chain Hook damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventAbility == Button.ABILITY_1
    
    damage(victim, attacker, eventDamage * 3.91 - eventDamage)


rule "Force Chain Hook cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 7)


rule "Increase Pigpen damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventPlayer.isUsingUltimate() == false
    
    damage(victim, attacker, eventDamage * 1.333 - eventDamage)


rule "Wholehog abilities check":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setKnockbackDealt(100)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    enableAllAbilities()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.setDamageDealt(90.625)
    eventPlayer.setKnockbackDealt(35)


rule "Wholehog force autofire":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
