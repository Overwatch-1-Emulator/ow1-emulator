#!mainFile "../../ow1pp_main.opy"

#!define removeTankPassive()\
    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))
