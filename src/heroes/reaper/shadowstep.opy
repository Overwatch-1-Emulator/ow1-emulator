#!mainFile "../../dev_main.opy"



rule "[reaper/shadowstep.opy]: Cleanse on use":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.clearStatusEffect(Status.BURNING)
    