#!mainFile "../../dev_main.opy"

macro removeTankPassive():
    eventPlayer.setKnockbackReceived(percent(100/(100-OW2_TANK_KNOCKBACK_REDUCTION_PERCENT)))
