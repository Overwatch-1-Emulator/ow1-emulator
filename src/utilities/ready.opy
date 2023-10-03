#!mainFile "../main.opy"

globalvar ready_color

playervar ready_hud
playervar ready

rule "[ready.opy]: Create ready HUD":
    @Event eachPlayer
    @Condition isInSetup()

    if eventPlayer.ready_hud[0] == null:
        hudHeader(eventPlayer, "{}/{} ready".format(len([player for player in getAllPlayers() if player.ready == true]), len(getAllPlayers())), HudPosition.TOP, Math.INFINITY, ready_color if eventPlayer.ready else Color.RED, HudReeval.STRING_AND_COLOR)
        eventPlayer.ready_hud[0] = getLastCreatedText()

    if eventPlayer.ready_hud[1] == null:
        hudSubheader(eventPlayer, "Press {} + {} to ready".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD)), HudPosition.TOP, Math.INFINITY, Color.WHITE, HudReeval.STRING_AND_COLOR)
        eventPlayer.ready_hud[1] = getLastCreatedText()

    if eventPlayer.ready_hud[2] == null:
        hudSubtext(eventPlayer, "Overwatch 1++ (YKMXH)", HudPosition.TOP, Math.INFINITY, Color.WHITE, HudReeval.STRING_AND_COLOR)
        eventPlayer.ready_hud[2] = getLastCreatedText()

    if eventPlayer.ready_hud[3] == null:
        hudSubtext(eventPlayer, "Ranked Matchmaking: dsc.gg/ow1", HudPosition.TOP, Math.INFINITY, rgb(250, 156, 29), HudReeval.STRING_AND_COLOR)
        eventPlayer.ready_hud[3] = getLastCreatedText()
    
    waitUntil(not isInSetup(), Math.INFINITY)
    
    destroyHudText(eventPlayer.ready_hud[0])
    eventPlayer.ready_hud[0] = null
    destroyHudText(eventPlayer.ready_hud[1])
    eventPlayer.ready_hud[1] = null
    destroyHudText(eventPlayer.ready_hud[2])
    eventPlayer.ready_hud[2] = null
    destroyHudText(eventPlayer.ready_hud[3])
    eventPlayer.ready_hud[3] = null


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
