#!mainFile "../../main.opy"


rule "Genji":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.GENJI
    
    eventPlayer.ult_change_check = 1.2
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()


rule "Increase Shurikens damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.GENJI
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.SECONDARY_FIRE) == true
    
    damage(victim, attacker, eventDamage * 1.074 - eventDamage)
