#!mainFile "../../main.opy"

subroutine initJunkerqueen

rule "[junkerqueen.opy]: Detect Junkerqueen initialization":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer.call_initialize == true # without this flag, the reset code in generic.opy executes after initialization

    initJunkerqueen()
    eventPlayer.call_initialize = false


def initJunkerqueen():
    @Name "[junkerqueen.opy]: initJunkerqueen()"

    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))
