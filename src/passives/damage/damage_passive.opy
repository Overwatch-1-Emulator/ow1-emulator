#!mainFile "../../main.opy"


rule "[passives/damage/damage_passive.opy]: Remove DPS passive (Dealing damage reduces enemy healing received)":
    @Event playerDealtDamage
    @Condition eventPlayer.getCurrentHero() in getDamageHeroes()
    
    victim.setHealingReceived(percent(100/(100-OW2_DAMAGE_PASSIVE_HEAL_REDUCTION)))
    wait(OW2_DAMAGE_PASSIVE_DURATION)
    victim.setHealingReceived(100)
