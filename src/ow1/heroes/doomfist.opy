#!mainFile "../../main.opy"

/*
This DPS doomfist workshop script is sourced from
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474

This file was created by decompiling the original 
workshop gamemode through OverPy, and editing the 
rules/functions as needed.
*/

playervar indicator_slam 0
playervar slam_timer 1
playervar slam_timer_visible 2
playervar is_uppercutting 3
playervar player_id 4
playervar beam_id 5
playervar hit_players 6
playervar uppercut_momentum 7
playervar uppercut_dealer 8
playervar players_in_view 9
playervar uppercut_lock_timer 10
playervar punch_hit_timer 11
playervar second_hit 12
playervar average_angle 18
playervar height 20
playervar slam_horizontal_distance 21
playervar slam_direction_when_pressed 22
playervar diamond_indicator 26
playervar ground_slam 27
playervar all_slam_vics 28
playervar has_slam_timer 29
playervar BottomLine 30
playervar isCloseSlam 31
playervar DpsSlam 32
playervar UltimatePlayers_Hit_increment 33
playervar UpperFloat 35
playervar isPunching 36
playervar MainPunchVictim 37
playervar SecondaryPunchVictim 38
playervar PunchCast 39
playervar UltimatePlayers_Hit 41
playervar SinglePunchPhase 42
playervar DoomKBCorrection 43
playervar PhaseVictims 44
playervar X_POS 45
playervar Y_POS 46
playervar FakePunchVictims 48
playervar DoomHealthCorrection 49
playervar RisingFistSymbol 50
playervar RisingFistSymbolTracker 51
playervar SlamTimerTEXT 52
playervar VictimsInView 53
playervar MultiPunchVictims 54
playervar MPVid 55
playervar isIndicating 56
playervar PunchCastID 57
playervar temphpTracker 61
playervar PfP 64
playervar SlamCamLocked 68
playervar slamRaycastEndPos 69
playervar tankslam360 71
playervar hasUsedSlam 72
playervar slamTrackedPosition 73
playervar slamEndPosition 74
playervar previousTickPosition 75
playervar tickRaycast 76
playervar originalRaycastHeight 77
playervar raycastTryNumber 78
playervar showIndicator 79
playervar spotFound 80
playervar TopLine 81
playervar RightLine 82
playervar LeftLine 83
playervar FakeSlamVictims 87
playervar SlamVicsInView 88
playervar TrueSlamVics 91
playervar victimHASbeenPUNCHED 92
playervar DamageTrueSlamVics 93
playervar SlamBounce 94
playervar NullSlamWithShields 95
playervar MONKEYslamVicsInVA 96


subroutine HandleUltimateDamage 0

# =========================================== ALL SLAM CODE (Damage Ramp & Movement) ===========================================
/*
rule "start slam timer":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility1() == true
    #@Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    #@Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == false
    
    eventPlayer.slam_timer = 0
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    chase(eventPlayer.slam_timer, 125, duration=1.25, ChaseReeval.NONE)
    wait(0.2)
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), 999999)
    #waitUntil(eventPlayer.isOnGround() or eventPlayer.getAltitude() < 0.2 or not eventPlayer.isUsingAbility1(), 999999)
    #eventPlayer.slam_timer = eventPlayer.slam_timer - 0.4
    #stopChasingVariable(eventPlayer.slam_timer)
    #eventPlayer.setDamageDealt(eventPlayer.slam_timer / 60 * 100)
    #wait(0.3)
    #eventPlayer.setDamageDealt(0)
    #wait(0.02)
    #eventPlayer.allowButton(Button.ABILITY_2)
    #eventPlayer.allowButton(Button.ABILITY_1)
    #eventPlayer.allowButton(Button.SECONDARY_FIRE)
    #eventPlayer.setDamageDealt(100)
    #else:
    if eventPlayer.ground_slam == true:
        if eventPlayer.slam_timer < 124:
            eventPlayer.slam_timer = eventPlayer.slam_timer - 3.333
            stopChasingVariable(eventPlayer.slam_timer)
            eventPlayer.setDamageDealt(eventPlayer.slam_timer / 60 * 100)
            wait(0.3)
            eventPlayer.setDamageDealt(0)
            eventPlayer.allowButton(Button.ABILITY_2)
            eventPlayer.allowButton(Button.ABILITY_1)
            eventPlayer.allowButton(Button.SECONDARY_FIRE)
            wait(0.32)
            eventPlayer.setDamageDealt(100)
        else:
            stopChasingVariable(eventPlayer.slam_timer)
            eventPlayer.setDamageDealt(eventPlayer.slam_timer / 60 * 100)
            wait(0.3)
            eventPlayer.setDamageDealt(0)
            eventPlayer.allowButton(Button.ABILITY_2)
            eventPlayer.allowButton(Button.ABILITY_1)
            eventPlayer.allowButton(Button.SECONDARY_FIRE)
            wait(0.32)
            eventPlayer.setDamageDealt(100)
    stopChasingVariable(eventPlayer.slam_timer)
    eventPlayer.setDamageDealt(eventPlayer.slam_timer / 60 * 100)
    wait(0.3)
    eventPlayer.setDamageDealt(0)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    wait(0.32)
    eventPlayer.setDamageDealt(100)
*/

rule "New slam button disabled":
    @Event eachPlayer
    
    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(eventPlayer.getCurrentHero() != Hero.DOOMFIST, 999999)
    eventPlayer.allowButton(Button.ABILITY_1)


