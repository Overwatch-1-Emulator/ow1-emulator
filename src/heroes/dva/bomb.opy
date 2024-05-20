#!mainFile "../../dev_main.opy"


rule "[dva/bomb.opy]: Force reset ult charge when DVa pops out of Mech":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.DVA
    @Condition eventPlayer.isInAlternateForm()

    if eventPlayer.isUsingUltimate(): return
    eventPlayer.setUltCharge(0)
