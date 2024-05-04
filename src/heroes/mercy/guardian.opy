#!mainFile "../../dev_main.opy"

playervar is_using_guardian_angel
playervar is_slingshotting
playervar slingshot_velocity


rule "[mercy/guardian.opy]: Detect Guardian Angel activation":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getSpeed() >= OW1_MERCY_GUARDIAN_ANGEL_MAX_SPEED/2
    @Condition eventPlayer.isUsingAbility1()

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


rule "[mercy/guardian.opy]: Activate GA slingshot":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_using_guardian_angel
    @Condition not eventPlayer.isHoldingButton(Button.JUMP) # wait until below acts as the final condition for activating slingshot
    waitUntil(eventPlayer.is_using_guardian_angel and eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)

    eventPlayer.startForcingButton(Button.ABILITY_1) # Cancel GA by pressing and unpressing button
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    eventPlayer.slingshot_velocity = eventPlayer.getVelocity()
    eventPlayer.is_slingshotting = true
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnGround(), OW1_MERCY_SLINGSHOT_DURATION)
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
    @Condition eventPlayer.is_slingshotting
    
    do:
        eventPlayer.applyImpulse(eventPlayer.slingshot_velocity, 
                                 0.50, # Arbitrarily decided based on trial & error
                                 Relativity.TO_WORLD, 
                                 Impulse.INCORPORATE_CONTRARY_MOTION)
        wait()
    while RULE_CONDITION


rule "[mercy/guardian.opy]: Force angelic descent during slingshot":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_slingshotting == true
    
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.startForcingButton(Button.JUMP)
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
    eventPlayer.stopForcingButton(Button.JUMP)


rule "[mercy/guardian.opy]: Slingshot GA cooldown logic":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_slingshotting == true

    eventPlayer.setAbility1Enabled(false)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.isOnGround(), Math.INFINITY)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_MERCY_GUARDIAN_ANGEL_COOLDOWN)
    eventPlayer.setAbility1Enabled(true)
