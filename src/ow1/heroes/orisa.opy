#!mainFile "../../main.opy"

playervar orisa_supercharger_ring
playervar orisa_supercharger
playervar orisa_ult_time 0
playervar orisa_ult_pos
playervar orisa_beam
playervar orisa_beam_enabled
playervar friendly_orisa_player
playervar enemy_orisa_player
subroutine initOrisa


rule "[orisa.opy]: Detect Orisa initialization":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initOrisa()
    eventPlayer.initialized = true


def initOrisa():
    @Name "[orisa.opy]: initOrisa()"
    eventPlayer.disallowButton(Button.ULTIMATE)
    getPlayers(eventPlayer.getTeam()).friendly_orisa_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_orisa_player = eventPlayer
    pass


rule "[orisa.opy]: Supercharger":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true and eventPlayer.getUltCharge() == 100 and eventPlayer.orisa_ult_time == 0

    
    eventPlayer.orisa_ult_pos = eventPlayer.getPosition() + Vector.UP
    eventPlayer.orisa_ult_time = 15
    chase(eventPlayer.orisa_ult_time, 0, rate=1, ChaseReeval.NONE)
    eventPlayer.communicate(Comms.VOICE_LINE_UP) 
    #createEffect(getAllPlayers(), Effect.RING, Color.LIME_GREEN, eventPlayer.orisa_ult_pos, 25, EffectReeval.NONE)
    #eventPlayer.orisa_supercharger_ring = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.orisa_ult_pos, 0.5, EffectReeval.NONE)
    eventPlayer.orisa_supercharger = getLastCreatedEntity()
    eventPlayer.setUltCharge(0)

rule "[orisa.opy]: Remove effect":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.friendly_orisa_player.orisa_ult_time == 0

    #destroyEffect(eventPlayer.orisa_supercharger_ring)
    destroyEffect(eventPlayer.orisa_supercharger)
    destroyEffect(eventPlayer.orisa_beam)
    eventPlayer.orisa_beam_enabled = false
    stopChasingVariable(eventPlayer.orisa_ult_time)

rule "[orisa.opy]: Enable Damage Boost":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.friendly_orisa_player.orisa_ult_time != 0 and eventPlayer in getPlayersInRadius(eventPlayer.friendly_orisa_player.orisa_ult_pos, 25, eventPlayer.friendly_orisa_player.getTeam(), LosCheck.SURFACES_AND_ENEMY_BARRIERS)
    
    if eventPlayer.orisa_beam_enabled == false:
        createBeam(getAllPlayers(), Beam.GOOD, eventPlayer.friendly_orisa_player.orisa_ult_pos, eventPlayer.getPosition(), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.orisa_beam_enabled = true
    eventPlayer.orisa_beam = getLastCreatedEntity()
    eventPlayer.setDamageDealt(150)

rule "[orisa.opy]: Disable Damage Boost":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.friendly_orisa_player.orisa_ult_time != 0 and not eventPlayer in getPlayersInRadius(eventPlayer.friendly_orisa_player.orisa_ult_pos, 25, eventPlayer.friendly_orisa_player.getTeam(), LosCheck.SURFACES_AND_ENEMY_BARRIERS)
    
    wait(1,Wait.ABORT_WHEN_FALSE)
    destroyEffect(eventPlayer.orisa_beam)
    eventPlayer.orisa_beam_enabled = false
    eventPlayer.setDamageDealt(100)

    
rule "[orisa.opy]: Set damage dealt after ultimate":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.friendly_orisa_player.orisa_ult_time == 0

    eventPlayer.setDamageDealt(100)