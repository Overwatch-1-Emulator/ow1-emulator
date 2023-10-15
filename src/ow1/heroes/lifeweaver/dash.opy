#!mainFile "../../../main.opy"


rule "[lifeweaver/init.opy]: Allow self healing during Rejuvanating Dash":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    @Condition not eventPlayer.isOnGround()
    @Condition eventPlayer.getAbilityCooldown(Button.JUMP) <= 0

    pushSelfHealing(Button.JUMP)
    waitUntil(eventPlayer.getAbilityCooldown(Button.JUMP) > 0, Math.INFINITY)
    popSelfHealing(Button.JUMP)
