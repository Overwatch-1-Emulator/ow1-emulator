#!mainFile "../../main.opy"

/*
This DPS doomfist workshop script is sourced from
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474

This file was created by decompiling the original 
workshop gamemode through OverPy, and editing the 
rules/functions as needed.
*/

# First raycast max range towards the direction the crosshair is aimed at
#!define findProtoIndicatorPosition() raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition()+OW1_DOOMFIST_SEISMIC_SLAM_RADIUS*eventPlayer.getFacingDirection(), null, null, null).getHitPosition()
# Then drop straight down vertically to find the final indicator position
#!define findIndicatorPosition() raycast(findProtoIndicatorPosition(), findProtoIndicatorPosition()+OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN*Vector.DOWN, null, getAllPlayers(), false).getHitPosition()
# Facing direction vector projected and normalized to the XZ plane
#!define getLateralFacingDirection() normalize(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z))
# Rotates vector around the y-axis in 3D space
# See https://stackoverflow.com/q/14607640 for formula on rotating vector in 3D space
#!define rotateRelativeToYAxis(v, angle_in_degrees) vect((v.x*cosDeg(angle_in_degrees) + v.z*sinDeg(angle_in_degrees)), (v.y), (-v.x*sinDeg(angle_in_degrees) + v.z*cosDeg(angle_in_degrees)))
# Same function as above but using pre-computed cos/sin lookup tables
#!define rotateRelativeToYAxisLUT(v, index) vect((v.x*eventPlayer.cos_lut[index] + v.z*eventPlayer.sin_lut[index]), (v.y), (-v.x*eventPlayer.sin_lut[index] + v.z*eventPlayer.cos_lut[index]))

enum SlamType:
    GROUND,
    INDICATOR

playervar cos_lut # lookup table for cosine values (for performance reasons)
playervar sin_lut # lookup table for sine values (for performance reasons)

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
playervar valid_slam_position
playervar indicator_visibility
playervar slam_damage
playervar slammed_victims

# Variables for rocket punch
playervar punched_victims
playervar wall_impacted_victims
playervar punch_damage
playervar wall_impact_damage

subroutine initDoomfist
subroutine initSlamIndicatorGui
subroutine executeUppercut
subroutine detectUpercutHit
subroutine executeSlam
subroutine initiateGroundSlam
subroutine initiateIndicatorSlam

rule "[doomfist.opy]: Detect Doomfist initialization":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initDoomfist()
    eventPlayer.initialized = true


def initDoomfist():
    @Name "[doomfist.opy]: initDoomfist()"

    # Set Doomfist health to OW1
    while (eventPlayer.getMaxHealth() != OW1_DOOMFIST_HEALTH):
        clearCustomHealth()
        setCustomHealth(OW1_DOOMFIST_HEALTH, 0, 0)
        wait(1)


    # Decouple ability button press from trigerring ability
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    
    eventPlayer.setDamageDealt(0.001)

    # Variables for swapping keybinds
    eventPlayer.shift_pressed_by_bot = false
    eventPlayer.e_pressed_by_bot = false

    eventPlayer.punched_victims = []
    eventPlayer.wall_impacted_victims = []
    
    initSlamIndicatorGui()


def initSlamIndicatorGui():
    eventPlayer.indicator_visibility = null

    eventPlayer.cos_lut = []
    eventPlayer.sin_lut = []

    for eventPlayer.i in range(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION):
        eventPlayer.cos_lut.append(cosDeg(eventPlayer.i*(OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION-1))-OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2))
        eventPlayer.sin_lut.append(sinDeg(eventPlayer.i*(OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION-1))-OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2))
    
    for eventPlayer.i in range(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION):
        createBeam(eventPlayer.indicator_visibility, 
                   Beam.GOOD, 
                   findIndicatorPosition() + OW1_DOOMFIST_SEISMIC_SLAM_AOE_MIN_RADIUS*rotateRelativeToYAxisLUT(getLateralFacingDirection(), evalOnce(eventPlayer.i)), 
                   findIndicatorPosition() + OW1_DOOMFIST_SEISMIC_SLAM_AOE_MAX_RADIUS*rotateRelativeToYAxisLUT(getLateralFacingDirection(), evalOnce(eventPlayer.i)), 
                   Color.BLUE, 
                   EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.entity_huds.append(getLastCreatedEntity())
    
    # Sphere for debugging indicator slam
    # createEffect(eventPlayer, Effect.SPHERE, Color.BLUE, findIndicatorPosition(), OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN, EffectReeval.POSITION_AND_RADIUS)


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
    @Condition not eventPlayer.hasStatusEffect(Status.HACKED) # Ensure Doomfist is not hacked
    @Condition not eventPlayer.hasStatusEffect(Status.FROZEN) # Ensure Doomfist is not frozen
    @Condition not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) # Ensure Doomfist is not knocked down
    @Condition not eventPlayer.hasStatusEffect(Status.ASLEEP) # Ensure Doomfist is not asleep
    @Condition not eventPlayer.hasStatusEffect(Status.STUNNED) # Ensure Doomfist is not stunned

    executeUppercut()


