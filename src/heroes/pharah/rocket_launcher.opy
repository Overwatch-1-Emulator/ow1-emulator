#!mainFile "../../main.opy"


rule "[pharah/rocket_launcher.opy]: OW1 Pharah fire rate":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.isFiringPrimaryFire()

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    wait(OW1_PHARAH_ROCKET_LAUNCHER_RECOVERY_TIME)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
