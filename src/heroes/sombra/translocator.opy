#!mainFile "../../dev_main.opy"

playervar translocator_pvar

#!defineMember _is_using_translocator translocator_pvar[0]
#!defineMember _translocator_id translocator_pvar[1]
#!defineMember _translocator_icon_id1 translocator_pvar[2]
#!defineMember _translocator_icon_id2 translocator_pvar[3]

playervar transloc_position
playervar trasnloc_velocity
playervar transloc_p0
playervar transloc_v0
playervar transloc_time

subroutine throwTranslocator
subroutine destroyTranslocator
subroutine showTranslocator
subroutine showTranslocatorIcon
subroutine hideTranslocator

#!define getTranslocVelocity(t) vect(eventPlayer.transloc_v0.x, \
                                     OW1_SOMBRA_TRANSLOCATOR_GRAVITY * t + eventPlayer.transloc_v0.y, \
                                     eventPlayer.transloc_v0.z)

#!define getTranslocPosition(t) vect(eventPlayer.transloc_v0.x * t + eventPlayer.transloc_p0.x, \
                                     OW1_SOMBRA_TRANSLOCATOR_GRAVITY/2 * (t ** 2) + eventPlayer.transloc_v0.y * t + eventPlayer.transloc_p0.y, \
                                     eventPlayer.transloc_v0.z * t + eventPlayer.transloc_p0.z)


rule "[sombra/translocator.opy]: Bind Ability 2 to translocator":
    @Event eachPlayer
    @Hero sombra
    @Condition not eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not isCCd(eventPlayer)
    @Condition not eventPlayer._is_using_translocator
    waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_2), Math.INFINITY)

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_SOMBRA_TRANSLOCATOR_COOLDOWN_TIME)
    destroyTranslocator()
    async(throwTranslocator(), AsyncBehavior.RESTART)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2), Math.INFINITY)
    waitUntil((eventPlayer.isHoldingButton(Button.ABILITY_2) \
            or eventPlayer.isHoldingButton(Button.INTERACT) \
            or eventPlayer.isDead()
            or (eventPlayer.transloc_position == null)) \
       and not isCCd(eventPlayer) \
       and not eventPlayer._is_casting_emp, Math.INFINITY) # prevent tp when cc'd or when casting emp
    if (eventPlayer.isHoldingButton(Button.ABILITY_2)):
        playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.PURPLE, eventPlayer.getPosition(), 100)
        playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.PURPLE, eventPlayer, 100)
        playEffect(getAllPlayers(), DynamicEffect.BUFF_IMPACT_SOUND, Color.PURPLE, eventPlayer.transloc_position, 100)
        if eventPlayer.transloc_position != null: # guard to ensure sombra doesn't tp to map origin
            eventPlayer.teleport(eventPlayer.transloc_position)
    if (eventPlayer.isHoldingButton(Button.INTERACT)):
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.transloc_position, 3)
        playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.PURPLE, eventPlayer.transloc_position, 100)
    destroyTranslocator()


def destroyTranslocator():
    @Name "[sombra/translocator.opy]: destroyTranslocator()"

    stopChasingVariable(eventPlayer.transloc_time)
    stopChasingVariable(eventPlayer.transloc_position)
    stopChasingVariable(eventPlayer.trasnloc_velocity)
    eventPlayer.transloc_time = null
    eventPlayer.transloc_position = null
    eventPlayer.trasnloc_velocity = null
    hideTranslocator()
    eventPlayer._is_using_translocator = false


def throwTranslocator():
    @Name "[sombra/translocator.opy]: throwTranslocator()"

    # Initialize translocator projectile
    eventPlayer.transloc_v0 = OW1_SOMBRA_TRANSLOCATOR_PROJECTILE_SPEED * eventPlayer.getFacingDirection()
    eventPlayer.transloc_p0 = eventPlayer.getEyePosition()
    eventPlayer.transloc_time = 0
    chase(eventPlayer.transloc_time, OW1_SOMBRA_TRANSLOCATOR_COOLDOWN_TIME, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.trasnloc_velocity = eventPlayer.transloc_v0
    chase(eventPlayer.trasnloc_velocity, getTranslocVelocity(eventPlayer.transloc_time), rate=9999, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.transloc_position = eventPlayer.transloc_p0
    chase(eventPlayer.transloc_position, getTranslocPosition(eventPlayer.transloc_time), rate=9999, ChaseReeval.DESTINATION_AND_RATE)

    showTranslocator()
    eventPlayer._is_using_translocator = true
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.PURPLE, eventPlayer, 100)

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

    # Play bouncing sound
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.PURPLE, eventPlayer.transloc_position, 100)

    # Fall down to floor after bouncing off wall
    eventPlayer._seed_hit_surface_normal = (raycast(eventPlayer.transloc_position, \
                                  eventPlayer.transloc_position + eventPlayer.trasnloc_velocity, \
                                  null, \
                                  null, \
                                  false).getNormal())
    eventPlayer.transloc_v0 = 0.03 * reflection(eventPlayer.trasnloc_velocity, eventPlayer._seed_hit_surface_normal)
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

    showTranslocatorIcon()
    # Play landing sound
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.PURPLE, eventPlayer.transloc_position, 100)


def showTranslocator():
    @Name "[sombra/translocator.opy]: showTranslocator()"

    # Draw translocator projectile object
    if eventPlayer._translocator_id == null:
        createEffect(getAllPlayers(), Effect.ORB, Color.PURPLE, eventPlayer.transloc_position, 0.1, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer._translocator_id = getLastCreatedEntity()


def showTranslocatorIcon():
    @Name "[sombra/translocator.opy]: showTranslocatorIcon()"

    # Draw translocator icons
    if eventPlayer._translocator_icon_id1 == null:
        createIcon(eventPlayer, eventPlayer.transloc_position + 0.5*Vector.DOWN, Icon.HALO, IconReeval.VISIBILITY_POSITION_AND_COLOR, Color.SKY_BLUE, false)
        eventPlayer._translocator_icon_id1 = getLastCreatedEntity()
    if eventPlayer._translocator_icon_id2 == null:
        createIcon(eventPlayer, eventPlayer.transloc_position, Icon.DIAMOND, IconReeval.VISIBILITY_POSITION_AND_COLOR, Color.SKY_BLUE, false)
        eventPlayer._translocator_icon_id2 = getLastCreatedEntity()


def hideTranslocator():
    @Name "[sombra/translocator.opy]: hideTranslocator()"

    destroyEffect(eventPlayer._translocator_id)
    eventPlayer._translocator_id = null
    destroyIcon(eventPlayer._translocator_icon_id1)
    eventPlayer._translocator_icon_id1 = null
    destroyIcon(eventPlayer._translocator_icon_id2)
    eventPlayer._translocator_icon_id2 = null


rule "[sombra/translocator.opy]: Show using translocator GUI":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0.2
    @Condition eventPlayer._is_using_translocator

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0.4)


rule "[sombra/translocator.opy]: Break translocator when shot":
    @Event eachPlayer
    @Condition eventPlayer.getTeam() == getOppositeTeam(eventPlayer.enemy_sombra_player.getTeam())
    @Condition eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()
    @Condition isAimingAtSphere(eventPlayer.getEyePosition(), eventPlayer.getFacingDirection(), eventPlayer.enemy_sombra_player.transloc_position, 0.1)

    destroyTranslocator()
