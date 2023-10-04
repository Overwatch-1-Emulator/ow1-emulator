#!mainFile "../../../main.opy"

globalvar PHI = Math.PI * (sqrt(5)-1) # golden angle in radians

playervar is_using_halt
playervar is_snared
playervar halt_position
playervar halt_ending_position
playervar halt_orb_id
playervar halt_snare_line_id
playervar position

subroutine shootHalt
subroutine explodeHalt


rule "[orisa/halt.opy]: Trigger Halt ability":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) <= 0
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    shootHalt()
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), Math.INFINITY) # Ensure player releases right click
    waitUntil(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) \
              or (eventPlayer.halt_position == eventPlayer.halt_ending_position), Math.INFINITY) # Detect halt pull activation on right click
    explodeHalt()

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_ORISA_HALT_COOLDOWN_TIME)


def shootHalt():
    @Name "[orisa/halt.opy]: Shoot Halt Orb"

    eventPlayer.is_using_halt = true # Start halt

    # Halt orb visuals
    if (eventPlayer.halt_orb_id[0] == null):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.halt_position, OW1_ORISA_HALT_PROJECTILE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.halt_orb_id[0] = getLastCreatedEntity()
    if (eventPlayer.halt_orb_id[1] == null):
        createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.halt_position, 0.5*OW1_ORISA_HALT_PROJECTILE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.halt_orb_id[1] = getLastCreatedEntity()

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
    getPlayersInRadius(eventPlayer.halt_position, 
                       OW1_ORISA_HALT_AOE_RADIUS, 
                       getOppositeTeam(eventPlayer.getTeam()), 
                       LosCheck.SURFACES_AND_ENEMY_BARRIERS).is_snared = true
    getPlayersInRadius(eventPlayer.halt_position, 
                       OW1_ORISA_HALT_AOE_RADIUS, 
                       getOppositeTeam(eventPlayer.getTeam()), 
                       LosCheck.SURFACES_AND_ENEMY_BARRIERS).setEnvironmentalKillCreditor(eventPlayer)

    # Halt orb explosion sounds
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer, 100)

    # Clear visuals
    destroyEffect(eventPlayer.halt_orb_id[0])
    eventPlayer.halt_orb_id[0] = null
    destroyEffect(eventPlayer.halt_orb_id[1])
    eventPlayer.halt_orb_id[1] = null

    eventPlayer.is_using_halt = false


rule "[orirsa.opy]: Slow down snared enemies":
    @Event eachPlayer
    @Condition eventPlayer.is_snared

    eventPlayer.setMoveSpeed(100-OW1_ORISA_HALT_SNARE_MOVE_PENALTY)
    wait(OW1_ORISA_HALT_SNARE_DURATION)
    eventPlayer.setMoveSpeed(100)


rule "[orisa/halt.opy]: Pull halted victims":
    @Event eachPlayer
    @Condition eventPlayer.is_snared

    eventPlayer.position = eventPlayer.getPosition()
    eventPlayer.startForcingPosition(eventPlayer.position, true)
    chase(eventPlayer.position, eventPlayer.enemy_orisa_player.halt_position, rate=OW1_ORISA_HALT_PULL_SPEED, ChaseReeval.DESTINATION_AND_RATE)
    waitUntil(eventPlayer.position == eventPlayer.enemy_orisa_player.halt_position, Math.INFINITY)
    stopChasingVariable(eventPlayer.position)
    eventPlayer.stopForcingPosition()
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), 
                             -eventPlayer.getSpeed(), 
                             Relativity.TO_WORLD, 
                             Impulse.INCORPORATE_CONTRARY_MOTION) # Cancel current momentum
    eventPlayer.is_snared = false


rule "[orisa/halt.opy]: Halt snare line VFX":
    @Event eachPlayer
    @Condition eventPlayer.enemy_orisa_player.is_using_halt
    @Condition eventPlayer.isAlive()

    # Halt orb explosion sounds
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.LIME_GREEN, eventPlayer, 100)
    
    if (eventPlayer.halt_snare_line_id == null):
        createBeam(getAllPlayers() if (distance(eventPlayer, 
                                                eventPlayer.enemy_orisa_player.halt_position) <= OW1_ORISA_HALT_AOE_RADIUS \
                                       and isInLoS(eventPlayer, 
                                                   eventPlayer.enemy_orisa_player.halt_position, 
                                                   BarrierLos.BLOCKED_BY_ALL_BARRIERS)) else null, 
                   Beam.GOOD, 
                   eventPlayer.enemy_orisa_player.halt_position, 
                   eventPlayer, 
                   Color.GREEN if eventPlayer.is_snared else Color.WHITE, 
                   EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
        eventPlayer.halt_snare_line_id = getLastCreatedEntity()
    
    waitUntil(not (eventPlayer.enemy_orisa_player.is_using_halt and eventPlayer.isAlive()), Math.INFINITY)
    destroyEffect(eventPlayer.halt_snare_line_id)
    eventPlayer.halt_snare_line_id = null


rule "[orisa/halt.opy]: Destroy Halt pull line vfx when halt is over":
    @Event eachPlayer
    @Condition not eventPlayer.enemy_orisa_player.is_using_halt

    destroyEffect(eventPlayer.halt_snare_line_id)
    eventPlayer.halt_snare_line_id = null


rule "[orisa/halt.opy]: Destroy Halt pull line vfx when dead":
    @Event eachPlayer
    @Condition eventPlayer.enemy_orisa_player.is_using_halt
    @Condition eventPlayer.isDead()

    destroyEffect(eventPlayer.halt_snare_line_id)
    eventPlayer.halt_snare_line_id = null
