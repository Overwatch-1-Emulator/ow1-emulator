#!mainFile "../../main.opy"


rule "Doomfist":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.DOOMFIST
    
    eventPlayer.ult_change_check = 0.97
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 349 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 399, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setHealingDealt(0)
    eventPlayer.setKnockbackDealt(80)
    eventPlayer.setDamageDealt(90)


rule "Increase Doomfist melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.DOOMFIST
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.128 - eventDamage)


rule "Increase Rocket Punch damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.DOOMFIST
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    damage(victim, attacker, eventDamage * 1.128 - eventDamage)


rule "Increase Meteor Strike damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.DOOMFIST
    @Condition eventAbility == Button.ULTIMATE
    
    damage(victim, attacker, eventDamage * 1.126 - eventDamage)