rule "(ALL SLAM) EVERYWHERE New slam indicator & allowance":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.getAltitude() > 3
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.is_uppercutting == false
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.slamRaycastEndPos = raycast(eventPlayer.getPosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, getAllPlayers(), false).getHitPosition()
    #if distance(eventPlayer.slamRaycastEndPos, nearestWalkablePosition(eventPlayer.slamRaycastEndPos)) > 0.25:
    eventPlayer.originalRaycastHeight = eventPlayer.getPosition().y - eventPlayer.slamRaycastEndPos.y
    eventPlayer.tickRaycast = raycast(eventPlayer.slamRaycastEndPos, eventPlayer.slamRaycastEndPos - (vect(0, 40 - eventPlayer.originalRaycastHeight, 0)), null, getAllPlayers(), false).getHitPosition()
    eventPlayer.raycastTryNumber = 1
    #while distance(eventPlayer.tickRaycast, nearestWalkablePosition(eventPlayer.tickRaycast)) > 0.25 and eventPlayer.raycastTryNumber < 30:
    eventPlayer.slamRaycastEndPos -= eventPlayer.getFacingDirection() / 2
    eventPlayer.tickRaycast = raycast(eventPlayer.slamRaycastEndPos, eventPlayer.slamRaycastEndPos - (vect(0, 40 - eventPlayer.originalRaycastHeight, 0)), null, getAllPlayers(), false).getHitPosition()
    eventPlayer.raycastTryNumber += 1
    if eventPlayer.raycastTryNumber >= 30:
        eventPlayer.spotFound = false
    else:
        eventPlayer.slamRaycastEndPos = eventPlayer.tickRaycast
        eventPlayer.spotFound = true
    else:
        eventPlayer.spotFound = true
    if eventPlayer.spotFound and eventPlayer.getFacingDirection().y < 0.25 and abs(angleBetweenVectors(eventPlayer.getFacingDirection(), vectorTowards(eventPlayer.getPosition(), eventPlayer.slamRaycastEndPos))) < 15 and eventPlayer.getPosition().y - eventPlayer.slamRaycastEndPos.y < 30 and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.slamRaycastEndPos * vect(1, 0, 1)) < 15:
        if eventPlayer.diamond_indicator == 0:
            #BOTTOM LINE
            createBeam(eventPlayer, Beam.GOOD, updateEveryTick(eventPlayer.slamRaycastEndPos + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0)) * 0.75) + vect(0, 0.15, 0)), updateEveryTick(eventPlayer.slamRaycastEndPos + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * -0.75) + vect(0, 0.15, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.BottomLine = getLastCreatedEntity()
            #TOP LINE
            createBeam(eventPlayer, Beam.GOOD, updateEveryTick(eventPlayer.slamRaycastEndPos + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * 4.463) + vect(0, 0.15, 0), updateEveryTick(eventPlayer.slamRaycastEndPos + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * -4.463) + vect(0, 0.15, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.TopLine = getLastCreatedEntity()
            #RIGHT SIDE
            createBeam(eventPlayer, Beam.GOOD, updateEveryTick(eventPlayer.slamRaycastEndPos + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0)) * 0.75) + vect(0, 0.15, 0)), updateEveryTick(eventPlayer.slamRaycastEndPos + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * 4.463) + vect(0, 0.15, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.RightLine = getLastCreatedEntity()
            #LEFT SIDE
            createBeam(eventPlayer, Beam.GOOD, updateEveryTick(eventPlayer.slamRaycastEndPos + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * -4.463) + vect(0, 0.15, 0), updateEveryTick(eventPlayer.slamRaycastEndPos + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * -0.75) + vect(0, 0.15, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            eventPlayer.LeftLine = getLastCreatedEntity()
            eventPlayer.diamond_indicator = [eventPlayer.BottomLine, eventPlayer.TopLine, eventPlayer.RightLine, eventPlayer.LeftLine]
        eventPlayer.showIndicator = true
    else:
        if eventPlayer.diamond_indicator:
            #destroyEffect(eventPlayer.BottomLine)
            #destroyEffect(eventPlayer.TopLine)
            destroyEffect(eventPlayer.diamond_indicator)
            wait()
            eventPlayer.diamond_indicator = 0
            eventPlayer.showIndicator = false
    wait()
    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0 and not eventPlayer.isFiringSecondaryFire() and eventPlayer.getAltitude() > 3 and not eventPlayer.isUsingAbility1() and eventPlayer.is_uppercutting == false:
        goto RULE_START
    else:
        if eventPlayer.getAltitude() > 3 and not eventPlayer.isUsingAbility1():
            eventPlayer.showIndicator = false
        if eventPlayer.diamond_indicator:
            #destroyEffect(eventPlayer.BottomLine)
            #destroyEffect(eventPlayer.TopLine)
            destroyEffect(eventPlayer.diamond_indicator)
            wait()
            eventPlayer.diamond_indicator = 0


/*
rule "(WALKABLE POSTION SLAM) New slam indicator & allowance":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.getAltitude() > 3
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.is_uppercutting == false
    
    eventPlayer.slamRaycastEndPos = raycast(eventPlayer.getPosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 15, null, getAllPlayers(), false).getHitPosition()
    if distance(eventPlayer.slamRaycastEndPos, nearestWalkablePosition(eventPlayer.slamRaycastEndPos)) > 0.25:
        eventPlayer.originalRaycastHeight = eventPlayer.getPosition().y - eventPlayer.slamRaycastEndPos.y
        eventPlayer.tickRaycast = raycast(eventPlayer.slamRaycastEndPos, eventPlayer.slamRaycastEndPos - (vect(0, 40 - eventPlayer.originalRaycastHeight, 0)), null, getAllPlayers(), false).getHitPosition()
        eventPlayer.raycastTryNumber = 1
        while distance(eventPlayer.tickRaycast, nearestWalkablePosition(eventPlayer.tickRaycast)) > 0.25 and eventPlayer.raycastTryNumber < 30:
            eventPlayer.slamRaycastEndPos -= eventPlayer.getFacingDirection() / 2
            eventPlayer.tickRaycast = raycast(eventPlayer.slamRaycastEndPos, eventPlayer.slamRaycastEndPos - (vect(0, 40 - eventPlayer.originalRaycastHeight, 0)), null, getAllPlayers(), false).getHitPosition()
            eventPlayer.raycastTryNumber += 1
        if eventPlayer.raycastTryNumber >= 30:
            eventPlayer.spotFound = false
        else:
            eventPlayer.slamRaycastEndPos = eventPlayer.tickRaycast
            eventPlayer.spotFound = true
    else:
        eventPlayer.spotFound = true
    if eventPlayer.spotFound and eventPlayer.getFacingDirection().y < 0.25 and abs(angleBetweenVectors(eventPlayer.getFacingDirection(), vectorTowards(eventPlayer.getPosition(), eventPlayer.slamRaycastEndPos))) < 15 and eventPlayer.getPosition().y - eventPlayer.slamRaycastEndPos.y < 30 and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.slamRaycastEndPos * vect(1, 0, 1)) < 15:
        if eventPlayer.BottomLine == 0:
            createEffect(eventPlayer, Effect.RING, Color.BLUE, updateEveryTick(eventPlayer.slamRaycastEndPos + 3 * (normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)))), 3, EffectReeval.POSITION_AND_RADIUS)
            eventPlayer.BottomLine = getLastCreatedEntity()
        eventPlayer.showIndicator = true
    else:
        if eventPlayer.BottomLine:
            destroyEffect(eventPlayer.BottomLine)
            eventPlayer.BottomLine = 0
            eventPlayer.showIndicator = false
    wait()
    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0 and not eventPlayer.isFiringSecondaryFire() and eventPlayer.getAltitude() > 3 and not eventPlayer.isUsingAbility1() and eventPlayer.is_uppercutting == false:
        goto RULE_START
    else:
        if eventPlayer.getAltitude() > 3 and not eventPlayer.isUsingAbility1():
            eventPlayer.showIndicator = false
        if eventPlayer.BottomLine:
            destroyEffect(eventPlayer.BottomLine)
            eventPlayer.BottomLine = 0
*/

rule "Seismic slam Bounce / Pull":
    @Event playerDealtDamage
    @Condition eventAbility == Button.ABILITY_1
    @Condition attacker.getCurrentHero() == Hero.DOOMFIST
    
    victim.setGravity(50)
    if distance(eventPlayer, victim) < 2.5:
        #eventPlayer.TrueSlamVics.forceButtonPress(Button.JUMP)
        victim.applyImpulse(normalize(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z)) + vect(0, 1, 0), max(0, 8.5 - distance(eventPlayer, victim) * 2), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        victim.setGravity(100)
        victim.isCloseSlam = true
    elif distance(eventPlayer.TrueSlamVics, eventPlayer) <= 8:
        #eventPlayer.TrueSlamVics.forceButtonPress(Button.JUMP)
        victim.applyImpulse(normalize(vect(vectorTowards(victim, eventPlayer).x, 0, vectorTowards(victim, eventPlayer).z)) + vect(0, 1, 0), 5 + distance(eventPlayer, victim) / 4, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        victim.setGravity(100)
        victim.isCloseSlam = false


rule "New ground slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isUsingAbility2() == false
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition (eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.STUNNED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.ROOTED)) == false
    @Condition eventPlayer.getAltitude() <= 3
    @Condition eventPlayer.hasUsedSlam == false
    @Condition eventPlayer.is_uppercutting == false
    
    #eventPlayer.PfP = eventPlayer.getFacingDirection()
    #eventPlayer.FakeSlamVictims = []
    #eventPlayer.TrueSlamVics = []
    eventPlayer.ground_slam = true
    eventPlayer.hasUsedSlam = true
    eventPlayer.setGravity(0)
    #eventPlayer.startAcceleration(Vector.UP, 17.5, 60, Relativity.TO_WORLD, AccelReeval.DIRECTION_RATE_AND_MAX_SPEED)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.startForcingButton(Button.ABILITY_1)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_2)
    wait()
    eventPlayer.applyImpulse(eventPlayer.getVelocity() * -1, eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.applyImpulse(normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) + vect(0, 0.075, 0), 16, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    #eventPlayer.startAcceleration(normalize(eventPlayer.getFacingDirection()), 16.44, 16.44, Relativity.TO_PLAYER, AccelReeval.NONE)
    wait(0.3)
    if eventPlayer.UpperFloat == true:
        #eventPlayer.setGravity(100)
        #eventPlayer.stopAcceleration()
        eventPlayer.disallowButton(Button.ABILITY_1)
        eventPlayer.stopForcingButton(Button.ABILITY_1)
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), 999999)
        eventPlayer.stopForcingThrottle()
        waitUntil(not eventPlayer.isUsingAbility1(), 999999)
        eventPlayer.allowButton(Button.PRIMARY_FIRE)
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.allowButton(Button.ABILITY_2)
        eventPlayer.hasUsedSlam = false
        eventPlayer.ground_slam = false
    else:
        eventPlayer.setGravity(100)
        eventPlayer.disallowButton(Button.ABILITY_1)
        eventPlayer.stopForcingButton(Button.ABILITY_1)
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), 999999)
        eventPlayer.stopForcingThrottle()
        #eventPlayer.setGravity(100)
        waitUntil(not eventPlayer.isUsingAbility1(), 999999)
        eventPlayer.allowButton(Button.PRIMARY_FIRE)
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.allowButton(Button.ABILITY_2)
        eventPlayer.hasUsedSlam = false
        eventPlayer.ground_slam = false


rule "New indicator slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isUsingAbility2() == false
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition (eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.STUNNED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.ROOTED)) == false
    @Condition eventPlayer.getAltitude() > 3
    @Condition eventPlayer.hasUsedSlam == false
    @Condition eventPlayer.showIndicator == true
    @Condition eventPlayer.is_uppercutting == false
    @Condition isInLoS(eventPlayer, eventPlayer.slamRaycastEndPos, BarrierLos.PASS_THROUGH_BARRIERS) == true
    @Condition eventPlayer.isInViewAngle(eventPlayer.slamRaycastEndPos, 45) == true
    
    #eventPlayer.FakeSlamVictims = []
    #eventPlayer.TrueSlamVics = []
    eventPlayer.indicator_slam = true
    eventPlayer.allowButton(Button.ABILITY_1)
    #eventPlayer.isIndicating = true
    eventPlayer.startForcingButton(Button.ABILITY_1)
    eventPlayer.hasUsedSlam = true
    eventPlayer.slamEndPosition = eventPlayer.slamRaycastEndPos
    eventPlayer.slamTrackedPosition = eventPlayer.getPosition()
    chase(eventPlayer.slamTrackedPosition, eventPlayer.slamEndPosition, rate=25, ChaseReeval.NONE)
    eventPlayer.setGravity(0)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.startForcingPosition(eventPlayer.slamTrackedPosition, true)
    while not (eventPlayer.slamTrackedPosition == eventPlayer.slamEndPosition or not eventPlayer.isUsingAbility1() or eventPlayer.isOnGround()):
        eventPlayer.previousTickPosition = eventPlayer.getEyePosition()
        wait()
        eventPlayer.disallowButton(Button.ABILITY_1)
        eventPlayer.stopForcingButton(Button.ABILITY_1)
        eventPlayer.tickRaycast = raycast(eventPlayer.previousTickPosition, eventPlayer.getEyePosition(), null, getAllPlayers(), false).getHitPosition()
        if eventPlayer.tickRaycast != eventPlayer.getEyePosition():
            eventPlayer.stopForcingPosition()
            eventPlayer.startForcingPosition(eventPlayer.tickRaycast, false)
            break
    stopChasingVariable(eventPlayer.slamTrackedPosition)
    wait()
    eventPlayer.applyImpulse(eventPlayer.getVelocity() * -1, eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.setGravity(100)
    eventPlayer.stopForcingPosition()
    waitUntil(not eventPlayer.isUsingAbility1(), 999999)
    eventPlayer.stopForcingThrottle()
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.hasUsedSlam = false
    eventPlayer.indicator_slam = false


rule "start slam timer (REVAMP)":
    @Event eachPlayer
    @Hero doomfist
    #@Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == false
    
    eventPlayer.FakeSlamVictims = []
    waitUntil(eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.slam_timer = 0
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    if eventPlayer.ground_slam == true:
        eventPlayer.slam_timer = -3.333
        chase(eventPlayer.slam_timer, 125, duration=1.283, ChaseReeval.NONE)
    elif eventPlayer.indicator_slam == true and eventPlayer.UpperFloat == true:
        eventPlayer.slam_timer = -2
        chase(eventPlayer.slam_timer, 125, duration=1.27, ChaseReeval.NONE)
    else:
        eventPlayer.slam_timer = 1.01
        chase(eventPlayer.slam_timer, 125, duration=1.239, ChaseReeval.NONE)
    wait(0.2)
    waitUntil(eventPlayer.isOnGround() or eventPlayer.getAbilityCooldown(Button.ABILITY_1) == true, 999999)
    #eventPlayer.MONKEYslamVicsInVA = []
    #waitUntil(eventPlayer.isOnGround() or eventPlayer.getAltitude() < 0.2 or not eventPlayer.isUsingAbility1(), 999999)
    #eventPlayer.slam_timer = eventPlayer.slam_timer - 0.4
    #stopChasingVariable(eventPlayer.slam_timer)
    #eventPlayer.setDamageDealt(eventPlayer.slam_timer / 60 * 100)
    #wait(0.3)
    #eventPlayer.setDamageDealt(0)
    #wait(0.02)
    #eventPlayer.allowButton(Button.ABILITY_2)
    #eventPlayer.allowButton(Button.ABILITY_1)
    #eventPlayer.allowButton(Button.SECONDARY_FIRE)
    #eventPlayer.setDamageDealt(100)
    #else:
    #if eventPlayer.ground_slam == true:
    #if eventPlayer.slam_timer < 124:
    #eventPlayer.slam_timer = eventPlayer.slam_timer - 3.333
    #stopChasingVariable(eventPlayer.slam_timer)
    #eventPlayer.setDamageDealt(eventPlayer.slam_timer / 60 * 100)
    #wait(0.3)
    #eventPlayer.setDamageDealt(0)
    #eventPlayer.allowButton(Button.ABILITY_2)
    #eventPlayer.allowButton(Button.ABILITY_1)
    #eventPlayer.allowButton(Button.SECONDARY_FIRE)
    #wait(0.32)
    #eventPlayer.setDamageDealt(100)
    #else:
    #stopChasingVariable(eventPlayer.slam_timer)
    #eventPlayer.setDamageDealt(eventPlayer.slam_timer / 60 * 100)
    #wait(0.3)
    #eventPlayer.setDamageDealt(0)
    #eventPlayer.allowButton(Button.ABILITY_2)
    #eventPlayer.allowButton(Button.ABILITY_1)
    #eventPlayer.allowButton(Button.SECONDARY_FIRE)
    #wait(0.32)
    #eventPlayer.setDamageDealt(100)
    #__end__()
    #__end__()
    if eventPlayer.indicator_slam == true:
        if eventPlayer.slam_timer >= 63.1 and eventPlayer.slam_timer <= 68.9:
            eventPlayer.slam_timer = 65.01
            stopChasingVariable(eventPlayer.slam_timer)
            eventPlayer.setDamageDealt(eventPlayer.slam_timer / 60 * 100)
            wait(0.35)
            eventPlayer.allowButton(Button.ABILITY_2)
            eventPlayer.allowButton(Button.ABILITY_1)
            eventPlayer.allowButton(Button.SECONDARY_FIRE)
            eventPlayer.setDamageDealt(100)
            #eventPlayer.TrueSlamVics = []
        else:
    #eventPlayer.setDamageDealt(0)
    stopChasingVariable(eventPlayer.slam_timer)
    eventPlayer.setDamageDealt(eventPlayer.slam_timer / 60 * 100)
    wait(0.35)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setDamageDealt(100)
    #eventPlayer.TrueSlamVics = []


# =========================================== RISING UPPERCUT CODE ===========================================


rule "New uppercut":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition (eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.STUNNED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.ROOTED)) == false
    #@Condition eventPlayer.getAbilityResource(Button.PRIMARY_FIRE) == true
    #@Condition eventPlayer.DamageTrueSlamVics != true
    @Condition eventPlayer.isPunching == false
    @Condition (eventPlayer.indicator_slam and eventPlayer.ground_slam) == false
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.UpperFloat = true
    eventPlayer.is_uppercutting = true
    eventPlayer.disablePlayerCollision()
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -1 * eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection() * vect(1, 0, 1), 5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.setGravity(0)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    eventPlayer.hit_players = []
    wait(0.15)
    eventPlayer.applyImpulse(vect(0, 1, 0), 40, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.1)
    eventPlayer.applyImpulse(vect(0, -1, 0), max(0, eventPlayer.getSpeedInDirection(vect(0, 1, 0))), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait()
    eventPlayer.applyImpulse(vect(0, 1, 0), 2.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.setGravity(0)
    eventPlayer.is_uppercutting = false
    eventPlayer.enablePlayerCollision()
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)
    wait(0.35)
    eventPlayer.stopForcingThrottle()
    wait(0.15)
    #waitUntil(eventPlayer.isUsingAbility1() == false, 99999)
    eventPlayer.setGravity(50)
    wait(0.25)
    eventPlayer.setGravity(100)
    eventPlayer.UpperFloat = false


rule "uppercut momentum":
    @Event eachPlayer
    @Condition eventPlayer.uppercut_momentum == true
    
    eventPlayer.uppercut_lock_timer = 0.6
    chase(eventPlayer.uppercut_lock_timer, 0, duration=0.6, ChaseReeval.NONE)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    wait()
    eventPlayer.applyImpulse(vect(0, 1, 0), 15, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.applyImpulse(vect(eventPlayer.uppercut_dealer.getFacingDirection().x, 0, eventPlayer.uppercut_dealer.getFacingDirection().z), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.uppercut_momentum = false


rule "uppercut momentum stop":
    @Event eachPlayer
    @Condition eventPlayer.uppercut_lock_timer == 0
    
    stopChasingVariable(eventPlayer.uppercut_lock_timer)
    #if not eventPlayer.isUsingAbility1():
    eventPlayer.stopForcingThrottle()


rule "uppercut hit":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_uppercutting == true
    
    eventPlayer.players_in_view = eventPlayer.getPlayersInViewAngle(getOppositeTeam(eventPlayer.getTeam()), 45)
    for eventPlayer.player_id in range(len(eventPlayer.players_in_view)):
        eventPlayer.beam_id = eventPlayer.players_in_view[eventPlayer.player_id]
        if not eventPlayer.beam_id in eventPlayer.hit_players and isInLoS(eventPlayer, eventPlayer.beam_id, BarrierLos.PASS_THROUGH_BARRIERS) and distance(eventPlayer, eventPlayer.beam_id) < 5:
            eventPlayer.beam_id.uppercut_momentum = true
            eventPlayer.beam_id.uppercut_dealer = eventPlayer
            #50 with the 20% buff
            damage(eventPlayer.beam_id, eventPlayer, 41.67)
            playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, eventPlayer.beam_id.getPosition(), 100)
            playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer.beam_id, 1)
            eventPlayer.hit_players.append(eventPlayer.beam_id)
    wait()
    if eventPlayer.is_uppercutting == true:
        goto RULE_START


rule "Uppercut Victim Effect":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventPlayer.is_uppercutting == true
    
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, eventPlayer.getTeam(), victim, 5)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, victim, 100)


