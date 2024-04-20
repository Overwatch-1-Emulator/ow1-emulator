#!mainFile "../../main.opy"


rule "[passives/damage/damage_passive.opy]: Remove DPS Passive":
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() in getDamageHeroes() == true
    @Condition attacker != victim
    
    eventPlayer.setHealingReceived(117.65)
    wait(2, Wait.RESTART_WHEN_TRUE)
    eventPlayer.setHealingReceived(100)

