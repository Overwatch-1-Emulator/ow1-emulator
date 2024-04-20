#!mainFile "../../main.opy"


rule "Hanzo":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HANZO
    
    eventPlayer.ult_change_check = 1.21
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(93.333)


rule "Increase Storm Bow and Hanzo melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.HANZO
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.MELEE) == true
    
    damage(victim, attacker, eventDamage * 1.085 - eventDamage)
