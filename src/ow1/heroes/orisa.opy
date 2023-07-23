#!mainFile "../../main.opy"

globalvar PHI = Math.PI * (sqrt(5)-1) # golden angle in radians

playervar is_using_supercharger
playervar is_supercharged
playervar orisa_supercharger_entity
playervar orisa_supercharger_uptime
playervar orisa_supercharger_position
playervar orisa_beam_entity
playervar orisa_beam_sound_effect

playervar is_using_halt
playervar is_getting_orisa_pulled
playervar halt_position
playervar halt_ending_position
playervar halt_entity1
playervar halt_entity2
playervar halt_pull_line_entity
playervar position

playervar barrier_position
playervar barrier_orientation
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

subroutine initOrisa

subroutine startSupercharger
subroutine endSupercharger

subroutine shootHalt
subroutine explodeHalt

subroutine throwBarrier
subroutine deployBarrier
subroutine destroyBarrier
subroutine fibonacciSphere

#!define isInsideOrisaBarrier(point, center, direction)\
    ((distance(center, point) <= OW1_ORISA_PROTECTIVE_BARRIER_RADIUS) and \
    (angleBetweenVectors(Vector.UP, directionTowards(center, point)) <= 90) and \
    (angleBetweenVectors(direction, directionTowards(center, point)) <= 90))

rule "[orisa.opy]: Detect Orisa initialization":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initOrisa()
    eventPlayer.initialized = true


def initOrisa():
    @Name "[orisa.opy]: initOrisa()"

    while (eventPlayer.getMaxHealth() != OW1_ORISA_HEALTH + OW1_ORISA_ARMOR):
        clearCustomHealth()
        setCustomHealth(OW1_ORISA_HEALTH, OW1_ORISA_ARMOR, 0)
        wait(1)

    eventPlayer.disallowButton(Button.SECONDARY_FIRE) # Disable OW2 Javelin
    eventPlayer.disallowButton(Button.ABILITY_2) # Disable OW2 Javelin Spin
    eventPlayer.disallowButton(Button.ULTIMATE) # Disable Terra Surge

    # Below variables are also declared and initialized in reset_hero.opy
    getPlayers(eventPlayer.getTeam()).friendly_orisa_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_orisa_player = eventPlayer

    eventPlayer.is_using_supercharger = false
    eventPlayer.is_using_halt = false

################################################ Supercharger (ultimate) ################################################
rule "[orisa.opy]: Trigger Supercharger start":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isOnGround() == true

    endSupercharger() # Destroy any existing Supercharger
    startSupercharger() # Start supercharger


rule "[orisa.opy]: Trigger Supercharger end":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.orisa_supercharger_uptime >= OW1_ORISA_SUPERCHARGER_MAX_DURATION

    endSupercharger()


def startSupercharger():
    @Name "[orisa.opy]: startSupercharger()"

    eventPlayer.setUltCharge(0)
    eventPlayer.setUltEnabled(false)
    eventPlayer.communicate(Comms.VOICE_LINE_UP)
    # Supercharge GUI
    eventPlayer.orisa_supercharger_position = eventPlayer.getPosition() + OW1_ORISA_SUPERCHARGER_HEIGHT/2*Vector.UP
    createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.orisa_supercharger_position, OW1_ORISA_SUPERCHARGER_HEIGHT/2, EffectReeval.NONE)
    eventPlayer.orisa_supercharger_entity = getLastCreatedEntity()
    # Supercharge Effect
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.GREEN, eventPlayer.orisa_supercharger_position, 3)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.GREEN, eventPlayer.orisa_supercharger_position, 200)
    # Start supercharger timer
    eventPlayer.orisa_supercharger_uptime = 0
    chase(eventPlayer.orisa_supercharger_uptime, OW1_ORISA_SUPERCHARGER_MAX_DURATION, rate=1, ChaseReeval.NONE)
    eventPlayer.is_using_supercharger = true


