#!mainFile "../../../main.opy"

playervar is_using_supercharger
playervar is_supercharged
playervar orisa_supercharger_entity
playervar orisa_supercharger_position
playervar orisa_beam_entity
playervar orisa_beam_sound_effect

subroutine startSupercharger
subroutine endSupercharger


rule "[orisa/supercharger.opy]: Trigger Supercharger start":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isOnGround() == true

    endSupercharger() # Destroy any existing Supercharger
    startSupercharger() # Start supercharger
    wait(OW1_ORISA_SUPERCHARGER_MAX_DURATION, Wait.RESTART_WHEN_TRUE) # Start supercharger timer
    endSupercharger()


def startSupercharger():
    @Name "[orisa/supercharger.opy]: startSupercharger()"

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
    # Announce supercharger active
    eventPlayer.is_using_supercharger = true


def endSupercharger():
    @Name "[orisa/supercharger.opy]: endSupercharger()"

    eventPlayer.setUltEnabled(true)
    destroyEffect(eventPlayer.orisa_supercharger_entity)
    getPlayers(eventPlayer.getTeam()).is_supercharged = false
    eventPlayer.is_using_supercharger = false


rule "[orisa/supercharger.opy]: Supercharge teammates in supercharger range":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.friendly_orisa_player.is_using_supercharger == true
    @Condition (distance(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_position) <= OW1_ORISA_SUPERCHARGER_AOE_RADIUS and \
               isInLoS(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_position, BarrierLos.PASS_THROUGH_BARRIERS)) == true
    
    eventPlayer.is_supercharged = true


rule "[orisa/supercharger.opy]: De-supercharge teammates outside supercharger range":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.is_supercharged == true
    @Condition eventPlayer.friendly_orisa_player.is_using_supercharger == true
    @Condition (distance(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_position) <= OW1_ORISA_SUPERCHARGER_AOE_RADIUS and \
               isInLoS(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_position, BarrierLos.PASS_THROUGH_BARRIERS)) == false
    
    wait(OW1_ORISA_SUPERCHARGER_LINGER_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.is_supercharged = false


rule "[orisa/supercharger.opy]: De-supercharge teammates when supercharger ends":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.is_using_supercharger == false
    
    getPlayers(eventPlayer.getTeam()).is_supercharged = false


rule "[orisa/supercharger.opy]: De-supercharge teammates when they die":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isDead()
    @Condition eventPlayer.is_supercharged == true
    
    eventPlayer.is_supercharged = false


rule "[orisa/supercharger.opy]: Damage boost player when supercharged":
    @Event eachPlayer
    @Condition eventPlayer.is_supercharged == true

    createBeam(getAllPlayers(), Beam.GOOD, eventPlayer.friendly_orisa_player.orisa_supercharger_position, eventPlayer.getPosition(), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.orisa_beam_entity = getLastCreatedEntity()
    createEffect(eventPlayer, Effect.ENERGY_SOUND, Color.GREEN, eventPlayer.getPosition(), 100, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.orisa_beam_sound_effect = getLastCreatedEntity()
    eventPlayer.setDamageDealt(percent(OW1_ORISA_SUPERCHARGER_DAMAGE_MULTIPLIER))


rule "[orisa/supercharger.opy]: Revert damage boost if not supercharged":
    @Event eachPlayer
    @Condition eventPlayer.is_supercharged == false

    destroyEffect(eventPlayer.orisa_beam_entity)
    destroyEffect(eventPlayer.orisa_beam_sound_effect)
    eventPlayer.setDamageDealt(100)

