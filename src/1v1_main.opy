#!include "env/1v1_env.opy"

# Useful constants
#!include "constants/ow1_constants.opy"
#!include "constants/ow2_constants.opy"

# Useful functions
#!include "utilities/macro_functions.opy"
#!include "utilities/stat_helper.opy"
#!include "utilities/custom_hp.opy"
#!include "utilities/reset.opy"
#!include "utilities/hero_switch.opy"
#!include "utilities/hero_roster.opy"
#!include "utilities/role_lock.opy"
##!include "utilities/ready.opy"
#!include "utilities/hit_detection.opy"
#!include "utilities/anti_crash.opy"

# Custom game lobby settings
#!include "lobby/1v1_lobby.opy"

# OW1 logic
# Remove damage passive
#!include "passives/damage/damage_passive.opy"
# Remove tank passive
#!include "passives/tank/ult_charge.opy"
#!include "passives/tank/knockback.opy"
# Remove support passive
#!include "passives/support/self_heal.opy"

# Include for global scoping
#!include "heroes/sombra/hack.opy"

# Hero specific logic
#!include "heroes/ana/init.opy"
#!include "heroes/ashe/init.opy"
#!include "heroes/baptiste/init.opy"
#!include "heroes/bastion/init.opy"
#!include "heroes/brigitte/init.opy"
#!include "heroes/doomfist/init.opy"
#!include "heroes/dva/init.opy"
#!include "heroes/echo/init.opy"
#!include "heroes/genji/init.opy"
#!include "heroes/hanzo/init.opy"
#!include "heroes/illari/init.opy"
#!include "heroes/junkerqueen/init.opy"
#!include "heroes/junkrat/init.opy"
#!include "heroes/kiriko/init.opy"
#!include "heroes/lifeweaver/init.opy"
#!include "heroes/lucio/init.opy"
#!include "heroes/mauga/init.opy"
#!include "heroes/mccree/init.opy"
#!include "heroes/mei/init.opy"
#!include "heroes/mercy/init.opy"
#!include "heroes/moira/init.opy"
#!include "heroes/orisa/init.opy"
#!include "heroes/pharah/init.opy"
#!include "heroes/ramattra/init.opy"
#!include "heroes/reaper/init.opy"
#!include "heroes/reinhardt/init.opy"
#!include "heroes/roadhog/init.opy"
#!include "heroes/sigma/init.opy"
#!include "heroes/sojourn/init.opy"
#!include "heroes/soldier/init.opy"
#!include "heroes/sombra/init.opy"
#!include "heroes/symmetra/init.opy"
#!include "heroes/torbjorn/init.opy"
#!include "heroes/tracer/init.opy"
#!include "heroes/widowmaker/init.opy"
#!include "heroes/winston/init.opy"
#!include "heroes/wreckingball/init.opy"
#!include "heroes/zarya/init.opy"
#!include "heroes/zenyatta/init.opy"

# Include debug at the end so any variable can be viewed
##!include "utilities/debug.opy"

#!include "utilities/watermark.opy"

globalvar arena_gvar
#!defineMember main_center arena_gvar[0]
#!defineMember main_high arena_gvar[1]
#!defineMember main_top_deck arena_gvar[2]
#!defineMember side_arena_center arena_gvar[3]
#!defineMember side_arena_spawns_facing arena_gvar[4]
#!defineMember MAIN_FACING arena_gvar[5]
#!defineMember HERO_LIST_1 arena_gvar[6]
#!defineMember first_match arena_gvar[7]
globalvar main_spawn_det_loc #arena_gvar[8]
#!defineMember MAIN_TOP_SPAWNS arena_gvar[9]
#!defineMember BURN_DAMAGE arena_gvar[10]
#!defineMember MAIN_OPPOSITE_SPAWNS arena_gvar[11]
#!defineMember INTRO_HUD arena_gvar[12]
#!defineMember MAIN_DECK_SPAWNS arena_gvar[14]
#!defineMember main_default_spawn arena_gvar[16]
#!defineMember SPEC_SPOT_2 arena_gvar[20]
#!defineMember SPEC_SPOT arena_gvar[21]
globalvar arena1_q #arena_gvar[22]
globalvar arena2_q #arena_gvar[23]
globalvar arena3_q #arena_gvar[24]
#!defineMember arena1_match arena_gvar[26]
#!defineMember arena2_match arena_gvar[27]
#!defineMember arena3_match arena_gvar[28]
#!defineMember one_hero arena_gvar[58]
#!defineMember HOST_DIFFERENT_HEROES arena_gvar[65]
#!defineMember one_hero2 arena_gvar[101]
#!defineMember HERO_LIST_2 arena_gvar[102]
#!defineMember ALWAYS_REFRESH_HERO arena_gvar[103]

playervar arena_pvar
#!defineMember one_hero_pvar arena_pvar[0]
#!defineMember randomizer arena_pvar[2]
#!defineMember _is_spectating arena_pvar[3]
#!defineMember dead_helper arena_pvar[4]
#!defineMember Hud arena_pvar[7]
#!defineMember hero_list arena_pvar[11]
#!defineMember hero_number arena_pvar[13]
#!defineMember Score arena_pvar[18]
#!defineMember ult_charge arena_pvar[20]
#!defineMember anti_heal_debuffed arena_pvar[26]

subroutine spawnLocationCheck
subroutine arena1Dies
subroutine arena2Dies
subroutine arena3Dies

