#!mainFile "../../main.opy"

# golden angle in radians
#!define PHI (Math.PI * (sqrt(5)-1))
globalvar los_i
globalvar los_j
globalvar barrier_i # crack loop only: that loop never waits, so it can't be interrupted
playervar barrier_deploy_i # deploy loop waits between batches, so it needs a per-player index
globalvar OW1_ORISA_BARRIER_LOS_FREQ = createWorkshopSetting(float[0.001:60], "Orisa", "Barrier LOS Polling Frequency (Hz)", OW1_ORISA_BARRIER_LOS_FREQ_DEFAULT)
globalvar OW1_ORISA_BARRIER_ORB_SIZE = createWorkshopSetting(float[0.1:3], 'Orisa', 'Barrier Orb Radius', OW1_ORISA_BARRIER_ORB_SIZE_DEFAULT)
globalvar OW1_ORISA_BARRIER_ORB_COUNT = createWorkshopSetting(int[100:200], 'Orisa', 'Barrier Orb Count', OW1_ORISA_BARRIER_ORB_COUNT_DEFAULT)

playervar barrier_pvar
# Barrier seed initial velocity v0
#!defineMember _barrier_seed_id barrier_pvar[0]
# Barrier seed initial position p0
#!defineMember _barrier_seed_v0 barrier_pvar[1]
#!defineMember _barrier_seed_p0 barrier_pvar[2]
playervar barrier_seed_t # Barrier seed time t
playervar barrier_seed_velocity
playervar barrier_seed_position
#!defineMember _seed_hit_surface_normal barrier_pvar[3]

#!defineMember _barrier_origin barrier_pvar[4]
#!defineMember barrier_orientation barrier_pvar[5]
#!defineMember barrier_sample_y barrier_pvar[6]
#!defineMember barrier_sample_radius barrier_pvar[7]
#!defineMember barrier_sample_coordinate barrier_pvar[8]
playervar barrier_entity_positions
playervar barrier_crack_thresholds # per-orb hp ratio below which that orb turns white
playervar barrier_entity_ids

playervar barrier_active
# getTotalTimeElapsed() when barrier times out
#!defineMember barrier_expiry_time barrier_pvar[9]
playervar barrier_hp
#!defineMember barrier_hp_hud_id barrier_pvar[10]
#!defineMember orisa_barrier_hit_positions barrier_pvar[11]

#!defineMember barrier_damage_block_id barrier_pvar[12]
#!defineMember barrier_all_enemies barrier_pvar[13]
playervar enemies_behind_barrier

subroutine throwBarrier
subroutine deployBarrier
subroutine destroyBarrier
subroutine fibonacciSphere
subroutine createBarrierHud
subroutine destroyBarrierHud
subroutine updateBarrierVisual


#!define getBarrierVelocity(t) vect(eventPlayer._barrier_seed_v0.x, \
                                   -9.8 * eventPlayer.barrier_seed_t + eventPlayer._barrier_seed_v0.y, \
                                   eventPlayer._barrier_seed_v0.z)

#!define getBarrierPosition(t) vect(eventPlayer._barrier_seed_v0.x * eventPlayer.barrier_seed_t + eventPlayer._barrier_seed_p0.x, \
                                   -9.8/2 * (eventPlayer.barrier_seed_t ** 2) + eventPlayer._barrier_seed_v0.y * eventPlayer.barrier_seed_t + eventPlayer._barrier_seed_p0.y, \
                                   eventPlayer._barrier_seed_v0.z * eventPlayer.barrier_seed_t + eventPlayer._barrier_seed_p0.z)

#!define isInsideOrisaBarrier(point, center, direction)\
    ((angleBetweenVectors(Vector.UP, directionTowards(center, point)) <= 90) and \
     (angleBetweenVectors(direction, directionTowards(center, point)) <= 90))

# Marks an orb as already cracked so it is never recreated twice
#!define BARRIER_ORB_CRACKED -Math.INFINITY

