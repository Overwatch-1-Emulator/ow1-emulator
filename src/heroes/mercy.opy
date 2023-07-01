#!include "ow1_constants.opy"

playervar slingshot_initial_velocity

rule "[mercy.opy]: Disable jump and crouch while guardian angel":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1), 10)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)

def startSlingshot():
    eventPlayer.applyImpulse(eventPlayer.slingshot_initial_velocity, magnitude(eventPlayer.slingshot_initial_velocity), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.startForcingButton(Button.JUMP) # start angelic descent
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), 10)
    eventPlayer.stopForcingButton(Button.JUMP)

rule "[mercy.opy]: Custom GA + jump combo logic":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.slingshot_initial_velocity = eventPlayer.getVelocity() + jump_velocity
    eventPlayer.forceButtonPress(Button.ABILITY_1) # interrupt GA
    wait() # wait for GA meter to clear
    startSlingshot()

rule "[mercy.opy]: Slingshot GA cooldown logic":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false

    waitUntil(eventPlayer.isHoldingButton(Button.JUMP), 10)
    if eventPlayer.isHoldingButton(Button.JUMP):
        eventPlayer.setAbility1Enabled(false)
        waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), ow1_mercy_guardian_angel_recovery_time)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, ow1_cooldown_ability1_MERCY)
        eventPlayer.setAbility1Enabled(true)
