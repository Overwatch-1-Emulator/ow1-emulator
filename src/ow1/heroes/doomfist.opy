#!mainFile "../../main.opy"

/*
This DPS doomfist workshop script is sourced from
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474

This file was created by decompiling the original 
workshop gamemode through OverPy, and editing the 
rules/functions as needed.
*/

playervar i

# Variables for uppercut
playervar pressing_uppercut_key
playervar is_using_uppercut
playervar enemies_in_uppercut_radius
playervar enemies_in_uppercut_view
playervar enemies_hit_by_uppercut

# Variables for slam
playervar pressing_slam_key
playervar is_using_slam

subroutine initDoomfist
subroutine initiateSlam
subroutine initiateUppercut
subroutine detectUpercutHit

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


rule "[doomfist.opy]: press virtual uppercut key on pressing shift":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)

    eventPlayer.pressing_uppercut_key = true
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1), 9999)
    eventPlayer.pressing_uppercut_key = false


rule "[doomfist.opy]: press virtual slam key on pressing e":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

    eventPlayer.pressing_slam_key = true
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2), 9999)
    eventPlayer.pressing_slam_key = false


rule "[doomfist.opy]: Perform uppercut":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.pressing_uppercut_key == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition not eventPlayer.hasStatusEffect(Status.HACKED)

    initiateUppercut()


rule "[doomfist.opy]: Perform slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.pressing_slam_key == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not eventPlayer.hasStatusEffect(Status.HACKED)

    initiateSlam()


def initiateUppercut():
    @Name "[doomfist.opy]: Execute main logic for Uppercut ability"

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
        eventPlayer.enemies_hit_by_uppercut[eventPlayer.i].startForcingThrottle(0, 0, 0, 0, 0, 0)
        wait()
        eventPlayer.enemies_hit_by_uppercut[eventPlayer.i].applyImpulse(Vector.UP, 15, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        eventPlayer.enemies_hit_by_uppercut[eventPlayer.i].applyImpulse(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        

def initiateSlam():
    @Name "[doomfist.opy]: Execute main logic for Slam"

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_DOOMFIST_SLAM_COOLDOWN)