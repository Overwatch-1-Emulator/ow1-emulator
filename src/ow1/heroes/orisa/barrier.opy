#!mainFile "../../../main.opy"

playervar barrier_projectile
playervar barrier_proj_v0 # Barrier projectile initial velocity v0
playervar barrier_proj_p0 # Barrier projectile initial position p0
playervar barrier_proj_t # Barrier projectile time t
playervar barrier_proj_velocity
playervar barrier_proj_position
playervar barrier_position
playervar barrier_orientation
playervar surface_normal
playervar barrier_sample_x
playervar barrier_sample_y
playervar barrier_sample_z
playervar barrier_sample_radius
playervar barrier_sample_theta
playervar barrier_sample_point
playervar barrier_entity_positions
playervar barrier_entities
playervar barrier_uptime
playervar barrier_active
playervar barrier_health
playervar orisa_barrier_hit_positions
playervar barrier_health_hud

subroutine throwBarrier
subroutine deployBarrier
subroutine destroyBarrier
subroutine fibonacciSphere
subroutine createBarrierHud
subroutine destroyBarrierHud

#!define getBarrierVelocity(t) vect(eventPlayer.barrier_proj_v0.x, \
                                   -9.8 * eventPlayer.barrier_proj_t + eventPlayer.barrier_proj_v0.y, \
                                   eventPlayer.barrier_proj_v0.z)

#!define getBarrierPosition(t) vect(eventPlayer.barrier_proj_v0.x * eventPlayer.barrier_proj_t + eventPlayer.barrier_proj_p0.x, \
                                   -9.8/2 * (eventPlayer.barrier_proj_t ** 2) + eventPlayer.barrier_proj_v0.y * eventPlayer.barrier_proj_t + eventPlayer.barrier_proj_p0.y, \
                                   eventPlayer.barrier_proj_v0.z * eventPlayer.barrier_proj_t + eventPlayer.barrier_proj_p0.z)

#!define isInsideOrisaBarrier(point, center, direction)\
    ((distance(center, point) <= OW1_ORISA_PROTECTIVE_BARRIER_RADIUS) and \
    (angleBetweenVectors(Vector.UP, directionTowards(center, point)) <= 90) and \
    (angleBetweenVectors(direction, directionTowards(center, point)) <= 90))

# Angle of reflection formula from https://math.stackexchange.com/q/13261
#!define reflection(d, n) (d - 2 * (dotProduct(d, n)) * n)

rule "[orisa/barrier.opy]: Disable OW2 Javelin spin":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.call_init == true

    eventPlayer.disallowButton(Button.ABILITY_2)


rule "[orisa/barrier.opy]: Trigger Projectile Barrier ability":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME)

    throwBarrier()
    destroyBarrier()
    deployBarrier()


