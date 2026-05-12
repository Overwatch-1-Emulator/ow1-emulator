#!mainFile "../../main.opy"


rule "[passives/global/global_passive.opy]: Remove DPS passive (Dealing damage reduces enemy healing received)":
    @Event playerDealtDamage
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.ana_nade_ally == false or eventPlayer.ana_nade_enmemy == false

    victim.setHealingReceived(percent(100/(100-(OW2_DAMAGE_PASSIVE_HEAL_REDUCTION_PERCENT if victim.role != Role.TANK else OW2_DAMAGE_PASSIVE_TANK_HEAL_REDUCTION_PERCENT))))
    wait(OW2_DAMAGE_PASSIVE_DURATION, Wait.RESTART_WHEN_TRUE)
    victim.setHealingReceived(100)
