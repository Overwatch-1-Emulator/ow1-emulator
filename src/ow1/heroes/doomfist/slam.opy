#!mainFile "../../../main.opy"

playervar shift_pressed_by_bot

playervar pressing_slam_key
playervar slam_to_use
playervar current_position
playervar proto_indicator_slam_position
playervar indicator_slam_position
playervar indicator_slam_direction
playervar slam_damage
playervar slam_damage_text_entity
playervar slammed_victims

playervar indicator_entity

subroutine executeSlam
subroutine startSlamAnimation
subroutine initiateGroundSlam
subroutine initiateIndicatorSlam

subroutine createSlamDamageGui
subroutine destroySlamDamageGui

subroutine createSlamIndicatorGui
subroutine destroySlamIndicatorGui

enum SlamType:
    GROUND,
    INDICATOR

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

rule "[slam.opy]: Detect shift key press by human": 
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.shift_pressed_by_bot == false
    
    eventPlayer.pressing_slam_key = true
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1), 9999)
    eventPlayer.pressing_slam_key = false


rule "[slam.opy]: Control flow for slam":
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


rule "[slam.opy]: Detect ground slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition updateEveryTick(eventPlayer.getAltitude() < OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_HEIGHT)

    eventPlayer.slam_to_use = SlamType.GROUND


rule "[slam.opy]: Detect indicator slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition updateEveryTick(eventPlayer.getAltitude() >= OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_HEIGHT)

    eventPlayer.slam_to_use = SlamType.INDICATOR


rule "[slam.opy]: Start tracking indicator slam destination":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.slam_to_use == SlamType.INDICATOR
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition eventPlayer.isUsingAbility1() == false

    chase(eventPlayer.proto_indicator_slam_position, findProtoIndicatorPosition(), rate=9999, ChaseReeval.DESTINATION_AND_RATE)
    chase(eventPlayer.indicator_slam_position, findIndicatorPosition(), rate=9999, ChaseReeval.DESTINATION_AND_RATE)


rule "[slam.opy]: Stop tracking indicator slam destination":
    @Event eachPlayer
    @Hero doomfist
    @Condition not ((eventPlayer.slam_to_use == SlamType.INDICATOR) and \
                   (eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0) and \
                   (eventPlayer.isUsingAbility1() == false))

    stopChasingVariable(eventPlayer.proto_indicator_slam_position)
    stopChasingVariable(eventPlayer.indicator_slam_position)


def executeSlam():
    @Name "[slam.opy]: executeSlam()"

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
    @Name "[slam.opy]: InitiateGroundSlam()"

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
    @Name "[slam.opy]: InitiateIndicatorSlam()"
    
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
    @Name "[slam.opy]: startSlamAnimation()"

    # Start slam animation
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.shift_pressed_by_bot = true
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.shift_pressed_by_bot = false
    eventPlayer.disallowButton(Button.ABILITY_1)

    wait()
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Cancel current momentum


rule "[slam.opy]: Calculate slam damage based on air time":
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
    @Name "[slam.opy]: createSlamDamageGui()"

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
    @Name "[slam.opy]: destroySlamDamageGui()"

    destroyInWorldText(eventPlayer.slam_damage_text_entity)
    eventPlayer.slam_damage_text_entity = null


# Need more permanent/robust solution
rule "[slam.opy]: Remove OW2 slam damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    
    heal(victim, null, eventDamage)


rule "[slam.opy]: Find slammed victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    @Condition OW1_DOOMFIST_SEISMIC_SLAM_AOE_MIN_RADIUS <= distance(attacker, victim)
    @Condition distance(attacker, victim) <= OW1_DOOMFIST_SEISMIC_SLAM_AOE_MAX_RADIUS
    # TODO add condition to check victim in 60 degree cone
    
    attacker.slammed_victims.append(victim)


rule "[slam.opy]: Slammed victims damage and pull/push effects":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    @Condition victim in attacker.slammed_victims

    damage(victim, attacker, floor(attacker.slam_damage)) # Custom slam damage
    victim.setGravity(50) 
    victim.applyImpulse(Vector.UP, 5.25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Boop slammed victims up
    victim.applyImpulse(directionTowards(victim, attacker), 1.5*(distance(victim, attacker)-(OW1_DOOMFIST_RISING_UPPERCUT_RADIUS-1)), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Push/Pull slammed victims; multiply pull magnitude by 1.5 to counteract air resistance
    victim.setGravity(100)


rule "[slam.opy]: Slam indicator VFX":
    @Event eachPlayer
    @Hero doomfist
    @Condition isIndicatorVisible() == true

    createSlamIndicatorGui()
    waitUntil(isIndicatorNotVisible() == true, 9999)
    destroySlamIndicatorGui()


def createSlamIndicatorGui():
    @Name "[slam.opy]: createSlamIndicatorGui()"

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
    @Name "[slam.opy]: destroySlamIndicatorGui()"

    for i in range(len(eventPlayer.indicator_entity)):
        destroyEffect(eventPlayer.indicator_entity[i])
    
    eventPlayer.indicator_entity = []
