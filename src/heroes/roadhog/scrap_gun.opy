#!mainFile "../../main.opy"

rule "[roadhog/blade.opy]: OW1 RoadHog Gun Fire Rate":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isFiringPrimaryFire()

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    wait(OW1_ROADHOG_SCRAP_GUN_RECOVERY_TIME)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)


rule "[roadhog/blade.opy]: OW1 RoadHog Gun Fire Rate":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    wait(OW1_ROADHOG_SCRAP_GUN_RECOVERY_TIME)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)