#!mainFile "../../dev_main.opy"

#!include "heroes/brigitte/inspire.opy"
#!include "heroes/brigitte/whipshot.opy"
#!include "heroes/brigitte/bash.opy"


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
    setBaseDamage(eventPlayer, ADJ_BRIGITTE_FLAIL_DAMAGE/OW2_BRIGITTE_FLAIL_DAMAGE)
    eventPlayer.setHealingDealt(80)

    removeSelfHealing()


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