def throwBarrier(): # Select shield position and orientation
    @Name "[orisa/barrier.opy]: throwBarrier()"

    # Initialize barrier projectile
    eventPlayer.barrier_orientation = getLateralFacingDirection(eventPlayer)
    eventPlayer.barrier_proj_v0 = OW1_ORISA_BARRIER_PROJECTILE_SPEED * eventPlayer.getFacingDirection()
    eventPlayer.barrier_proj_p0 = eventPlayer.getEyePosition()
    eventPlayer.barrier_proj_t = 0
    chase(eventPlayer.barrier_proj_t, OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.barrier_proj_velocity = eventPlayer.barrier_proj_v0
    chase(eventPlayer.barrier_proj_velocity, getBarrierVelocity(eventPlayer.barrier_proj_t), rate=9999, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.barrier_proj_position = eventPlayer.barrier_proj_p0
    chase(eventPlayer.barrier_proj_position, getBarrierPosition(eventPlayer.barrier_proj_t), rate=9999, ChaseReeval.DESTINATION_AND_RATE)

    # Draw barrier projectile object
    createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.barrier_proj_position, 0.1, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.barrier_projectile = getLastCreatedEntity()

    # Wait for barrier projectile to hit wall
    waitUntil(updateEveryTick(
                distance(eventPlayer.barrier_proj_position, \
                         raycast(eventPlayer.barrier_proj_position, \
                                 eventPlayer.barrier_proj_position + eventPlayer.barrier_proj_velocity, \
                                 null, \
                                 null, \
                                 false).getHitPosition()) \ 
                         < 0.5), OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME)
    
    # Freeze barrier projectile
    stopChasingVariable(eventPlayer.barrier_proj_t)
    stopChasingVariable(eventPlayer.barrier_proj_velocity)
    stopChasingVariable(eventPlayer.barrier_proj_position)
    
    # Fall down to floor after bouncing off wall
    eventPlayer.surface_normal = (raycast(eventPlayer.barrier_proj_position, \
                                  eventPlayer.barrier_proj_position + eventPlayer.barrier_proj_velocity, \
                                  null, \
                                  null, \
                                  false).getNormal())
    eventPlayer.barrier_proj_v0 = 0.03 * reflection(eventPlayer.barrier_proj_velocity, eventPlayer.surface_normal)
    eventPlayer.barrier_proj_p0 = eventPlayer.barrier_proj_position
    eventPlayer.barrier_proj_t = 0
    chase(eventPlayer.barrier_proj_t, OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.barrier_proj_velocity = eventPlayer.barrier_proj_v0
    chase(eventPlayer.barrier_proj_velocity, getBarrierVelocity(eventPlayer.barrier_proj_t), rate=9999, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.barrier_proj_position = eventPlayer.barrier_proj_p0
    chase(eventPlayer.barrier_proj_position, getBarrierPosition(eventPlayer.barrier_proj_t), rate=9999, ChaseReeval.DESTINATION_AND_RATE)

    # Wait for barrier projectile to hit ground
    waitUntil(updateEveryTick(
                distance(eventPlayer.barrier_proj_position, \
                         raycast(eventPlayer.barrier_proj_position, \
                                 eventPlayer.barrier_proj_position + eventPlayer.barrier_proj_velocity, \
                                 null, \
                                 null, \
                                 false).getHitPosition()) \ 
                         < 0.5), OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME)
    
    # Freeze barrier projectile
    stopChasingVariable(eventPlayer.barrier_proj_t)
    stopChasingVariable(eventPlayer.barrier_proj_velocity)
    stopChasingVariable(eventPlayer.barrier_proj_position)

    # Move projectile to where it collided with the ground
    eventPlayer.barrier_proj_position = raycast(eventPlayer.barrier_proj_position, \
                                                eventPlayer.barrier_proj_position + eventPlayer.barrier_proj_velocity, \
                                                null, \
                                                null, \
                                                false).getHitPosition()
    
    # Destroy projectile
    destroyEffect(eventPlayer.barrier_projectile)


def deployBarrier(): # Create shield visual object
    @Name "[orisa/barrier.opy]: deployBarrier()"

    # Define barrer by the sphere center position
    eventPlayer.barrier_position = eventPlayer.barrier_proj_position - OW1_ORISA_PROTECTIVE_BARRIER_RADIUS*eventPlayer.barrier_orientation

    # Debug barrier center
    # createEffect(eventPlayer, Effect.SPHERE, Color.BLACK, eventPlayer.barrier_position, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    
    fibonacciSphere()

    # Draw each barrier sample
    for i in range(len(eventPlayer.barrier_entity_positions)):
        eventPlayer.barrier_sample_point = eventPlayer.barrier_entity_positions[i]
        createEffect(getAllPlayers(), 
                     Effect.SPHERE, 
                     eventPlayer.getTeam() 
                        if random.uniform(0, 1) <= eventPlayer.barrier_health/OW1_ORISA_PROJECTILE_BARRIER_HEALTH
                        else Color.WHITE, 
                     evalOnce(eventPlayer.barrier_sample_point), 
                     OW1_ORISA_BARRIER_ORB_SIZE, 
                     EffectReeval.COLOR)
        eventPlayer.barrier_entities.append(getLastCreatedEntity())

    eventPlayer.barrier_active = true
    eventPlayer.barrier_health = OW1_ORISA_PROJECTILE_BARRIER_HEALTH
    eventPlayer.barrier_uptime = 0
    chase(eventPlayer.barrier_uptime, OW1_ORISA_PROJECTILE_BARRIER_MAX_UPTIME, rate=1, ChaseReeval.NONE)

    createBarrierHud()


def fibonacciSphere():
    @Name "[orisa/barrier.opy]: fibonacciSphere()"
    # Evenly distribute N points around a sphere
    # Store coodrindate of those points to barrier_entity_positions array
    # See https://stackoverflow.com/a/26127012 for algorithm

    eventPlayer.barrier_entity_positions = []

    for i in range(OW1_ORISA_PROTECTIVE_BARRIER_RESOLUTION):
        eventPlayer.barrier_sample_y = 1 - (i / (OW1_ORISA_PROTECTIVE_BARRIER_RESOLUTION-1)) * 2
        if (eventPlayer.barrier_sample_y < -0.2): break # Do not draw bottom half of sphere
        eventPlayer.barrier_sample_radius = sqrt(1 - eventPlayer.barrier_sample_y * eventPlayer.barrier_sample_y)

        eventPlayer.barrier_sample_theta = PHI * i

        eventPlayer.barrier_sample_x = cos(eventPlayer.barrier_sample_theta) * eventPlayer.barrier_sample_radius
        eventPlayer.barrier_sample_z = sin(eventPlayer.barrier_sample_theta) * eventPlayer.barrier_sample_radius

        eventPlayer.barrier_sample_point = vect(eventPlayer.barrier_sample_x, eventPlayer.barrier_sample_y, eventPlayer.barrier_sample_z)
        if angleBetweenVectors(eventPlayer.barrier_sample_point, eventPlayer.barrier_orientation) > 90: continue # Do not draw back half of sphere
        eventPlayer.barrier_entity_positions.append(OW1_ORISA_PROTECTIVE_BARRIER_RADIUS * eventPlayer.barrier_sample_point + eventPlayer.barrier_position)


def destroyBarrier():
    @Name "[orisa/barrier.opy]: destroyBarrier()"

    for i in range(len(eventPlayer.barrier_entities)):
        destroyEffect(eventPlayer.barrier_entities[i])

    eventPlayer.barrier_entities = []
    eventPlayer.barrier_entity_positions = []

    eventPlayer.barrier_active = false

    destroyBarrierHud()


rule "[orisa/barrier.opy]: destroy barrier on reset":
    @Event eachPlayer
    @Condition eventPlayer.barrier_active == true
    @Condition eventPlayer.call_reset == true

    destroyBarrier()


rule "[orisa/barrier.opy]: Destroy barrier on barrier timeout":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.barrier_uptime >= OW1_ORISA_PROJECTILE_BARRIER_MAX_UPTIME

    stopChasingVariable(eventPlayer.barrier_uptime)
    destroyBarrier()


rule "[orisa/barrier.opy]: Destroy barrier when barrier hp runs out":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.barrier_health <= 0

    stopChasingVariable(eventPlayer.barrier_uptime)
    destroyBarrier()


rule "[orisa/barrier.opy]: Take no damage when behind barrier":
    @Event playerDealtDamage
    @Condition victim.friendly_orisa_player.barrier_active == true
    @Condition isAimingAtSphere(attacker.getEyePosition(), attacker.getFacingDirection(), victim.friendly_orisa_player.barrier_position, OW1_ORISA_PROTECTIVE_BARRIER_RADIUS)

    detectSphereHit(attacker.getEyePosition(), directionTowards(attacker, victim), victim.friendly_orisa_player.barrier_position, OW1_ORISA_PROTECTIVE_BARRIER_RADIUS)
    eventPlayer.orisa_barrier_hit_positions = [point for point in eventPlayer.lsi_x if isInsideOrisaBarrier(point, victim.friendly_orisa_player.barrier_position, victim.friendly_orisa_player.barrier_orientation)]

    for i in range(len(eventPlayer.orisa_barrier_hit_positions)):
        if (distance(attacker.getEyePosition(), eventPlayer.orisa_barrier_hit_positions[i]) < distance(attacker.getEyePosition(), victim.getEyePosition())): # barrier hit is between the attacker and the victim
            heal(victim, null, eventDamage)
            victim.friendly_orisa_player.barrier_health -= eventDamage
            return


rule "[orisa/barrier.opy]: Receive no healing when behind barrier":
    @Event playerReceivedHealing
    @Condition healee.enemy_orisa_player.barrier_active == true
    @Condition isAimingAtSphere(healer.getEyePosition(), directionTowards(healer, healee), healee.enemy_orisa_player.barrier_position, OW1_ORISA_PROTECTIVE_BARRIER_RADIUS)

    detectSphereHit(healer.getEyePosition(), directionTowards(healer, healee), healee.enemy_orisa_player.barrier_position, OW1_ORISA_PROTECTIVE_BARRIER_RADIUS)
    eventPlayer.orisa_barrier_hit_positions = [point for point in eventPlayer.lsi_x if isInsideOrisaBarrier(point, healee.enemy_orisa_player.barrier_position, healee.enemy_orisa_player.barrier_orientation)]

    for i in range(len(eventPlayer.orisa_barrier_hit_positions)):
        if (distance(healer.getEyePosition(), eventPlayer.orisa_barrier_hit_positions[i]) < distance(healer.getEyePosition(), healee.getEyePosition())): # barrier hit is between the healer and the healee
            damage(healee, null, eventHealing)
            healee.enemy_orisa_player.barrier_health -= eventHealing
            return


def createBarrierHud():
    @Name "[orisa/barrier.opy]: createBarrierHud()"

    progressBarHud(eventPlayer, 
                   percent(eventPlayer.barrier_health/OW1_ORISA_PROJECTILE_BARRIER_HEALTH), 
                   "{}".format(ceil(eventPlayer.barrier_health)), 
                   HudPosition.TOP, 
                   Math.INFINITY, 
                   Color.SKY_BLUE, 
                   Color.WHITE, 
                   ProgressHudReeval.VALUES, 
                   SpecVisibility.DEFAULT)
    eventPlayer.barrier_health_hud = getLastCreatedText()


def destroyBarrierHud():
    @Name "[orisa/barrier.opy]: destroyBarrierHud()"

    destroyProgressBarHud(eventPlayer.barrier_health_hud)