rule "[doomfist.opy]: Control flow for slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.pressing_slam_key == true
    @Condition eventPlayer.is_using_uppercut == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not eventPlayer.hasStatusEffect(Status.HACKED) # Ensure Doomfist is not hacked
    @Condition not eventPlayer.hasStatusEffect(Status.FROZEN) # Ensure Doomfist is not frozen
    @Condition not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) # Ensure Doomfist is not knocked down
    @Condition not eventPlayer.hasStatusEffect(Status.ASLEEP) # Ensure Doomfist is not asleep
    @Condition not eventPlayer.hasStatusEffect(Status.STUNNED) # Ensure Doomfist is not stunned

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
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_DOOMFIST_RISING_UPPERCUT_COOLDOWN_TIME)
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

    eventPlayer.enemies_in_uppercut_radius = getPlayersInRadius(eventPlayer, OW1_DOOMFIST_RISING_UPPERCUT_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES_AND_ENEMY_BARRIERS) # Find enemies in uppercut range
    eventPlayer.enemies_in_uppercut_view = eventPlayer.getPlayersInViewAngle(getOppositeTeam(eventPlayer.getTeam()), 90) # Find enemies in 90 degree FOV

    # enemies_hit_by_uppercut = Union(enemies_in_uppercut_radius, enemies_in_uppercut_view)
    eventPlayer.enemies_hit_by_uppercut = []
    for eventPlayer.i in range(len(eventPlayer.enemies_in_uppercut_radius)):
        if eventPlayer.enemies_in_uppercut_radius[eventPlayer.i] in eventPlayer.enemies_in_uppercut_view:
            eventPlayer.enemies_hit_by_uppercut.append(eventPlayer.enemies_in_uppercut_radius[eventPlayer.i])

    for eventPlayer.i in range(len(eventPlayer.enemies_hit_by_uppercut)):
        eventPlayer.setDamageDealt(100)
        damage(eventPlayer.enemies_hit_by_uppercut[eventPlayer.i], eventPlayer, OW1_DOOMFIST_RISING_UPPERCUT_DAMAGE)
        eventPlayer.setDamageDealt(0.001)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer.enemies_hit_by_uppercut[eventPlayer.i], 1)
        playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer.enemies_hit_by_uppercut[eventPlayer.i].getPosition(), 100)
        eventPlayer.enemies_hit_by_uppercut[eventPlayer.i].applyImpulse(Vector.UP, 15, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        eventPlayer.enemies_hit_by_uppercut[eventPlayer.i].applyImpulse(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)


rule "[doomfist.opy]: Detect ground slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition updateEveryTick(eventPlayer.getAltitude() < OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_HEIGHT)

    eventPlayer.slam_to_use = SlamType.GROUND


rule "[doomfist.opy]: Detect indicator slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition updateEveryTick(eventPlayer.getAltitude() >= OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_HEIGHT)

    eventPlayer.slam_to_use = SlamType.INDICATOR


def executeSlam():
    @Name "[doomfist.opy]: Execute main logic for Seismic Slam ability"
    eventPlayer.slammed_victims = [] # clear slammed victims

    if eventPlayer.slam_to_use == SlamType.INDICATOR:
        if eventPlayer.indicator_visibility == eventPlayer: # Only execute indicator slam if indicator visible
            initiateIndicatorSlam()
    else if eventPlayer.slam_to_use == SlamType.GROUND:
        initiateGroundSlam()

    if eventPlayer.is_using_slam == true:
        waitUntil(not eventPlayer.isUsingAbility1(), 9999)
        eventPlayer.is_using_slam = false
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.uppercut_cooldown)
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_DOOMFIST_SEISMIC_SLAM_COOLDOWN_TIME)


