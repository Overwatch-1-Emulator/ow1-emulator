#!include "ow1_constants.opy"

playervar slingshot_initial_velocity
playervar slingshotting

rule "[mercy.opy]: Disable jump and crouch while guardian angel":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    waitUntil(not eventPlayer.isUsingAbility1(), 10)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)

def startSlingshot():
    eventPlayer.applyImpulse(eventPlayer.slingshot_initial_velocity, magnitude(eventPlayer.slingshot_initial_velocity), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.startForcingButton(Button.JUMP) # start angelic descent
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), 10)
    eventPlayer.stopForcingButton(Button.JUMP)
    eventPlayer.slingshotting = false

rule "[mercy.opy]: Detect slingshot":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.slingshotting == false

    waitUntil(eventPlayer.isHoldingButton(Button.JUMP), 10)
    if eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.slingshotting = true

rule "[mercy.opy]: Execute slingshot":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.slingshotting == true

    eventPlayer.slingshot_initial_velocity = eventPlayer.getVelocity() + jump_velocity
    if eventPlayer.isHoldingButton(Button.CROUCH): # add extra jump momentum for superjump
        eventPlayer.slingshot_initial_velocity += 0.25*eventPlayer.getVelocity()
    eventPlayer.forceButtonPress(Button.ABILITY_1) # interrupt GA
    wait() # wait for OW2 GA meter to clear
    startSlingshot()

rule "[mercy.opy]: Slingshot GA cooldown logic":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.slingshotting == true

    eventPlayer.setAbility1Enabled(false)
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), ow1_mercy_guardian_angel_recovery_time)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, ow1_cooldown_ability1_MERCY)
    eventPlayer.setAbility1Enabled(true)
