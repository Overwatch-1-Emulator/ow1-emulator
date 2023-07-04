#!mainFile "../../main.opy"

/*
This DPS doomfist workshop script is sourced from
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474

This file was created by decompiling the original 
workshop gamemode through OverPy, and editing the 
rules/functions as needed.
*/

enum SlamType:
    GROUND,
    INDICATOR

playervar i

# Variables for uppercut
playervar pressing_uppercut_key
playervar shift_pressed_by_bot
playervar is_using_uppercut
playervar enemies_in_uppercut_radius
playervar enemies_in_uppercut_view
playervar enemies_hit_by_uppercut
playervar uppercut_cooldown

# Variables for slam
playervar pressing_slam_key
playervar e_pressed_by_bot
playervar is_using_slam
playervar slam_to_use
playervar current_position
playervar proto_slam_destination
playervar final_slam_destination

subroutine initDoomfist
subroutine initSlamIndicatorGui
subroutine executeUppercut
subroutine detectUpercutHit
subroutine executeSlam
subroutine initiateGroundSlam
subroutine initiateIndicatorSlam

rule "[doomfist.opy]: Initialize Doomfist":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initDoomfist()
    eventPlayer.initialized = true


def initDoomfist():
    @Name "[doomfist.opy]: initDoomfist"
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)

    eventPlayer.setMaxHealth(55.556)
    eventPlayer.setKnockbackReceived(142.895)

    eventPlayer.shift_pressed_by_bot = false
    eventPlayer.e_pressed_by_bot = false
    
    initSlamIndicatorGui()


def initSlamIndicatorGui():
    # #BOTTOM LINE
    # createBeam(eventPlayer, Beam.GOOD, updateEveryTick(eventPlayer.slam_raycast_end_position + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0)) * 0.75) + vect(0, 0.15, 0)), updateEveryTick(eventPlayer.slam_raycast_end_position + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * -0.75) + vect(0, 0.15, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    # eventPlayer.BottomLine = getLastCreatedEntity()
    # #TOP LINE
    # createBeam(eventPlayer, Beam.GOOD, updateEveryTick(eventPlayer.slam_raycast_end_position + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * 4.463) + vect(0, 0.15, 0), updateEveryTick(eventPlayer.slam_raycast_end_position + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * -4.463) + vect(0, 0.15, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    # eventPlayer.TopLine = getLastCreatedEntity()
    # #RIGHT SIDE
    # createBeam(eventPlayer, Beam.GOOD, updateEveryTick(eventPlayer.slam_raycast_end_position + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0)) * 0.75) + vect(0, 0.15, 0)), updateEveryTick(eventPlayer.slam_raycast_end_position + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * 4.463) + vect(0, 0.15, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    # eventPlayer.RightLine = getLastCreatedEntity()
    # #LEFT SIDE
    # createBeam(eventPlayer, Beam.GOOD, updateEveryTick(eventPlayer.slam_raycast_end_position + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * -4.463) + vect(0, 0.15, 0), updateEveryTick(eventPlayer.slam_raycast_end_position + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * -0.75) + vect(0, 0.15, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    # eventPlayer.LeftLine = getLastCreatedEntity()
    # eventPlayer.diamond_indicator = [eventPlayer.BottomLine, eventPlayer.TopLine, eventPlayer.RightLine, eventPlayer.LeftLine]

rule "[doomfist.opy]: Detect shift key press by human":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.shift_pressed_by_bot == false

    eventPlayer.pressing_uppercut_key = true
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1), 9999)
    eventPlayer.pressing_uppercut_key = false


rule "[doomfist.opy]: Detect e key press by human":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.e_pressed_by_bot == false

    eventPlayer.pressing_slam_key = true
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2), 9999)
    eventPlayer.pressing_slam_key = false


rule "[doomfist.opy]: Control flow for uppercut":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.pressing_uppercut_key == true
    @Condition eventPlayer.is_using_slam == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition not eventPlayer.hasStatusEffect(Status.HACKED)

    executeUppercut()


rule "[doomfist.opy]: Control flow for slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.pressing_slam_key == true
    @Condition eventPlayer.is_using_uppercut == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not eventPlayer.hasStatusEffect(Status.HACKED)

    executeSlam()


def executeUppercut():
    @Name "[doomfist.opy]: Execute main logic for Rising Uppercut ability"

    eventPlayer.is_using_uppercut = true # Start of uppercut
    eventPlayer.disablePlayerCollision() # Doomfist phases through enemies during uppercut
    eventPlayer.disallowButton(Button.MELEE) # Doomfist cannot melee during uppercut
    eventPlayer.disallowButton(Button.PRIMARY_FIRE) # Doomfist cannot shoot during uppercut
    eventPlayer.setSecondaryFireEnabled(false) # Doomfist cannot punch during uppercut

    # Uppercut physics
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Cancel current momentum
    eventPlayer.applyImpulse(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z), 5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Move laterally in the facing direction
    eventPlayer.setGravity(0) # Override gravity during uppercut
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0) # Deny player from inputting movement commands
    detectUpercutHit()
    wait(0.15)
    eventPlayer.applyImpulse(Vector.UP, 40, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.1)
    eventPlayer.applyImpulse(Vector.DOWN, max(0, eventPlayer.getSpeedInDirection(Vector.UP)), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait()
    eventPlayer.applyImpulse(vect(0, 1, 0), 2.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.setGravity(0)
    eventPlayer.is_using_uppercut = false # End of uppercut
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_DOOMFIST_UPPERCUT_COOLDOWN)
    eventPlayer.enablePlayerCollision()
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)
    wait(0.35)
    eventPlayer.stopForcingThrottle()
    wait(0.15)
    eventPlayer.setGravity(50)
    wait(0.25)
    eventPlayer.setGravity(100)


