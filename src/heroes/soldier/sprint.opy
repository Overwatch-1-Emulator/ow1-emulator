#!mainFile "../../main.opy"


rule "[soldier/sprint.opy]: Disallow Reload while using Sprint":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setReloadEnabled(false)

    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setReloadEnabled(true)
    eventPlayer.cancelPrimaryAction() # Cancel out reloading after Sprinting ends


rule "[soldier/sprint.opy]: Force reload when using Sprint":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.getMaxAmmo(0) > eventPlayer.getAmmo(0) # Won't cancel if at max ammo

    eventPlayer.cancelPrimaryAction()
    eventPlayer.setReloadEnabled(true)
    wait(TICK_DURATION, Wait.IGNORE_CONDITION)
    eventPlayer.forceButtonPress(Button.RELOAD)
