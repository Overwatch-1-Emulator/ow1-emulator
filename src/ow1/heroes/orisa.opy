#!mainFile "../../main.opy"

playervar orisa_supercharger_ring
playervar orisa_supercharger
playervar orisa_ult_time 0
playervar orisa_ult_pos
playervar orisa_beam
playervar orisa_beam_enabled
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
    pass


rule "[orisa.opy]: Supercharger":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true and eventPlayer.getUltCharge() == 100

    eventPlayer.orisa_ult_pos = eventPlayer.getPosition()
    eventPlayer.orisa_ult_time = 15
    chase(eventPlayer.orisa_ult_time, 0, rate=1, ChaseReeval.NONE)
    eventPlayer.setUltCharge(0)

rule "[orisa.opy]: Ult Effect":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true and eventPlayer.getUltCharge() == 100

    createEffect(getAllPlayers(), Effect.RING, Color.LIME_GREEN, eventPlayer.orisa_ult_pos, 25, EffectReeval.NONE)
    eventPlayer.orisa_supercharger_ring = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.SPHERE, Color.LIME_GREEN, eventPlayer.orisa_ult_pos, 0.5, EffectReeval.NONE)
    eventPlayer.orisa_supercharger = getLastCreatedEntity()

rule "[orisa.opy]: Remove effect":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.orisa_ult_time == 0

    destroyEffect(eventPlayer.orisa_supercharger_ring)
    destroyEffect(eventPlayer.orisa_supercharger)
    destroyEffect(eventPlayer.orisa_beam)
    stopChasingVariable(eventPlayer.orisa_ult_time)

rule "[orisa.opy]: Damage Boost":
    @Event eachPlayer
    @Condition eventPlayer.orisa_ult_time != 0
    
    
    while eventPlayer.orisa_ult_time != 0:
        wait(0.2)
        if distance(eventPlayer.orisa_ult_pos, eventPlayer.getPosition()) <= 25:
            if eventPlayer.orisa_beam_enabled == false:
                createBeam(getAllPlayers(), Beam.GOOD, eventPlayer.orisa_ult_pos, eventPlayer.getPosition(), Color.BLUE, EffectReeval.POSITION_AND_RADIUS)
                eventPlayer.orisa_beam = getLastCreatedEntity()
                eventPlayer.orisa_beam_enabled = true
            eventPlayer.setDamageDealt(150)
        elif distance(eventPlayer.orisa_ult_pos, eventPlayer.getPosition()) > 25:
            destroyEffect(eventPlayer.orisa_beam)
            eventPlayer.orisa_beam_enabled = false
            eventPlayer.setDamageDealt(100)
    
rule "[orisa.opy]: Set damage dealt":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.orisa_ult_time == 0

    eventPlayer.setDamageDealt(100)