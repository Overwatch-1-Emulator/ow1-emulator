#!mainFile "../../main.opy"


rule "[soldier/sprint.opy]: Disallow Reload while Sprinting":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setReloadEnabled(false)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setReloadEnabled(true)
    eventPlayer.cancelPrimaryAction() # Cancel out reloading after Sprinting ends