def endSupercharger():
    @Name "[orisa.opy]: endSupercharger()"

    eventPlayer.setUltEnabled(true)
    stopChasingVariable(eventPlayer.orisa_supercharger_uptime)
    destroyEffect(eventPlayer.orisa_supercharger_entity)
    getPlayers(eventPlayer.getTeam()).is_supercharged = false
    eventPlayer.is_using_supercharger = false


rule "[orisa.opy]: Supercharge teammates in supercharger range":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.friendly_orisa_player.is_using_supercharger == true
    @Condition (distance(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_position) <= OW1_ORISA_SUPERCHARGER_AOE_RADIUS and \
               isInLoS(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_position, BarrierLos.PASS_THROUGH_BARRIERS)) == true
    
    eventPlayer.is_supercharged = true


rule "[orisa.opy]: De-supercharge teammates outside supercharger range":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.is_supercharged == true
    @Condition eventPlayer.friendly_orisa_player.is_using_supercharger == true
    @Condition (distance(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_position) <= OW1_ORISA_SUPERCHARGER_AOE_RADIUS and \
               isInLoS(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_position, BarrierLos.PASS_THROUGH_BARRIERS)) == false
    
    wait(OW1_ORISA_SUPERCHARGER_LINGER_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.is_supercharged = false


rule "[orisa.opy]: De-supercharge teammates when supercharger ends":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.friendly_orisa_player.is_using_supercharger == false
    
    eventPlayer.is_supercharged = false


rule "[orisa.opy]: De-supercharge teammates when they die":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isDead() == true
    
    eventPlayer.is_supercharged = false


rule "[orisa.opy]: Damage boost player when supercharged":
    @Event eachPlayer
    @Condition eventPlayer.is_supercharged == true

    createBeam(getAllPlayers(), Beam.GOOD, eventPlayer.friendly_orisa_player.orisa_supercharger_position, eventPlayer.getPosition(), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.orisa_beam_entity = getLastCreatedEntity()
    createEffect(eventPlayer, Effect.ENERGY_SOUND, Color.GREEN, eventPlayer.getPosition(), 100, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.orisa_beam_sound_effect = getLastCreatedEntity()
    eventPlayer.setDamageDealt(percent(OW1_ORISA_SUPERCHARGER_DAMAGE_MULTIPLIER))


rule "[orisa.opy]: Revert damage boost if not supercharged":
    @Event eachPlayer
    @Condition eventPlayer.is_supercharged == false

    destroyEffect(eventPlayer.orisa_beam_entity)
    destroyEffect(eventPlayer.orisa_beam_sound_effect)
    eventPlayer.setDamageDealt(100)

################################################ Halt! (secondary fire) ################################################
rule "[orisa.opy]: Trigger Halt ability start":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true

    shootHalt()
    waitUntil(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false, 9999) # Make sure player releases right click
    waitUntil(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true or (eventPlayer.halt_position == eventPlayer.halt_ending_position), 9999) # Detect halt pull activation on right click
    explodeHalt()

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_ORISA_HALT_COOLDOWN_TIME)


def shootHalt():
    @Name "[orisa.opy]: Shoot Halt Orb"

    # Calculate starting/ending positions
    eventPlayer.halt_position = eventPlayer.getEyePosition()
    eventPlayer.halt_ending_position = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 1000*eventPlayer.getFacingDirection(), null, null, true).getHitPosition()
    eventPlayer.is_getting_orisa_pulled = false

    wait(OW1_ORISA_HALT_LAUNCH_CAST_TIME)
    eventPlayer.is_using_halt = true # Start halt

    # Halt orb GUI
    createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.halt_position, OW1_ORISA_HALT_PROJECTILE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.halt_entity1 = getLastCreatedEntity()
    eventPlayer.entity_huds.append(eventPlayer.halt_entity1)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.halt_position, 0.5*OW1_ORISA_HALT_PROJECTILE_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.halt_entity2 = getLastCreatedEntity()
    eventPlayer.entity_huds.append(eventPlayer.halt_entity2)
    # Start flying halt orb
    chase(eventPlayer.halt_position, eventPlayer.halt_ending_position, rate=OW1_ORISA_HALT_PROJECTILE_SPEED, ChaseReeval.DESTINATION_AND_RATE)


def explodeHalt():
    @Name "[orisa.opy]: Explode Halt Orb"

    stopChasingVariable(eventPlayer.halt_position)
    wait(OW1_ORISA_HALT_ACTIVATION_TIME)
    getPlayersInRadius(eventPlayer.halt_position, OW1_ORISA_HALT_AOE_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES_AND_ENEMY_BARRIERS).is_getting_orisa_pulled = true
    getPlayersInRadius(eventPlayer.halt_position, OW1_ORISA_HALT_AOE_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES_AND_ENEMY_BARRIERS).setEnvironmentalKillCreditor(eventPlayer)
    eventPlayer.is_using_halt = false
    destroyEffect(eventPlayer.halt_entity1)
    destroyEffect(eventPlayer.halt_entity2)
    eventPlayer.entity_huds.remove(eventPlayer.halt_entity1)
    eventPlayer.entity_huds.remove(eventPlayer.halt_entity2)


rule "[orisa.opy]: Pull halted victims":
    @Event eachPlayer
    @Condition eventPlayer.is_getting_orisa_pulled == true

    eventPlayer.position = eventPlayer.getPosition()
    eventPlayer.startForcingPosition(eventPlayer.position, true)
    chase(eventPlayer.position, eventPlayer.enemy_orisa_player.halt_position, rate=OW1_ORISA_HALT_PULL_SPEED, ChaseReeval.DESTINATION_AND_RATE)
    waitUntil(eventPlayer.position == eventPlayer.enemy_orisa_player.halt_position, 9999)
    stopChasingVariable(eventPlayer.position)
    eventPlayer.stopForcingPosition()
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Cancel current momentum
    eventPlayer.is_getting_orisa_pulled = false


rule "[orisa.opy]: Create Halt pull line vfx when in pull range":
    @Event eachPlayer
    @Condition eventPlayer.enemy_orisa_player.is_using_halt == true
    @Condition (distance(eventPlayer, eventPlayer.enemy_orisa_player.halt_position) <= OW1_ORISA_HALT_AOE_RADIUS and \
               isInLoS(eventPlayer, eventPlayer.enemy_orisa_player.halt_position, BarrierLos.BLOCKED_BY_ALL_BARRIERS)) == true
    
    createBeam(getAllPlayers(), Beam.GOOD, eventPlayer.enemy_orisa_player.halt_position, eventPlayer, Color.GREEN if eventPlayer.is_getting_orisa_pulled else Color.WHITE, EffectReeval.POSITION_RADIUS_AND_COLOR)
    eventPlayer.halt_pull_line_entity = getLastCreatedEntity()
    eventPlayer.entity_huds.append(eventPlayer.halt_pull_line_entity)


rule "[orisa.opy]: Destroy Halt pull line vfx when not in pull range":
    @Event eachPlayer
    @Condition eventPlayer.enemy_orisa_player.is_using_halt == true
    @Condition (distance(eventPlayer, eventPlayer.enemy_orisa_player.halt_position) <= OW1_ORISA_HALT_AOE_RADIUS and \
               isInLoS(eventPlayer, eventPlayer.enemy_orisa_player.halt_position, BarrierLos.BLOCKED_BY_ALL_BARRIERS)) == false
    
    destroyEffect(eventPlayer.halt_pull_line_entity)
    eventPlayer.entity_huds.remove(eventPlayer.halt_pull_line_entity)


rule "[orisa.opy]: Destroy Halt pull line vfx when halt is over":
    @Event eachPlayer
    @Condition eventPlayer.enemy_orisa_player.is_using_halt == false

    destroyEffect(eventPlayer.halt_pull_line_entity)
    eventPlayer.entity_huds.remove(eventPlayer.halt_pull_line_entity)

################################################ Projectile Barrier (ability 2) ################################################
rule "[orisa.opy]: Trigger Projectile Barrier ability":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true

    throwBarrier()
    destroyBarrier()
    deployBarrier()

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_ORISA_PROJECTILE_BARRIER_COOLDOWN_TIME)


