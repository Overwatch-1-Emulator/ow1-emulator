#!mainFile "../../main.opy"

rule "[genji/blade.opy]: OW1 Genji Blade Swing Speed":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    wait(OW1_GENJI_BLADE_SWING_SPEED)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
