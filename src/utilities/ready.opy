#!mainFile "../dev_main.opy"


globalvar ready_gvar
#!defineMember ready_color ready_gvar[0]
globalvar READY_THRESHOLD_PERCENT = createWorkshopSetting(int[0:100], "Lobby", "Ready Threshold", 75)

playervar ready_pvar
#!defineMember ready ready_pvar[0]
playervar ready_hud
playervar ready_hud_i


rule "[utilities/ready.opy]: Create ready HUD":
    @Event eachPlayer
    @Condition isInSetup()

    if eventPlayer.ready_hud[0] == null:
        hudText(eventPlayer, 
                "{}/{} ready".format(len([player for player in getAllPlayers() if player.ready == true]), len(getAllPlayers())), 
                "Press {} + {} to ready".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD)), 
                GAMEMODE_NAME" "GAMEMODE_VERSION" ""("GAMEMODE_CODE")", 
                HudPosition.TOP, 
                Math.INFINITY, 
                ready_color if eventPlayer.ready else Color.RED, 
                Color.WHITE, 
                Color.WHITE, 
                HudReeval.STRING_AND_COLOR)
        eventPlayer.ready_hud[0] = getLastCreatedText()

    if eventPlayer.ready_hud[1] == null:
        hudSubtext(eventPlayer, "Join Discord for Matchmaking", HudPosition.TOP, Math.INFINITY, rgb(250, 156, 29), HudReeval.STRING_AND_COLOR)
        eventPlayer.ready_hud[1] = getLastCreatedText()

    if eventPlayer.ready_hud[2] == null:
        hudSubtext(eventPlayer, DISCORD_SHORT_LINK, HudPosition.TOP, Math.INFINITY, rgb(141, 187, 9), HudReeval.STRING_AND_COLOR)
        eventPlayer.ready_hud[2] = getLastCreatedText()
    
    waitUntil(not isInSetup(), Math.INFINITY)

    for eventPlayer.ready_hud_i in range(len(eventPlayer.ready_hud)):
        destroyHudText(eventPlayer.ready_hud[eventPlayer.ready_hud_i])
        eventPlayer.ready_hud[eventPlayer.ready_hud_i] = null


rule "[utilities/ready.opy]: Set initial ready color":
    @Event global
    @Condition isInSetup()

    ready_color = Color.YELLOW


rule "[utilities/ready.opy]: Unready all players when entering setup":
    @Event eachPlayer
    @Condition isInSetup()

    eventPlayer.ready = false


rule "[utilities/ready.opy]: Toggle ready when pressing Interact + Reload":
    @Event eachPlayer
    @Condition isInSetup()
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    eventPlayer.ready = not eventPlayer.ready


rule "[utilities/ready.opy]: Start match when everyone ready":
    @Event global
    @Condition isInSetup()
    @Condition getMatchTime() > SETUP_BUFFER_TIME
    @Condition len([player for player in getAllPlayers() if player.ready])/len(getAllPlayers()) >= READY_THRESHOLD_PERCENT/100
    @Condition not isGameInProgress() # Guard to prevent incorrect match time modification
    @Condition not isAssemblingHeroes() # Guard to prevent incorrect match time modification

    ready_color = Color.GREEN
    setMatchTime(SETUP_BUFFER_TIME)


rule "[utilities/ready.opy]: Reset ready when match starts":
    @Event global
    @Condition isGameInProgress()

    getAllPlayers().ready = false
