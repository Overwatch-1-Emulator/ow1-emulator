#!mainFile "../../main.opy"


rule "Soldier 76":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SOLDIER
    
    eventPlayer.ult_change_check = 1.2
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    heal(eventPlayer, null, 1)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(86.4)
    eventPlayer.heal_state = 1


rule "Increase Heavy Pulse Rifle damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.SOLDIER
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, eventDamage * 1.026 - eventDamage)


/*
rule "76 backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SOLDIER
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.heal_state == 0
    
    eventPlayer.heal_state = 1
    eventPlayer.setHealingDealt(1)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0, 9999999)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0, 9999999)
    eventPlayer.setHealingDealt(0)
    eventPlayer.heal_state = 0
*/

/*
rule "76 heal":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.SOLDIER
    @Condition eventAbility == Button.ABILITY_2
    
    heal(eventPlayer, null, eventHealing * 87.6)
*/