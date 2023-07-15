#!mainFile "../../main.opy"

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


rule "[orisa.opy]: Cancel ult":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true and eventPlayer.getUltCharge() == 100

    #getPlayersInRadius(eventPlayer.getPosition(), 25, eventPlayer.getTeam(), LosCheck.SURFACES)
    createEffect(getAllPlayers(), Effect.RING, Color.LIME_GREEN, eventPlayer.getPosition(), 10, EffectReeval.NONE)
    eventPlayer.setUltCharge(0)
