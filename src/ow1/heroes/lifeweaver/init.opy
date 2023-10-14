#!mainFile "../../../main.opy"


rule "[lifeweaver/init.opy]: Initialize Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.call_init
    
    resetHero()
    setCustomHealth(OW1_LIFEWEAVER_HEALTH, 0, 0)
    removeSelfHealing()
    eventPlayer.call_init = false


rule "[lifeweaver/init.opy]: Allow self healing during Rejuvanating Dash":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    @Condition not eventPlayer.isOnGround()
    @Condition eventPlayer.getAbilityCooldown(Button.JUMP) <= 0

    pushSelfHealing(Button.JUMP)
    waitUntil(eventPlayer.getAbilityCooldown(Button.JUMP) > 0, Math.INFINITY)
    popSelfHealing(Button.JUMP)


rule "[lifeweaver/init.opy]: Allow self healing during Tree of Life":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isUsingUltimate()

    pushSelfHealing(Button.ULTIMATE)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    popSelfHealing(Button.ULTIMATE)
