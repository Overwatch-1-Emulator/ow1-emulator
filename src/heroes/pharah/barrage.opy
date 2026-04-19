#!mainFile "../../main.opy"


rule "[pharah/barrage.opy]: Remove Movespeed on Barrage":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.stopForcingThrottle()
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)