#!define startForcingSpectator(player)\
    player.teleport(SPEC_SPOT)\
    player.startForcingThrottle(0, 0, 0, 0, 0, 0)\
    player.setGravity(abs(0))\
    player.setMoveSpeed(abs(0))\
    player.disallowButton(Button.PRIMARY_FIRE)\
    player.disallowButton(Button.SECONDARY_FIRE)\
    player.disallowButton(Button.MELEE)\
    player.disallowButton(Button.ABILITY_1)\
    player.disallowButton(Button.ABILITY_2)\
    player.disallowButton(Button.ULTIMATE)\
    player.stopForcingButton(Button.PRIMARY_FIRE)\
    player.stopForcingButton(Button.SECONDARY_FIRE)\
    player.stopForcingButton(Button.MELEE)\
    player.stopForcingButton(Button.ABILITY_1)\
    player.stopForcingButton(Button.ABILITY_2)\
    player.setStatusEffect(null, Status.UNKILLABLE, 9999)\
    player.setInvisibility(Invis.ALL)\
    player.setStatusEffect(null, Status.PHASED_OUT, 9999)\
    player.setStatusEffect(null, Status.ROOTED, 9999)\
    player.setDamageDealt(0)\
    wait(0.5)\
    player.setFacing(localVector(MAIN_FACING, player, Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)\
    player._is_spectating = true\


#!define stopForcingSpectator(player)\
    player.setGravity(100)\
    player.setMoveSpeed(100)\
    player.setStatusEffect(null, Status.UNKILLABLE, 0)\
    player.setInvisibility(Invis.NONE)\
    player.setStatusEffect(null, Status.PHASED_OUT, 0)\
    player.setStatusEffect(null, Status.ROOTED, 0)\
    player.setDamageDealt(100)\
    player.stopForcingThrottle()\
    player.allowButton(Button.PRIMARY_FIRE)\
    player.allowButton(Button.SECONDARY_FIRE)\
    player.allowButton(Button.MELEE)\
    player.allowButton(Button.ABILITY_1)\
    player.allowButton(Button.ABILITY_2)\
    player.allowButton(Button.ULTIMATE)\
    player.call_init = true\
    player._is_spectating = false\


rule "Workshop Settings --------------------------------------------------------------------------------------":
    disableInspector()

    BURN_DAMAGE = createWorkshopSetting(int[25:200], "Burn Damage", "Damage per tick", 25, 0)
    ALWAYS_REFRESH_HERO = createWorkshopSetting(bool, "Always refresh hero (cooldowns, shield, etc) after winning on arena 1", "Refresh hero after winning on arena 1", false, 0)
    HOST_DIFFERENT_HEROES = createWorkshopSetting(bool, "B Special settings for mode where players have different list of heroes", "Host player has different list of heroes", false, 0)


rule "Creating HERO_LIST_1, Check one_hero":
    HERO_LIST_1.append(_available_heroes)
    del HERO_LIST_1[0]
    #if len(HERO_LIST_1) == 1:
    #one_hero = true
    #HERO_LIST_1.append(HERO_LIST_1[0])
    #__end__()


rule "Creating HERO_LIST_2, Check one_hero2, for host player ----------------------------------------------------------------------------":
    @Condition HOST_DIFFERENT_HEROES == true

    HERO_LIST_2.append(_available_heroes)
    del HERO_LIST_2[0]
    #if len(HERO_LIST_2) == 1:
    #one_hero2 = true
    #HERO_LIST_2.append(HERO_LIST_2[0])
    #__end__()


rule "Disable Scoring":
    disableScoring()
    hudText(getAllPlayers(), "Code: {}".format(GAMEMODE_CODE), "dsc.gg/ow1", "Full details: workshop.codes/ow1-emulator", HudPosition.TOP, 22, Color.ORANGE, Color.BLUE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    INTRO_HUD = getLastCreatedText()


rule "Pause Timer":
    @Condition isGameInProgress() == true
    
    pauseMatchTime()
    setMatchTime(1220)
    wait(1)
    destroyHudText(INTRO_HUD)


rule "Restart Hero List":
    @Event eachPlayer
    @Condition eventPlayer.hero_number == len(eventPlayer.hero_list)
    
    eventPlayer.hero_number = 0


rule "Arena Locations":
    main_center = vect(0, 267, 280)
    main_high = vect(0, 280, 280)
    main_top_deck = vect(0, 279.5, 295.5)
    MAIN_FACING = vect(0, 268.5, 280)
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.RED, main_center, 16.7, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, main_top_deck, 2.61, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    SPEC_SPOT = vect(13.366, 285, 279.711)
    SPEC_SPOT_2 = vect(-13.672, 285, 279.735)


rule "Arena Spawn Locations":
    main_default_spawn = vect(-0.087, 268, 267.986)
    #MAIN_OPPOSITE_SPAWNS = vect(11.146, 268, 275.313)
    MAIN_OPPOSITE_SPAWNS = [vect(11, 268, 276.2), vect(-11, 268, 276.2)]
    MAIN_TOP_SPAWNS = [vect(7.923, 268, 273.866), vect(0.004, 268, 276.965), vect(-7.771, 268, 273.383)]
    #MAIN_DECK_SPAWNS = vect(9.421, 268, 280.176)
    MAIN_DECK_SPAWNS = [vect(9.486, 268, 280.02), vect(-0.005, 268, 283.035), vect(-9.486, 268, 280.02)]


rule "Arena Spawn Location Detection Spots":
    main_spawn_det_loc[0] = vect(0.198, 271.351, 302.477)
    main_spawn_det_loc[1] = vect(0.147, 271.348, 266.101)
    main_spawn_det_loc[2] = vect(20.349, 268.349, 281.046)
    main_spawn_det_loc[3] = vect(-20.35, 268.349, 281.009)


rule "Arena 2: Zone.0, SafeCheck.1, Spawn.0&1, Facing.2":
    side_arena_center = vect(-41.832, 260, 344.857)
    side_arena_center.append(vect(-41.832, 270, 344.857))
    side_arena_spawns_facing = vect(-50.464, 268.667, 351.671)
    side_arena_spawns_facing.append(vect(-31.82, 268.549, 332.737))
    side_arena_spawns_facing.append(vect(-38.715, 271.502, 343.17))
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.RED, side_arena_center[0], 18, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Arena 3: Zone.2, SafeCheck.3, Spawn.3&4, Facing.5":
    side_arena_center.append(vect(41.832, 260, 344.857))
    side_arena_center.append(vect(41.832, 270, 344.857))
    side_arena_spawns_facing.append(vect(50.464, 268.667, 351.671))
    side_arena_spawns_facing.append(vect(31.82, 268.549, 332.737))
    side_arena_spawns_facing.append(vect(38.715, 271.502, 343.17))
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.BLUE, side_arena_center[2], 18, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Player Joins host player different heroes --------------------------------------------------------------------------------------":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer == hostPlayer
    @Condition HOST_DIFFERENT_HEROES == true
    
    eventPlayer.hero_list = random.shuffle(HERO_LIST_2)
    eventPlayer.startForcingHero(eventPlayer.hero_list[eventPlayer.hero_number])
    if len(eventPlayer.hero_list) == 1:
        eventPlayer.one_hero_pvar = true
        eventPlayer.hero_list.append(eventPlayer.hero_list[0])
    if isGameInProgress():
        goto lbl_0
    arena1_q.append(eventPlayer)
    goto lbl_1
    lbl_0:
    if getNumberOfPlayers(Team.ALL) > 3:
        goto lbl_2
    arena1_q.append(eventPlayer)
    goto lbl_3
    lbl_2:
    if getNumberOfPlayers(Team.ALL) != 4:
        goto lbl_4
    arena2_q.append(eventPlayer)
    goto lbl_5
    lbl_4:
    if getNumberOfPlayers(Team.ALL) != 5:
        goto lbl_6
    arena2_q.append(eventPlayer)
    goto lbl_7
    lbl_6:
    if getNumberOfPlayers(Team.ALL) < 6:
        goto lbl_8
    arena3_q.append(eventPlayer)
    lbl_1:
    lbl_3:
    lbl_5:
    lbl_7:
    lbl_8:
    startForcingSpectator(eventPlayer)
    if not eventPlayer in arena1_q:
        goto lbl_9
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena1_q.index(eventPlayer) - 2)), "Score per kill: 3", "Arena: 1", HudPosition.TOP, 2, Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_9:
    if not eventPlayer in arena2_q:
        goto lbl_10
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena2_q.index(eventPlayer) - 2)), "Score per kill: 2", "Arena: 2", HudPosition.TOP, 2, Color.RED, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_10:
    if not eventPlayer in arena3_q:
        goto lbl_11
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena3_q.index(eventPlayer) - 2)), "Score per kill: 1", "Arena: 3", HudPosition.TOP, 2, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_11:
    wait(0.3)
    startForcingSpectator(eventPlayer)


