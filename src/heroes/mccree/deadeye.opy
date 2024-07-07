#!mainFile "../../dev_main.opy"

subroutine startOW1Deadeye


rule "[mccree/deadeye.opy]: OW1 deadeye damage + remove OW2 damage reduction during deadeye":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isUsingUltimate()

    async(startOW1Deadeye, AsyncBehavior.RESTART)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setDamageDealt(percent(eventPlayer._base_damage_scalar))
    eventPlayer.setDamageReceived(100)
    eventPlayer.setMoveSpeed(100)


def startOW1Deadeye():
    @Name "[mccree/deadeye.opy]: startOW1Deadeye()"

    eventPlayer.setDamageDealt(percent(OW1_MCCREE_DEADEYE_DAMAGE/OW2_MCCREE_DEADEYE_DAMAGE))
    eventPlayer.setDamageReceived(percent(100/(100-OW2_MCCREE_DEADEYE_DAMAGE_REDUCTION_MAX)))
    wait(OW2_MCCREE_DEADEYE_PENALTY_DURATION)
    if not eventPlayer.isUsingUltimate(): return
    eventPlayer.setDamageReceived(percent(100/(100-OW2_MCCREE_DEADEYE_DAMAGE_REDUCTION_MIN)))
    eventPlayer.setMoveSpeed(percent(OW2_MCCREE_DEADEYE_MOVE_SPEED_MIN/OW2_MCCREE_DEADEYE_MOVE_SPEED_MAX))
