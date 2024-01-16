#!mainFile "../../main.opy"


rule "[dva/bomb.opy]: Force reset ult charge when DVa pops out of Mech":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()

    if eventPlayer.isUsingUltimate(): return
    eventPlayer.setUltCharge(0)
