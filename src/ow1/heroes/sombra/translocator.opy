#!mainFile "../../../main.opy"

playervar is_using_translocator
playervar transloc_position
playervar trasnloc_velocity
playervar transloc_p0
playervar transloc_v0
playervar transloc_time

playervar translocator_id

subroutine deployTranslocator

#!define getTranslocVelocity(t) vect(eventPlayer.transloc_v0.x, \
                                     -9.8 * t + eventPlayer.transloc_v0.y, \
                                     eventPlayer.transloc_v0.z)

#!define getTranslocPosition(t) vect(eventPlayer.transloc_v0.x * t + eventPlayer.transloc_p0.x, \
                                     -9.8/2 * (t ** 2) + eventPlayer.transloc_v0.y * t + eventPlayer.transloc_p0.y, \
                                     eventPlayer.transloc_v0.z * t + eventPlayer.transloc_p0.z)


rule "[sombra/translocator.opy]: Bind Ability 2 to translocator":
    @Event eachPlayer
    @Hero sombra
    @Condition not eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not eventPlayer.is_using_translocator
    waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_2), Math.INFINITY)

    eventPlayer.is_using_translocator = true
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_SOMBRA_TRANSLOCATOR_COOLDOWN_TIME)
    deployTranslocator()


rule "[sombra/translocator.opy]: Teleport to translocator":
    @Event eachPlayer
    @Hero sombra
    @Condition not eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.is_using_translocator
    waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_2), Math.INFINITY)

    # Freeze translocator projectile
    eventPlayer.teleport(eventPlayer.transloc_position)
    stopChasingVariable(eventPlayer.transloc_time)
    stopChasingVariable(eventPlayer.transloc_position)
    stopChasingVariable(eventPlayer.trasnloc_velocity)
    eventPlayer.transloc_time = null
    eventPlayer.transloc_position = null
    eventPlayer.trasnloc_velocity = null
    destroyEffect(eventPlayer.translocator_id)
    eventPlayer.is_using_translocator = false


def deployTranslocator():
    @Name "[sombra/translocator.opy]: deployTranslocator()"

    # Initialize translocator projectile
    eventPlayer.transloc_v0 = OW1_SOMBRA_TRANSLOCATOR_PROJECTILE_SPEED * eventPlayer.getFacingDirection()
    eventPlayer.transloc_p0 = eventPlayer.getEyePosition()
    eventPlayer.transloc_time = 0
    chase(eventPlayer.transloc_time, OW1_SOMBRA_TRANSLOCATOR_COOLDOWN_TIME, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.trasnloc_velocity = eventPlayer.transloc_v0
    chase(eventPlayer.trasnloc_velocity, getTranslocVelocity(eventPlayer.transloc_time), rate=9999, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.transloc_position = eventPlayer.transloc_p0
    chase(eventPlayer.transloc_position, getTranslocPosition(eventPlayer.transloc_time), rate=9999, ChaseReeval.DESTINATION_AND_RATE)

    # Draw translocator projectile object
    createEffect(getAllPlayers(), Effect.SPHERE, Color.PURPLE, eventPlayer.transloc_position, 0.1, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.translocator_id = getLastCreatedEntity()

    # Wait for translocator projectile to hit wall
    waitUntil(updateEveryTick(
                distance(eventPlayer.transloc_position, \
                         raycast(eventPlayer.transloc_position, \
                                 eventPlayer.transloc_position + eventPlayer.trasnloc_velocity, \
                                 null, \
                                 null, \
                                 false).getHitPosition()) \ 
                         < 0.5), OW1_SOMBRA_TRANSLOCATOR_COOLDOWN_TIME)
    
    # Freeze translocator projectile
    stopChasingVariable(eventPlayer.transloc_time)
    stopChasingVariable(eventPlayer.trasnloc_velocity)
    stopChasingVariable(eventPlayer.transloc_position)
    
    # Fall down to floor after bouncing off wall
    eventPlayer.seed_hit_surface_normal = (raycast(eventPlayer.transloc_position, \
                                  eventPlayer.transloc_position + eventPlayer.trasnloc_velocity, \
                                  null, \
                                  null, \
                                  false).getNormal())
    eventPlayer.transloc_v0 = 0.03 * reflection(eventPlayer.trasnloc_velocity, eventPlayer.seed_hit_surface_normal)
    eventPlayer.transloc_p0 = eventPlayer.transloc_position
    eventPlayer.transloc_time = 0
    chase(eventPlayer.transloc_time, OW1_SOMBRA_TRANSLOCATOR_COOLDOWN_TIME, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.trasnloc_velocity = eventPlayer.transloc_v0
    chase(eventPlayer.trasnloc_velocity, getTranslocVelocity(eventPlayer.transloc_time), rate=9999, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.transloc_position = eventPlayer.transloc_p0
    chase(eventPlayer.transloc_position, getTranslocPosition(eventPlayer.transloc_time), rate=9999, ChaseReeval.DESTINATION_AND_RATE)

    # Wait for translocator projectile to hit ground
    waitUntil(updateEveryTick(
                distance(eventPlayer.transloc_position, \
                         raycast(eventPlayer.transloc_position, \
                                 eventPlayer.transloc_position + eventPlayer.trasnloc_velocity, \
                                 null, \
                                 null, \
                                 false).getHitPosition()) \ 
                         < 0.5), OW1_SOMBRA_TRANSLOCATOR_COOLDOWN_TIME)
    
    # Freeze translocator projectile
    stopChasingVariable(eventPlayer.transloc_time)
    stopChasingVariable(eventPlayer.trasnloc_velocity)
    stopChasingVariable(eventPlayer.transloc_position)
