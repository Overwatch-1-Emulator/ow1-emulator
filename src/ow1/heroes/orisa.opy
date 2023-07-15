#!mainFile "../../main.opy"

playervar halt_position
playervar halt_ending_position
playervar halt_visible
playervar is_using_halt
playervar halt_exploded
playervar halt_victims
playervar halt_attacker
playervar position
playervar halt_effect_id

subroutine initOrisa
subroutine initHaltGui
subroutine shootHalt
subroutine explodeHalt

rule "[orisa.opy]: Detect Orisa initialization":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initOrisa()
    eventPlayer.initialized = true


def initOrisa():
    @Name "[orisa.opy]: initOrisa()"

    eventPlayer.disallowButton(Button.SECONDARY_FIRE) # Disable OW2 Javelin

    eventPlayer.halt_visible = false
    eventPlayer.is_using_halt = false
    eventPlayer.halt_exploded = false

    initHaltGui()


def initHaltGui():
    @Name "[orisa.opy]: initHaltGui"

    createEffect(eventPlayer if eventPlayer.halt_visible else null, Effect.SPHERE, Color.LIME_GREEN, eventPlayer.halt_position, OW1_ORISA_HALT_PROJECTILE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(eventPlayer if eventPlayer.halt_visible else null, Effect.SPHERE, Color.LIME_GREEN, eventPlayer.halt_position, 0.5*OW1_ORISA_HALT_PROJECTILE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "[orisa.opy]: Trigger Halt ability":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true

    # Initialize Halt variables
    eventPlayer.halt_victims = []

    eventPlayer.is_using_halt = true # Start Halt ability
    shootHalt()
    eventPlayer.halt_visible = true
    waitUntil(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false, 9999)
    waitUntil(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true or (eventPlayer.halt_position == eventPlayer.halt_ending_position), 9999) # Detect halt activation
    explodeHalt()
    eventPlayer.halt_visible = false
    eventPlayer.is_using_halt = false # End Halt ability

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_ORISA_HALT_COOLDOWN_TIME)


def shootHalt():
    @Name "[orisa.opy]: Shoot Halt Orb"

    # Calculate starting/ending positions
    eventPlayer.halt_position = eventPlayer.getEyePosition()
    eventPlayer.halt_ending_position = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 1000*eventPlayer.getFacingDirection(), null, null, true).getHitPosition()

    wait(OW1_ORISA_HALT_LAUNCH_CAST_TIME)
    chase(eventPlayer.halt_position, eventPlayer.halt_ending_position, rate=OW1_ORISA_HALT_PROJECTILE_SPEED, ChaseReeval.DESTINATION_AND_RATE)


def explodeHalt():
    @Name "[orisa.opy]: Explode Halt Orb"

    stopChasingVariable(eventPlayer.halt_position)
    wait(OW1_ORISA_HALT_ACTIVATION_TIME)
    eventPlayer.halt_victims = getPlayersInRadius(eventPlayer.halt_position, OW1_ORISA_HALT_AOE_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES_AND_ENEMY_BARRIERS)
    eventPlayer.halt_victims.halt_attacker = eventPlayer


rule "[orisa.opy]: Pull halted victims":
    @Event eachPlayer
    @Condition eventPlayer.halt_attacker != null

    
    createBeam(getAllPlayers(), Beam.GOOD, eventPlayer, eventPlayer.halt_attacker.halt_position, Color.LIME_GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.halt_effect_id = getLastCreatedEntity()

    eventPlayer.position = eventPlayer.getPosition()
    eventPlayer.startForcingPosition(eventPlayer.position, true)
    chase(eventPlayer.position, eventPlayer.halt_attacker.halt_position, rate=OW1_ORISA_HALT_PULL_SPEED, ChaseReeval.DESTINATION_AND_RATE)
    waitUntil(eventPlayer.position == eventPlayer.halt_attacker.halt_position, 9999)
    stopChasingVariable(eventPlayer.position)
    eventPlayer.stopForcingPosition()
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Cancel current momentum

    destroyEffect(eventPlayer.halt_effect_id)
    eventPlayer.halt_attacker = null