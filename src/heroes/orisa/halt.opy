#!mainFile "../../dev_main.opy"

playervar is_using_halt
playervar is_snared
playervar halt_victims
playervar halt_position
playervar halt_ending_position
playervar halt_orb_id
playervar halt_snare_line_id
playervar halt_victim_position
playervar halt_active

subroutine shootHalt
subroutine explodeHalt
subroutine snareVictim
subroutine showSnareLine
subroutine hideSnareLine

macro isInHaltAOE(player):
    (distance(centerMass(player), player.enemy_orisa_player.halt_position) <= OW1_ORISA_HALT_AOE_RADIUS \
 and isInLoS(centerMass(player), player.enemy_orisa_player.halt_position, BarrierLos.BLOCKED_BY_ALL_BARRIERS))

macro snareVisible(player):
    (player.enemy_orisa_player.is_using_halt \
 and isInHaltAOE(player) \
 and player.isAlive())


rule "[orisa/halt.opy]: Trigger Halt ability":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) <= 0
    @Condition eventPlayer.isAlive()
    @Condition not isCCd(eventPlayer)

    shootHalt()
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), Math.INFINITY) # Ensure player releases right click
    waitUntil(updateEveryTick((eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) and eventPlayer.isAlive() and not isCCd(eventPlayer)) \
                           or (eventPlayer.halt_position == eventPlayer.halt_ending_position)), Math.INFINITY) # Detect halt pull activation on right click
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

    wait(OW1_ORISA_HALT_LAUNCH_CAST_TIME)

    # Start flying halt orb
    chase(eventPlayer.halt_position, eventPlayer.halt_ending_position, rate=OW1_ORISA_HALT_PROJECTILE_SPEED, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.halt_active = false


def explodeHalt():
    @Name "[orisa/halt.opy]: Explode Halt Orb"

    eventPlayer.halt_active = true
    stopChasingVariable(eventPlayer.halt_position)
    wait(OW1_ORISA_HALT_ACTIVATION_TIME)

    # Halt orb explosion sounds
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.LIME_GREEN, eventPlayer, 100)

    # Clear visuals
    destroyEffect(eventPlayer.halt_orb_id[0])
    eventPlayer.halt_orb_id[0] = null
    destroyEffect(eventPlayer.halt_orb_id[1])
    eventPlayer.halt_orb_id[1] = null

    eventPlayer.is_using_halt = false
    wait(OW1_ORISA_HALT_SNARE_DURATION)
    eventPlayer.halt_active = false


rule "[orisa/halt.opy]: Slow down halted victims":
    @Event eachPlayer
    @Condition eventPlayer.enemy_orisa_player.halt_active
    if not isInHaltAOE(eventPlayer): return # prevents victim from reactivating this rule by going in and out of halt aoe range

    # slow down victims in halt range
    eventPlayer.setMoveSpeed(100-OW1_ORISA_HALT_SNARE_MOVE_PENALTY)
    wait(OW1_ORISA_HALT_ACTIVATION_TIME)

    if isInHaltAOE(eventPlayer):
        async(snareVictim, AsyncBehavior.RESTART)

    wait(OW1_ORISA_HALT_SNARE_DURATION)
    eventPlayer.setMoveSpeed(100)


def snareVictim():
    @Name "[orisa/halt.opy]: snareVictim()"

    eventPlayer.setEnvironmentalKillCreditor(eventPlayer)
    eventPlayer.halt_victim_position = eventPlayer.getPosition()
    eventPlayer.startForcingPosition(eventPlayer.halt_victim_position, true)
    chase(eventPlayer.halt_victim_position, eventPlayer.enemy_orisa_player.halt_position, rate=OW1_ORISA_HALT_PULL_SPEED, ChaseReeval.DESTINATION_AND_RATE)
    waitUntil(eventPlayer.halt_victim_position == eventPlayer.enemy_orisa_player.halt_position, Math.INFINITY)
    stopChasingVariable(eventPlayer.halt_victim_position)
    eventPlayer.stopForcingPosition()
    cancelMomentum(eventPlayer)


rule "[orisa/halt.opy]: Halt snare line VFX":
    @Event eachPlayer
    @Condition snareVisible(eventPlayer)

    # Halt orb explosion sounds
    showSnareLine()
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.LIME_GREEN, eventPlayer, 100)
    
    waitUntil(not (snareVisible(eventPlayer)), Math.INFINITY)
    hideSnareLine()


def showSnareLine():
    @Name "[orisa/halt.opy]: showSnareLine()"

    if (eventPlayer.halt_snare_line_id == null):
        createBeam(getAllPlayers() if snareVisible(eventPlayer) else null, 
                   Beam.GOOD, 
                   eventPlayer.enemy_orisa_player.halt_position, 
                   centerMass(eventPlayer), 
                   Color.GREEN if eventPlayer.halt_active else Color.WHITE, 
                   EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
        eventPlayer.halt_snare_line_id = getLastCreatedEntity()


def hideSnareLine():
    @Name "[orisa/halt.opy]: hideSnareLine()"

    destroyEffect(eventPlayer.halt_snare_line_id)
    eventPlayer.halt_snare_line_id = null


rule "[orisa/halt.opy]: Destroy Halt pull line vfx when halt starts":
    @Event eachPlayer
    @Condition eventPlayer.enemy_orisa_player.is_using_halt

    destroyEffect(eventPlayer.halt_snare_line_id)
    eventPlayer.halt_snare_line_id = null


rule "[orisa/halt.opy]: Destroy Halt pull line vfx when halt is over":
    @Event eachPlayer
    @Condition not eventPlayer.enemy_orisa_player.is_using_halt

    destroyEffect(eventPlayer.halt_snare_line_id)
    eventPlayer.halt_snare_line_id = null


rule "[orisa/halt.opy]: Destroy Halt pull line vfx when dead":
    @Event playerDied
    @Condition eventPlayer.enemy_orisa_player.is_using_halt

    destroyEffect(eventPlayer.halt_snare_line_id)
    eventPlayer.halt_snare_line_id = null