# =========================================== DPS CONVERSTION / STAT CORRECTION =========================================== 

rule "punch damage change 2":
    @Event playerDealtDamage
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim.second_hit == true
    @Condition attacker.getCurrentHero() == Hero.DOOMFIST
    
    damage(victim, attacker, 3.167 * (eventDamage / 1.2))


rule "punch damage change":
    @Event playerDealtDamage
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim.second_hit == false
    @Condition attacker.getCurrentHero() == Hero.DOOMFIST
    
    eventPlayer.victimHASbeenPUNCHED = true
    damage(victim, attacker, 0.667 * (eventDamage / 1.2))
    victim.punch_hit_timer = 0
    victim.second_hit = true
    chase(victim.punch_hit_timer, 1, duration=1, ChaseReeval.NONE)
    eventPlayer.victimHASbeenPUNCHED = false


rule "punch hit timer":
    @Event eachPlayer
    @Condition eventPlayer.punch_hit_timer == 1
    
    eventPlayer.second_hit = false
    stopChasingVariable(eventPlayer.punch_hit_timer)


rule "Doom Health correction (+)":
    @Event eachPlayer
    @Condition Hero.DOOMFIST == eventPlayer.getCurrentHero()
    @Condition eventPlayer.DoomHealthCorrection == false
    
    #eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.temphpTracker, true, true)
    #eventPlayer.temphpTracker = 1
    eventPlayer.setMaxHealth(55.556)
    eventPlayer.DoomHealthCorrection = true