# Angle of reflection formula from https://math.stackexchange.com/q/13261
#!define reflection(d, n) (d - 2 * (dotProduct(d, n)) * n)

# barrier_active is checked first: workshop stops evaluating conditions at the
# first false one, so players with no active enemy barrier skip the vector math
#!define isAimingAtOrisaBarrier() \
    ((eventPlayer.enemy_orisa_player.barrier_active) \
 and (angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.enemy_orisa_player._barrier_origin)) < 90) \
 and (distance(eventPlayer.getEyePosition(), eventPlayer.enemy_orisa_player._barrier_origin) * sinDeg(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.enemy_orisa_player._barrier_origin))) <= OW1_ORISA_PROTECTIVE_BARRIER_RADIUS))


rule "[orisa/barrier.opy]: Trigger Projectile Barrier ability":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME)

    throwBarrier()
    destroyBarrier()
    deployBarrier()


def throwBarrier(): # Select shield position and orientation
    @Name "[orisa/barrier.opy]: throwBarrier()"

    # Initialize barrier projectile
    eventPlayer.barrier_orientation = getForwardDirection(eventPlayer)
    eventPlayer._barrier_seed_v0 = OW1_ORISA_BARRIER_PROJECTILE_SPEED * eventPlayer.getFacingDirection()
    eventPlayer._barrier_seed_p0 = eventPlayer.getEyePosition()
    eventPlayer.barrier_seed_t = 0
    chase(eventPlayer.barrier_seed_t, OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.barrier_seed_velocity = eventPlayer._barrier_seed_v0
    chase(eventPlayer.barrier_seed_velocity, getBarrierVelocity(eventPlayer.barrier_seed_t), rate=9999, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.barrier_seed_position = eventPlayer._barrier_seed_p0
    chase(eventPlayer.barrier_seed_position, getBarrierPosition(eventPlayer.barrier_seed_t), rate=9999, ChaseReeval.DESTINATION_AND_RATE)

    # Draw barrier projectile object
    createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.barrier_seed_position, 0.1, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer._barrier_seed_id = getLastCreatedEntity()

    # Wait for barrier projectile to hit wall
    waitUntil(updateEveryTick(
                distance(eventPlayer.barrier_seed_position, \
                         raycast(eventPlayer.barrier_seed_position, \
                                 eventPlayer.barrier_seed_position + eventPlayer.barrier_seed_velocity, \
                                 null, \
                                 null, \
                                 false).getHitPosition()) \
                         < 0.5) == true, OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME)

    # Freeze barrier projectile
    stopChasingVariable(eventPlayer.barrier_seed_t)
    stopChasingVariable(eventPlayer.barrier_seed_velocity)
    stopChasingVariable(eventPlayer.barrier_seed_position)

    # Fall down to floor after bouncing off wall
    eventPlayer._seed_hit_surface_normal = (raycast(eventPlayer.barrier_seed_position, \
                                  eventPlayer.barrier_seed_position + eventPlayer.barrier_seed_velocity, \
                                  null, \
                                  null, \
                                  false).getNormal())
    eventPlayer._barrier_seed_v0 = 0.03 * reflection(eventPlayer.barrier_seed_velocity, eventPlayer._seed_hit_surface_normal)
    eventPlayer._barrier_seed_p0 = eventPlayer.barrier_seed_position
    eventPlayer.barrier_seed_t = 0
    chase(eventPlayer.barrier_seed_t, OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.barrier_seed_velocity = eventPlayer._barrier_seed_v0
    chase(eventPlayer.barrier_seed_velocity, getBarrierVelocity(eventPlayer.barrier_seed_t), rate=9999, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.barrier_seed_position = eventPlayer._barrier_seed_p0
    chase(eventPlayer.barrier_seed_position, getBarrierPosition(eventPlayer.barrier_seed_t), rate=9999, ChaseReeval.DESTINATION_AND_RATE)

    # Wait for barrier projectile to hit ground
    waitUntil(updateEveryTick(
                distance(eventPlayer.barrier_seed_position, \
                         raycast(eventPlayer.barrier_seed_position, \
                                 eventPlayer.barrier_seed_position + eventPlayer.barrier_seed_velocity, \
                                 null, \
                                 null, \
                                 false).getHitPosition()) \
                         < 0.5) == true, OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME)

    # Freeze barrier projectile
    stopChasingVariable(eventPlayer.barrier_seed_t)
    stopChasingVariable(eventPlayer.barrier_seed_velocity)
    stopChasingVariable(eventPlayer.barrier_seed_position)

    # Move projectile to where it collided with the ground
    eventPlayer.barrier_seed_position = raycast(eventPlayer.barrier_seed_position, \
                                                eventPlayer.barrier_seed_position + eventPlayer.barrier_seed_velocity, \
                                                null, \
                                                null, \
                                                false).getHitPosition()

    # Destroy projectile
    destroyEffect(eventPlayer._barrier_seed_id)


def deployBarrier(): # Create shield visual object
    @Name "[orisa/barrier.opy]: deployBarrier()"

    # Define barrer by the sphere center position
    eventPlayer._barrier_origin = eventPlayer.barrier_seed_position - OW1_ORISA_PROTECTIVE_BARRIER_RADIUS*eventPlayer.barrier_orientation

    # Debug barrier center
    # createEffect(eventPlayer, Effect.SPHERE, Color.BLACK, eventPlayer._barrier_origin, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    fibonacciSphere()

    # Draw each barrier sample. No reevaluation: orbs are static, and cracking
    # recreates only the orbs that change (see updateBarrierVisual)
    for eventPlayer.barrier_deploy_i in range(len(eventPlayer.barrier_entity_positions)):
        eventPlayer.barrier_crack_thresholds[eventPlayer.barrier_deploy_i] = random.uniform(0, 1)
        createEffect(getAllPlayers(),
                     Effect.SPHERE,
                     eventPlayer.getTeam(),
                     eventPlayer.barrier_entity_positions[eventPlayer.barrier_deploy_i],
                     OW1_ORISA_BARRIER_ORB_SIZE,
                     EffectReeval.NONE)
        eventPlayer.barrier_entity_ids.append(getLastCreatedEntity())
        if eventPlayer.barrier_deploy_i % OW1_ORISA_BARRIER_ORBS_PER_TICK == 0:
            wait() # batch the orb creation so the whole barrier isn't built in one tick

    # Play barrier deploying sound
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.LIME_GREEN, eventPlayer.barrier_seed_position, 100)

    eventPlayer.barrier_active = true
    eventPlayer.barrier_hp = OW1_ORISA_PROJECTILE_BARRIER_HEALTH
    eventPlayer.barrier_expiry_time = getTotalTimeElapsed() + OW1_ORISA_PROJECTILE_BARRIER_MAX_UPTIME

    createBarrierHud()


def fibonacciSphere():
    @Name "[orisa/barrier.opy]: fibonacciSphere()"
    # Evenly distribute N points around a sphere
    # Store coodrindate of those points to barrier_entity_positions array
    # See https://stackoverflow.com/a/26127012 for algorithm

    eventPlayer.barrier_entity_positions = []

    for barrier_i in range(OW1_ORISA_BARRIER_ORB_COUNT):
        eventPlayer.barrier_sample_y = 1 - (barrier_i / (OW1_ORISA_BARRIER_ORB_COUNT-1)) * 2
        if (eventPlayer.barrier_sample_y < -0.2):
            break # Do not draw bottom half of sphere
        eventPlayer.barrier_sample_radius = sqrt(1 - eventPlayer.barrier_sample_y ** 2)
        eventPlayer.barrier_sample_coordinate = vect(cos(PHI*barrier_i) * eventPlayer.barrier_sample_radius,
                                                eventPlayer.barrier_sample_y,
                                                sin(PHI*barrier_i) * eventPlayer.barrier_sample_radius)
        if angleBetweenVectors(eventPlayer.barrier_sample_coordinate, eventPlayer.barrier_orientation) > 90:
            continue # Do not draw back half of sphere
        eventPlayer.barrier_entity_positions.append(eventPlayer._barrier_origin + OW1_ORISA_PROTECTIVE_BARRIER_RADIUS * eventPlayer.barrier_sample_coordinate)


def destroyBarrier():
    @Name "[orisa/barrier.opy]: destroyBarrier()"

    for barrier_i in range(len(eventPlayer.barrier_entity_ids)):
        destroyEffect(eventPlayer.barrier_entity_ids[barrier_i])

    eventPlayer.barrier_entity_ids = []
    eventPlayer.barrier_entity_positions = []
    eventPlayer.barrier_crack_thresholds = []

    eventPlayer.barrier_active = false

    destroyBarrierHud()


rule "[orisa/barrier.opy]: Destroy barrier on barrier timeout":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.barrier_active
    @Condition getTotalTimeElapsed() >= eventPlayer.barrier_expiry_time

    destroyBarrier()


rule "[orisa/barrier.opy]: Destroy barrier when barrier hp runs out":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.barrier_hp <= 0

    destroyBarrier()

rule "[orisa/barrier.opy]: Deal no damage to enemies behind barrier":
    @Event eachPlayer
    @Condition isAimingAtOrisaBarrier()

    if eventPlayer.barrier_damage_block_id == null:
        startDamageModification(eventPlayer.enemies_behind_barrier,
                                eventPlayer,
                                percent(OW1_ORISA_PROJECTILE_BARRIER_BLOCK),
                                DamageReeval.RECEIVERS_DAMAGERS_AND_DMGPERCENT)
        eventPlayer.barrier_damage_block_id = getLastDamageModification()

    while (isAimingAtOrisaBarrier()):
        eventPlayer.enemies_behind_barrier = []
        eventPlayer.barrier_all_enemies = eventPlayer.getPlayersInViewAngle(getOppositeTeam(eventPlayer.getTeam()), 90) # Scan all enemies in front

        for los_i in range(len(eventPlayer.barrier_all_enemies)):
            findSphereHit(
                eventPlayer.getEyePosition(),
                directionTowards(eventPlayer.getEyePosition(), eventPlayer.barrier_all_enemies[los_i].getEyePosition()),
                eventPlayer.enemy_orisa_player._barrier_origin,
                OW1_ORISA_PROTECTIVE_BARRIER_RADIUS)
            eventPlayer.orisa_barrier_hit_positions = [
                point for point in eventPlayer._lsi_x
                if isInsideOrisaBarrier(
                    point,
                    eventPlayer.enemy_orisa_player._barrier_origin,
                    eventPlayer.enemy_orisa_player.barrier_orientation)]
            for los_j in range(len(eventPlayer.orisa_barrier_hit_positions)):
                if (distance(
                        eventPlayer.getEyePosition(),
                        eventPlayer.orisa_barrier_hit_positions[los_j])
                    < distance(
                        eventPlayer.getEyePosition(),
                        eventPlayer.barrier_all_enemies[los_i].getEyePosition())): # barrier hit is between the attacker and the victim
                    eventPlayer.enemies_behind_barrier.append(eventPlayer.barrier_all_enemies[los_i])
                    break
        wait(1/OW1_ORISA_BARRIER_LOS_FREQ)

    stopDamageModification(eventPlayer.barrier_damage_block_id)
    eventPlayer.barrier_damage_block_id = null
    eventPlayer.enemies_behind_barrier = []


rule "[orisa/barrier.opy]: Normal damage when no barrier active":
    @Event eachPlayer
    @Condition not eventPlayer.enemy_orisa_player.barrier_active

    stopDamageModification(eventPlayer.barrier_damage_block_id)
    eventPlayer.barrier_damage_block_id = null


rule "[orisa/barrier.opy]: Decrease barrier health":
    @Event playerDealtDamage
    @Condition victim in eventPlayer.enemies_behind_barrier
    @Condition eventPlayer.enemy_orisa_player.barrier_active

    eventPlayer.enemy_orisa_player.barrier_hp -= (eventDamage if not eventWasCriticalHit else eventDamage/2)/OW1_ORISA_PROJECTILE_BARRIER_BLOCK
    heal(victim, null, eventDamage)

# rule "[orisa/barrier.opy]: Receive no healing when behind barrier":
#     @Event playerReceivedHealing
#     @Condition healee.enemy_orisa_player.barrier_active == true
#     @Condition isAimingAtSphere(healer.getEyePosition(), directionTowards(healer, healee), healee.enemy_orisa_player._barrier_origin, OW1_ORISA_PROTECTIVE_BARRIER_RADIUS)

#     findSphereHit(healer.getEyePosition(), directionTowards(healer, healee), healee.enemy_orisa_player._barrier_origin, OW1_ORISA_PROTECTIVE_BARRIER_RADIUS)
#     eventPlayer.orisa_barrier_hit_positions = [point for point in eventPlayer._lsi_x if isInsideOrisaBarrier(point, healee.enemy_orisa_player._barrier_origin, healee.enemy_orisa_player.barrier_orientation)]

#     for i in range(len(eventPlayer.orisa_barrier_hit_positions)):
#         if (distance(healer.getEyePosition(), eventPlayer.orisa_barrier_hit_positions[i]) < distance(healer.getEyePosition(), healee.getEyePosition())): # barrier hit is between the healer and the healee
#             damage(healee, null, eventHealing)
#             healee.enemy_orisa_player.barrier_hp -= eventHealing
#             return


def createBarrierHud():
    @Name "[orisa/barrier.opy]: createBarrierHud()"

    progressBarHud(eventPlayer,
                   percent(eventPlayer.barrier_hp/OW1_ORISA_PROJECTILE_BARRIER_HEALTH),
                   "{}".format(ceil(eventPlayer.barrier_hp)),
                   HudPosition.TOP,
                   Math.INFINITY,
                   Color.SKY_BLUE,
                   Color.WHITE,
                   ProgressHudReeval.VALUES,
                   SpecVisibility.DEFAULT)
    eventPlayer.barrier_hp_hud_id = getLastCreatedText()


def destroyBarrierHud():
    @Name "[orisa/barrier.opy]: destroyBarrierHud()"

    destroyProgressBarHud(eventPlayer.barrier_hp_hud_id)


def updateBarrierVisual():
    @Name "[orisa/barrier.opy]: updateBarrierVisual()"

    # Each orb cracks once, when hp ratio drops below its random threshold.
    # Runs in a single tick (no wait) so the half/quarter rules can't interleave
    # on the shared barrier_i index or double-create an orb.
    for barrier_i in range(len(eventPlayer.barrier_entity_positions)):
        if (eventPlayer.barrier_hp/OW1_ORISA_PROJECTILE_BARRIER_HEALTH) < eventPlayer.barrier_crack_thresholds[barrier_i]:
            eventPlayer.barrier_crack_thresholds[barrier_i] = BARRIER_ORB_CRACKED
            destroyEffect(eventPlayer.barrier_entity_ids[barrier_i])
            createEffect(getAllPlayers(),
                         Effect.SPHERE,
                         Color.WHITE,
                         eventPlayer.barrier_entity_positions[barrier_i],
                         OW1_ORISA_BARRIER_ORB_SIZE,
                         EffectReeval.NONE)
            eventPlayer.barrier_entity_ids[barrier_i] = getLastCreatedEntity()


rule "[orisa/barrier.opy]: Crack Barrier at half health":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.barrier_hp <= OW1_ORISA_PROJECTILE_BARRIER_HEALTH/2

    updateBarrierVisual()


rule "[orisa/barrier.opy]: Crack Barrier at quarter health":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.barrier_hp <= OW1_ORISA_PROJECTILE_BARRIER_HEALTH/4

    updateBarrierVisual()
