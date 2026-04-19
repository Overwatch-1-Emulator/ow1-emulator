#!mainFile "../../main.opy"



rule "[soldier/sprint.opy]: Disallow Reload While Spring":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isReloading() and eventPlayer.isUsingAbility1()

    eventPlayer.cancelPrimaryAction()
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.allowButton(Button.RELOAD)