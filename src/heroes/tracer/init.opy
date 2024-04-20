#!mainFile "../../main.opy"


rule "Tracer":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.TRACER
    
    eventPlayer.ult_change_check = 1.18
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 5)
    eventPlayer.setMaxHealth(85.714)
    #resetHealth()
    #eventPlayer.addHealthPool(Health.NORMAL, 174, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(91.667)
    eventPlayer.startScalingSize(0.96, true)


rule "Increase Tracer melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.TRACER
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.117 - eventDamage)


rule "Increase Pulse Bomb damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.TRACER
    @Condition eventAbility == Button.ULTIMATE
    
    damage(victim, attacker, eventDamage * 1.1 - eventDamage)