rule "Player Joins not host player different heroes ----------------------------------------":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer != hostPlayer
    @Condition HOST_DIFFERENT_HEROES == true
    
    eventPlayer.hero_list = random.shuffle(HERO_LIST_1)
    eventPlayer.startForcingHero(eventPlayer.hero_list[eventPlayer.hero_number])
    if len(eventPlayer.hero_list) == 1:
        eventPlayer.one_hero_pvar = true
        eventPlayer.hero_list.append(eventPlayer.hero_list[0])
    if isGameInProgress():
        goto lbl_0
    arena1_q.append(eventPlayer)
    goto lbl_1
    lbl_0:
    if getNumberOfPlayers(Team.ALL) > 3:
        goto lbl_2
    arena1_q.append(eventPlayer)
    goto lbl_3
    lbl_2:
    if getNumberOfPlayers(Team.ALL) != 4:
        goto lbl_4
    arena2_q.append(eventPlayer)
    goto lbl_5
    lbl_4:
    if getNumberOfPlayers(Team.ALL) != 5:
        goto lbl_6
    arena2_q.append(eventPlayer)
    goto lbl_7
    lbl_6:
    if getNumberOfPlayers(Team.ALL) < 6:
        goto lbl_8
    arena3_q.append(eventPlayer)
    lbl_1:
    lbl_3:
    lbl_5:
    lbl_7:
    lbl_8:
    startForcingSpectator(eventPlayer)
    if not eventPlayer in arena1_q:
        goto lbl_9
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena1_q.index(eventPlayer) - 2)), "Score per kill: 3", "Arena: 1", HudPosition.TOP, 2, Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_9:
    if not eventPlayer in arena2_q:
        goto lbl_10
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena2_q.index(eventPlayer) - 2)), "Score per kill: 2", "Arena: 2", HudPosition.TOP, 2, Color.RED, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_10:
    if not eventPlayer in arena3_q:
        goto lbl_11
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena3_q.index(eventPlayer) - 2)), "Score per kill: 1", "Arena: 3", HudPosition.TOP, 2, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_11:
    wait(0.3)
    startForcingSpectator(eventPlayer)


