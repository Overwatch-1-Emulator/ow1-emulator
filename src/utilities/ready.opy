#!mainFile "../main.opy"

playervar ready

rule "[ready.opy]: Unready all players when entering setup":
    @Event eachPlayer
    @Condition isInSetup() == true

    eventPlayer.ready = false


rule "[ready.opy]: Toggle ready when pressing Interact + Reload":
    @Event eachPlayer
    @Condition isInSetup() == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true

    eventPlayer.ready = not eventPlayer.ready # Toggle readiness


rule "[ready.opy]: Display message when ready":
    @Event eachPlayer
    @Condition eventPlayer.ready == true

    bigMessage(eventPlayer, "Ready")


rule "[ready.opy]: Display message when not ready":
    @Event eachPlayer
    @Condition eventPlayer.ready == false

    bigMessage(eventPlayer, "Not Ready")


rule "[ready.opy]: Start match when everyone ready":
    @Event global
    @Condition isGameInProgress() == false # Guard to prevent incorrect match time modification
    @Condition isAssemblingHeroes() == false # Guard to prevent incorrect match time modification
    @Condition isInSetup() == true
    @Condition all([player.ready for player in getAllPlayers()]) == true

    setMatchTime(5)
