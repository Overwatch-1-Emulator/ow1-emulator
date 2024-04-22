#!mainFile "../../dev_main.opy"

#!include "heroes/soldier/biotic_field.opy"


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
    removeSelfHealing()


rule "Increase Heavy Pulse Rifle damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.SOLDIER
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, eventDamage * 1.026 - eventDamage)
