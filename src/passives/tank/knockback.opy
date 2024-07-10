#!mainFile "../../dev_main.opy"

#!define removeTankPassive()\
    eventPlayer.setKnockbackReceived(percent(100/(100-OW2_TANK_KNOCKBACK_REDUCTION_PERCENT)))
