#!mainFile "../../main.opy"

/*
This DPS doomfist workshop script is heavily based on
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
#!define getLateralFacingDirection(player) normalize(vect(player.getFacingDirection().x, 0, player.getFacingDirection().z))
# Rotates vector around the y-axis in 3D space
# See https://stackoverflow.com/q/14607640 for formula on rotating vector in 3D space
#!define rotateRelativeToYAxis(v, angle_in_degrees) vect((v.x*cosDeg(angle_in_degrees) + v.z*sinDeg(angle_in_degrees)), (v.y), (-v.x*sinDeg(angle_in_degrees) + v.z*cosDeg(angle_in_degrees)))
# Same function as above but using pre-computed cos/sin lookup tables
#!define rotateRelativeToYAxisLUT(v, index) vect((v.x*eventPlayer.cos_lut[index] + v.z*eventPlayer.sin_lut[index]), (v.y), (-v.x*eventPlayer.sin_lut[index] + v.z*eventPlayer.cos_lut[index]))

# Get enemy players using uppercut
#!define getUppercuttingPlayers() [i for i in getPlayersOnHero(Hero.DOOMFIST, getOppositeTeam(eventPlayer.getTeam())) if i.is_using_uppercut == true]

# Calculate OW1 rocket punch damage given charge time
# Assume damage scales linearly with charge time, then use the line from 2 points formula (y-y1) = (y2-y1)/(x2-x1)*(x-x1)
#!define getRocketPunchDamage(charge_time) ((OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MAX-OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MIN)/(OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN)*(charge_time-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX)+OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MAX)
# Calculate OW1 rocket punch damage given charge time
# Assume damage scales linearly with charge time, then use the line from 2 points formula (y-y1) = (y2-y1)/(x2-x1)*(x-x1)
#!define getRocketPunchWallImpactDamage(charge_time) ((OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MAX-OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MIN)/(OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN)*(charge_time-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX)+OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MAX)

# Calculate OW1 meteor strike outer sphere damage from OW2 meteor strike outer sphere damage
#!define getMeteorStrikeDamage(d) (OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE + ((OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE - OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MIN_DAMAGE)/(OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE - OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MIN_DAMAGE)) * (d - OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE))


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
playervar uppercut_victims

# Variables for slam
playervar pressing_slam_key
playervar e_pressed_by_bot
playervar is_using_slam
playervar slam_to_use
playervar current_position
playervar indicator_slam_position
playervar indicator_slam_direction
playervar indicator_visibility
playervar slam_damage
playervar slam_damage_gui_visible
playervar slammed_victims

# Variables for rocket punch
playervar punched_victims
playervar wall_impacted_victims
playervar punch_charge_time

subroutine initDoomfist
subroutine initSlamIndicatorGui
subroutine initSlamDamageGui
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
    
    # Variables for swapping keybinds
    eventPlayer.shift_pressed_by_bot = false
    eventPlayer.e_pressed_by_bot = false

    eventPlayer.punched_victims = []
    eventPlayer.wall_impacted_victims = []
    
    initSlamIndicatorGui()
    initSlamDamageGui()


def initSlamIndicatorGui():
    @Name "[doomfist.opy]: initSlamIndicatorGui()"

    eventPlayer.indicator_visibility = null

    eventPlayer.cos_lut = []
    eventPlayer.sin_lut = []

    for eventPlayer.i in range(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION):
        eventPlayer.cos_lut.append(cosDeg(eventPlayer.i*(OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION-1))-OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2))
        eventPlayer.sin_lut.append(sinDeg(eventPlayer.i*(OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION-1))-OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2))
    
    for eventPlayer.i in range(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION):
        createBeam(eventPlayer.indicator_visibility, 
                   Beam.GOOD, 
                   updateEveryTick(findIndicatorPosition() + OW1_DOOMFIST_SEISMIC_SLAM_AOE_MIN_RADIUS*rotateRelativeToYAxisLUT(getLateralFacingDirection(eventPlayer), evalOnce(eventPlayer.i))), 
                   updateEveryTick(findIndicatorPosition() + OW1_DOOMFIST_SEISMIC_SLAM_AOE_MAX_RADIUS*rotateRelativeToYAxisLUT(getLateralFacingDirection(eventPlayer), evalOnce(eventPlayer.i))), 
                   Color.BLUE, 
                   EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.entity_huds.append(getLastCreatedEntity())
    
    # Sphere for debugging indicator slam
    # createEffect(eventPlayer, Effect.SPHERE, Color.BLUE, findIndicatorPosition(), OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN, EffectReeval.POSITION_AND_RADIUS)


def initSlamDamageGui():
    @Name "[doomfist.opy]: initSlamDamageGui()"

    eventPlayer.slam_damage_gui_visible = false
    createInWorldText(eventPlayer if eventPlayer.slam_damage_gui_visible else null, 
    "{0}".format(round(eventPlayer.slam_damage)), 
    updateEveryTick(eventPlayer.getEyePosition() + (100 * (0 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((0 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
    verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
    2, 
    Clip.NONE, 
    WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
    Color.WHITE, 
    SpecVisibility.DEFAULT)
    eventPlayer.text_huds.append(getLastCreatedText())


rule "[doomfist.opy]: Detect shift key press by human": 
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.shift_pressed_by_bot == false
    
    eventPlayer.pressing_slam_key = true
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1), 9999)
    eventPlayer.pressing_slam_key = false


rule "[doomfist.opy]: Detect e key press by human":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.e_pressed_by_bot == false

    eventPlayer.pressing_uppercut_key = true
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2), 9999)
    eventPlayer.pressing_uppercut_key = false


rule "[doomfist.opy]: Control flow for uppercut":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.pressing_uppercut_key == true
    @Condition eventPlayer.is_using_slam == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
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
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition not eventPlayer.hasStatusEffect(Status.HACKED) # Ensure Doomfist is not hacked
    @Condition not eventPlayer.hasStatusEffect(Status.FROZEN) # Ensure Doomfist is not frozen
    @Condition not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) # Ensure Doomfist is not knocked down
    @Condition not eventPlayer.hasStatusEffect(Status.ASLEEP) # Ensure Doomfist is not asleep
    @Condition not eventPlayer.hasStatusEffect(Status.STUNNED) # Ensure Doomfist is not stunned

    executeSlam()


def executeUppercut():
    @Name "[doomfist.opy]: Execute main logic for Rising Uppercut ability"

    eventPlayer.uppercut_victims = [] # Clear uppercut victims
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
    wait(0.15)
    eventPlayer.applyImpulse(Vector.UP, 40, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.1)
    eventPlayer.applyImpulse(Vector.DOWN, max(0, eventPlayer.getSpeedInDirection(Vector.UP)), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.is_using_uppercut = false # End of uppercut
    wait()
    eventPlayer.applyImpulse(Vector.UP, 2.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.setGravity(0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_DOOMFIST_RISING_UPPERCUT_COOLDOWN_TIME)
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


rule "[doomfist.opy]: Detect uppercut victims":
    @Event eachPlayer
    @Condition any([i.is_using_uppercut == true for i in getPlayersInRadius(eventPlayer, OW1_DOOMFIST_RISING_UPPERCUT_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) if i.getCurrentHero() == Hero.DOOMFIST])
    @Condition angleBetweenVectors(getLateralFacingDirection(getUppercuttingPlayers()[0]), directionTowards(getUppercuttingPlayers()[0], eventPlayer)) <= 90
    @Condition eventPlayer not in getUppercuttingPlayers()[0].uppercut_victims

    getUppercuttingPlayers()[0].uppercut_victims.append(eventPlayer)
    damage(eventPlayer, getUppercuttingPlayers()[0], OW1_DOOMFIST_RISING_UPPERCUT_DAMAGE)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer, 1)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    eventPlayer.applyImpulse(Vector.UP, 15, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.applyImpulse(vect(getUppercuttingPlayers()[0].getFacingDirection().x, 0, getUppercuttingPlayers()[0].getFacingDirection().z), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)


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
        if distance(findIndicatorPosition(), findProtoIndicatorPosition()) < OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN: # Only execute indicator slam is valid
            initiateIndicatorSlam()
    else if eventPlayer.slam_to_use == SlamType.GROUND:
        initiateGroundSlam()

    if eventPlayer.is_using_slam == true:
        waitUntil(not eventPlayer.isUsingAbility1(), 9999)
        eventPlayer.is_using_slam = false
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_DOOMFIST_SEISMIC_SLAM_COOLDOWN_TIME)


def initiateGroundSlam():
    @Name "[doomfist.opy]: InitiateGroundSlam()"
    eventPlayer.is_using_slam = true
    eventPlayer.setGravity(0)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)

    # Start slam animation
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
    eventPlayer.indicator_slam_position = findIndicatorPosition()
    eventPlayer.indicator_slam_direction = directionTowards(eventPlayer.getPosition(), eventPlayer.indicator_slam_position)
    eventPlayer.is_using_slam = true
    eventPlayer.setGravity(0.001)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)

    # Start slam animation
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.shift_pressed_by_bot = true
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.shift_pressed_by_bot = false
    eventPlayer.disallowButton(Button.ABILITY_1)

    eventPlayer.current_position = eventPlayer.getPosition()
    chase(eventPlayer.current_position, eventPlayer.indicator_slam_position, rate=OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_SPEED, ChaseReeval.NONE)
    eventPlayer.startForcingPosition(eventPlayer.current_position, true)
    eventPlayer.applyImpulse(eventPlayer.indicator_slam_direction, OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_SPEED, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Helps prevent clipping through map geometry
    waitUntil(distance(eventPlayer.current_position, eventPlayer.indicator_slam_position) <= 0.01 or not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.stopForcingPosition()
    stopChasingVariable(eventPlayer.current_position)
    eventPlayer.stopForcingThrottle()
    eventPlayer.setGravity(100)
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # cancel current momentum


rule "[doomfist.opy]: Calculate slam damage based on air time":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_slam == true
    
    eventPlayer.slam_damage = 0 
    waitUntil(updateEveryTick(eventPlayer.isOnGround() == false), 9999)
    eventPlayer.slam_damage_gui_visible = true
    chase(eventPlayer.slam_damage, OW1_DOOMFIST_SEISMIC_SLAM_DAMAGE_MAX, rate=OW1_DOOMFIST_SEISMIC_SLAM_DAMAGE_RATE, ChaseReeval.NONE)
    waitUntil(updateEveryTick(eventPlayer.isOnGround() == true), 9999)
    stopChasingVariable(eventPlayer.slam_damage)
    wait(1)
    eventPlayer.slam_damage_gui_visible = false


# Need more permanent/robust solution
rule "[doomfist.opy]: Remove OW2 slam damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    
    heal(victim, null, eventDamage)


rule "[doomfist.opy]: Find slammed victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    @Condition OW1_DOOMFIST_SEISMIC_SLAM_AOE_MIN_RADIUS <= distance(attacker, victim)
    @Condition distance(attacker, victim) <= OW1_DOOMFIST_SEISMIC_SLAM_AOE_MAX_RADIUS
    # TODO add condition to check victim in 60 degree cone
    
    attacker.slammed_victims.append(victim)


rule "[doomfist.opy]: Slammed victims damage and pull/push effects":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    @Condition victim in attacker.slammed_victims

    damage(victim, attacker, round(attacker.slam_damage)) # Custom slam damage
    victim.setGravity(50) 
    victim.applyImpulse(Vector.UP, 5.25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Boop slammed victims up
    victim.applyImpulse(directionTowards(victim, attacker), 1.5*(distance(victim, attacker)-(OW1_DOOMFIST_RISING_UPPERCUT_RADIUS-1)), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Push/Pull slammed victims; multiply pull magnitude by 1.5 to counteract air resistance
    victim.setGravity(100)

rule "[doomfist.opy]: Indicator slam visibility":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0 # Slam available
    @Condition not eventPlayer.is_using_slam # Not using ability
    @Condition eventPlayer.slam_to_use == SlamType.INDICATOR
    @Condition distance(findIndicatorPosition(), findProtoIndicatorPosition()) < OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN # If vertical distance is greater than the margin, it's invalid.

    eventPlayer.indicator_visibility = eventPlayer


rule "[doomfist.opy]: Hide indicator while slam not available":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0

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


rule "[doomfist.opy]: Hide floating indicator slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition distance(findIndicatorPosition(), findProtoIndicatorPosition()) >= OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN

    eventPlayer.indicator_visibility = null


rule "[doomfist.opy]: Initialize rocket punch":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true

    eventPlayer.punched_victims = []
    eventPlayer.wall_impacted_victims = []
    eventPlayer.punch_charge_time = 0
    chase(eventPlayer.punch_charge_time, OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX, rate=1, ChaseReeval.NONE)
    waitUntil(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false, 9999)
    stopChasingVariable(eventPlayer.punch_charge_time)


# DO NOT switch the order of this rule with the next rule
# The order is functionally significant
rule "[doomfist.opy]: Find wall impacted victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim in attacker.punched_victims
    @Condition victim not in attacker.wall_impacted_victims

    damage(victim, attacker, getRocketPunchWallImpactDamage(eventPlayer.punch_charge_time)-eventDamage)
    attacker.wall_impacted_victims.append(victim)


# DO NOT switch the order of this rule with the previous rule
# The order is functionally significant
rule "[doomfist.opy]: Find punched victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim not in attacker.punched_victims

    damage(victim, attacker, getRocketPunchDamage(eventPlayer.punch_charge_time)-eventDamage)
    attacker.punched_victims.append(victim)


rule "[doomfist.opy]: Remove Empowered Punch from ultimate":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate() == true
    
    # eventPlayer.disallowButton(Button.ABILITY_1)
    # eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 4.8)
    waitUntil(not eventPlayer.isUsingUltimate(), 9999)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setStatusEffect(null, Status.STUNNED, 0.016)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setSecondaryFireEnabled(false)
    wait()
    eventPlayer.setSecondaryFireEnabled(true)
    # eventPlayer.allowButton(Button.ABILITY_1)
    # eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)


rule "[doomfist.opy]: Deal OW1 Meteor Strike damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage < (OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE + OW2_DOOMFIST_METEOR_STRIKE_INNER_SPHERE_DAMAGE)/2

    damage(victim, attacker, getMeteorStrikeDamage(eventDamage) - eventDamage)


rule "[doomfist.opy]: Deal OW1 hand cannon damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_DOOMFIST_HAND_CANNON_DAMAGE/OW2_DOOMFIST_HAND_CANNON_DAMAGE)-eventDamage) # Deal additional damage to match OW1 damage