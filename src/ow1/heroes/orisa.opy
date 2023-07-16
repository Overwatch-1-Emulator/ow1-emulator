#!mainFile "../../main.opy"

globalvar PHI = Math.PI * (sqrt(5)-1) # golden angle in radians

playervar all_enemies

playervar halt_position
playervar halt_ending_position
playervar halt_visible
playervar is_using_halt
playervar halt_exploded
playervar halt_victims
playervar halted
playervar halt_attacker
playervar position
playervar halt_effect_ids

playervar barrier_position
playervar barrier_orientation
playervar barrier_sample_x
playervar barrier_sample_y
playervar barrier_sample_z
playervar barrier_sample_radius
playervar barrier_sample_theta
playervar barrier_sample_point
playervar barrier_sample_points
playervar barrier_entity_ids

subroutine initOrisa
subroutine initHaltGui
subroutine shootHalt
subroutine explodeHalt

subroutine throwBarrier
subroutine deployBarrier
subroutine destroyBarrier
subroutine fibonacciSphere

rule "[orisa.opy]: Detect Orisa initialization":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initOrisa()
    eventPlayer.initialized = true


def initOrisa():
    @Name "[orisa.opy]: initOrisa()"

    while (eventPlayer.getMaxHealth() != OW1_ORISA_HEALTH + OW1_ORISA_ARMOR):
        clearCustomHealth()
        setCustomHealth(OW1_ORISA_HEALTH, OW1_ORISA_ARMOR, 0)
        wait(1)
    
    eventPlayer.halt_visible = false
    eventPlayer.is_using_halt = false
    eventPlayer.halt_exploded = false

    eventPlayer.disallowButton(Button.SECONDARY_FIRE) # Disable OW2 Javelin
    eventPlayer.disallowButton(Button.ABILITY_2) # Disable OW2 Javelin Spin

    initHaltGui()


def initHaltGui():
    @Name "[orisa.opy]: initHaltGui()"

    createEffect(getAllPlayers() if eventPlayer.halt_visible else null, Effect.SPHERE, Color.LIME_GREEN, eventPlayer.halt_position, OW1_ORISA_HALT_PROJECTILE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers() if eventPlayer.halt_visible else null, Effect.SPHERE, Color.LIME_GREEN, eventPlayer.halt_position, 0.5*OW1_ORISA_HALT_PROJECTILE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


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
    eventPlayer.halt_victims.halted = true


rule "[orisa.opy]: Pull halted victims":
    @Event eachPlayer
    @Condition eventPlayer.halted == true

    eventPlayer.position = eventPlayer.getPosition()
    eventPlayer.startForcingPosition(eventPlayer.position, true)
    chase(eventPlayer.position, eventPlayer.halt_attacker.halt_position, rate=OW1_ORISA_HALT_PULL_SPEED, ChaseReeval.DESTINATION_AND_RATE)
    waitUntil(eventPlayer.position == eventPlayer.halt_attacker.halt_position, 9999)
    stopChasingVariable(eventPlayer.position)
    eventPlayer.stopForcingPosition()
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Cancel current momentum
    eventPlayer.halted = false


rule "[orisa.opy]: Create Halt pull line vfx":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.halt_visible == true

    eventPlayer.halt_effect_ids = []
    eventPlayer.all_enemies = getPlayers(getOppositeTeam(eventPlayer.getTeam()))
    for i in range(len(eventPlayer.all_enemies)):
        createBeam(getAllPlayers() if (distance(eventPlayer.halt_position, eventPlayer.all_enemies[evalOnce(i)]) <= OW1_ORISA_HALT_AOE_RADIUS) and isInLoS(eventPlayer.halt_position, eventPlayer.all_enemies[evalOnce(i)], BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) else null, Beam.GOOD, eventPlayer.halt_position, eventPlayer.all_enemies[evalOnce(i)], Color.LIME_GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.halt_effect_ids.append(getLastCreatedEntity())


rule "[orisa.opy]: Destroy Halt pull line vfx":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.halt_visible == false

    for i in range(len(eventPlayer.halt_effect_ids)):
        destroyEffect(eventPlayer.halt_effect_ids[i])


rule "[orisa.opy]: Trigger Projectile Barrier ability":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true

    throwBarrier()
    destroyBarrier()
    deployBarrier()

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME)


def throwBarrier(): # Select shield position and orientation
    @Name "[orisa.opy]: throwBarrier()"

    eventPlayer.barrier_orientation = getLateralFacingDirection(eventPlayer)
    eventPlayer.barrier_position = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 1000*eventPlayer.getFacingDirection(), null, null, false).getHitPosition()
    eventPlayer.barrier_position -= OW1_ORISA_PROTECTIVE_BARRIER_RADIUS*eventPlayer.barrier_orientation


def destroyBarrier():
    @Name "[orisa.opy]: destroyBarrier()"

    for i in range(len(eventPlayer.barrier_entity_ids)):
        destroyEffect(eventPlayer.barrier_entity_ids[i])

    eventPlayer.barrier_entity_ids = []


def deployBarrier(): # Create shield visual object
    @Name "[orisa.opy]: deployBarrier()"

    # Debug barrier center
    # createEffect(eventPlayer, Effect.SPHERE, Color.BLACK, eventPlayer.barrier_position, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    fibonacciSphere()

    # Draw each barrier sample
    for i in range(len(eventPlayer.barrier_sample_points)):
        eventPlayer.barrier_sample_point = eventPlayer.barrier_sample_points[i]
        createEffect(getAllPlayers(), Effect.SPHERE, eventPlayer.getTeam(), evalOnce(eventPlayer.barrier_sample_point), sqrt(1*OW1_ORISA_PROTECTIVE_BARRIER_RADIUS**2/OW1_ORISA_PROTECTIVE_BARRIER_RESOLUTION), EffectReeval.NONE)
        eventPlayer.barrier_entity_ids.append(getLastCreatedEntity())

    
def fibonacciSphere():
    @Name "[orisa.opy]: fibonacciSphere()"
    # Evenly distribute N points around a sphere
    # Store coodrindate of those points to barrier_sample_points array
    # See https://stackoverflow.com/a/26127012 for algorithm

    eventPlayer.barrier_sample_points = []

    for i in range(OW1_ORISA_PROTECTIVE_BARRIER_RESOLUTION):
        eventPlayer.barrier_sample_y = 1 - (i / (OW1_ORISA_PROTECTIVE_BARRIER_RESOLUTION-1)) * 2
        if (eventPlayer.barrier_sample_y < -0.2): break # Do not draw bottom half of sphere
        eventPlayer.barrier_sample_radius = sqrt(1 - eventPlayer.barrier_sample_y * eventPlayer.barrier_sample_y)

        eventPlayer.barrier_sample_theta = PHI * i

        eventPlayer.barrier_sample_x = cos(eventPlayer.barrier_sample_theta) * eventPlayer.barrier_sample_radius
        eventPlayer.barrier_sample_z = sin(eventPlayer.barrier_sample_theta) * eventPlayer.barrier_sample_radius

        eventPlayer.barrier_sample_point = vect(eventPlayer.barrier_sample_x, eventPlayer.barrier_sample_y, eventPlayer.barrier_sample_z)
        if angleBetweenVectors(eventPlayer.barrier_sample_point, eventPlayer.barrier_orientation) > 90: continue # Do not draw back half of sphere
        eventPlayer.barrier_sample_points.append(OW1_ORISA_PROTECTIVE_BARRIER_RADIUS * eventPlayer.barrier_sample_point + eventPlayer.barrier_position)