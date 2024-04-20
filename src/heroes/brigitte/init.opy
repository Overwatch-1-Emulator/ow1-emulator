#!mainFile "../../main.opy"


rule "Brigitte":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.BRIGITTE
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 149, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 50, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(77.888)
    eventPlayer.setHealingDealt(80)
    eventPlayer.heal_state = 1


rule "Increase Brigitte damage on most abilities":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.BRIGITTE
    @Condition eventAbility != Button.PRIMARY_FIRE
    
    damage(victim, attacker, eventDamage * 1.286 - eventDamage)


rule "Increase Inspire self healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BRIGITTE
    @Condition healee == healer
    
    heal(healee, null, eventHealing * 1.246 - eventHealing)


rule "Increase Repair Pack healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BRIGITTE
    @Condition eventAbility == Button.ABILITY_2
    
    heal(healee, healer, eventHealing * 1.25 - eventHealing)


rule "Extra Repair Pack burst healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BRIGITTE
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventHealing >= 19
    
    heal(healee, healer, 10)