rule "Player Joins":
    @Event playerJoined
    @Condition not eventPlayer.isDummy()
    @Condition not HOST_DIFFERENT_HEROES
    
    eventPlayer.hero_list = random.shuffle(HERO_LIST_1)
    eventPlayer.startForcingHero(eventPlayer.hero_list[eventPlayer.hero_number])
    if len(eventPlayer.hero_list) == 1:
        eventPlayer.one_hero_pvar = true
        eventPlayer.hero_list.append(eventPlayer.hero_list[0])
    if isGameInProgress():
        goto lbl_0
    arena1_q.append(eventPlayer)
    goto lbl_1
    lbl_0:
    if getNumberOfPlayers(Team.ALL) > 3:
        goto lbl_2
    arena1_q.append(eventPlayer)
    goto lbl_3
    lbl_2:
    if getNumberOfPlayers(Team.ALL) != 4:
        goto lbl_4
    arena2_q.append(eventPlayer)
    goto lbl_5
    lbl_4:
    if getNumberOfPlayers(Team.ALL) != 5:
        goto lbl_6
    arena2_q.append(eventPlayer)
    goto lbl_7
    lbl_6:
    if getNumberOfPlayers(Team.ALL) < 6:
        goto lbl_8
    arena3_q.append(eventPlayer)
    lbl_1:
    lbl_3:
    lbl_5:
    lbl_7:
    lbl_8:
    startForcingSpectator(eventPlayer)
    if not eventPlayer in arena1_q:
        goto lbl_9
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena1_q.index(eventPlayer) - 2)), "Score per kill: 3", "Arena: 1", HudPosition.TOP, 2, Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_9:
    if not eventPlayer in arena2_q:
        goto lbl_10
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena2_q.index(eventPlayer) - 2)), "Score per kill: 2", "Arena: 2", HudPosition.TOP, 2, Color.RED, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_10:
    if not eventPlayer in arena3_q:
        goto lbl_11
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena3_q.index(eventPlayer) - 2)), "Score per kill: 1", "Arena: 3", HudPosition.TOP, 2, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_11:
    wait(0.3)
    startForcingSpectator(eventPlayer)


rule "Spread everyone once the game is in Progress":
    @Condition isGameInProgress() == true
    
    if getNumberOfPlayers(Team.ALL) != 4:
        goto lbl_0
    arena2_q.append(arena1_q[3])
    arena2_q.append(arena1_q[4])
    del arena1_q[4]
    del arena1_q[3]
    return
    lbl_0:
    if getNumberOfPlayers(Team.ALL) != 5:
        goto lbl_1
    arena2_q.append(arena1_q[3])
    arena2_q.append(arena1_q[4])
    arena2_q.append(arena1_q[5])
    del arena1_q[5]
    del arena1_q[4]
    del arena1_q[3]
    return
    lbl_1:
    if getNumberOfPlayers(Team.ALL) != 6:
        goto lbl_2
    arena2_q.append(arena1_q[3])
    arena2_q.append(arena1_q[4])
    arena3_q.append(arena1_q[5])
    arena3_q.append(arena1_q[6])
    del arena1_q[6]
    del arena1_q[5]
    del arena1_q[4]
    del arena1_q[3]
    return
    lbl_2:
    if getNumberOfPlayers(Team.ALL) != 7:
        goto lbl_3
    arena2_q.append(arena1_q[3])
    arena2_q.append(arena1_q[4])
    arena3_q.append(arena1_q[5])
    arena3_q.append(arena1_q[6])
    arena3_q.append(arena1_q[7])
    del arena1_q[7]
    del arena1_q[6]
    del arena1_q[5]
    del arena1_q[4]
    del arena1_q[3]
    return
    lbl_3:
    if getNumberOfPlayers(Team.ALL) != 8:
        goto lbl_4
    arena2_q.append(arena1_q[3])
    arena2_q.append(arena1_q[4])
    arena3_q.append(arena1_q[5])
    arena3_q.append(arena1_q[6])
    arena3_q.append(arena1_q[7])
    arena3_q.append(arena1_q[8])
    del arena1_q[8]
    del arena1_q[7]
    del arena1_q[6]
    del arena1_q[5]
    del arena1_q[4]
    del arena1_q[3]
    return
    lbl_4:
    if getNumberOfPlayers(Team.ALL) != 9:
        goto lbl_5
    arena2_q.append(arena1_q[3])
    arena2_q.append(arena1_q[4])
    arena3_q.append(arena1_q[5])
    arena3_q.append(arena1_q[6])
    arena3_q.append(arena1_q[7])
    arena3_q.append(arena1_q[8])
    arena3_q.append(arena1_q[9])
    del arena1_q[9]
    del arena1_q[8]
    del arena1_q[7]
    del arena1_q[6]
    del arena1_q[5]
    del arena1_q[4]
    del arena1_q[3]
    return
    lbl_5:
    if getNumberOfPlayers(Team.ALL) != 10:
        goto lbl_6
    arena2_q.append(arena1_q[3])
    arena2_q.append(arena1_q[4])
    arena3_q.append(arena1_q[5])
    arena3_q.append(arena1_q[6])
    arena3_q.append(arena1_q[7])
    arena3_q.append(arena1_q[8])
    arena3_q.append(arena1_q[9])
    arena3_q.append(arena1_q[10])
    del arena1_q[10]
    del arena1_q[9]
    del arena1_q[8]
    del arena1_q[7]
    del arena1_q[6]
    del arena1_q[5]
    del arena1_q[4]
    del arena1_q[3]
    return
    lbl_6:
    if getNumberOfPlayers(Team.ALL) != 11:
        goto lbl_7
    arena2_q.append(arena1_q[3])
    arena2_q.append(arena1_q[4])
    arena3_q.append(arena1_q[5])
    arena3_q.append(arena1_q[6])
    arena3_q.append(arena1_q[7])
    arena3_q.append(arena1_q[8])
    arena3_q.append(arena1_q[9])
    arena3_q.append(arena1_q[10])
    arena3_q.append(arena1_q[11])
    del arena1_q[11]
    del arena1_q[10]
    del arena1_q[9]
    del arena1_q[8]
    del arena1_q[7]
    del arena1_q[6]
    del arena1_q[5]
    del arena1_q[4]
    del arena1_q[3]
    return
    lbl_7:
    if getNumberOfPlayers(Team.ALL) != 12:
        goto lbl_8
    arena2_q.append(arena1_q[3])
    arena2_q.append(arena1_q[4])
    arena3_q.append(arena1_q[5])
    arena3_q.append(arena1_q[6])
    arena3_q.append(arena1_q[7])
    arena3_q.append(arena1_q[8])
    arena3_q.append(arena1_q[9])
    arena3_q.append(arena1_q[10])
    arena3_q.append(arena1_q[11])
    arena3_q.append(arena1_q[12])
    del arena1_q[12]
    del arena1_q[11]
    del arena1_q[10]
    del arena1_q[9]
    del arena1_q[8]
    del arena1_q[7]
    del arena1_q[6]
    del arena1_q[5]
    del arena1_q[4]
    del arena1_q[3]
    lbl_8:


