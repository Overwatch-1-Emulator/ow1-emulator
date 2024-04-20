#!mainFile "../../main.opy"


rule "Winston":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.WINSTON
    
    eventPlayer.ult_change_check = 1.13
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 299 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 399, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 100, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setDamageDealt(80)


rule "Increase Winston other forms of damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.WINSTON
    @Condition eventAbility != Button.PRIMARY_FIRE
    @Condition eventAbility != Button.ULTIMATE
    
    damage(victim, attacker, eventDamage * 1.25 - eventDamage)


rule "Set default Leap cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.WINSTON
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 6)


rule "Reset Leap cooldown after Primal Rage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.WINSTON
    @Condition eventPlayer.isUsingUltimate() == true
    
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)