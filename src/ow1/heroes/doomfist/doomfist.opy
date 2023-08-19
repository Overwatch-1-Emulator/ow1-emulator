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
#!define findProtoIndicatorPosition() raycast(eventPlayer.getEyePosition(), \
                                              eventPlayer.getEyePosition()+OW1_DOOMFIST_SEISMIC_SLAM_RADIUS*eventPlayer.getFacingDirection(), \
                                              null, \
                                              null, \
                                              null).getHitPosition()
# Then drop straight down vertically to find the final indicator position
#!define findIndicatorPosition() raycast(eventPlayer.proto_indicator_slam_position, \
                                         eventPlayer.proto_indicator_slam_position + OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN*Vector.DOWN, \
                                         null, \
                                         getAllPlayers(), \
                                         false).getHitPosition()

# Calculate OW1 rocket punch damage given charge time
# Assume damage scales linearly with charge time, then use the line from 2 points formula (y-y1) = (y2-y1)/(x2-x1)*(x-x1)
#!define getRocketPunchDamage(charge_time) ((OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MAX-OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MIN)/(OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN)*(charge_time-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX)+OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MAX)
# Calculate OW1 rocket punch damage given charge time
# Assume damage scales linearly with charge time, then use the line from 2 points formula (y-y1) = (y2-y1)/(x2-x1)*(x-x1)
#!define getRocketPunchWallImpactDamage(charge_time) ((OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MAX-OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MIN)/(OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN)*(charge_time-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX)+OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MAX)

# Calculate OW1 meteor strike outer sphere damage from OW2 meteor strike outer sphere damage
#!define getMeteorStrikeDamage(d) (OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE + ((OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE - OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MIN_DAMAGE)/(OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE - OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MIN_DAMAGE)) * (d - OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE))

#!define isIndicatorVisible() \
    (eventPlayer.slam_to_use == SlamType.INDICATOR and \
    eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0 and \
    not eventPlayer.isUsingAbility1() == true and \
    distance(eventPlayer.indicator_slam_position, eventPlayer.proto_indicator_slam_position) < OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN)

#!define isIndicatorNotVisible() \
    (eventPlayer.slam_to_use != SlamType.INDICATOR or \
    eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0 or \
    eventPlayer.isUsingAbility1() == true or \
    distance(eventPlayer.indicator_slam_position, eventPlayer.proto_indicator_slam_position) >= OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN)

enum SlamType:
    GROUND,
    INDICATOR

playervar i

# Variables for uppercut
playervar pressing_uppercut_key
playervar shift_pressed_by_bot
playervar is_using_uppercut
playervar is_hit_by_uppercut

# Variables for slam
playervar pressing_slam_key
playervar e_pressed_by_bot
playervar is_using_slam
playervar slam_to_use
playervar current_position
playervar proto_indicator_slam_position
playervar indicator_slam_position
playervar indicator_slam_direction
playervar slam_damage
playervar slam_damage_text_entity
playervar slammed_victims
subroutine createSlamDamageGui
subroutine destroySlamDamageGui

playervar indicator_entity
subroutine createSlamIndicatorGui
subroutine destroySlamIndicatorGui

# Variables for rocket punch
playervar punched_victims
playervar wall_impacted_victims
playervar punch_charge_time

subroutine initDoomfist
subroutine executeUppercut
subroutine detectUpercutHit
subroutine executeSlam
subroutine startSlamAnimation
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

    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))

    # Below variables are also declared and initialized in reset_hero.opy
    getPlayers(eventPlayer.getTeam()).friendly_doomfist_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_doomfist_player = eventPlayer


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
    # @Condition not eventPlayer.hasStatusEffect(Status.HACKED) # Ensure Doomfist is not hacked
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
    # @Condition not eventPlayer.hasStatusEffect(Status.HACKED) # Ensure Doomfist is not hacked
    @Condition not eventPlayer.hasStatusEffect(Status.FROZEN) # Ensure Doomfist is not frozen
    @Condition not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) # Ensure Doomfist is not knocked down
    @Condition not eventPlayer.hasStatusEffect(Status.ASLEEP) # Ensure Doomfist is not asleep
    @Condition not eventPlayer.hasStatusEffect(Status.STUNNED) # Ensure Doomfist is not stunned

    executeSlam()


