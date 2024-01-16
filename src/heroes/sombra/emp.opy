#!mainFile "../../main.opy"


rule "[sombra/emp.opy]: No damage with EMP":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.getUltCharge() >= 100
    
    waitUntil(eventPlayer.isHoldingButton(Button.ULTIMATE), Math.INFINITY)
    waitUntil(eventPlayer.getUltCharge() <= 0, Math.INFINITY)
    eventPlayer.setDamageDealt(100) # Deal 10000 damage to all barrier
    waitUntil(eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setDamageDealt(percent(eventPlayer.base_damage_scalar))


rule "[sombra/emp.opy]: Remove OW2 EMP damage":
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() == Hero.SOMBRA
    @Condition eventAbility == Button.ULTIMATE

    heal(victim, null, eventDamage)
