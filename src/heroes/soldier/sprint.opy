#!mainFile "../../main.opy"


rule "[soldier/sprint.opy]: Disallow Reload while Sprinting":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setReloadEnabled(false)

    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setReloadEnabled(true)
    eventPlayer.cancelPrimaryAction() # Cancel out reloading after Sprinting ends


rule "[soldier/sprint.opy]: Disallow Reload while Sprinting":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.getMaxAmmo(0) > eventPlayer.getAmmo(0)

    eventPlayer.cancelPrimaryAction()
    eventPlayer.setReloadEnabled(true)
    wait(TICK_DURATION, Wait.IGNORE_CONDITION)
    eventPlayer.forceButtonPress(Button.RELOAD)