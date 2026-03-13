#!mainFile "../../dev_main.opy"


rule "[reinhardt/barrier.opy]: OW1 Reinhardt barrier health":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) <= 0

    eventPlayer.setMaxHealth(percent(OW1_REINHARDT_BARRIER_HEALTH/OW2_REINHARDT_BARRIER_HEALTH))
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    waitUntil(eventPlayer.isFiringSecondaryFire(), 1)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))

    waitUntil(not eventPlayer.isFiringSecondaryFire())
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