def executeUppercut():
    @Name "[doomfist.opy]: executeUppercut()"

    eventPlayer.disablePlayerCollision() # Doomfist phases through enemies during uppercut

    # Uppercut physics
    eventPlayer.is_using_uppercut = true # Start of uppercut
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Cancel current momentum
    eventPlayer.applyImpulse(getLateralFacingDirection(eventPlayer), 5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Step Forward
    eventPlayer.setGravity(0) # Override gravity during uppercut
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0) # Deny player from inputting movement commands
    wait(0.15)
    eventPlayer.applyImpulse(Vector.UP, 40, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Uppercut
    wait(0.1)
    eventPlayer.applyImpulse(Vector.DOWN, max(0, eventPlayer.getSpeedInDirection(Vector.UP)), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.is_using_uppercut = false # End of uppercut
    wait()
    eventPlayer.applyImpulse(Vector.UP, 2.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.setGravity(0)
    eventPlayer.enablePlayerCollision()
    wait(0.35)
    eventPlayer.stopForcingThrottle()
    wait(0.15)
    eventPlayer.setGravity(50)
    wait(0.25)
    eventPlayer.setGravity(100)


rule "[doomfist.opy]: Play uppercut VFX":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_uppercut == true

    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, eventPlayer.getTeam(), eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, eventPlayer.getTeam(), eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, eventPlayer.getTeam(), eventPlayer, 100)


rule "[doomfist.opy]: Set uppercut cooldown":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_uppercut == true

    waitUntil(eventPlayer.is_using_uppercut == false, 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_DOOMFIST_RISING_UPPERCUT_COOLDOWN_TIME)


rule "[doomfist.opy]: Disable abilities when uppercutting":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_uppercut == true
    
    eventPlayer.setMeleeEnabled(false) # Doomfist cannot melee during uppercut
    eventPlayer.setPrimaryFireEnabled(false) # Doomfist cannot shoot during uppercut
    eventPlayer.setSecondaryFireEnabled(false) # Doomfist cannot punch during uppercut
    waitUntil(eventPlayer.is_using_uppercut == false, 9999)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)


rule "[doomfist.opy]: Detect uppercut victims":
    @Event eachPlayer
    @Condition eventPlayer.enemy_doomfist_player.is_using_uppercut == true # Enemy doomfist using uppercut
    @Condition distance(eventPlayer.enemy_doomfist_player, eventPlayer) <= OW1_DOOMFIST_RISING_UPPERCUT_RADIUS # Victim within uppercut hitbox range
    @Condition isInLoS(eventPlayer.enemy_doomfist_player, eventPlayer, BarrierLos.PASS_THROUGH_BARRIERS) # Victim in los of doomfist
    @Condition angleBetweenVectors(getLateralFacingDirection(eventPlayer.enemy_doomfist_player), \
                                   directionTowards(eventPlayer.enemy_doomfist_player, eventPlayer)) <= 90 # Victim visible to doomfist
    @Condition eventPlayer.enemy_doomfist_player.isAlive() == true # Enemy doomfist alive
    @Condition eventPlayer.isAlive() == true # Victim is alive

    eventPlayer.is_hit_by_uppercut = true


rule "[doomfist.opy]: Uppercut victim movement physics":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut == true

    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0) # Lose movement control
    eventPlayer.applyImpulse(Vector.UP, 13.5, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.applyImpulse(getLateralFacingDirection(eventPlayer.enemy_doomfist_player), 8.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(OW1_DOOMFIST_RISING_UPPERCUT_AIR_LOCK_TIME)
    eventPlayer.stopForcingThrottle() # Regain movement control
    eventPlayer.is_hit_by_uppercut = false


rule "[doomfist.opy]: Damage uppercut victims":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut == true

    damage(eventPlayer, eventPlayer.enemy_doomfist_player, OW1_DOOMFIST_RISING_UPPERCUT_DAMAGE)
    eventPlayer.setEnvironmentalKillCreditor(eventPlayer.enemy_doomfist_player)


rule "[doomfist.opy]: Play uppercut hit VFX":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut == true

    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer, 1)


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


rule "[doomfist.opy]: Start tracking indicator slam destination":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.slam_to_use == SlamType.INDICATOR
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition eventPlayer.isUsingAbility1() == false

    chase(eventPlayer.proto_indicator_slam_position, findProtoIndicatorPosition(), rate=9999, ChaseReeval.DESTINATION_AND_RATE)
    chase(eventPlayer.indicator_slam_position, findIndicatorPosition(), rate=9999, ChaseReeval.DESTINATION_AND_RATE)


rule "[doomfist.opy]: Stop tracking indicator slam destination":
    @Event eachPlayer
    @Hero doomfist
    @Condition not ((eventPlayer.slam_to_use == SlamType.INDICATOR) and \
                   (eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0) and \
                   (eventPlayer.isUsingAbility1() == false))

    stopChasingVariable(eventPlayer.proto_indicator_slam_position)
    stopChasingVariable(eventPlayer.indicator_slam_position)


def executeSlam():
    @Name "[doomfist.opy]: executeSlam()"

    eventPlayer.slammed_victims = [] # clear slammed victims

    if eventPlayer.slam_to_use == SlamType.INDICATOR:
        if distance(eventPlayer.indicator_slam_position, eventPlayer.proto_indicator_slam_position) < OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN: # Only execute when indicator slam is valid
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

    startSlamAnimation()
    eventPlayer.applyImpulse(getLateralFacingDirection(eventPlayer) + vect(0, 0.075, 0), 16, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # apply custom momentum
    wait(0.3)
    eventPlayer.setGravity(100)
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.stopForcingThrottle()


def initiateIndicatorSlam():
    @Name "[doomfist.opy]: InitiateIndicatorSlam()"
    
    stopChasingVariable(eventPlayer.proto_indicator_slam_position)
    stopChasingVariable(eventPlayer.indicator_slam_position)
    eventPlayer.proto_indicator_slam_position = findProtoIndicatorPosition()
    eventPlayer.indicator_slam_position = findIndicatorPosition()
    eventPlayer.indicator_slam_direction = directionTowards(eventPlayer.getPosition(), eventPlayer.indicator_slam_position)
    eventPlayer.is_using_slam = true
    eventPlayer.setGravity(0.001)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)

    startSlamAnimation()
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


def startSlamAnimation():
    @Name "[doomfist.opy]: startSlamAnimation()"

    # Start slam animation
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.shift_pressed_by_bot = true
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.shift_pressed_by_bot = false
    eventPlayer.disallowButton(Button.ABILITY_1)

    wait()
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Cancel current momentum


rule "[doomfist.opy]: Calculate slam damage based on air time":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_slam == true
    
    eventPlayer.slam_damage = 0 
    waitUntil(updateEveryTick(eventPlayer.isOnGround() == false), 9999)
    createSlamDamageGui()
    chase(eventPlayer.slam_damage, OW1_DOOMFIST_SEISMIC_SLAM_DAMAGE_MAX, rate=OW1_DOOMFIST_SEISMIC_SLAM_DAMAGE_RATE, ChaseReeval.NONE)
    waitUntil(updateEveryTick(eventPlayer.isOnGround() == true), 9999)
    stopChasingVariable(eventPlayer.slam_damage)
    wait(1)
    destroySlamDamageGui()


def createSlamDamageGui():
    @Name "[doomfist.opy]: createSlamDamageGui()"

    createInWorldText(eventPlayer, "{0}".format(floor(eventPlayer.slam_damage)), 
    updateEveryTick(eventPlayer.getEyePosition() + (100 * (0 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((0 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
    verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
    2, 
    Clip.NONE, 
    WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
    Color.WHITE, 
    SpecVisibility.DEFAULT)
    eventPlayer.slam_damage_text_entity = getLastCreatedText()


def destroySlamDamageGui():
    @Name "[doomfist.opy]: destroySlamDamageGui()"

    destroyInWorldText(eventPlayer.slam_damage_text_entity)
    eventPlayer.slam_damage_text_entity = null


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

    damage(victim, attacker, floor(attacker.slam_damage)) # Custom slam damage
    victim.setGravity(50) 
    victim.applyImpulse(Vector.UP, 5.25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Boop slammed victims up
    victim.applyImpulse(directionTowards(victim, attacker), 1.5*(distance(victim, attacker)-(OW1_DOOMFIST_RISING_UPPERCUT_RADIUS-1)), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Push/Pull slammed victims; multiply pull magnitude by 1.5 to counteract air resistance
    victim.setGravity(100)


rule "[doomfist.opy]: Slam indicator VFX":
    @Event eachPlayer
    @Hero doomfist
    @Condition isIndicatorVisible() == true

    createSlamIndicatorGui()
    waitUntil(isIndicatorNotVisible() == true, 9999)
    destroySlamIndicatorGui()


def createSlamIndicatorGui():
    @Name "[doomfist.opy]: createSlamIndicatorGui()"

    for i in range(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION):
        createBeam(eventPlayer if isIndicatorVisible() else null,
                   Beam.GOOD, 
                   updateEveryTick(eventPlayer.indicator_slam_position + \
                                   OW1_DOOMFIST_SEISMIC_SLAM_AOE_MIN_RADIUS * \
                                   worldVector(cosDeg(OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2-evalOnce(i)*OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION-1))*Vector.FORWARD + \
                                               sinDeg(OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2-evalOnce(i)*OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION-1))*Vector.LEFT, \
                                               eventPlayer, \
                                               Transform.ROTATION)), 
                   updateEveryTick(eventPlayer.indicator_slam_position + \
                                   OW1_DOOMFIST_SEISMIC_SLAM_AOE_MAX_RADIUS * \
                                   worldVector(cosDeg(OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2-evalOnce(i)*OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION-1))*Vector.FORWARD + \
                                               sinDeg(OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2-evalOnce(i)*OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/(OW1_DOOMFIST_SEISMIC_SLAM_INDICATOR_RESOLUTION-1))*Vector.LEFT, \
                                               eventPlayer, \
                                               Transform.ROTATION)), 
                   Color.BLUE, 
                   EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.indicator_entity.append(getLastCreatedEntity())
    
    # Sphere for debugging indicator slam
    # createEffect(eventPlayer, Effect.SPHERE, Color.BLUE, findIndicatorPosition(), OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN, EffectReeval.POSITION_AND_RADIUS)


def destroySlamIndicatorGui():
    @Name "[doomfist.opy]: destroySlamIndicatorGui()"

    for i in range(len(eventPlayer.indicator_entity)):
        destroyEffect(eventPlayer.indicator_entity[i])
    
    eventPlayer.indicator_entity = []


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