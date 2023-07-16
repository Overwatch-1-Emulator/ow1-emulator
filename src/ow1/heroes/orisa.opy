#!mainFile "../../main.opy"

playervar orisa_supercharger
playervar orisa_ult_time
playervar orisa_ult_pos
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

    createEffect(getAllPlayers(), Effect.RING, Color.LIME_GREEN, eventPlayer.getPosition(), 10, EffectReeval.NONE)
    eventPlayer.orisa_supercharger = getLastCreatedEntity()

rule "[orisa.opy]: Remove effect":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.orisa_ult_time == 0

    destroyEffect(eventPlayer.orisa_supercharger)
    stopChasingVariable(eventPlayer.orisa_ult_time)