rule "Doom Health correction (-)":
    @Event eachPlayer
    @Condition Hero.DOOMFIST != eventPlayer.getCurrentHero()
    @Condition eventPlayer.DoomHealthCorrection == true
    
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    eventPlayer.DoomHealthCorrection = false


rule "Doom Knockback Correction (+)":
    @Event eachPlayer
    @Condition Hero.DOOMFIST == eventPlayer.getCurrentHero()
    @Condition eventPlayer.DoomKBCorrection == false
    
    eventPlayer.DoomKBCorrection = true
    eventPlayer.setKnockbackReceived(142.895)


rule "Doom Knockback Correction (-)":
    @Event eachPlayer
    @Condition Hero.DOOMFIST != eventPlayer.getCurrentHero()
    @Condition eventPlayer.DoomKBCorrection == true
    
    eventPlayer.DoomKBCorrection = false
    eventPlayer.setKnockbackReceived(100)


rule "============================================================ BUG TESTING =================================================":
    @Event eachPlayer
    


/*
rule "slam effect (Bug testing)":
    @Event eachPlayer
    @Hero doomfist
    
    #hudText(getAllPlayers(), "", "{0}".format(distance(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 20 * eventPlayer.getFacingDirection(), [], getAllPlayers(), true).getHitPosition(), nearestWalkablePosition(raycast(eventPlayer.getEyePo
    #hudHeader(eventPlayer, "angle: {0}".format(asin(eventPlayer.slam_direction_when_pressed.y) * 180 / 3.142), HudPosition.LEFT, 1, Color.ORANGE, HudReeval.STRING, SpecVisibility.DEFAULT)
    #hudHeader(eventPlayer, "better angle: {0}".format(eventPlayer.average_angle * 180 / 3.142), HudPosition.LEFT, 1, Color.ORANGE, HudReeval.STRING, SpecVisibility.DEFAULT)
    #hudHeader(eventPlayer, "height: {0}".format(eventPlayer.height), HudPosition.LEFT, 1, Color.ORANGE, HudReeval.STRING, SpecVisibility.DEFAULT)
    #hudHeader(eventPlayer, "distance: {0}".format(eventPlayer.slam_horizontal_distance), HudPosition.LEFT, 1, Color.ORANGE, HudReeval.STRING, SpecVisibility.DEFAULT)
    #hudHeader(eventPlayer, "average_angle: {0}".format(eventPlayer.average_angle), HudPosition.LEFT, 1, Color.ORANGE, HudReeval.STRING, SpecVisibility.DEFAULT)
    #hudHeader(eventPlayer, "looking: {0}".format(eventPlayer.getFacingDirection()), HudPosition.LEFT, 1, Color.ORANGE, HudReeval.STRING, SpecVisibility.DEFAULT)
    #hudHeader(eventPlayer, "speed up: {0}".format(eventPlayer.getSpeedInDirection(vect(0, 1, 0))), HudPosition.LEFT, 1, Color.ORANGE, HudReeval.STRING, SpecVisibility.DEFAULT)
    #hudHeader(eventPlayer, "Gravity: {0}".format(eventPlayer.getFacingDirection()), HudPosition.LEFT, 1, Color.ORANGE, HudReeval.STRING, SpecVisibility.DEFAULT)
    #hudHeader(eventPlayer, "speed FD: {0}".format(eventPlayer.getSpeedInDirection(eventPlayer.getFacingDirection())), HudPosition.LEFT, 1, Color.ORANGE, HudReeval.STRING, SpecVisibility.DEFAULT)
    hudHeader(eventPlayer, "VIC HAS BEEN PUNCHED: {0}".format("YUH" if eventPlayer.victimHASbeenPUNCHED == true else null), HudPosition.LEFT, 1, Color.ORANGE, HudReeval.STRING, SpecVisibility.DEFAULT)
    #hudHeader(eventPlayer, "gc: {0}".format("ur on the ground lil bro" if eventPlayer.isOnGround() == true else "ur in air lil bro"), HudPosition.LEFT, 1, Color.ORANGE, HudReeval.STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "is: {0}".format("IS INDICATING" if eventPlayer.indicator_slam == true else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "GS: {0}".format("IS GROUNDING" if eventPlayer.ground_slam == true else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "US: {0}".format("U USED SLAM LIL BRO" if eventPlayer.hasUsedSlam == true else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(eventPlayer, "MAINpv: {0}".format(eventPlayer.MainPunchVictim), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(eventPlayer, "MaPVpC: {1}".format(null, "LIL BRO IS PHASED! NOT GOOD" if eventPlayer.MainPunchVictim.hasStatusEffect(Status.PHASED_OUT) == true else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "{0}".format("UR PUNCHING LIL BRO" if eventPlayer.isPunching == true else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(getAllPlayers(), "{0}".format("METRO STIKE!" if eventPlayer.isUsingUltimate() else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "{0}".format("UR **** ON COOLDOWN LIL BRO" if eventPlayer.getAbilityCooldown(Button.ABILITY_1) == true else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(eventPlayer, "{0}".format("SCLOCKED" if eventPlayer.SlamCamLocked == true else "SCUNLOCKED"), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(eventPlayer, "{0}".format("UR PUNCHING LIL BRO" if eventPlayer.isPunching == true else "NOT PUNCHING"), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(getAllPlayers(), "SV: {0}".format("TSV: {0} FSV: {1}".format(eventPlayer.TrueSlamVics, eventPlayer.FakeSlamVictims) if eventPlayer.isUsingAbility1() else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "{0}".format(eventPlayer.DpsSlam), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "{0}".format(eventPlayer.TrueSlamVics), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "{0}".format(eventPlayer.FakePunchVictims), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "{0}".format(eventPlayer.MainPunchVictim), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "{0}".format("PHASED" if eventPlayer.PhaseVictims == true else "Not Phased"), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "{0}".format("IS FIRING SECONDARY" if eventPlayer.isFiringSecondaryFire() else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "{0}".format("SF BUTTON IS HELD" if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "{0}".format("UR NOT FIRING SECONDARY" if eventPlayer.isFiringSecondaryFire() == false else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudHeader(getAllPlayers(), "{0}".format("U LET GO OF THE BUTTON" if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false else null), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
*/

