#!mainFile "../../dev_main.opy"

#!include "heroes/lucio/aura.opy"


rule "Lucio":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.LUCIO
    
    eventPlayer.ult_change_check = 1.02
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setKnockbackDealt(89.286)
    eventPlayer.setHealingDealt(100)
    eventPlayer.setDamageDealt(66.667)

    removeSelfHealing()


rule "Increase Lucio melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.LUCIO
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.778 - eventDamage)


rule "Increase Sonic Amplifier damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.LUCIO
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, eventDamage * 2.018 - eventDamage)