rule "Player playing in Arena 1 Leaves - (wait?)":
    @Event playerLeft
    @Condition (eventPlayer == arena1_q[1] or eventPlayer == arena1_q[2]) == true
    @Condition arena1_match == true
    
    arena1_q.remove(eventPlayer)
    heal(arena1_q[1], null, 1000)
    #wait(1)
    arena1_match = false


rule "Player playing in Arena 2 Leaves - (wait?)":
    @Event playerLeft
    @Condition (eventPlayer == arena2_q[1] or eventPlayer == arena2_q[2]) == true
    @Condition arena2_match == true
    
    arena2_q.remove(eventPlayer)
    heal(arena2_q[1], null, 1000)
    startForcingSpectator(arena2_q[1])
    #wait(1)
    arena2_match = false


rule "Player playing in Arena 3 Leaves - (wait?)":
    @Event playerLeft
    @Condition (eventPlayer == arena3_q[1] or eventPlayer == arena1_q[2]) == true
    @Condition arena3_match == true
    
    arena3_q.remove(eventPlayer)
    heal(arena3_q[1], null, 1000)
    startForcingSpectator(arena3_q[1])
    #wait(1)
    arena3_match = false


rule "Player Leaves, Remove from All Queues":
    @Event playerLeft
    
    arena1_q.remove(eventPlayer)
    arena2_q.remove(eventPlayer)
    arena3_q.remove(eventPlayer)


rule "Player leaves: 4 -> 3 players: Sort the Queue":
    @Event playerLeft
    @Condition len(getAllPlayers()) == 3
    
    del arena2_q[0]
    if arena2_q == false:
        goto lbl_0
    arena1_q.append(arena2_q)
    lbl_0:
    arena2_q = 0
    arena2_match = false
    startForcingSpectator(arena1_q[3])


rule "Player leaves: 6 -> 5 players: Sort the Queue":
    @Event playerLeft
    @Condition len(getAllPlayers()) == 5
    
    del arena3_q[0]
    if arena3_q == false:
        goto lbl_0
    arena2_q.append(arena3_q)
    lbl_0:
    arena3_q = 0
    arena3_match = false
    startForcingSpectator(arena2_q[3])
    startForcingSpectator(arena2_q[4])
    startForcingSpectator(arena2_q[5])


/*
rule "Bugfix":
*/

rule "Arena 1 bug fix":
    @Event eachPlayer
    @Condition (eventPlayer == arena1_q[1] or eventPlayer == arena1_q[2]) == true
    #@Condition eventPlayer == arena1_q[2]
    @Condition eventPlayer._is_spectating == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition isGameInProgress() == true
    @Condition first_match == true
    
    wait(1.5, Wait.ABORT_WHEN_FALSE)
    stopForcingSpectator(eventPlayer)


