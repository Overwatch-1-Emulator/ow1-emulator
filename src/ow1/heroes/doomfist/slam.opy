#!mainFile "../../../main.opy"

playervar slam_to_use
playervar current_position
playervar proto_indicator_slam_position
playervar indicator_slam_position
playervar indicator_slam_direction
playervar slam_damage
playervar slam_damage_text_entity
playervar slammed_victims

playervar slam_indicator_id

subroutine initSlam
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
                                              getAllPlayers(), \
                                              false).getHitPosition()

# Then drop straight down vertically to find the final indicator position
#!define findIndicatorPosition() raycast(eventPlayer.proto_indicator_slam_position, \
                                         eventPlayer.proto_indicator_slam_position + OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN*Vector.DOWN, \
                                         null, \
                                         getAllPlayers(), \
                                         false).getHitPosition()

#!define isIndicatorVisible() \
    (eventPlayer.slam_to_use == SlamType.INDICATOR and \
    eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0 and \
    not eventPlayer.isUsingAbility1() and \
    not eventPlayer.isUsingUltimate() and \
    distance(eventPlayer.indicator_slam_position, eventPlayer.proto_indicator_slam_position) < OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN)


def initSlam():
    @Name "[doomfist/slam.opy]: initSlam()"

    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.slam_damage = 0
    createSlamIndicatorGui()


rule "[doomfist/slam.opy]: Control flow for slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition not eventPlayer.isMeleeing()
    # @Condition not eventPlayer.hasStatusEffect(Status.HACKED) # Ensure Doomfist is not hacked
    @Condition not eventPlayer.hasStatusEffect(Status.FROZEN) # Ensure Doomfist is not frozen
    @Condition not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) # Ensure Doomfist is not knocked down
    @Condition not eventPlayer.hasStatusEffect(Status.ASLEEP) # Ensure Doomfist is not asleep
    @Condition not eventPlayer.hasStatusEffect(Status.STUNNED) # Ensure Doomfist is not stunned
    @Condition eventPlayer.is_using_uppercut == false

    executeSlam()


rule "[doomfist/slam.opy]: Detect ground slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition updateEveryTick(eventPlayer.getAltitude() < OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_HEIGHT)
    
    eventPlayer.slam_to_use = SlamType.GROUND


rule "[doomfist/slam.opy]: Detect indicator slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition updateEveryTick(eventPlayer.getAltitude() >= OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_HEIGHT)

    eventPlayer.slam_to_use = SlamType.INDICATOR


rule "[doomfist/slam.opy]: Start tracking indicator slam destination":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.slam_to_use == SlamType.INDICATOR
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition not eventPlayer.isUsingAbility1()

    chase(eventPlayer.proto_indicator_slam_position, findProtoIndicatorPosition(), rate=Math.INFINITY, ChaseReeval.DESTINATION_AND_RATE)
    chase(eventPlayer.indicator_slam_position, findIndicatorPosition(), rate=Math.INFINITY, ChaseReeval.DESTINATION_AND_RATE)


rule "[doomfist/slam.opy]: Stop tracking indicator slam destination":
    @Event eachPlayer
    @Hero doomfist
    @Condition not ((eventPlayer.slam_to_use == SlamType.INDICATOR) \
                    and (eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0) \
                    and (not eventPlayer.isUsingAbility1()))

    stopChasingVariable(eventPlayer.proto_indicator_slam_position)
    stopChasingVariable(eventPlayer.indicator_slam_position)


def executeSlam():
    @Name "[doomfist/slam.opy]: executeSlam()"

    eventPlayer.slammed_victims = [] # clear slammed victims

    if eventPlayer.slam_to_use == SlamType.INDICATOR:
        if distance(eventPlayer.indicator_slam_position, eventPlayer.proto_indicator_slam_position) < OW1_DOOMFIST_INDICATOR_SEISMIC_SLAM_MARGIN: # Only execute when indicator slam is valid
            initiateIndicatorSlam()
    else if eventPlayer.slam_to_use == SlamType.GROUND:
        initiateGroundSlam()

    if eventPlayer.is_using_slam == true:
        waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
        eventPlayer.is_using_slam = false
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_DOOMFIST_SLAM_CD)


