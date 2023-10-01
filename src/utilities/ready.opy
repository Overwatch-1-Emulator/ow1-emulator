#!mainFile "../main.opy"

globalvar ready_color

playervar ready_hud
playervar ready

rule "[ready.opy]: Create ready HUD":
    @Event eachPlayer
    @Condition isInSetup()

    if eventPlayer.ready_hud == null:
        hudText(eventPlayer, \
                "{}/{} ready".format(len([player for player in getAllPlayers() if player.ready == true]), len(getAllPlayers())), \
                "Press {} + {} to ready".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD)), \
                "Overwatch 1++: dsc.gg/ow1", \
                HudPosition.TOP, \
                Math.INFINITY, \
                ready_color if eventPlayer.ready else Color.RED, \
                Color.WHITE, \
                Color.WHITE, \
                HudReeval.STRING_AND_COLOR)
        eventPlayer.ready_hud = getLastCreatedText()
    waitUntil(not isInSetup(), Math.INFINITY)
    destroyHudText(eventPlayer.ready_hud)
    eventPlayer.ready_hud = null


rule "[ready.opy]: Set initial ready color":
    @Event global
    @Condition isInSetup() == true

    ready_color = Color.YELLOW


rule "[ready.opy]: Unready all players when entering setup":
    @Event eachPlayer
    @Condition isInSetup() == true

    eventPlayer.ready = false


rule "[ready.opy]: Toggle ready when pressing Interact + Reload":
    @Event eachPlayer
    @Condition isInSetup() == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true

    eventPlayer.ready = not eventPlayer.ready


rule "[ready.opy]: Start match when everyone ready":
    @Event global
    @Condition isGameInProgress() == false # Guard to prevent incorrect match time modification
    @Condition isAssemblingHeroes() == false # Guard to prevent incorrect match time modification
    @Condition isInSetup() == true
    @Condition getMatchTime() > SETUP_BUFFER_TIME
    @Condition len([player for player in getAllPlayers() if player.ready])/len(getAllPlayers()) >= READY_THRESHOLD

    ready_color = Color.GREEN
    setMatchTime(SETUP_BUFFER_TIME)
