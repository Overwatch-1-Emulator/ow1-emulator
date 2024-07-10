#!mainFile "../../dev_main.opy"


rule "[passives/damage/damage_passive.opy]: Remove DPS passive (Dealing damage reduces enemy healing received)":
    @Event playerDealtDamage
    @Condition eventPlayer.getCurrentHero() in getDamageHeroes()
    
    victim.setHealingReceived(percent(100/(100-(OW2_DAMAGE_PASSIVE_HEAL_REDUCTION_PERCENT if victim not in getTankHeroes() else OW2_DAMAGE_PASSIVE_TANK_HEAL_REDUCTION_PERCENT))))
    wait(OW2_DAMAGE_PASSIVE_DURATION, Wait.RESTART_WHEN_TRUE)
    victim.setHealingReceived(100)
