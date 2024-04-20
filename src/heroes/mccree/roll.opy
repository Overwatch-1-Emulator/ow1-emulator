#!mainFile "../../main.opy"


rule "[mccree/roll.opy]: Remove damage reduction during roll":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setDamageReceived(percent(100/(100-OW2_MCCREE_COMBAT_ROLL_DAMAGE_REDUCTION)))
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setDamageReceived(100)