def initiateGroundSlam():
    @Name "[doomfist.opy]: InitiateGroundSlam()"
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
    @Name "[doomfist.opy]: InitiateIndicatorSlam()"
    eventPlayer.valid_slam_position = findIndicatorPosition()
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
    chase(eventPlayer.current_position, eventPlayer.valid_slam_position, rate=OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_SPEED, ChaseReeval.NONE)
    eventPlayer.startForcingPosition(eventPlayer.current_position, true)
    waitUntil((eventPlayer.getAltitude() <= 0.01 and distance(eventPlayer.current_position, eventPlayer.valid_slam_position) <= 0.01) or not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.stopForcingPosition()
    stopChasingVariable(eventPlayer.current_position)
    eventPlayer.stopForcingThrottle()
    eventPlayer.setGravity(100)
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # cancel current momentum


rule "[doomfist.opy]: Damage slammed victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    # [TODO] add more conditions to check that the player is inside OW1 slam hitbox

    eventPlayer.setDamageDealt(100)
    damage(victim, attacker, round(attacker.slam_damage))
    eventPlayer.setDamageDealt(0.001)
    attacker.slammed_victims.append(victim)


rule "[doomfist.opy]: Calculate slam damage based on air time":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_slam == true

    eventPlayer.slam_damage = 0 
    chase(eventPlayer.slam_damage, OW1_DOOMFIST_SEISMIC_SLAM_DAMAGE_MAX, rate=OW1_DOOMFIST_SEISMIC_SLAM_DAMAGE_RATE, ChaseReeval.NONE)
    waitUntil(updateEveryTick(eventPlayer.is_using_slam == false), 9999)
    bigMessage(eventPlayer, "{}".format(round(eventPlayer.slam_damage)))
    stopChasingVariable(eventPlayer.slam_damage)
 

rule "[doomfist.opy]: Debug slam air time":
    @Disabled
    @Event eachPlayer 
    @Hero doomfist

    hudSubheader(eventPlayer, "{0}".format(eventPlayer.slam_damage), HudPosition.TOP, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "[doomfist.opy]: Indicator slam validity":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0 # Slam available
    @Condition not eventPlayer.is_using_slam # Not using ability
    @Condition eventPlayer.slam_to_use == SlamType.INDICATOR
    @Condition distance(findIndicatorPosition(), findProtoIndicatorPosition()) < OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN # If vertical distance is greater than the margin, it's invalid.

    eventPlayer.indicator_visibility = eventPlayer


rule "[doomfist.opy]: Hide indicator while slam not available":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0

    eventPlayer.indicator_visibility = null


rule "[doomfist.opy]: Hide indicator while using slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_slam

    eventPlayer.indicator_visibility = null


rule "[doomfist.opy]: Hide indicator if not indicator slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.slam_to_use != SlamType.INDICATOR

    eventPlayer.indicator_visibility = null


rule "[doomfist.opy]: Hide FLOATING indicator slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition distance(findIndicatorPosition(), findProtoIndicatorPosition()) >= OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN

    eventPlayer.indicator_visibility = null


rule "[doomfist.opy]: Detect rocket punch positive edge":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isFiringSecondaryFire() == true

    eventPlayer.punched_victims = []
    eventPlayer.wall_impacted_victims = []
    waitUntil(eventPlayer.isFiringSecondaryFire() == false, 9999)

# DO NOT switch the order of this rule with the next rule
# The order is functionally significant
rule "[doomfist.opy]: Find wall impacted victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim in attacker.punched_victims
    @Condition victim not in attacker.wall_impacted_victims

    attacker.setDamageDealt(100)
    damage(victim, attacker, attacker.wall_impact_damage)
    attacker.wall_impacted_victims.append(victim)
    attacker.setDamageDealt(0.001)

# DO NOT switch the order of this rule with the previous rule
# The order is functionally significant
rule "[doomfist.opy]: Find punched victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim not in attacker.punched_victims

    attacker.setDamageDealt(100)
    damage(victim, attacker, attacker.punch_damage) 
    attacker.punched_victims.append(victim)
    attacker.setDamageDealt(0.001)


rule "[doomfist.opy]: Calculate punch damage based on charge time":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    eventPlayer.punch_damage = OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MIN
    eventPlayer.wall_impact_damage = OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MIN
    chase(eventPlayer.punch_damage, OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MAX, rate=(OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MAX-OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MIN)/OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME, ChaseReeval.NONE)
    chase(eventPlayer.wall_impact_damage, OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MAX, rate=(OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MAX-OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MIN)/OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME, ChaseReeval.NONE)
    waitUntil(updateEveryTick(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false), 9999)
    stopChasingVariable(eventPlayer.punch_damage)
    stopChasingVariable(eventPlayer.wall_impact_damage)