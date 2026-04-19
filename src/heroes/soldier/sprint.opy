#!mainFile "../../main.opy"


#!mainFile "../../main.opy"


rule "[soldier/sprint.opy]: Disallow Reload while Sprinting":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.disallowButton(Button.RELOAD)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.allowButton(Button.RELOAD)