def throwBarrier(): # Select shield position and orientation
    @Name "[orisa.opy]: throwBarrier()"

    eventPlayer.barrier_orientation = getLateralFacingDirection(eventPlayer)
    eventPlayer.barrier_position = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + 1000*eventPlayer.getFacingDirection(), null, null, false).getHitPosition()
    eventPlayer.barrier_position -= OW1_ORISA_PROTECTIVE_BARRIER_RADIUS*eventPlayer.barrier_orientation


def deployBarrier(): # Create shield visual object
    @Name "[orisa.opy]: deployBarrier()"

    # Debug barrier center
    # createEffect(eventPlayer, Effect.SPHERE, Color.BLACK, eventPlayer.barrier_position, 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    fibonacciSphere()

    # Draw each barrier sample
    for i in range(len(eventPlayer.barrier_entity_positions)):
        eventPlayer.barrier_sample_point = eventPlayer.barrier_entity_positions[i]
        createEffect(getAllPlayers(), Effect.SPHERE, eventPlayer.getTeam(), evalOnce(eventPlayer.barrier_sample_point), sqrt(1*OW1_ORISA_PROTECTIVE_BARRIER_RADIUS**2/OW1_ORISA_PROTECTIVE_BARRIER_RESOLUTION), EffectReeval.NONE)
        eventPlayer.barrier_entities.append(getLastCreatedEntity())

    eventPlayer.barrier_active = true
    eventPlayer.barrier_health = OW1_ORISA_PROJECTILE_BARRIER_HEALTH
    eventPlayer.barrier_uptime = 0
    chase(eventPlayer.barrier_uptime, OW1_ORISA_PROJECTILE_BARRIER_MAX_UPTIME, rate=1, ChaseReeval.NONE)


