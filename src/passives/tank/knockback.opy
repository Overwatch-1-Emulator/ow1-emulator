#!mainFile "../../main.opy"

subroutine removeTankPassive

def removeTankPassive():
    @Name "[passives/tank/knockback.opy]: removeTankPassive()"

    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))
