#!mainFile "../../dev_main.opy"

playervar is_using_supercharger
playervar is_supercharged
playervar orisa_supercharger_id
playervar orisa_supercharger_origin
playervar orisa_supercharger_beam_id
playervar orisa_supercharger_sound_id

subroutine startSupercharger
subroutine endSupercharger


rule "[orisa/supercharger.opy]: play Terra Surge voiceline":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.getUltCharge() >= 100
    
    eventPlayer.allowButton(Button.ULTIMATE)
    getPlayersInRadius(eventPlayer, 
                       OW2_ORISA_TERRA_SURGE_RADIUS, 
                       getOppositeTeam(eventPlayer.getTeam()), 
                       LosCheck.SURFACES).setStatusEffect(null, Status.PHASED_OUT, 0.016)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.ULTIMATE)


rule "[orisa/supercharger.opy]: Trigger Supercharger start":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.cancelPrimaryAction() # Stop Terra Surge animation
    if eventPlayer.isUsingAbility1():
        damage(eventPlayer, null, OW2_ORISA_FORTIFY_OVERHEALTH/(1-OW2_ORISA_FORTIFY_DAMAGE_REDUCTION)) # Remove shield gained from Terra Surge

    endSupercharger() # Destroy any existing Supercharger
    waitUntil(eventPlayer.isOnGround(), Math.INFINITY)
    startSupercharger() # Start new supercharger
    wait(OW1_ORISA_SUPERCHARGER_MAX_DURATION, Wait.RESTART_WHEN_TRUE) # Start supercharger timer
    endSupercharger()


def startSupercharger():
    @Name "[orisa/supercharger.opy]: startSupercharger()"

    eventPlayer.orisa_supercharger_origin = eventPlayer.getPosition() + OW1_ORISA_SUPERCHARGER_HEIGHT/2*Vector.UP

    eventPlayer.setUltCharge(0)
    eventPlayer.setUltEnabled(false) # Prevent Orisa from getting ult charge
    eventPlayer.communicate(Comms.VOICE_LINE_UP) # Play ultimate voice line

    # Supercharge GUI
    if eventPlayer.orisa_supercharger_id[0] == null:
        createEffect(getAllPlayers(), 
                     Effect.SPHERE, 
                     Color.LIME_GREEN, 
                     eventPlayer.orisa_supercharger_origin + OW1_ORISA_SUPERCHARGER_HEIGHT/4*Vector.UP, 
                     OW1_ORISA_SUPERCHARGER_HEIGHT/3, 
                     EffectReeval.NONE)
        eventPlayer.orisa_supercharger_id[0] = getLastCreatedEntity()
    if eventPlayer.orisa_supercharger_id[1] == null:
        createEffect(getAllPlayers(), 
                     Effect.SPHERE, 
                     Color.LIME_GREEN, 
                     eventPlayer.orisa_supercharger_origin + OW1_ORISA_SUPERCHARGER_HEIGHT/4*Vector.DOWN, 
                     OW1_ORISA_SUPERCHARGER_HEIGHT/3, 
                     EffectReeval.NONE)
        eventPlayer.orisa_supercharger_id[1] = getLastCreatedEntity()
    
    # Supercharger deploy effect
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.GREEN, eventPlayer.orisa_supercharger_origin, 3)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.GREEN, eventPlayer.orisa_supercharger_origin, 200)

    # Announce supercharger active
    eventPlayer.is_using_supercharger = true


def endSupercharger():
    @Name "[orisa/supercharger.opy]: endSupercharger()"

    eventPlayer.setUltEnabled(true)
    destroyEffect(eventPlayer.orisa_supercharger_id[0])
    eventPlayer.orisa_supercharger_id[0] = null
    destroyEffect(eventPlayer.orisa_supercharger_id[1])
    eventPlayer.orisa_supercharger_id[1] = null
    eventPlayer.is_using_supercharger = false
    getPlayers(eventPlayer.getTeam()).is_supercharged = false


rule "[orisa/supercharger.opy]: Supercharge teammates in supercharger range":
    @Event eachPlayer
    @Condition eventPlayer.friendly_orisa_player.is_using_supercharger
    @Condition (distance(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_origin) <= OW1_ORISA_SUPERCHARGER_AOE_RADIUS and \
               isInLoS(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_origin, BarrierLos.PASS_THROUGH_BARRIERS))
    @Condition eventPlayer.isAlive()

    eventPlayer.is_supercharged = true


rule "[orisa/supercharger.opy]: De-supercharge teammates outside supercharger range":
    @Event eachPlayer
    @Condition eventPlayer.friendly_orisa_player.is_using_supercharger
    @Condition eventPlayer.is_supercharged
    @Condition not (distance(eventPlayer, 
                             eventPlayer.friendly_orisa_player.orisa_supercharger_origin) <= OW1_ORISA_SUPERCHARGER_AOE_RADIUS \
                    and \
                    isInLoS(eventPlayer, 
                            eventPlayer.friendly_orisa_player.orisa_supercharger_origin, 
                            BarrierLos.PASS_THROUGH_BARRIERS))
    
    wait(OW1_ORISA_SUPERCHARGER_LINGER_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.is_supercharged = false


rule "[orisa/supercharger.opy]: De-supercharge teammates when supercharger ends":
    @Event eachPlayer
    @Hero orisa
    @Condition not eventPlayer.is_using_supercharger
    
    getPlayers(eventPlayer.getTeam()).is_supercharged = false


rule "[orisa/supercharger.opy]: De-supercharge teammates when they die":
    @Event playerDied
    @Condition eventPlayer.is_supercharged
    
    eventPlayer.is_supercharged = false


rule "[orisa/supercharger.opy]: Damage boost player when supercharged":
    @Event eachPlayer
    @Condition eventPlayer.is_supercharged

    eventPlayer.setDamageDealt(percent(OW1_ORISA_SUPERCHARGER_DAMAGE_MULTIPLIER*eventPlayer._base_damage_scalar))

    # Beam and sound effects
    if (eventPlayer.orisa_supercharger_beam_id == null): # beam
        createBeam(getAllPlayers(), 
                   Beam.GOOD, 
                   eventPlayer.friendly_orisa_player.orisa_supercharger_origin, 
                   (eventPlayer.getPosition() + eventPlayer.getEyePosition())/2, 
                   Color.BLUE, 
                   EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.orisa_supercharger_beam_id = getLastCreatedEntity()
    if (eventPlayer.orisa_supercharger_sound_id == null): # sound
        createEffect(eventPlayer, 
                     Effect.ENERGY_SOUND, 
                     Color.GREEN, 
                     eventPlayer.getPosition(), 
                     100, 
                     EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.orisa_supercharger_sound_id = getLastCreatedEntity()


rule "[orisa/supercharger.opy]: Revert damage boost if not supercharged":
    @Event eachPlayer
    @Condition not eventPlayer.is_supercharged
    
    eventPlayer.setDamageDealt(percent(eventPlayer._base_damage_scalar))

    # Beam and sound effects
    destroyEffect(eventPlayer.orisa_supercharger_beam_id)
    eventPlayer.orisa_supercharger_beam_id = null
    destroyEffect(eventPlayer.orisa_supercharger_sound_id)
    eventPlayer.orisa_supercharger_sound_id = null