def fibonacciSphere():
    @Name "[orisa.opy]: fibonacciSphere()"
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
    @Name "[orisa.opy]: destroyBarrier()"

    for i in range(len(eventPlayer.barrier_entities)):
        destroyEffect(eventPlayer.barrier_entities[i])

    eventPlayer.barrier_entities = []
    eventPlayer.barrier_entity_positions = []

    eventPlayer.barrier_active = false


rule "[orisa.opy]: destroy barrier on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true
    @Condition eventPlayer.getCurrentHero() != Hero.ORISA

    destroyBarrier()


rule "[orisa.opy]: Destroy barrier on barrier timeout":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.barrier_uptime >= OW1_ORISA_PROJECTILE_BARRIER_MAX_UPTIME

    stopChasingVariable(eventPlayer.barrier_uptime)
    destroyBarrier()


rule "[orisa.opy]: Destroy barrier when barrier hp runs out":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.barrier_health <= 0

    stopChasingVariable(eventPlayer.barrier_uptime)
    destroyBarrier()


rule "[orisa.opy]: Take no damage when behind barrier":
    @Event playerDealtDamage
    @Condition victim.friendly_orisa_player.barrier_active == true
    @Condition isAimingAtSphere(attacker.getEyePosition(), attacker.getFacingDirection(), victim.friendly_orisa_player.barrier_position, OW1_ORISA_PROTECTIVE_BARRIER_RADIUS)

    detectSphereHit(attacker.getEyePosition(), attacker.getFacingDirection(), victim.friendly_orisa_player.barrier_position, OW1_ORISA_PROTECTIVE_BARRIER_RADIUS)
    eventPlayer.orisa_barrier_hit_positions = [point for point in eventPlayer.lsi_x if isInsideOrisaBarrier(point, victim.friendly_orisa_player.barrier_position, victim.friendly_orisa_player.barrier_orientation)]

    for i in range(len(eventPlayer.orisa_barrier_hit_positions)):
        if (distance(attacker.getEyePosition(), eventPlayer.orisa_barrier_hit_positions[i]) < distance(attacker.getEyePosition(), victim.getEyePosition())): # barrier hit is between the attacker and the victim
            heal(victim, null, eventDamage)
            victim.friendly_orisa_player.barrier_health -= eventDamage
            return