rule "Arena 2 bug fix":
    @Condition arena2_q[1] == true
    @Condition arena2_q[2] == true
    @Condition arena2_match == true
    
    wait(30, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Duel taking over 30s in Arena2 or bugged, killing 1 player to keep the queue rolling")
    kill(arena2_q[2], arena2_q[1])
    wait(3, Wait.ABORT_WHEN_FALSE)
    kill(arena2_q[1], arena2_q[2])


rule "Arena 3 bug fix":
    @Condition arena3_q[1] == true
    @Condition arena3_q[2] == true
    @Condition arena3_match == true
    
    wait(30, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Duel taking over 30s in Arena3 or bugged, killing 1 player to keep the queue rolling")
    kill(arena3_q[2], arena3_q[1])
    wait(3, Wait.ABORT_WHEN_FALSE)
    kill(arena3_q[1], arena3_q[2])


/*
rule "Match and Round Start":
*/

rule "Arena1 First Match Start":
    @Condition isGameInProgress() == true
    @Condition arena1_q[1] == true
    @Condition arena1_q[2] == true
    @Condition arena1_q[1].hasSpawned() == true
    @Condition arena1_q[2].hasSpawned() == true
    @Condition arena1_match == false
    @Condition first_match == false
    
    arena1_match = true
    wait(0.25)
    arena1_q[1].teleport(MAIN_OPPOSITE_SPAWNS[0])
    arena1_q[2].teleport(MAIN_OPPOSITE_SPAWNS[1])
    wait(0.05)
    arena1_q[1].setFacing(localVector(MAIN_FACING, arena1_q[1], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    arena1_q[2].setFacing(localVector(MAIN_FACING, arena1_q[2], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    wait(0.05)
    stopForcingSpectator(arena1_q[1])
    stopForcingSpectator(arena1_q[2])
    wait(0.3)
    heal(arena1_q[1], null, 1000)
    heal(arena1_q[2], null, 1000)
    arena1_q[1].dead_helper = false
    arena1_q[2].dead_helper = false
    first_match = true


rule "Arena1 Match Start":
    @Condition arena1_q[1] == true
    @Condition arena1_q[2] == true
    @Condition arena1_match == false
    @Condition first_match == true
    
    spawnLocationCheck()
    wait(0.1)
    arena1_q[2].teleport(main_default_spawn)
    wait(0.05)
    arena1_q[2].setFacing(localVector(MAIN_FACING, arena1_q[2], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    wait(0.05)
    stopForcingSpectator(arena1_q[1])
    stopForcingSpectator(arena1_q[2])
    wait(0.1)
    heal(arena1_q[1], null, 1000)
    heal(arena1_q[2], null, 1000)
    arena1_q[1].dead_helper = false
    arena1_q[2].dead_helper = false
    arena1_match = true
    if RULE_CONDITION:
        goto RULE_START


rule "Arena2 Match Start":
    @Condition arena2_q[1] == true
    @Condition arena2_q[2] == true
    @Condition arena2_match == false
    
    wait()
    arena2_match = true
    wait(0.5)
    arena2_q[1].teleport(side_arena_spawns_facing[0])
    arena2_q[2].teleport(side_arena_spawns_facing[1])
    wait(0.05)
    arena2_q[1].setFacing(localVector(side_arena_spawns_facing[2], arena2_q[1], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    arena2_q[2].setFacing(localVector(side_arena_spawns_facing[2], arena2_q[2], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    wait(0.05)
    stopForcingSpectator(arena2_q[1])
    stopForcingSpectator(arena2_q[2])
    arena2_q[1].dead_helper = false
    arena2_q[2].dead_helper = false
    wait(0.3)
    heal(arena2_q[1], null, 1000)
    heal(arena2_q[2], null, 1000)
    if RULE_CONDITION:
        goto RULE_START


rule "Arena3 Match Start":
    @Condition arena3_q[1] == true
    @Condition arena3_q[2] == true
    @Condition arena3_match == false
    
    wait()
    arena3_match = true
    wait(0.5)
    arena3_q[1].teleport(side_arena_spawns_facing[3])
    arena3_q[2].teleport(side_arena_spawns_facing[4])
    wait(0.05)
    arena3_q[1].setFacing(localVector(side_arena_spawns_facing[5], arena3_q[1], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    arena3_q[2].setFacing(localVector(side_arena_spawns_facing[5], arena3_q[2], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    wait(0.05)
    stopForcingSpectator(arena3_q[1])
    stopForcingSpectator(arena3_q[2])
    arena3_q[1].dead_helper = false
    arena3_q[2].dead_helper = false
    wait(0.3)
    heal(arena3_q[1], null, 1000)
    heal(arena3_q[2], null, 1000)
    if RULE_CONDITION:
        goto RULE_START


def spawnLocationCheck():
    @Name "SUB: Spawn location check"
    
    if distance(arena1_q[1].getEyePosition(), main_spawn_det_loc[2]) <= 19:
        main_default_spawn = MAIN_OPPOSITE_SPAWNS[1]
        #smallMessage(getAllPlayers(), "Attacker is Right")
    elif distance(arena1_q[1].getEyePosition(), main_spawn_det_loc[3]) <= 19:
        main_default_spawn = MAIN_OPPOSITE_SPAWNS[0]
        #smallMessage(getAllPlayers(), "Attacker is Left")
    elif distance(arena1_q[1].getEyePosition(), main_spawn_det_loc[0]) <= 15:
        main_default_spawn = random.choice(MAIN_TOP_SPAWNS)
        #smallMessage(getAllPlayers(), "Attacker is stairs / top")
    elif distance(arena1_q[1].getEyePosition(), main_spawn_det_loc[1]) <= 10:
        #smallMessage(getAllPlayers(), "Attacker is deck side")
        main_default_spawn = random.choice(MAIN_DECK_SPAWNS)
    else:
        main_default_spawn = random.choice(MAIN_OPPOSITE_SPAWNS)
        #smallMessage(getAllPlayers(), "None / Mid / default spawn")


/*
rule "_is_spectating":
*/

rule "Player Dies, Set Spectating and Change Hero ---------------------------------------------täs on one_hero---------------------":
    @Event playerDied
    @Condition isGameInProgress() == true

    eventPlayer.ult_charge = eventPlayer.getUltCharge()
    eventPlayer.hero_number += 1
    wait(0.25)
    if eventPlayer.one_hero_pvar:
        eventPlayer.startForcingHero(Hero.SYMMETRA)
    eventPlayer.startForcingHero(eventPlayer.hero_list[eventPlayer.hero_number])
    wait(0.15)
    waitUntil(not eventPlayer.call_init, Math.INFINITY)
    startForcingSpectator(eventPlayer)
    eventPlayer.setUltCharge(eventPlayer.ult_charge)


rule "Spectating: You are next message & Sound":
    @Event eachPlayer
    @Condition eventPlayer._is_spectating == true
    @Condition (arena1_q[3] == eventPlayer or arena2_q[3] == eventPlayer or arena3_q[3] == eventPlayer) == true
    
    bigMessage(eventPlayer, "you are next")
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)


/*
rule "Player Dies":
*/

def arena1Dies():
    @Name "SUB: Arena 1 Player dies - arena1_q[1] = Winner ----------täs one_hero meniks que number oikei"
    
    arena1_q[1].setAmmo(0, arena1_q[1].getMaxAmmo(0))
    heal(arena1_q[1], null, 1000)
    arena1_q[1].Score += 3
    arena1_q[1].setScore(arena1_q[1].Score)
    eventPlayer.clearStatusEffect(Status.BURNING)
    arena1_q[1].clearStatusEffect(Status.BURNING)
    arena1_match = false
    #always refresh testing
    if ALWAYS_REFRESH_HERO == true:
        goto lbl_0
    if arena1_q[1].anti_heal_debuffed == true:
        goto lbl_1
    if arena1_q[1].getCurrentHero() != Hero.DOOMFIST:
        goto lbl_2
    wait(0.5)
    damage(arena1_q[1], null, arena1_q[1].getHealth() - 225)
    lbl_1:
    lbl_2:
    if arena1_q[1].one_hero_pvar == true:
        goto lbl_3
    if arena1_q[1].anti_heal_debuffed != true:
        goto lbl_4
    lbl_0:
    lbl_3:
    arena1_q[1].ult_charge = arena1_q[1].getUltCharge()
    arena1_q[1].startForcingHero(Hero.SYMMETRA)
    wait(0.2)
    arena1_q[1].startForcingHero(arena1_q[1].hero_list[arena1_q[1].hero_number])
    wait(0.05)
    arena1_q[1].setUltCharge(arena1_q[1].ult_charge)
    lbl_4:


def arena2Dies():
    @Name "SUB: Arena 2 Player dies - arena2_q[1] = Winner"
    
    heal(arena2_q[1], null, 1000)
    arena2_q[1].ult_charge = arena2_q[1].getUltCharge()
    wait(0.1)
    arena2_q[1].startForcingHero(Hero.SYMMETRA)
    wait(0.2)
    arena2_q[1].startForcingHero(arena2_q[1].hero_list[arena2_q[1].hero_number])
    wait(0.05)
    arena2_q[1].setUltCharge(arena2_q[1].ult_charge)
    if arena2_q[1] == false:
        goto lbl_0
    arena1_q.append(arena2_q[1])
    lbl_0:
    startForcingSpectator(arena2_q[1])
    heal(arena2_q[1], null, 1000)
    if arena2_q[1].Score >= 48:
        goto lbl_1
    arena2_q[1].Score += 2
    lbl_1:
    arena2_q[1].setScore(arena2_q[1].Score)
    arena2_q[1].clearStatusEffect(Status.BURNING)
    if arena2_q[1] == false:
        goto lbl_2
    del arena2_q[1]
    lbl_2:
    eventPlayer.clearStatusEffect(Status.BURNING)
    arena2_match = false


def arena3Dies():
    @Name "SUB: Arena 3 Player dies - arena3_q[1] = Winner (toimiiks tää skip if 5)"
    
    heal(arena3_q[1], null, 300)
    arena3_q[1].ult_charge = arena3_q[1].getUltCharge()
    wait(0.1)
    arena3_q[1].startForcingHero(Hero.SYMMETRA)
    wait(0.2)
    arena3_q[1].startForcingHero(arena3_q[1].hero_list[arena3_q[1].hero_number])
    wait(0.05)
    arena3_q[1].setUltCharge(arena3_q[1].ult_charge)
    if arena3_q[1] == false:
        goto lbl_0
    if len(getAllPlayers()) <= 3:
        arena1_q.append(arena3_q[1])
    else:
        arena2_q.append(arena3_q[1])
    lbl_0:
    startForcingSpectator(arena3_q[1])
    if arena3_q[1].Score == 49:
        goto lbl_1
    arena3_q[1].Score += 1
    lbl_1:
    arena3_q[1].setScore(arena3_q[1].Score)
    heal(arena3_q[1], null, 300)
    arena3_q[1].clearStatusEffect(Status.BURNING)
    if arena3_q[1] == false:
        goto lbl_2
    del arena3_q[1]
    lbl_2:
    eventPlayer.clearStatusEffect(Status.BURNING)
    arena3_match = false


rule "Arena 1: Player Dies, 1-3 Players":
    @Event playerDied
    @Condition len(getAllPlayers()) < 4
    @Condition (eventPlayer == arena1_q[1] or eventPlayer == arena1_q[2]) == true
    @Condition eventPlayer.dead_helper == false
    
    eventPlayer.dead_helper = true
    arena1_q.remove(eventPlayer)
    arena1_q.append(eventPlayer)
    arena1Dies()


rule "Arena 1: Player Dies, 4-X Players":
    @Event playerDied
    @Condition len(getAllPlayers()) >= 4
    @Condition (eventPlayer == arena1_q[1] or eventPlayer == arena1_q[2]) == true
    @Condition eventPlayer.dead_helper == false
    
    eventPlayer.dead_helper = true
    arena1_q.remove(eventPlayer)
    arena2_q.append(eventPlayer)
    arena1Dies()


rule "Arena 2: Player Dies, 1-3 Players (vääräs järkäs menee Q)":
    @Event playerDied
    @Condition len(getAllPlayers()) < 4
    @Condition (eventPlayer == arena2_q[1] or eventPlayer == arena2_q[2]) == true
    @Condition eventPlayer.dead_helper == false
    
    eventPlayer.dead_helper = true
    arena2_q.remove(eventPlayer)
    arena1_q.append(eventPlayer)
    arena2Dies()


rule "Arena 2: Player Dies, 4-5 Players":
    @Event playerDied
    @Condition len(getAllPlayers()) < 6
    @Condition len(getAllPlayers()) > 3
    @Condition (eventPlayer == arena2_q[1] or eventPlayer == arena2_q[2]) == true
    @Condition eventPlayer.dead_helper == false
    
    eventPlayer.dead_helper = true
    arena2_q.remove(eventPlayer)
    arena2_q.append(eventPlayer)
    arena2Dies()


rule "Arena 2: Player Dies, 6-12 Players":
    @Event playerDied
    @Condition len(getAllPlayers()) > 5
    @Condition (eventPlayer == arena2_q[1] or eventPlayer == arena2_q[2]) == true
    @Condition eventPlayer.dead_helper == false
    
    eventPlayer.dead_helper = true
    arena2_q.remove(eventPlayer)
    arena3_q.append(eventPlayer)
    arena2Dies()


rule "Arena 3: Player Dies, 1-3 Players (vääräs järkäs menee Q)":
    @Event playerDied
    @Condition len(getAllPlayers()) < 4
    @Condition (eventPlayer == arena3_q[1] or eventPlayer == arena3_q[2]) == true
    @Condition eventPlayer.dead_helper == false
    
    eventPlayer.dead_helper = true
    arena3_q.remove(eventPlayer)
    arena1_q.append(eventPlayer)
    arena3Dies()


rule "Arena 3: Player Dies, 4-5 Players (vääräs järkäs menee Q)":
    @Event playerDied
    @Condition len(getAllPlayers()) < 6
    @Condition len(getAllPlayers()) > 3
    @Condition (eventPlayer == arena3_q[1] or eventPlayer == arena3_q[2]) == true
    @Condition eventPlayer.dead_helper == false
    
    eventPlayer.dead_helper = true
    arena3_q.remove(eventPlayer)
    arena2_q.append(eventPlayer)
    arena3Dies()


rule "Arena 3: Player Dies, 6-12 Players":
    @Event playerDied
    @Condition len(getAllPlayers()) > 5
    @Condition (eventPlayer == arena3_q[1] or eventPlayer == arena3_q[2]) == true
    @Condition eventPlayer.dead_helper == false
    
    eventPlayer.dead_helper = true
    arena3_q.remove(eventPlayer)
    arena3_q.append(eventPlayer)
    arena3Dies()


rule "Player attributes":


rule "Refreshing Hero if player was under anti heal after winning":
    @Event playerTookDamage
    @Condition (attacker.getCurrentHero() == Hero.ANA and (eventDamage == 60 or eventDamage == 90)) == true
    @Condition eventPlayer._is_spectating == false
    @Condition eventPlayer in arena1_q == true
    
    eventPlayer.anti_heal_debuffed = true
    wait(4)
    eventPlayer.anti_heal_debuffed = false


rule "Queue Hud Arena 1":
    @Event eachPlayer
    @Condition eventPlayer._is_spectating == true
    @Condition eventPlayer in arena1_q == true
    @Condition isGameInProgress() == true
    
    destroyHudText(eventPlayer.Hud)
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena1_q.index(eventPlayer) - 2)), "Score per kill: 3", "Arena: 1", HudPosition.TOP, 2, Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()


rule "Queue Hud Arena 2":
    @Event eachPlayer
    @Condition eventPlayer._is_spectating == true
    @Condition eventPlayer in arena2_q == true
    @Condition isGameInProgress() == true
    
    destroyHudText(eventPlayer.Hud)
    if eventPlayer.Score >= 48:
        goto lbl_0
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena2_q.index(eventPlayer) - 2)), "Score per kill: 2", "Arena: 2", HudPosition.TOP, 2, Color.RED, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    lbl_0:
    if eventPlayer.Score < 48:
        goto lbl_1
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena2_q.index(eventPlayer) - 2)), "To win you need to get a kill in Arena 1", "Arena: 2", HudPosition.TOP, 2, Color.RED, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    lbl_1:
    eventPlayer.Hud = getLastCreatedText()


rule "Queue Hud Arena 3":
    @Event eachPlayer
    @Condition eventPlayer._is_spectating == true
    @Condition eventPlayer in arena3_q == true
    @Condition isGameInProgress() == true
    
    destroyHudText(eventPlayer.Hud)
    if eventPlayer.Score == 49:
        goto lbl_0
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena3_q.index(eventPlayer) - 2)), "Score per kill: 1", "Arena: 3", HudPosition.TOP, 2, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    lbl_0:
    if eventPlayer.Score != 49:
        goto lbl_1
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(arena3_q.index(eventPlayer) - 2)), "To win you need to get a kill in Arena 1", "Arena: 3", HudPosition.TOP, 2, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    lbl_1:
    eventPlayer.Hud = getLastCreatedText()


rule "Destory Queue Hud when not Spectating":
    @Event eachPlayer
    @Condition eventPlayer._is_spectating == false
    @Condition isGameInProgress() == true
    
    destroyHudText(eventPlayer.Hud)


rule "Arena is decided by death of one player":


rule "Safe Zone Check Arena 1 Center":
    @Event eachPlayer
    @Condition distance(eventPlayer, main_high) >= 16.4
    @Condition distance(eventPlayer, main_center) >= 15.1
    @Condition (arena1_q[1] == eventPlayer or arena1_q[2] == eventPlayer) == true
    @Condition (eventPlayer.getAltitude() >= 30 or eventPlayer.getAltitude() <= 6) == true
    @Condition eventPlayer._is_spectating == false
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BURN_DAMAGE)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Safe Zone Check Arena 1 Top":
    @Event eachPlayer
    @Condition distance(eventPlayer, main_top_deck) <= 3.75
    @Condition eventPlayer._is_spectating == false
    @Condition (arena1_q[1] == eventPlayer or arena1_q[2] == eventPlayer) == true
    @Condition (eventPlayer.getAltitude() >= 30 or eventPlayer.getAltitude() <= 6) == true
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BURN_DAMAGE)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Safe Zone Check Arena 2":
    @Event eachPlayer
    @Condition distance(eventPlayer, side_arena_center[1]) >= 17.4
    @Condition (arena2_q[1] == eventPlayer or arena2_q[2] == eventPlayer) == true
    @Condition eventPlayer._is_spectating == false
    @Condition arena2_match == true
    @Condition (eventPlayer.getAltitude() >= 30 or eventPlayer.getAltitude() <= 6) == true
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BURN_DAMAGE)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Safe Zone Check Arena 3":
    @Event eachPlayer
    @Condition distance(eventPlayer, side_arena_center[3]) >= 17.4
    @Condition eventPlayer._is_spectating == false
    @Condition (arena3_q[1] == eventPlayer or arena3_q[2] == eventPlayer) == true
    @Condition arena3_match == true
    @Condition (eventPlayer.getAltitude() >= 30 or eventPlayer.getAltitude() <= 6) == true
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BURN_DAMAGE)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START