def initiateGroundSlam():
    @Name "[doomfist/slam.opy]: InitiateGroundSlam()"

    eventPlayer.is_using_slam = true
    eventPlayer.setGravity(0)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)

    startSlamAnimation()
    eventPlayer.applyImpulse(getLateralFacingDirection(eventPlayer) + vect(0, 0.075, 0), 16, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # apply custom momentum
    wait(0.3)
    eventPlayer.setGravity(100)
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.stopForcingThrottle()


def initiateIndicatorSlam():
    @Name "[doomfist/slam.opy]: InitiateIndicatorSlam()"
    
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
    waitUntil(distance(eventPlayer.current_position, eventPlayer.indicator_slam_position) <= 0.01 or not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.stopForcingPosition()
    stopChasingVariable(eventPlayer.current_position)
    eventPlayer.stopForcingThrottle()
    eventPlayer.setGravity(100)
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # cancel current momentum


def startSlamAnimation():
    @Name "[doomfist/slam.opy]: startSlamAnimation()"

    # Start slam animation
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_1)

    wait()
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Cancel current momentum


rule "[doomfist/slam.opy]: Calculate slam damage based on air time":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_slam == true
    
    eventPlayer.slam_damage = 0
    createSlamDamageGui()
    waitUntil(not eventPlayer.isOnGround(), Math.INFINITY)
    chase(eventPlayer.slam_damage, OW1_DOOMFIST_SEISMIC_SLAM_DAMAGE_MAX, rate=OW1_DOOMFIST_SEISMIC_SLAM_DAMAGE_RATE, ChaseReeval.NONE)
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.is_using_slam, Math.INFINITY)
    stopChasingVariable(eventPlayer.slam_damage)
    wait(1, Wait.RESTART_WHEN_TRUE)
    destroySlamDamageGui()


def createSlamDamageGui():
    @Name "[doomfist/slam.opy]: createSlamDamageGui()"

    if eventPlayer.slam_damage_text_entity != null: return
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
    @Name "[doomfist/slam.opy]: destroySlamDamageGui()"

    destroyInWorldText(eventPlayer.slam_damage_text_entity)
    eventPlayer.slam_damage_text_entity = null


# Need more permanent/robust solution
rule "[doomfist/slam.opy]: Remove OW2 slam damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    
    heal(victim, null, eventDamage)


rule "[doomfist/slam.opy]: Find slammed victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    @Condition OW1_DOOMFIST_SLAM_AOE_MIN_RADIUS <= distance(attacker, victim)
    @Condition distance(attacker, victim) <= OW1_DOOMFIST_SLAM_AOE_MAX_RADIUS
    # TODO add condition to check victim in 60 degree cone
    
    attacker.slammed_victims.append(victim)


rule "[doomfist/slam.opy]: Slammed victims damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    @Condition victim in attacker.slammed_victims

    damage(victim, attacker, floor(attacker.slam_damage)) # Custom slam damage


rule "[doomfist/slam.opy]: Slammed victims bounce effect":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1 # Ability used to damage player is Seismic Slam
    @Condition victim in attacker.slammed_victims

    victim.setGravity(50) 
    victim.applyImpulse(Vector.UP, 5.25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Boop slammed victims up
    victim.applyImpulse(directionTowards(victim, attacker), 1.5*(distance(victim, attacker)-(OW1_DOOMFIST_RISING_UPPERCUT_RADIUS-1)), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Push/Pull slammed victims; multiply pull magnitude by 1.5 to counteract air resistance
    victim.setGravity(100)


def createSlamIndicatorGui():
    @Name "[doomfist/slam.opy]: createSlamIndicatorGui()"

    for i in range(OW1_DOOMFIST_SLAM_INDICATOR_RESOLUTION):
        if eventPlayer.slam_indicator_id[i] == null:
            createEffect(eventPlayer if isIndicatorVisible() else null, 
                         Effect.RING, 
                         Color.BLUE, 
                         updateEveryTick(eventPlayer.indicator_slam_position + \
                                         evalOnce(i+1)*(OW1_DOOMFIST_SLAM_AOE_MAX_RADIUS)/OW1_DOOMFIST_SLAM_INDICATOR_RESOLUTION * \
                                         worldVector(Vector.FORWARD, 
                                                     eventPlayer, 
                                                     Transform.ROTATION)), 
                         (evalOnce(i+1)*(OW1_DOOMFIST_SLAM_AOE_MAX_RADIUS)/OW1_DOOMFIST_SLAM_INDICATOR_RESOLUTION)*sinDeg(OW1_DOOMFIST_SEISMIC_SLAM_FAN_ANGLE/2), 
                         EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.slam_indicator_id[i] = getLastCreatedEntity()
    
    # Sphere for debugging indicator slam
    # if eventPlayer.slam_indicator_id[0] == null:
    #     createEffect(eventPlayer if isIndicatorVisible() else null, 
    #                 Effect.RING, 
    #                 Color.BLUE, 
    #                 updateEveryTick(eventPlayer.indicator_slam_position), 
    #                 0.5, 
    #                 EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #     eventPlayer.slam_indicator_id[0] = getLastCreatedEntity()


def destroySlamIndicatorGui():
    @Name "[doomfist/slam.opy]: destroySlamIndicatorGui()"

    for i in range(len(eventPlayer.slam_indicator_id)):
        destroyEffect(eventPlayer.slam_indicator_id[i])
        eventPlayer.slam_indicator_id[i] = null
    
    # Sphere for debugging indicator slam
    # destroyEffect(eventPlayer.slam_indicator_id[0])
    # eventPlayer.slam_indicator_id[0] = null
