#!mainFile "../../../main.opy"

playervar is_using_guardian_angel
playervar is_slingshotting


rule "[mercy/guardian.opy]: Initialize Guardian Angel Ability":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.call_init == true

    eventPlayer.is_using_guardian_angel = false
    eventPlayer.is_slingshotting = false


rule "[mercy/guardian.opy]: Detect Guardian Angel activation":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.getSpeed() >= OW1_MERCY_GUARDIAN_ANGEL_MAX_SPEED/2

    eventPlayer.is_using_guardian_angel = true
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.is_using_guardian_angel = false


rule "[mercy/guardian.opy]: Disable jump and crouch during guardian angel":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_using_guardian_angel
    
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    waitUntil(not eventPlayer.is_using_guardian_angel, Math.INFINITY)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)


rule "[mercy/guardian.opy]: Define GA slingshot":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_using_guardian_angel == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP)

    eventPlayer.cancelPrimaryAction()
    eventPlayer.is_slingshotting = true
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnGround(), 3)
    eventPlayer.is_slingshotting = false


rule "[mercy/guardian.opy]: Apply upwards momentum when starting slingshot":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_slingshotting == true

    eventPlayer.applyImpulse(Vector.UP, 
                             OW1_JUMP_SPEED , 
                             Relativity.TO_WORLD, 
                             Impulse.INCORPORATE_CONTRARY_MOTION)


rule "[mercy/guardian.opy]: Give speed boost during slingshot":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_slingshotting == true
    
    eventPlayer.setMoveSpeed(300)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    waitUntil(eventPlayer.isOnGround(), 1)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.stopForcingThrottle()


rule "[mercy/guardian.opy]: Force angelic descent during slingshot":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_slingshotting == true
    
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.startForcingButton(Button.JUMP)
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), 99999)
    eventPlayer.stopForcingButton(Button.JUMP)


rule "[mercy/guardian.opy]: Slingshot GA cooldown logic":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_slingshotting == true

    eventPlayer.setAbility1Enabled(false)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.isOnGround(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_MERCY_GUARDIAN_ANGEL_COOLDOWN)
    eventPlayer.setAbility1Enabled(true)
