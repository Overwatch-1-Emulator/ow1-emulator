#!mainFile "../../dev_main.opy"


rule "[mccree/roll.opy]: Reduce damage reduction during roll":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MCCREE
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setDamageReceived(
        percent((100-ADJ_MCCREE_COMBAT_ROLL_DAMAGE_REDUCTION)/(100-OW2_MCCREE_COMBAT_ROLL_DAMAGE_REDUCTION)))
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setDamageReceived(100)