/*
rule "Dummy Bots (+) (Bug Testing)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    if eventPlayer.isHoldingButton(Button.CROUCH):
        createDummy(Hero.TRACER, getOppositeTeam(eventPlayer.getTeam()), -1, eventPlayer.getPosition(), eventPlayer.getFacingDirection())
    elif eventPlayer.isHoldingButton(Button.JUMP):
        createDummy(Hero.KIRIKO, getOppositeTeam(eventPlayer.getTeam()), -1, eventPlayer.getPosition(), eventPlayer.getFacingDirection())
    else:
        createDummy(Hero.WIDOWMAKER, getOppositeTeam(eventPlayer.getTeam()), -1, eventPlayer.getPosition(), eventPlayer.getFacingDirection())
*/

/*
rule "Dummy Bots (-) (Bug Testing)":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    destroyAllDummies()
    #if eventPlayer.isHoldingButton(Button.CROUCH):
    #createDummy(Hero.TRACER, getOppositeTeam(eventPlayer.getTeam()), -1, eventPlayer.getPosition(), eventPlayer.getFacingDirection())
    #elif eventPlayer.isHoldingButton(Button.JUMP):
    #createDummy(Hero.KIRIKO, getOppositeTeam(eventPlayer.getTeam()), -1, eventPlayer.getPosition(), eventPlayer.getFacingDirection())
    #else:
    #createDummy(Hero.WIDOWMAKER, getOppositeTeam(eventPlayer.getTeam()), -1, eventPlayer.getPosition(), eventPlayer.getFacingDirection())
*/

