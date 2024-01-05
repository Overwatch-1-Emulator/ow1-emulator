#!mainFile "../main.opy"

globalvar info_gvar
globalvar rgb_list = [vect(255, 0, 0), vect(255, 255, 0), vect(0, 255, 0), vect(0, 255, 255), vect(0, 0, 255), vect(255, 0, 255)]
globalvar HIDE_WATERMARK = createWorkshopSetting(bool, "Misc", "Hide Watermark", false)

playervar info_pvar
#!defineMember rgb_i info_pvar[0]
playervar info_id
playervar rgb_vect
#!define RGB_DURATION 0.5

# #!define infoVisible(player) \
#     ((player.isInSpawnRoom()) \
#   or (player.isDead()) \
#   or (isInSetup()))

#!define infoVisible(player) \
    (true)


rule "[info.opy]: Create info HUD":
    @Event eachPlayer
    @Condition not HIDE_WATERMARK

    if eventPlayer.info_id[0] == null:
        hudSubheader(eventPlayer if infoVisible(eventPlayer) else null, 
                     GAMEMODE_NAME" ""("GAMEMODE_CODE")", 
                     HudPosition.LEFT, 
                     Math.INFINITY, 
                     Color.WHITE, 
                     HudReeval.VISIBILITY)
        eventPlayer.info_id[0] = getLastCreatedText()

    if eventPlayer.info_id[1] == null:
        hudSubheader(eventPlayer if infoVisible(eventPlayer) else null, 
                     DISCORD_LINK, 
                     HudPosition.LEFT, 
                     Math.INFINITY, 
                     rgb(eventPlayer.rgb_vect.x, eventPlayer.rgb_vect.y, eventPlayer.rgb_vect.z), 
                     HudReeval.VISIBILITY_AND_COLOR)
        eventPlayer.info_id[1] = getLastCreatedText()
    
    eventPlayer.rgb_i = 0
    eventPlayer.rgb_vect = rgb_list[eventPlayer.rgb_i]
    

rule "[info.opy]: Create info HUD":
    @Event eachPlayer
    @Condition infoVisible(eventPlayer)

    eventPlayer.rgb_i = (eventPlayer.rgb_i + 1)%(len(rgb_list))
    chase(eventPlayer.rgb_vect, rgb_list[eventPlayer.rgb_i], duration=RGB_DURATION, ChaseReeval.NONE)
    waitUntil(eventPlayer.rgb_vect == rgb_list[eventPlayer.rgb_i], Math.INFINITY)
    if RULE_CONDITION:
        goto RULE_START
