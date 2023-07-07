#!mainFile "../../main.opy"

playervar is_using_guardian_angel
playervar slingshot_initial_velocity
playervar is_slingshotting

subroutine initMercy
subroutine startSlingshot

rule "[mercy.opy]: Initialize mercy":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initMercy()
    eventPlayer.initialized = true


def initMercy():
    eventPlayer.setAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.is_using_guardian_angel = false
    eventPlayer.is_slingshotting = false


rule "[mercy.opy]: Disable jump and crouch while guardian angel":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_using_guardian_angel
    
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    waitUntil(updateEveryTick(not eventPlayer.is_using_guardian_angel), 9999)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)


rule "[mercy.opy]: Define Guardian Angel":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.getSpeed() > OW1_MERCY_MAX_REGULAR_MOVE_SPEED

    eventPlayer.is_using_guardian_angel = true
    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.is_using_guardian_angel = false


rule "[mercy.opy]: Define GA slingshot":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_using_guardian_angel == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP)

    eventPlayer.slingshot_initial_velocity = eventPlayer.getVelocity() + OW1_JUMP_SPEED*Vector.UP
    # if eventPlayer.isHoldingButton(Button.CROUCH): # add extra vertical momentum for superjump
    #     eventPlayer.slingshot_initial_velocity += eventPlayer.getVelocity()/3
    eventPlayer.cancelPrimaryAction()
    startSlingshot()

rule "[mercy.opy]: Slingshot GA cooldown logic":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.is_slingshotting == true

    eventPlayer.setAbility1Enabled(false)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1) or eventPlayer.getAltitude() <= 0, 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_MERCY_GUARDIAN_ANGEL_COOLDOWN)
    eventPlayer.setAbility1Enabled(true)

def startSlingshot():
    @Name "[mercy.opy]: startSlingshot()"
    eventPlayer.is_slingshotting = true
    eventPlayer.applyImpulse(eventPlayer.slingshot_initial_velocity, magnitude(eventPlayer.slingshot_initial_velocity), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.startForcingButton(Button.JUMP) # start angelic descent
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), 99999)
    eventPlayer.stopForcingButton(Button.JUMP)
    eventPlayer.is_slingshotting = false