# =========================================== HUD THINGS ===========================================


rule "slam timer hud":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    @Condition eventPlayer.has_slam_timer == false
    
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer if eventPlayer.slam_timer_visible else null, "", "{0}".format(round(eventPlayer.slam_timer)), "", HudPosition.TOP, 0.65, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudText(eventPlayer if eventPlayer.slam_timer_visible else null, "", "{0}".format(eventPlayer.slam_timer), "", HudPosition.TOP, 0.65, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.has_slam_timer = true


rule "slam timer visibility":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.slam_timer_visible = true
    #waitUntil(not eventPlayer.isUsingAbility1(), 999999)
    wait()
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), 999999)
    #waitUntil(eventPlayer.isOnGround(), 9999999)
    #wait(1)
    eventPlayer.slam_timer_visible = false
    eventPlayer.SlamTimerTEXT = true


rule "Final Slam Timer BOLD":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    #@Condition eventPlayer.isOnGround() == true
    #@Condition eventPlayer.slam_timer_visible == true
    @Condition eventPlayer.SlamTimerTEXT == true
    
    eventPlayer.Y_POS = -0.1
    eventPlayer.X_POS = 0
    #ROUNDING, NORMAL GAMEPLAY
    createInWorldText(eventPlayer if eventPlayer.SlamTimerTEXT else null, round(eventPlayer.slam_timer), updateEveryTick(eventPlayer.getEyePosition() + (100 * (eventPlayer.X_POS * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((eventPlayer.Y_POS - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    #NO ROUNDING FOR BUG TESTING
    #createInWorldText(eventPlayer if eventPlayer.SlamTimerTEXT else null, eventPlayer.slam_timer, updateEveryTick(eventPlayer.getEyePosition() + (100 * (eventPlayer.X_POS * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((eventPlayer.Y_POS - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    wait(1)
    eventPlayer.SlamTimerTEXT = false


/*
rule "Fake Uppercut Symbol (+)":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    @Condition eventPlayer.RisingFistSymbolTracker == false
    
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.RIGHT, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(getAllPlayers(), null, "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎", iconString(Icon.ARROW_UP), HudPosition.RIGHT, 0.7, Color.BLACK, Color.BLACK, Color.BLACK, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.RisingFistSymbol = getLastCreatedText()
    eventPlayer.RisingFistSymbolTracker = true
*/

/*
rule "Fake Uppercut Symbol (Temp - on cooldown)":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == true
    @Condition eventPlayer.RisingFistSymbolTracker == true
    
    destroyHudText(eventPlayer.RisingFistSymbol)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0, 99999)
    hudText(getAllPlayers(), null, "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎ ‎", iconString(Icon.ARROW_UP), HudPosition.RIGHT, 0.7, Color.BLACK, Color.BLACK, Color.BLACK, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.RisingFistSymbol = getLastCreatedText()
*/

/*
rule "Fake Uppercut Symbol (-)":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.DOOMFIST
    @Condition eventPlayer.RisingFistSymbolTracker == true
    
    destroyAllHudTexts()
    eventPlayer.RisingFistSymbolTracker = false
*/

# =========================================== SINGLE PUNCH CODE ===========================================


rule "Single Punch Condition":
    @Event eachPlayer
    @Condition eventPlayer.isPunching == true
    
    eventPlayer.MainPunchVictim.clearStatusEffect(Status.PHASED_OUT)
    #eventPlayer.hit_players = []
    #eventPlayer.PunchCast = raycast(eventPlayer.getPosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 20, getPlayers(getOppositeTeam(eventPlayer.getTeam())), eventPlayer, false).getHitPosition()
    #eventPlayer.MainPunchVictim = getClosestPlayer(eventPlayer.PunchCast, getOppositeTeam(eventPlayer.getTeam()))
    #eventPlayer.MainPunchVictim = eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam()))
    #eventPlayer.players_in_view = eventPlayer.getPlayersInViewAngle(getOppositeTeam(eventPlayer.getTeam()), 45)
    #updateEveryTick(getPlayersInRadius(updateEveryTick(eventPlayer.getPosition()), 10, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF)).setStatusEffect(null, Status.PHASED_OUT, 9999)
    #for eventPlayer.player_id in range(len(eventPlayer.players_in_view)):
    #eventPlayer.beam_id = eventPlayer.players_in_view[eventPlayer.player_id]
    #if not eventPlayer.beam_id in eventPlayer.hit_players and isInLoS(eventPlayer, eventPlayer.beam_id, BarrierLos.PASS_THROUGH_BARRIERS) and distance(eventPlayer, eventPlayer.beam_id) < 5:
    #eventPlayer.beam_id.uppercut_momentum = true
    #for eventPlayer.MainPunchVictim in range(1, len(eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())))):
    #eventPlayer.SecondaryPunchVictim = updateEveryTick(getClosestPlayer(eventPlayer.MainPunchVictim, getOppositeTeam(eventPlayer.getTeam())))
    #(eventPlayer.getPlayersInViewAngle(Team.ALL, 45) + 0).setStatusEffect(null, Status.PHASED_OUT, 9999)
    #eventPlayer.MainPunchVictim.clearStatusEffect(Status.FROZEN)
    #eventPlayer.SecondaryPunchVictim.setStatusEffect(null, Status.FROZEN, 9999)
    #waitUntil(eventPlayer.isPunching == false, 100000000)
    #eventPlayer.SecondaryPunchVictim.clearStatusEffect(Status.FROZEN)
    #getAllPlayers().clearStatusEffect(Status.PHASED_OUT)
    #eventPlayer.hit_players.append(eventPlayer.beam_id)
    #__end__()
    #__end__()
    #wait()
    #if eventPlayer.is_uppercutting == true:
    #        goto RULE_START
    eventPlayer.VictimsInView = eventPlayer.getPlayersInViewAngle(getOppositeTeam(eventPlayer.getTeam()), 100)
    for eventPlayer.MPVid in range(len(eventPlayer.VictimsInView)):
        eventPlayer.PunchCastID = eventPlayer.VictimsInView[eventPlayer.MPVid]
        if not eventPlayer.PunchCastID in eventPlayer.MultiPunchVictims and distance(eventPlayer, eventPlayer.PunchCastID) <= 10:
            #if not eventPlayer.PunchCastID in eventPlayer.MultiPunchVictims and isGameInProgress() and distance(eventPlayer, eventPlayer.PunchCastID) <= 10:
            #eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).clearStatusEffect(Status.PHASED_OUT)
            eventPlayer.PhaseVictims = true
            #playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.WHITE, eventPlayer.beam_id.getPosition(), 100)
            #playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT, Color.WHITE, eventPlayer.beam_id, 1)
            #eventPlayer.FakePunchVictims = eventPlayer.MultiPunchVictims.exclude(eventPlayer.MainPunchVictim)
            eventPlayer.MultiPunchVictims.append(eventPlayer.PunchCastID)
    eventPlayer.MainPunchVictim.clearStatusEffect(Status.PHASED_OUT)
    wait()
    if eventPlayer.isPunching == true:
        goto RULE_START


rule "is punching":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isFiringSecondaryFire() == true
    #@Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    #@Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    
    #waitUntil(eventPlayer.isFiringSecondaryFire() == true, 99999)
    #waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 99999)
    #eventPlayer.MainPunchVictim = eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam()))
    #waitUntil(not (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isFiringSecondaryFire() == false), 0.167)
    #eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.MainPunchVictim = []
    eventPlayer.MultiPunchVictims = []
    eventPlayer.FakePunchVictims = []
    #createEffect(getAllPlayers(), Effect.SPHERE, Color.WHITE, updateEveryTick(eventPlayer.getPosition()), 10, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #hudText(getAllPlayers(), "U ARE PUNCHING", null, "U ARE PUNCHING", HudPosition.LEFT, 0, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.isPunching = true
    #waitUntil(not eventAbility == eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 100000000)
    #waitUntil(eventPlayer.isFiringSecondaryFire() == false, 100000000)
    waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == true or eventPlayer.victimHASbeenPUNCHED == true, 100000000)
    #destroyHudText(getLastCreatedText())
    eventPlayer.isPunching = false
    #eventPlayer.MainPunchVictim = null
    #destroyAllEffects()
    #eventPlayer.SinglePunchPhase = false
    eventPlayer.victimHASbeenPUNCHED = false


rule "Update MainPunchVic every Tick":
    @Event eachPlayer
    @Condition eventPlayer.isPunching == true
    #@Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    #@Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    
    #eventPlayer.MainPunchVictim = null
    #wait()
    #waitUntil(eventPlayer.isFiringSecondaryFire() == true, 99999)
    #waitUntil(not (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isFiringSecondaryFire() == false), 0.167)
    eventPlayer.MainPunchVictim = sorted(eventPlayer.MultiPunchVictims, lambda player: distance(eventPlayer, player))[0]
    #eventPlayer.MainPunchVictim = updateEveryTick(getClosestPlayer(eventPlayer, getOppositeTeam(eventPlayer.getTeam())))
    eventPlayer.FakePunchVictims = eventPlayer.MultiPunchVictims.exclude(eventPlayer.MainPunchVictim)
    eventPlayer.MainPunchVictim.clearStatusEffect(Status.PHASED_OUT)
    wait()
    if eventPlayer.isPunching == true:
        goto RULE_START


rule "MainPunchVic Phased Fix":
    @Event eachPlayer
    #@Condition eventPlayer.MainPunchVictim.hasStatusEffect(Status.PHASED_OUT) == true
    @Condition eventPlayer.isPunching == true
    
    eventPlayer.MainPunchVictim.clearStatusEffect(Status.PHASED_OUT)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "Phase MultiPunchVics ONLY (+/-)":
    @Event eachPlayer
    @Condition eventPlayer.PhaseVictims == true
    
    #wait()
    #waitUntil(eventPlayer.isPunching == true, 99999)
    eventPlayer.FakePunchVictims.setStatusEffect(null, Status.PHASED_OUT, 100000000)
    #if eventPlayer.hit_players.hasStatusEffect(Status.PHASED_OUT) == false:
    #        goto RULE_START
    #eventPlayer.applyImpulse(Vector.UP, 70, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    #eventPlayer.MainPunchVictim.clearStatusEffect(Status.PHASED_OUT)
    #if eventPlayer.isPunching == true:
    #        goto RULE_START
    if eventPlayer.isPunching == true:
        goto RULE_START
    #waitUntil(eventPlayer.isPunching == false, 100000000)
    wait()
    eventPlayer.PhaseVictims = false
    eventPlayer.FakePunchVictims.clearStatusEffect(Status.PHASED_OUT)


rule "=========================================================== OLD SLAM HIT DETECTION ============================================":


rule "Dps Slam And Tank Slam Radius":
    @Event eachPlayer
    @Hero doomfist
    #@Condition (eventPlayer.isUsingAbility1() and eventPlayer.isOnGround()) == true
    #@Condition eventPlayer.isUsingAbility1() == true
    #@Condition (eventPlayer.isUsingAbility1() and eventPlayer.SlamCamLocked != true) == true
    @Condition (eventPlayer.isUsingAbility1() and eventPlayer.getAbilityCooldown(Button.ABILITY_1) != true) == true
    
    eventPlayer.MONKEYslamVicsInVA = getPlayersInRadius(eventPlayer, 17.31, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF)
    eventPlayer.DpsSlam = getPlayersInRadius(eventPlayer, 8, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "True / Fake Slam Vics":
    @Event eachPlayer
    @Hero doomfist
    #@Condition (eventPlayer.isUsingAbility1() and eventPlayer.SlamCamLocked == true) == true
    #@Condition eventPlayer.DamageTrueSlamVics == true
    #@Condition (eventPlayer.isUsingAbility1() and eventPlayer.isOnGround()) == true
    @Condition eventPlayer.isUsingAbility1() == true
    
    #eventPlayer.FakeSlamVictims = [player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player in getPlayersInRadius(eventPlayer, 17.3, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF) and player in eventPlayer.isInViewAngle(eventPlayer, 90) and not player in getPlayersInRadius(eventPlayer, 8, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF) and player in eventPlayer.isInViewAngle(eventPlayer, 45)]
    #eventPlayer.TrueSlamVics = [player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player in getPlayersInRadius(eventPlayer, 8, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF) and player in eventPlayer.isInViewAngle(eventPlayer, 45)]
    #eventPlayer.all_slam_vics = [player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player in getPlayersInRadius(eventPlayer, 17.3, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF) and player in eventPlayer.isInViewAngle(eventPlayer, 90)]
    eventPlayer.TrueSlamVics = [player for player in eventPlayer.DpsSlam if eventPlayer.isInViewAngle(getPlayers(getOppositeTeam(eventPlayer.getTeam())), 45)]
    #wait()
    eventPlayer.tankslam360 = [player for player in eventPlayer.MONKEYslamVicsInVA if eventPlayer.isInViewAngle(getPlayers(getOppositeTeam(eventPlayer.getTeam())), 90)]
    eventPlayer.FakeSlamVictims = eventPlayer.tankslam360.exclude(eventPlayer.TrueSlamVics)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "Slam Victim Damage":
    @Event eachPlayer
    #@Condition eventPlayer.DamageTrueSlamVics == true
    @Condition eventPlayer.isUsingAbility1() == true
    
    #waitUntil(eventPlayer.SlamCamLocked == true, 99999)
    #waitUntil(eventPlayer.isOnGround(), 99999)
    #wait(0.067)
    #eventPlayer.setDamageDealt(eventPlayer.slam_timer / 60 * 100)
    #wait(0.183)
    #eventPlayer.NullSlamWithShields = true
    #damage(eventPlayer.TrueSlamVics, eventPlayer, eventPlayer.slam_timer / 1.2)
    #wait()
    #eventPlayer.SlamBounce = true
    #eventPlayer.setDamageDealt(0)
    #eventPlayer.FakeSlamVictims.setDamageReceived(0)
    waitUntil(eventPlayer.isUsingAbility1() == false, 99999)
    eventPlayer.setDamageDealt(100)
    wait(0.167)
    wait(0.2)
    #eventPlayer.setAbility2Enabled(true)
    eventPlayer.setDamageDealt(100)
    #eventPlayer.FakeSlamVictims.setDamageReceived(100)
    #eventPlayer.FakeSlamVictims = []
    #eventPlayer.DamageTrueSlamVics = false
    #eventPlayer.TrueSlamVics = []
    #eventPlayer.SlamCamLocked = false


rule "SlamCamLocked":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isOnGround() == true
    
    wait(0.017, Wait.ABORT_WHEN_FALSE)
    eventPlayer.SlamCamLocked = true
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.SlamCamLocked = false


rule "Phase Out FSV (var)":
    @Event eachPlayer
    @Hero doomfist
    #@Condition eventPlayer.NullSlamWithShields == true
    #@Condition eventAbility == Button.ABILITY_1
    @Condition (eventPlayer.isUsingAbility1() and eventPlayer.SlamCamLocked) == true
    #@Condition (eventPlayer.isUsingAbility1() and eventPlayer.isOnGround()) == true
    
    eventPlayer.FakeSlamVictims.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.MONKEYslamVicsInVA.clearStatusEffect(Status.PHASED_OUT)
    #eventPlayer.SlamVicsInView.addHealthPool(Health.NORMAL, 60, false, false)
    #eventPlayer.TrueSlamVics.addHealthPool(Health.NORMAL, 60, false, false)
    #eventPlayer.FakeSlamVictims.setStatusEffect(null, Status.FROZEN, 9999)
    eventPlayer.FakeSlamVictims.setStatusEffect(null, Status.PHASED_OUT, 9999)
    #waitUntil(eventPlayer.DamageTrueSlamVics != true, 99999)
    #if eventPlayer.getAbilityCooldown(Button.ABILITY_1) == false:
    #        goto RULE_START
    wait()
    if eventPlayer.isUsingAbility1():
        goto RULE_START
    wait(0.167)
    #wait(1)
    #removeHealthPool(getLastCreatedHealthPool())
    #eventPlayer.FakeSlamVictims.clearStatusEffect(Status.FROZEN)
    eventPlayer.FakeSlamVictims.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.MONKEYslamVicsInVA.clearStatusEffect(Status.PHASED_OUT)
    #eventPlayer.SlamVicsInView.removeAllHealthPools()
    #eventPlayer.NullSlamWithShields = false
    eventPlayer.FakeSlamVictims = []
    eventPlayer.TrueSlamVics = []
    eventPlayer.DpsSlam = []
    eventPlayer.tankslam360 = []
    eventPlayer.MONKEYslamVicsInVA = []


rule "======================================= BUG FIXES / REMOVE EMP PUNCH ===========================================================":


rule "TankBugSlamRemoval":
    @Event eachPlayer
    @Hero doomfist
    #@Condition (eventPlayer.UpperFloat or eventPlayer.is_uppercutting) == true
    #@Condition (eventPlayer.indicator_slam == false or eventPlayer.ground_slam) == false
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    #@Condition eventPlayer.isUsingAbility1() == true
    
    #if eventPlayer.showIndicator == false or eventPlayer.getAltitude() <= 3:
    #eventPlayer.disallowButton(Button.ABILITY_1)
    #eventPlayer.allowButton(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), 99999)
    if eventPlayer.isUsingAbility1() == true and eventPlayer.indicator_slam == false and eventPlayer.ground_slam == false:
        eventPlayer.cancelPrimaryAction()
        stopChasingVariable(eventPlayer.slam_timer)
        eventPlayer.slam_timer_visible = false
        eventPlayer.slam_timer = 0
        wait()
        eventPlayer.applyImpulse(eventPlayer.getVelocity() * -1, eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        #waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_1) == true and eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0 and eventPlayer.isUsingAbility2() == false and eventPlayer.isFiringSecondaryFire() == false and eventPlayer.getAltitude() > 3 and eventPlayer.hasUsedSlam == false and eventPlayer.showIndicator == true and eventPlayer.is_uppercutting == false and eventPlayer.ground_slam == false or eventPlayer.ground_slam == true, 99999)
        #wait(2)
    else:
    waitUntil(eventPlayer.isUsingAbility1() == false, 99999)
    if RULE_CONDITION:
        goto RULE_START


rule "Remove EMP PUNCH from ult":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.isPunching = false
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 4.8)
    waitUntil(not eventPlayer.isUsingUltimate(), 100000000)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setStatusEffect(null, Status.STUNNED, 0.016)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setSecondaryFireEnabled(false)
    wait()
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)


rule "uppercut Cooldown correction":
    @Event eachPlayer
    #@Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.is_uppercutting == true
    
    #waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2), 99999)
    wait(0.38)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 6)


/*
rule "================================== THE BEST DEFFENCE CORRECTIONS ===============================================================":
*/

/*
rule "TempHP removal":
    @Event eachPlayer
    @Condition eventPlayer.temphpTracker > 1
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    chase(eventPlayer.temphpTracker, 1, rate=3, ChaseReeval.DESTINATION_AND_RATE)
*/

/*
rule "Temp HP Setter":
    @Event eachPlayer
    @Condition eventPlayer.temphpTracker != evalOnce(eventPlayer.temphpTracker)
    
    eventPlayer.setHealth(eventPlayer.getHealthOfType(Health.NORMAL) + eventPlayer.temphpTracker)
    wait(0.25)
    goto RULE_START
*/

/*
rule "Temp Tracker (Bug Fixing)":
    hudHeader(getAllPlayers(), "{0}, {1}".format(localPlayer.temphpTracker, localPlayer.getHealthOfType(Health.NORMAL)), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
*/

/*
rule "Has been punched Temp Health Fix":
    @Event playerDealtDamage
    @Condition eventPlayer.victimHASbeenPUNCHED == true
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    
    damage(eventPlayer, null, 35)
    eventPlayer.temphpTracker += 30
*/

/*
rule "ULT temp":
    @Event playerDealtDamage
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    @Condition eventAbility == Button.ULTIMATE
    
    eventPlayer.UltimatePlayers_Hit += 1
    damage(eventPlayer, null, 75)
    wait()
    async(HandleUltimateDamage, AsyncBehavior.NOOP)
*/

/*
rule "SLAM temp":
    @Event playerDealtDamage
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    @Condition eventAbility == Button.ABILITY_1
    
    damage(eventPlayer, null, 35)
    eventPlayer.temphpTracker += 30
*/

/*
def HandleUltimateDamage():
    @Name "Rule 99"
    
    for eventPlayer.UltimatePlayers_Hit_increment in range(eventPlayer.UltimatePlayers_Hit):
        eventPlayer.temphpTracker += 75
    wait(1)
    eventPlayer.UltimatePlayers_Hit = 0
*/

/*
rule "Max Shields":
    @Event eachPlayer
    @Condition eventPlayer.temphpTracker > 150 == true
    
    eventPlayer.temphpTracker = 150
*/

/*
rule "UPPERCUT temp":
    @Event playerDealtDamage
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    @Condition eventPlayer.is_uppercutting == true
    
    eventPlayer.temphpTracker += 30
*/