def detectUpercutHit():
    @Name "[doomfist.opy]: Detect enemies hit by Uppercut"

    eventPlayer.enemies_in_uppercut_radius = getPlayersInRadius(eventPlayer, OW1_DOOMFIST_UPPERCUT_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES_AND_ENEMY_BARRIERS) # Find enemies in uppercut range
    eventPlayer.enemies_in_uppercut_view = eventPlayer.getPlayersInViewAngle(getOppositeTeam(eventPlayer.getTeam()), 45) # Find enemies in 45 degree FOV

    # enemies_hit_by_uppercut = Union(enemies_in_uppercut_radius, enemies_in_uppercut_view)
    eventPlayer.enemies_hit_by_uppercut = []
    for eventPlayer.i in range(len(eventPlayer.enemies_in_uppercut_radius)):
        if eventPlayer.enemies_in_uppercut_radius[eventPlayer.i] in eventPlayer.enemies_in_uppercut_view:
            eventPlayer.enemies_hit_by_uppercut.append(eventPlayer.enemies_in_uppercut_radius[eventPlayer.i])

    for eventPlayer.i in range(len(eventPlayer.enemies_hit_by_uppercut)):
        damage(eventPlayer.enemies_hit_by_uppercut[eventPlayer.i], eventPlayer, OW1_DOOMFIST_UPPERCUT_DAMAGE)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer.enemies_hit_by_uppercut[eventPlayer.i], 1)
        playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer.enemies_hit_by_uppercut[eventPlayer.i].getPosition(), 100)
        eventPlayer.enemies_hit_by_uppercut[eventPlayer.i].applyImpulse(Vector.UP, 15, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        eventPlayer.enemies_hit_by_uppercut[eventPlayer.i].applyImpulse(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        

def executeSlam():
    @Name "[doomfist.opy]: Execute main logic for Seismic Slam ability"

    if eventPlayer.getAltitude() >= 3:
        eventPlayer.slam_to_use = SlamType.INDICATOR
    else:
        eventPlayer.slam_to_use = SlamType.GROUND

    if eventPlayer.slam_to_use == SlamType.INDICATOR:
        initiateIndicatorSlam()
    else if eventPlayer.slam_to_use == SlamType.GROUND:
        initiateGroundSlam()
    else:
        initiateGroundSlam()

    if eventPlayer.is_using_slam == true:
        waitUntil(not eventPlayer.isUsingAbility1(), 9999)
        eventPlayer.is_using_slam = false
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.uppercut_cooldown)
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_DOOMFIST_SLAM_COOLDOWN)


def initiateGroundSlam():
    eventPlayer.is_using_slam = true
    eventPlayer.setGravity(0)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)

    # Start slam animation
    eventPlayer.uppercut_cooldown = eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.shift_pressed_by_bot = true
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.shift_pressed_by_bot = false
    eventPlayer.disallowButton(Button.ABILITY_1)

    wait() # wait for doom to start moving
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # immediately cancel momentum
    eventPlayer.applyImpulse(normalize(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z)) + vect(0, 0.075, 0), 16, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # apply custom momentum
    wait(0.3)
    eventPlayer.setGravity(100)
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.stopForcingThrottle()


def initiateIndicatorSlam():
    # Calculate destination
    # First raycast max range towards the direction the crosshair is aimed at
    eventPlayer.proto_slam_destination = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + OW1_DOOMFIST_SLAM_RADIUS*eventPlayer.getFacingDirection(), null, getAllPlayers(), false).getHitPosition()
    # Then drop straight down vertically
    eventPlayer.final_slam_destination = raycast(eventPlayer.proto_slam_destination, eventPlayer.proto_slam_destination+OW1_DOOMFIST_SLAM_RADIUS*Vector.DOWN, null, getAllPlayers(), false).getHitPosition()

    # If vertical distance is greater than the margin, it's invalid.
    if distance(eventPlayer.final_slam_destination, eventPlayer.proto_slam_destination) > OW1_DOOMFIST_INDICATOR_SLAM_MARGIN:
        return

    eventPlayer.is_using_slam = true
    eventPlayer.setGravity(0)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)

    # Start slam animation
    eventPlayer.uppercut_cooldown = eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.shift_pressed_by_bot = true
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.shift_pressed_by_bot = false
    eventPlayer.disallowButton(Button.ABILITY_1)

    eventPlayer.current_position = eventPlayer.getPosition()
    chase(eventPlayer.current_position, eventPlayer.final_slam_destination, rate=25, ChaseReeval.NONE)
    eventPlayer.startForcingPosition(eventPlayer.current_position, true)
    waitUntil(eventPlayer.isOnGround() or distance(eventPlayer.getPosition(), eventPlayer.final_slam_destination) < 1 or not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.stopForcingPosition()
    stopChasingVariable(eventPlayer.current_position)
    eventPlayer.stopForcingThrottle()
    eventPlayer.setGravity(100)
