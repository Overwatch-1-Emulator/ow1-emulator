#!mainFile "../../main.opy"

playervar slingshot_initial_velocity
playervar slingshotting

subroutine startSlingshot

def initMercy():
    eventPlayer.setAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MERCY_CLIP_SIZE)

rule "[mercy.opy]: Initialize mercy":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initMercy()
    eventPlayer.initialized = true

rule "[mercy.opy]: Change GA Cooldown":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingAbility1() == true and eventPlayer.isHoldingButton(Button.JUMP) == true or eventPlayer.isUsingAbility1() == true and eventPlayer.isHoldingButton(Button.CROUCH) == true and eventPlayer.isUsingUltimate() == false

    waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)

rule "[mercy.opy]: Disable jump and crouch while guardian angel":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    waitUntil(not eventPlayer.isUsingAbility1(), 10)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)

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

    eventPlayer.slingshot_initial_velocity = eventPlayer.getVelocity() + OW1_JUMP_SPEED*Vector.UP
    if eventPlayer.isHoldingButton(Button.CROUCH): # add extra vertical momentum for superjump
        eventPlayer.slingshot_initial_velocity += eventPlayer.getVelocity()/3
    eventPlayer.forceButtonPress(Button.ABILITY_1) # interrupt GA
    wait() # wait for OW2 GA meter to clear
    startSlingshot()

rule "[mercy.opy]: Slingshot GA cooldown logic":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.slingshotting == true

    eventPlayer.setAbility1Enabled(false)
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), OW1_MERCY_GUARDIAN_ANGEL_RECOVERY_TIME)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_MERCY_GUARDIAN_ANGEL_COOLDOWN)
    eventPlayer.setAbility1Enabled(true)

def startSlingshot():
    @Name "[mercy.opy]: startSlingshot()"
    eventPlayer.applyImpulse(eventPlayer.slingshot_initial_velocity, magnitude(eventPlayer.slingshot_initial_velocity), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.startForcingButton(Button.JUMP) # start angelic descent
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), 99999)
    eventPlayer.stopForcingButton(Button.JUMP)
    eventPlayer.slingshotting = false