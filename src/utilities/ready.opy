#!mainFile "../main.opy"

globalvar ready_hud
globalvar ready_description_hud

playervar ready

rule "[ready.opy]: Create ready HUD":
    @Event global
    @Condition isInSetup()
    
    hudHeader(getAllPlayers(), \
              "{}/{} ready".format(len([player for player in getAllPlayers() if player.ready == true]), len(getAllPlayers())), \
              HudPosition.TOP, \
              9999, \
              Color.GREEN if all([player.ready for player in getAllPlayers()]) == true else Color.RED, \
              HudReeval.STRING_AND_COLOR)
    ready_hud = getLastCreatedText()
    hudSubheader(getAllPlayers(), \
                 "Press {} + {} to ready".format(buttonString(Button.INTERACT), buttonString(Button.RELOAD)), \
                 HudPosition.TOP, \
                 9999, \
                 Color.WHITE, \
                 HudReeval.STRING_AND_COLOR)
    ready_description_hud = getLastCreatedText()
    waitUntil(not isInSetup(), 9999)
    destroyHudText(ready_hud)
    destroyHudText(ready_description_hud)


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
    @Condition all([player.ready for player in getAllPlayers()]) == true

    setMatchTime(SETUP_BUFFER_TIME)
