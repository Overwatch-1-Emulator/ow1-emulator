#!mainFile "../../main.opy"

rule "[dva/gun.opy]: OW1 DVa movement penalty when shooting":
    @Event eachPlayer
    @Hero dva
    @Condition not eventPlayer.isInAlternateForm()
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition not eventPlayer.isUsingAbility1()

    setMoveModifier(eventPlayer, MoveMod.DVA_GUN, (1-OW1_DVA_MOVE_PENALTY)/(1-OW2_DVA_MOVE_PENALTY))


rule "[dva/gun.opy]: Remove movement penalty when not shooting":
    @Event eachPlayer
    @Hero dva
    @Condition not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    clearMoveModifier(eventPlayer, MoveMod.DVA_GUN)


rule "[dva/gun.opy]: Remove movement penalty when flying":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingAbility1()

    clearMoveModifier(eventPlayer, MoveMod.DVA_GUN)