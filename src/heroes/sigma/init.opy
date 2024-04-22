#!mainFile "../../dev_main.opy"


rule "Sigma":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SIGMA
    
    eventPlayer.ult_change_check = 1.07
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249 if eventPlayer.isDuplicatingAHero() or setting_echo_tank_hp else 299, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 150, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    removeSelfHealing()
    eventPlayer.balance_change_check = 0


rule "Remove Kinetic Grasp overhealth":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SIGMA
    @Condition eventPlayer.isUsingAbility1() == true
    
    wait(1.92)
    if not RULE_CONDITION:
        return
    eventPlayer.setStatusEffect(null, Status.STUNNED, 0.001)
    if eventPlayer.isInSpawnRoom():
        wait(0.1)
        eventPlayer.balance_change_check = eventPlayer.getMaxHealth()
        eventPlayer.balance_change_check -= 450
        eventPlayer.setHealth(eventPlayer.getMaxHealth() - eventPlayer.balance_change_check)


rule "Increase Accretion damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.SIGMA
    @Condition eventAbility == Button.ABILITY_2
    
    damage(victim, attacker, eventDamage * 1.125 - eventDamage)