#!mainFile "../../dev_main.opy"

#!include "heroes/baptiste/regen_burst.opy"


rule "Baptiste":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    
    eventPlayer.ult_change_check = 0.93
    eventPlayer.removeAllHealthPools()
    #eventPlayer.setAmmo(1, 10)
    #eventPlayer.setMaxAmmo(1, 10)
    eventPlayer.setMaxHealth(80)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    #eventPlayer.addHealthPool(Health.SHIELDS, 25, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(100)
    setBaseHealing(eventPlayer, 0.7)
    eventPlayer.balance_change_check = true

    removeSelfHealing()


# rule "Increase Baptiste melee damage":
#     @Event playerDealtDamage
#     @Condition eventPlayer.hero_setup == Hero.BAPTISTE
#     @Condition eventAbility == Button.MELEE
    
#     damage(victim, attacker, eventDamage * 1.045 - eventDamage)


rule "Increase Biotic Launcher healing":
    @Event playerDealtHealing
    @Condition eventPlayer.balance_change_check == true
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventHealing <= 34
    
    eventPlayer.balance_change_check = false
    heal(healee, healer, eventHealing * 2.857 - eventHealing)
    wait(0.25)
    eventPlayer.balance_change_check = true
