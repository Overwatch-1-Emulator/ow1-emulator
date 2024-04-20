#!mainFile "../../main.opy"

# golden angle in radians
#!define PHI (Math.PI * (sqrt(5)-1))
globalvar los_i
globalvar los_j
globalvar barrier_i

playervar barrier_pvar
#!defineMember _barrier_seed_id barrier_pvar[0]
# Barrier seed initial velocity v0
#!defineMember _barrier_seed_v0 barrier_pvar[1]
# Barrier seed initial position p0
#!defineMember _barrier_seed_p0 barrier_pvar[2]
playervar barrier_seed_t # Barrier seed time t
playervar barrier_seed_velocity
playervar barrier_seed_position
#!defineMember _seed_hit_surface_normal barrier_pvar[3]

#!defineMember _barrier_origin barrier_pvar[4]
playervar barrier_orientation
playervar barrier_sample_y
playervar barrier_sample_radius
playervar barrier_sample_coordinate
playervar barrier_entity_positions
playervar barrier_entity_colors
playervar barrier_entity_ids

playervar barrier_active
playervar barrier_uptime
playervar barrier_hp
playervar barrier_hp_hud_id
playervar orisa_barrier_hit_positions

playervar barrier_damage_block_id
playervar barrier_all_enemies
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

# Angle of reflection formula from https://math.stackexchange.com/q/13261
#!define reflection(d, n) (d - 2 * (dotProduct(d, n)) * n)

#!define isAimingAtOrisaBarrier() \
    ((distance(eventPlayer.getEyePosition(), eventPlayer.enemy_orisa_player._barrier_origin) * sinDeg(angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.enemy_orisa_player._barrier_origin))) <= OW1_ORISA_PROTECTIVE_BARRIER_RADIUS) \
 and (angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.enemy_orisa_player._barrier_origin)) < 90) \
 and (eventPlayer.enemy_orisa_player.barrier_active))


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
                         < 0.5), OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME)
    
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
                         < 0.5), OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME)
    
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

    # Draw each barrier sample
    for barrier_i in range(len(eventPlayer.barrier_entity_positions)):
        createEffect(getAllPlayers(), 
                     Effect.SPHERE, 
                     eventPlayer.barrier_entity_colors[evalOnce(barrier_i)],
                     eventPlayer.barrier_entity_positions[evalOnce(barrier_i)], 
                     OW1_ORISA_BARRIER_ORB_SIZE, 
                     EffectReeval.COLOR)
        eventPlayer.barrier_entity_ids.append(getLastCreatedEntity())

    # Play barrier deploying sound
    playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.LIME_GREEN, eventPlayer.barrier_seed_position, 100)

    eventPlayer.barrier_active = true
    eventPlayer.barrier_hp = OW1_ORISA_PROJECTILE_BARRIER_HEALTH
    eventPlayer.barrier_uptime = 0
    chase(eventPlayer.barrier_uptime, OW1_ORISA_PROJECTILE_BARRIER_MAX_UPTIME, rate=1, ChaseReeval.NONE)
    
    updateBarrierVisual()
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

    eventPlayer.barrier_active = false

    destroyBarrierHud()


rule "[orisa/barrier.opy]: Destroy barrier on barrier timeout":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.barrier_uptime >= OW1_ORISA_PROJECTILE_BARRIER_MAX_UPTIME

    stopChasingVariable(eventPlayer.barrier_uptime)
    destroyBarrier()


rule "[orisa/barrier.opy]: Destroy barrier when barrier hp runs out":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.barrier_hp <= 0

    stopChasingVariable(eventPlayer.barrier_uptime)
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
    
    for barrier_i in range(len(eventPlayer.barrier_entity_positions)):
        eventPlayer.barrier_entity_colors[barrier_i] = eventPlayer.getTeam() \
                                               if random.uniform(0, 1) <= (eventPlayer.barrier_hp/OW1_ORISA_PROJECTILE_BARRIER_HEALTH) \
                                               else Color.WHITE
        wait()


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
