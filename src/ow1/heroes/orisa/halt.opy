#!mainFile "../../../main.opy"

globalvar PHI = Math.PI * (sqrt(5)-1) # golden angle in radians

playervar is_using_halt
playervar is_snared
playervar halt_position
playervar halt_ending_position
playervar halt_entity1
playervar halt_entity2
playervar halt_pull_line_entity
playervar position

subroutine shootHalt
subroutine explodeHalt

rule "[orisa/halt.opy]: Initialize Halt ability":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.call_init == true

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.is_using_halt = false


rule "[orisa/halt.opy]: Trigger Halt ability start":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true

    shootHalt()
    waitUntil(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false, Math.INFINITY) # Make sure player releases right click
    waitUntil(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true or (eventPlayer.halt_position == eventPlayer.halt_ending_position), Math.INFINITY) # Detect halt pull activation on right click
    explodeHalt()

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_ORISA_HALT_COOLDOWN_TIME)


def shootHalt():
    @Name "[orisa/halt.opy]: Shoot Halt Orb"

    eventPlayer.is_using_halt = true # Start halt

    # Halt orb visuals
    createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.halt_position, OW1_ORISA_HALT_PROJECTILE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.halt_entity1 = getLastCreatedEntity()
    eventPlayer.entity_huds.append(eventPlayer.halt_entity1)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.halt_position, 0.5*OW1_ORISA_HALT_PROJECTILE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.halt_entity2 = getLastCreatedEntity()
    eventPlayer.entity_huds.append(eventPlayer.halt_entity2)

    # Halt orb sounds
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer, 100)
    
    # Calculate starting/ending positions
    eventPlayer.halt_position = eventPlayer.getEyePosition()
    eventPlayer.halt_ending_position = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 1000*eventPlayer.getFacingDirection(), null, null, true).getHitPosition()
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).is_snared = false

    wait(OW1_ORISA_HALT_LAUNCH_CAST_TIME)
    # Start flying halt orb
    chase(eventPlayer.halt_position, eventPlayer.halt_ending_position, rate=OW1_ORISA_HALT_PROJECTILE_SPEED, ChaseReeval.DESTINATION_AND_RATE)


def explodeHalt():
    @Name "[orisa/halt.opy]: Explode Halt Orb"

    stopChasingVariable(eventPlayer.halt_position)
    wait(OW1_ORISA_HALT_ACTIVATION_TIME)
    getPlayersInRadius(eventPlayer.halt_position, OW1_ORISA_HALT_AOE_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES_AND_ENEMY_BARRIERS).is_snared = true
    getPlayersInRadius(eventPlayer.halt_position, OW1_ORISA_HALT_AOE_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES_AND_ENEMY_BARRIERS).setEnvironmentalKillCreditor(eventPlayer)


    # Halt orb explosion sounds
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer, 100)

    # Clear visuals
    destroyEffect(eventPlayer.halt_entity1)
    destroyEffect(eventPlayer.halt_entity2)
    eventPlayer.entity_huds.remove(eventPlayer.halt_entity1)
    eventPlayer.entity_huds.remove(eventPlayer.halt_entity2)

    eventPlayer.is_using_halt = false


rule "[orisa/halt.opy]: Destroy Halt Orb VFX":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.is_using_halt == false


rule "[orirsa.opy]: Slow down snared enemies":
    @Event eachPlayer
    @Condition eventPlayer.is_snared == true

    eventPlayer.setMoveSpeed(100-OW1_ORISA_HALT_SNARE_MOVE_PENALTY)
    wait(OW1_ORISA_HALT_SNARE_DURATION)
    eventPlayer.setMoveSpeed(100)


rule "[orisa/halt.opy]: Pull halted victims":
    @Event eachPlayer
    @Condition eventPlayer.is_snared == true

    eventPlayer.position = eventPlayer.getPosition()
    eventPlayer.startForcingPosition(eventPlayer.position, true)
    chase(eventPlayer.position, eventPlayer.enemy_orisa_player.halt_position, rate=OW1_ORISA_HALT_PULL_SPEED, ChaseReeval.DESTINATION_AND_RATE)
    waitUntil(eventPlayer.position == eventPlayer.enemy_orisa_player.halt_position, Math.INFINITY)
    stopChasingVariable(eventPlayer.position)
    eventPlayer.stopForcingPosition()
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Cancel current momentum
    eventPlayer.is_snared = false


rule "[orisa/halt.opy]: Create Halt pull line vfx when in pull range":
    @Event eachPlayer
    @Condition eventPlayer.enemy_orisa_player.is_using_halt == true
    @Condition (distance(eventPlayer, eventPlayer.enemy_orisa_player.halt_position) <= OW1_ORISA_HALT_AOE_RADIUS and \
               isInLoS(eventPlayer, eventPlayer.enemy_orisa_player.halt_position, BarrierLos.BLOCKED_BY_ALL_BARRIERS)) == true
    @Condition eventPlayer.isAlive()
               
    # Halt orb explosion sounds
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.LIME_GREEN, eventPlayer, 100)
    
    createBeam(getAllPlayers(), Beam.GOOD, eventPlayer.enemy_orisa_player.halt_position, eventPlayer, Color.GREEN if eventPlayer.is_snared else Color.WHITE, EffectReeval.POSITION_RADIUS_AND_COLOR)
    eventPlayer.halt_pull_line_entity = getLastCreatedEntity()
    eventPlayer.entity_huds.append(eventPlayer.halt_pull_line_entity)


rule "[orisa/halt.opy]: Destroy Halt pull line vfx when not in pull range":
    @Event eachPlayer
    @Condition eventPlayer.enemy_orisa_player.is_using_halt == true
    @Condition (distance(eventPlayer, eventPlayer.enemy_orisa_player.halt_position) <= OW1_ORISA_HALT_AOE_RADIUS and \
               isInLoS(eventPlayer, eventPlayer.enemy_orisa_player.halt_position, BarrierLos.BLOCKED_BY_ALL_BARRIERS)) == false
    
    destroyEffect(eventPlayer.halt_pull_line_entity)
    eventPlayer.entity_huds.remove(eventPlayer.halt_pull_line_entity)


rule "[orisa/halt.opy]: Destroy Halt pull line vfx when halt is over":
    @Event eachPlayer
    @Condition eventPlayer.enemy_orisa_player.is_using_halt == false

    destroyEffect(eventPlayer.halt_pull_line_entity)
    eventPlayer.entity_huds.remove(eventPlayer.halt_pull_line_entity)

rule "[orisa/halt.opy]: Destroy Halt pull line vfx when dead":
    @Event eachPlayer
    @Condition eventPlayer.isDead()

    destroyEffect(eventPlayer.halt_pull_line_entity)
    eventPlayer.entity_huds.remove(eventPlayer.halt_pull_line_entity)
