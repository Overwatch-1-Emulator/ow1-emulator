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
#!defineMember MainCenter arena_gvar[0]
#!defineMember MainHigh arena_gvar[1]
#!defineMember MainTopDeck arena_gvar[2]
#!defineMember SideArenaCenter arena_gvar[3]
#!defineMember SideArenaSpawnsFacing arena_gvar[4]
#!defineMember MainFacing arena_gvar[5]
#!defineMember HeroList1 arena_gvar[6]
#!defineMember FirstMatch arena_gvar[7]
globalvar MainSpawnDetLoc #arena_gvar[8]
#!defineMember MainTopSpawn arena_gvar[9]
#!defineMember BurnDamage arena_gvar[10]
#!defineMember MainOppositeSpawn arena_gvar[11]
#!defineMember IntroHud arena_gvar[12]
#!defineMember MainDeckSpawn arena_gvar[14]
#!defineMember MainDefaultSpawn arena_gvar[16]
#!defineMember SpecSpot2 arena_gvar[20]
#!defineMember SpecSpot arena_gvar[21]
globalvar Arena1Q #arena_gvar[22]
globalvar Arena2Q #arena_gvar[23]
globalvar Arena3Q #arena_gvar[24]
#!defineMember Arena1Match arena_gvar[26]
#!defineMember Arena2Match arena_gvar[27]
#!defineMember Arena3Match arena_gvar[28]
#!defineMember PathLoc arena_gvar[47]
#!defineMember OneHero arena_gvar[58]
#!defineMember PathHelper arena_gvar[62]
#!defineMember PathDirection arena_gvar[63]
#!defineMember PathOld arena_gvar[64]
#!defineMember HostHasDifferentheroes arena_gvar[65]
#!defineMember PathLocStairs arena_gvar[66]
#!defineMember PathLocDeck arena_gvar[67]
#!defineMember BotSeePlayer arena_gvar[68]
#!defineMember PredictionSpot arena_gvar[69]
#!defineMember OneHero2 arena_gvar[101]
#!defineMember HeroList2 arena_gvar[102]
#!defineMember AlwaysRefreshHero arena_gvar[103]

playervar arena_pvar
#!defineMember OneHeroPlayerVariable arena_pvar[0]
#!defineMember Randomizer arena_pvar[2]
#!defineMember _spectating arena_pvar[3]
#!defineMember DeadHelper arena_pvar[4]
#!defineMember Hud arena_pvar[7]
#!defineMember JoinSpecHelper arena_pvar[9]
#!defineMember HeroList arena_pvar[11]
#!defineMember HeroNumber arena_pvar[13]
#!defineMember Score arena_pvar[18]
#!defineMember UltCharge arena_pvar[20]
#!defineMember AntiHealDebuffed arena_pvar[26]

subroutine SpawnLocationCheck 0
subroutine Arena1Dies 1
subroutine Arena2Dies 2
subroutine Arena3Dies 3


rule "Workshop Settings --------------------------------------------------------------------------------------":
    disableInspector()

    BurnDamage = createWorkshopSetting(int[25:200], "Burn Damage", "Damage per tick", 25, 0)
    AlwaysRefreshHero = createWorkshopSetting(bool, "Always refresh hero (cooldowns, shield, etc) after winning on arena 1", "Refresh hero after winning on arena 1", false, 0)
    HostHasDifferentheroes = createWorkshopSetting(bool, "B Special settings for mode where players have different list of heroes", "Host player has different list of heroes", false, 0)


rule "Creating HeroList1, Check OneHero":
    HeroList1.append(_available_heroes)
    del HeroList1[0]
    #if len(HeroList1) == 1:
    #OneHero = true
    #HeroList1.append(HeroList1[0])
    #__end__()


rule "Creating Herolist2, Check OneHero2, for host player ----------------------------------------------------------------------------":
    @Condition HostHasDifferentheroes == true

    HeroList2.append(_available_heroes)
    del HeroList2[0]
    #if len(HeroList2) == 1:
    #OneHero2 = true
    #HeroList2.append(HeroList2[0])
    #__end__()


rule "Disable Scoring":
    disableScoring()
    hudText(getAllPlayers(), "Code: {}".format(GAMEMODE_CODE), "dsc.gg/ow1", "Full details: workshop.codes/ow1-emulator", HudPosition.TOP, 22, Color.ORANGE, Color.BLUE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    IntroHud = getLastCreatedText()


rule "Pause Timer":
    @Condition isGameInProgress() == true
    
    pauseMatchTime()
    setMatchTime(1220)
    wait(1)
    destroyHudText(IntroHud)


rule "Restart Hero List":
    @Event eachPlayer
    @Condition eventPlayer.HeroNumber == len(eventPlayer.HeroList)
    
    eventPlayer.HeroNumber = 0


rule "Arena Locations":
    MainCenter = vect(0, 267, 280)
    MainHigh = vect(0, 280, 280)
    MainTopDeck = vect(0, 279.5, 295.5)
    MainFacing = vect(0, 268.5, 280)
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.RED, MainCenter, 16.7, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, MainTopDeck, 2.61, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    SpecSpot = vect(13.366, 285, 279.711)
    SpecSpot2 = vect(-13.672, 285, 279.735)


rule "Arena Spawn Locations":
    MainDefaultSpawn = vect(-0.087, 268, 267.986)
    #MainOppositeSpawn = vect(11.146, 268, 275.313)
    MainOppositeSpawn = vect(11, 268, 276.2)
    MainOppositeSpawn.append(vect(-11, 268, 276.2))
    MainTopSpawn = vect(7.923, 268, 273.866)
    MainTopSpawn.append(vect(0.004, 268, 276.965))
    MainTopSpawn.append(vect(-7.771, 268, 273.383))
    #MainDeckSpawn = vect(9.421, 268, 280.176)
    MainDeckSpawn = vect(9.486, 268, 280.02)
    MainDeckSpawn.append(vect(-0.005, 268, 283.035))
    MainDeckSpawn.append(vect(-9.486, 268, 280.02))


rule "Arena Spawn Location Detection Spots":
    MainSpawnDetLoc[0] = vect(0.198, 271.351, 302.477)
    MainSpawnDetLoc[1] = vect(0.147, 271.348, 266.101)
    MainSpawnDetLoc[2] = vect(20.349, 268.349, 281.046)
    MainSpawnDetLoc[3] = vect(-20.35, 268.349, 281.009)


rule "Arena 2: Zone.0, SafeCheck.1, Spawn.0&1, Facing.2":
    SideArenaCenter = vect(-41.832, 260, 344.857)
    SideArenaCenter.append(vect(-41.832, 270, 344.857))
    SideArenaSpawnsFacing = vect(-50.464, 268.667, 351.671)
    SideArenaSpawnsFacing.append(vect(-31.82, 268.549, 332.737))
    SideArenaSpawnsFacing.append(vect(-38.715, 271.502, 343.17))
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.RED, SideArenaCenter[0], 18, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Arena 3: Zone.2, SafeCheck.3, Spawn.3&4, Facing.5":
    SideArenaCenter.append(vect(41.832, 260, 344.857))
    SideArenaCenter.append(vect(41.832, 270, 344.857))
    SideArenaSpawnsFacing.append(vect(50.464, 268.667, 351.671))
    SideArenaSpawnsFacing.append(vect(31.82, 268.549, 332.737))
    SideArenaSpawnsFacing.append(vect(38.715, 271.502, 343.17))
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.BLUE, SideArenaCenter[2], 18, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Player Joins host player different heroes --------------------------------------------------------------------------------------":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer == hostPlayer
    @Condition HostHasDifferentheroes == true
    
    eventPlayer.HeroList = random.shuffle(HeroList2)
    eventPlayer.startForcingHero(eventPlayer.HeroList[eventPlayer.HeroNumber])
    if len(eventPlayer.HeroList) == 1:
        eventPlayer.OneHeroPlayerVariable = true
        eventPlayer.HeroList.append(eventPlayer.HeroList[0])
    if isGameInProgress():
        goto lbl_0
    Arena1Q.append(eventPlayer)
    goto lbl_1
    lbl_0:
    if getNumberOfPlayers(Team.ALL) > 3:
        goto lbl_2
    Arena1Q.append(eventPlayer)
    goto lbl_3
    lbl_2:
    if getNumberOfPlayers(Team.ALL) != 4:
        goto lbl_4
    Arena2Q.append(eventPlayer)
    goto lbl_5
    lbl_4:
    if getNumberOfPlayers(Team.ALL) != 5:
        goto lbl_6
    Arena2Q.append(eventPlayer)
    goto lbl_7
    lbl_6:
    if getNumberOfPlayers(Team.ALL) < 6:
        goto lbl_8
    Arena3Q.append(eventPlayer)
    lbl_1:
    lbl_3:
    lbl_5:
    lbl_7:
    lbl_8:
    eventPlayer._spectating = true
    if not eventPlayer in Arena1Q:
        goto lbl_9
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena1Q.index(eventPlayer) - 2)), "Score per kill: 3", "Arena: 1", HudPosition.TOP, 2, Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_9:
    if not eventPlayer in Arena2Q:
        goto lbl_10
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena2Q.index(eventPlayer) - 2)), "Score per kill: 2", "Arena: 2", HudPosition.TOP, 2, Color.RED, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_10:
    if not eventPlayer in Arena3Q:
        goto lbl_11
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena3Q.index(eventPlayer) - 2)), "Score per kill: 1", "Arena: 3", HudPosition.TOP, 2, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_11:
    wait(0.3)
    if eventPlayer._spectating == false:
        goto lbl_12
    eventPlayer.JoinSpecHelper = true
    lbl_12:


rule "Player Joins not host player different heroes ----------------------------------------":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    @Condition eventPlayer != hostPlayer
    @Condition HostHasDifferentheroes == true
    
    eventPlayer.HeroList = random.shuffle(HeroList1)
    eventPlayer.startForcingHero(eventPlayer.HeroList[eventPlayer.HeroNumber])
    if len(eventPlayer.HeroList) == 1:
        eventPlayer.OneHeroPlayerVariable = true
        eventPlayer.HeroList.append(eventPlayer.HeroList[0])
    if isGameInProgress():
        goto lbl_0
    Arena1Q.append(eventPlayer)
    goto lbl_1
    lbl_0:
    if getNumberOfPlayers(Team.ALL) > 3:
        goto lbl_2
    Arena1Q.append(eventPlayer)
    goto lbl_3
    lbl_2:
    if getNumberOfPlayers(Team.ALL) != 4:
        goto lbl_4
    Arena2Q.append(eventPlayer)
    goto lbl_5
    lbl_4:
    if getNumberOfPlayers(Team.ALL) != 5:
        goto lbl_6
    Arena2Q.append(eventPlayer)
    goto lbl_7
    lbl_6:
    if getNumberOfPlayers(Team.ALL) < 6:
        goto lbl_8
    Arena3Q.append(eventPlayer)
    lbl_1:
    lbl_3:
    lbl_5:
    lbl_7:
    lbl_8:
    eventPlayer._spectating = true
    if not eventPlayer in Arena1Q:
        goto lbl_9
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena1Q.index(eventPlayer) - 2)), "Score per kill: 3", "Arena: 1", HudPosition.TOP, 2, Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_9:
    if not eventPlayer in Arena2Q:
        goto lbl_10
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena2Q.index(eventPlayer) - 2)), "Score per kill: 2", "Arena: 2", HudPosition.TOP, 2, Color.RED, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_10:
    if not eventPlayer in Arena3Q:
        goto lbl_11
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena3Q.index(eventPlayer) - 2)), "Score per kill: 1", "Arena: 3", HudPosition.TOP, 2, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_11:
    wait(0.3)
    if eventPlayer._spectating == false:
        goto lbl_12
    eventPlayer.JoinSpecHelper = true
    lbl_12:


rule "Player Joins":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    @Condition HostHasDifferentheroes == false
    
    eventPlayer.HeroList = random.shuffle(HeroList1)
    eventPlayer.startForcingHero(eventPlayer.HeroList[eventPlayer.HeroNumber])
    if len(eventPlayer.HeroList) == 1:
        eventPlayer.OneHeroPlayerVariable = true
        eventPlayer.HeroList.append(eventPlayer.HeroList[0])
    if isGameInProgress():
        goto lbl_0
    Arena1Q.append(eventPlayer)
    goto lbl_1
    lbl_0:
    if getNumberOfPlayers(Team.ALL) > 3:
        goto lbl_2
    Arena1Q.append(eventPlayer)
    goto lbl_3
    lbl_2:
    if getNumberOfPlayers(Team.ALL) != 4:
        goto lbl_4
    Arena2Q.append(eventPlayer)
    goto lbl_5
    lbl_4:
    if getNumberOfPlayers(Team.ALL) != 5:
        goto lbl_6
    Arena2Q.append(eventPlayer)
    goto lbl_7
    lbl_6:
    if getNumberOfPlayers(Team.ALL) < 6:
        goto lbl_8
    Arena3Q.append(eventPlayer)
    lbl_1:
    lbl_3:
    lbl_5:
    lbl_7:
    lbl_8:
    eventPlayer._spectating = true
    if not eventPlayer in Arena1Q:
        goto lbl_9
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena1Q.index(eventPlayer) - 2)), "Score per kill: 3", "Arena: 1", HudPosition.TOP, 2, Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_9:
    if not eventPlayer in Arena2Q:
        goto lbl_10
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena2Q.index(eventPlayer) - 2)), "Score per kill: 2", "Arena: 2", HudPosition.TOP, 2, Color.RED, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_10:
    if not eventPlayer in Arena3Q:
        goto lbl_11
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena3Q.index(eventPlayer) - 2)), "Score per kill: 1", "Arena: 3", HudPosition.TOP, 2, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()
    lbl_11:
    wait(0.3)
    if eventPlayer._spectating == false:
        goto lbl_12
    eventPlayer.JoinSpecHelper = true
    lbl_12:


rule "Joins, First Spec helper":
    @Event eachPlayer
    @Condition eventPlayer.JoinSpecHelper == true
    
    eventPlayer.teleport(SpecSpot)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    eventPlayer.setGravity(abs(0))
    eventPlayer.setMoveSpeed(abs(0))
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 9999)
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)
    eventPlayer.setDamageDealt(0)
    wait(0.5)
    if eventPlayer._spectating == false:
        goto lbl_0
    eventPlayer.setFacing(localVector(MainFacing, eventPlayer, Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    lbl_0:


rule "Spread everyone once the game is in Progress":
    @Condition isGameInProgress() == true
    
    if getNumberOfPlayers(Team.ALL) != 4:
        goto lbl_0
    Arena2Q.append(Arena1Q[3])
    Arena2Q.append(Arena1Q[4])
    del Arena1Q[4]
    del Arena1Q[3]
    return
    lbl_0:
    if getNumberOfPlayers(Team.ALL) != 5:
        goto lbl_1
    Arena2Q.append(Arena1Q[3])
    Arena2Q.append(Arena1Q[4])
    Arena2Q.append(Arena1Q[5])
    del Arena1Q[5]
    del Arena1Q[4]
    del Arena1Q[3]
    return
    lbl_1:
    if getNumberOfPlayers(Team.ALL) != 6:
        goto lbl_2
    Arena2Q.append(Arena1Q[3])
    Arena2Q.append(Arena1Q[4])
    Arena3Q.append(Arena1Q[5])
    Arena3Q.append(Arena1Q[6])
    del Arena1Q[6]
    del Arena1Q[5]
    del Arena1Q[4]
    del Arena1Q[3]
    return
    lbl_2:
    if getNumberOfPlayers(Team.ALL) != 7:
        goto lbl_3
    Arena2Q.append(Arena1Q[3])
    Arena2Q.append(Arena1Q[4])
    Arena3Q.append(Arena1Q[5])
    Arena3Q.append(Arena1Q[6])
    Arena3Q.append(Arena1Q[7])
    del Arena1Q[7]
    del Arena1Q[6]
    del Arena1Q[5]
    del Arena1Q[4]
    del Arena1Q[3]
    return
    lbl_3:
    if getNumberOfPlayers(Team.ALL) != 8:
        goto lbl_4
    Arena2Q.append(Arena1Q[3])
    Arena2Q.append(Arena1Q[4])
    Arena3Q.append(Arena1Q[5])
    Arena3Q.append(Arena1Q[6])
    Arena3Q.append(Arena1Q[7])
    Arena3Q.append(Arena1Q[8])
    del Arena1Q[8]
    del Arena1Q[7]
    del Arena1Q[6]
    del Arena1Q[5]
    del Arena1Q[4]
    del Arena1Q[3]
    return
    lbl_4:
    if getNumberOfPlayers(Team.ALL) != 9:
        goto lbl_5
    Arena2Q.append(Arena1Q[3])
    Arena2Q.append(Arena1Q[4])
    Arena3Q.append(Arena1Q[5])
    Arena3Q.append(Arena1Q[6])
    Arena3Q.append(Arena1Q[7])
    Arena3Q.append(Arena1Q[8])
    Arena3Q.append(Arena1Q[9])
    del Arena1Q[9]
    del Arena1Q[8]
    del Arena1Q[7]
    del Arena1Q[6]
    del Arena1Q[5]
    del Arena1Q[4]
    del Arena1Q[3]
    return
    lbl_5:
    if getNumberOfPlayers(Team.ALL) != 10:
        goto lbl_6
    Arena2Q.append(Arena1Q[3])
    Arena2Q.append(Arena1Q[4])
    Arena3Q.append(Arena1Q[5])
    Arena3Q.append(Arena1Q[6])
    Arena3Q.append(Arena1Q[7])
    Arena3Q.append(Arena1Q[8])
    Arena3Q.append(Arena1Q[9])
    Arena3Q.append(Arena1Q[10])
    del Arena1Q[10]
    del Arena1Q[9]
    del Arena1Q[8]
    del Arena1Q[7]
    del Arena1Q[6]
    del Arena1Q[5]
    del Arena1Q[4]
    del Arena1Q[3]
    return
    lbl_6:
    if getNumberOfPlayers(Team.ALL) != 11:
        goto lbl_7
    Arena2Q.append(Arena1Q[3])
    Arena2Q.append(Arena1Q[4])
    Arena3Q.append(Arena1Q[5])
    Arena3Q.append(Arena1Q[6])
    Arena3Q.append(Arena1Q[7])
    Arena3Q.append(Arena1Q[8])
    Arena3Q.append(Arena1Q[9])
    Arena3Q.append(Arena1Q[10])
    Arena3Q.append(Arena1Q[11])
    del Arena1Q[11]
    del Arena1Q[10]
    del Arena1Q[9]
    del Arena1Q[8]
    del Arena1Q[7]
    del Arena1Q[6]
    del Arena1Q[5]
    del Arena1Q[4]
    del Arena1Q[3]
    return
    lbl_7:
    if getNumberOfPlayers(Team.ALL) != 12:
        goto lbl_8
    Arena2Q.append(Arena1Q[3])
    Arena2Q.append(Arena1Q[4])
    Arena3Q.append(Arena1Q[5])
    Arena3Q.append(Arena1Q[6])
    Arena3Q.append(Arena1Q[7])
    Arena3Q.append(Arena1Q[8])
    Arena3Q.append(Arena1Q[9])
    Arena3Q.append(Arena1Q[10])
    Arena3Q.append(Arena1Q[11])
    Arena3Q.append(Arena1Q[12])
    del Arena1Q[12]
    del Arena1Q[11]
    del Arena1Q[10]
    del Arena1Q[9]
    del Arena1Q[8]
    del Arena1Q[7]
    del Arena1Q[6]
    del Arena1Q[5]
    del Arena1Q[4]
    del Arena1Q[3]
    lbl_8:


rule "Player playing in Arena 1 Leaves - (wait?)":
    @Event playerLeft
    @Condition (eventPlayer == Arena1Q[1] or eventPlayer == Arena1Q[2]) == true
    @Condition Arena1Match == true
    
    Arena1Q.remove(eventPlayer)
    heal(Arena1Q[1], null, 1000)
    #wait(1)
    Arena1Match = false


rule "Player playing in Arena 2 Leaves - (wait?)":
    @Event playerLeft
    @Condition (eventPlayer == Arena2Q[1] or eventPlayer == Arena2Q[2]) == true
    @Condition Arena2Match == true
    
    Arena2Q.remove(eventPlayer)
    heal(Arena2Q[1], null, 1000)
    Arena2Q[1]._spectating = true
    #wait(1)
    Arena2Match = false


rule "Player playing in Arena 3 Leaves - (wait?)":
    @Event playerLeft
    @Condition (eventPlayer == Arena3Q[1] or eventPlayer == Arena1Q[2]) == true
    @Condition Arena3Match == true
    
    Arena3Q.remove(eventPlayer)
    heal(Arena3Q[1], null, 1000)
    Arena3Q[1]._spectating = true
    #wait(1)
    Arena3Match = false


rule "Player Leaves, Remove from All Queues":
    @Event playerLeft
    
    Arena1Q.remove(eventPlayer)
    Arena2Q.remove(eventPlayer)
    Arena3Q.remove(eventPlayer)


rule "Player leaves: 4 -> 3 players: Sort the Queue":
    @Event playerLeft
    @Condition len(getAllPlayers()) == 3
    
    del Arena2Q[0]
    if Arena2Q == false:
        goto lbl_0
    Arena1Q.append(Arena2Q)
    lbl_0:
    Arena2Q = 0
    Arena2Match = false
    Arena1Q[3]._spectating = true


rule "Player leaves: 6 -> 5 players: Sort the Queue":
    @Event playerLeft
    @Condition len(getAllPlayers()) == 5
    
    del Arena3Q[0]
    if Arena3Q == false:
        goto lbl_0
    Arena2Q.append(Arena3Q)
    lbl_0:
    Arena3Q = 0
    Arena3Match = false
    Arena2Q[3]._spectating = true
    Arena2Q[4]._spectating = true
    Arena2Q[5]._spectating = true


/*
rule "Bugfix":
*/

rule "Arena 1 bug fix":
    @Event eachPlayer
    @Condition (eventPlayer == Arena1Q[1] or eventPlayer == Arena1Q[2]) == true
    #@Condition eventPlayer == Arena1Q[2]
    @Condition eventPlayer._spectating == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition isGameInProgress() == true
    @Condition FirstMatch == true
    
    wait(1.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer._spectating = false


rule "Arena 2 bug fix":
    @Condition Arena2Q[1] == true
    @Condition Arena2Q[2] == true
    @Condition Arena2Match == true
    
    wait(30, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Duel taking over 30s in Arena2 or bugged, killing 1 player to keep the queue rolling")
    kill(Arena2Q[2], Arena2Q[1])
    wait(3, Wait.ABORT_WHEN_FALSE)
    kill(Arena2Q[1], Arena2Q[2])


rule "Arena 3 bug fix":
    @Condition Arena3Q[1] == true
    @Condition Arena3Q[2] == true
    @Condition Arena3Match == true
    
    wait(30, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Duel taking over 30s in Arena3 or bugged, killing 1 player to keep the queue rolling")
    kill(Arena3Q[2], Arena3Q[1])
    wait(3, Wait.ABORT_WHEN_FALSE)
    kill(Arena3Q[1], Arena3Q[2])


/*
rule "Match and Round Start":
*/

rule "Arena1 First Match Start":
    @Condition isGameInProgress() == true
    @Condition Arena1Q[1] == true
    @Condition Arena1Q[2] == true
    @Condition Arena1Q[1].hasSpawned() == true
    @Condition Arena1Q[2].hasSpawned() == true
    @Condition Arena1Match == false
    @Condition FirstMatch == false
    
    Arena1Match = true
    wait(0.25)
    Arena1Q[1].teleport(MainOppositeSpawn[0])
    Arena1Q[2].teleport(MainOppositeSpawn[1])
    wait(0.05)
    Arena1Q[1].setFacing(localVector(MainFacing, Arena1Q[1], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    Arena1Q[2].setFacing(localVector(MainFacing, Arena1Q[2], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    wait(0.05)
    Arena1Q[1]._spectating = 0
    Arena1Q[2]._spectating = 0
    wait(0.3)
    heal(Arena1Q[1], null, 1000)
    heal(Arena1Q[2], null, 1000)
    Arena1Q[1].DeadHelper = false
    Arena1Q[2].DeadHelper = false
    FirstMatch = true


rule "Arena1 Match Start":
    @Condition Arena1Q[1] == true
    @Condition Arena1Q[2] == true
    @Condition Arena1Match == false
    @Condition FirstMatch == true
    
    SpawnLocationCheck()
    wait(0.1)
    Arena1Q[2].teleport(MainDefaultSpawn)
    wait(0.05)
    Arena1Q[2].setFacing(localVector(MainFacing, Arena1Q[2], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    wait(0.05)
    Arena1Q[1]._spectating = false
    Arena1Q[2]._spectating = false
    wait(0.1)
    heal(Arena1Q[1], null, 1000)
    heal(Arena1Q[2], null, 1000)
    Arena1Q[1].DeadHelper = false
    Arena1Q[2].DeadHelper = false
    Arena1Match = true
    if RULE_CONDITION:
        goto RULE_START


rule "Arena2 Match Start":
    @Condition Arena2Q[1] == true
    @Condition Arena2Q[2] == true
    @Condition Arena2Match == false
    
    wait()
    Arena2Match = true
    wait(0.5)
    Arena2Q[1].teleport(SideArenaSpawnsFacing[0])
    Arena2Q[2].teleport(SideArenaSpawnsFacing[1])
    wait(0.05)
    Arena2Q[1].setFacing(localVector(SideArenaSpawnsFacing[2], Arena2Q[1], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    Arena2Q[2].setFacing(localVector(SideArenaSpawnsFacing[2], Arena2Q[2], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    wait(0.05)
    Arena2Q[1]._spectating = false
    Arena2Q[2]._spectating = false
    Arena2Q[1].DeadHelper = false
    Arena2Q[2].DeadHelper = false
    wait(0.3)
    heal(Arena2Q[1], null, 1000)
    heal(Arena2Q[2], null, 1000)
    if RULE_CONDITION:
        goto RULE_START


rule "Arena3 Match Start":
    @Condition Arena3Q[1] == true
    @Condition Arena3Q[2] == true
    @Condition Arena3Match == false
    
    wait()
    Arena3Match = true
    wait(0.5)
    Arena3Q[1].teleport(SideArenaSpawnsFacing[3])
    Arena3Q[2].teleport(SideArenaSpawnsFacing[4])
    wait(0.05)
    Arena3Q[1].setFacing(localVector(SideArenaSpawnsFacing[5], Arena3Q[1], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    Arena3Q[2].setFacing(localVector(SideArenaSpawnsFacing[5], Arena3Q[2], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    wait(0.05)
    Arena3Q[1]._spectating = false
    Arena3Q[2]._spectating = false
    Arena3Q[1].DeadHelper = false
    Arena3Q[2].DeadHelper = false
    wait(0.3)
    heal(Arena3Q[1], null, 1000)
    heal(Arena3Q[2], null, 1000)
    if RULE_CONDITION:
        goto RULE_START


def SpawnLocationCheck():
    @Name "SUB: Spawn location check"
    
    if distance(Arena1Q[1].getEyePosition(), MainSpawnDetLoc[2]) <= 19:
        MainDefaultSpawn = MainOppositeSpawn[1]
        #smallMessage(getAllPlayers(), "Attacker is Right")
    elif distance(Arena1Q[1].getEyePosition(), MainSpawnDetLoc[3]) <= 19:
        MainDefaultSpawn = MainOppositeSpawn[0]
        #smallMessage(getAllPlayers(), "Attacker is Left")
    elif distance(Arena1Q[1].getEyePosition(), MainSpawnDetLoc[0]) <= 15:
        MainDefaultSpawn = random.choice(MainTopSpawn)
        #smallMessage(getAllPlayers(), "Attacker is stairs / top")
    elif distance(Arena1Q[1].getEyePosition(), MainSpawnDetLoc[1]) <= 10:
        #smallMessage(getAllPlayers(), "Attacker is deck side")
        MainDefaultSpawn = random.choice(MainDeckSpawn)
    else:
        MainDefaultSpawn = random.choice(MainOppositeSpawn)
        #smallMessage(getAllPlayers(), "None / Mid / default spawn")


/*
rule "_spectating":
*/

rule "Player Dies, Set Spectating and Change Hero ---------------------------------------------täs on onehero---------------------":
    @Event playerDied
    @Condition isGameInProgress() == true

    eventPlayer._spectating = true
    eventPlayer.UltCharge = eventPlayer.getUltCharge()
    eventPlayer.HeroNumber += 1
    wait(0.25)
    if eventPlayer.OneHeroPlayerVariable == false:
        goto lbl_0
    eventPlayer.startForcingHero(Hero.SYMMETRA)
    lbl_0:
    eventPlayer.startForcingHero(eventPlayer.HeroList[eventPlayer.HeroNumber])
    if eventPlayer._spectating:
        waitUntil(not eventPlayer.call_init, Math.INFINITY)
        eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
        eventPlayer.setGravity(abs(0))
        eventPlayer.setMoveSpeed(abs(0))
        eventPlayer.disallowButton(Button.PRIMARY_FIRE)
        eventPlayer.disallowButton(Button.SECONDARY_FIRE)
        eventPlayer.disallowButton(Button.ABILITY_1)
        eventPlayer.disallowButton(Button.ABILITY_2)
        eventPlayer.disallowButton(Button.ULTIMATE)
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
        eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
        eventPlayer.stopForcingButton(Button.ABILITY_1)
        eventPlayer.stopForcingButton(Button.ABILITY_2)
        eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 9999)
        eventPlayer.setInvisibility(Invis.ALL)
        eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
        eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)
        eventPlayer.setDamageDealt(0)
    wait(0.15)
    eventPlayer.setUltCharge(eventPlayer.UltCharge)


rule "Spectating":
    @Event eachPlayer
    @Condition eventPlayer._spectating == true
    
    eventPlayer.teleport(SpecSpot)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    eventPlayer.setGravity(abs(0))
    eventPlayer.setMoveSpeed(abs(0))
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 9999)
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)
    eventPlayer.setDamageDealt(0)
    wait(0.5)
    if eventPlayer._spectating == false:
        goto lbl_0
    eventPlayer.setFacing(localVector(MainFacing, eventPlayer, Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    lbl_0:


rule "Spectating: You are next message & Sound":
    @Event eachPlayer
    @Condition eventPlayer._spectating == true
    @Condition (Arena1Q[3] == eventPlayer or Arena2Q[3] == eventPlayer or Arena3Q[3] == eventPlayer) == true
    
    bigMessage(eventPlayer, "you are next")
    playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)


rule "Not Spectating: Allow buttons":
    @Event eachPlayer
    @Condition eventPlayer._spectating == false
    
    eventPlayer.setGravity(100)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 0)
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 0)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 0)
    eventPlayer.setDamageDealt(100)
    eventPlayer.stopForcingThrottle()
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    # if eventPlayer.getCurrentHero() == Hero.TRACER:
    #     eventPlayer.setAbilityCooldown(Button.ABILITY_2, 3.5)
    eventPlayer.call_init = true


/*
rule "Player Dies":
*/

def Arena1Dies():
    @Name "SUB: Arena 1 Player dies - Arena1Q[1] = Winner ----------täs onehero meniks que number oikei"
    
    Arena1Q[1].setAmmo(0, Arena1Q[1].getMaxAmmo(0))
    heal(Arena1Q[1], null, 1000)
    Arena1Q[1].Score += 3
    Arena1Q[1].setScore(Arena1Q[1].Score)
    eventPlayer.clearStatusEffect(Status.BURNING)
    Arena1Q[1].clearStatusEffect(Status.BURNING)
    Arena1Match = false
    #always refresh testing
    if AlwaysRefreshHero == true:
        goto lbl_0
    if Arena1Q[1].AntiHealDebuffed == true:
        goto lbl_1
    if Arena1Q[1].getCurrentHero() != Hero.DOOMFIST:
        goto lbl_2
    wait(0.5)
    damage(Arena1Q[1], null, Arena1Q[1].getHealth() - 225)
    lbl_1:
    lbl_2:
    if Arena1Q[1].OneHeroPlayerVariable == true:
        goto lbl_3
    if Arena1Q[1].AntiHealDebuffed != true:
        goto lbl_4
    lbl_0:
    lbl_3:
    Arena1Q[1].UltCharge = Arena1Q[1].getUltCharge()
    Arena1Q[1].startForcingHero(Hero.SYMMETRA)
    wait(0.2)
    Arena1Q[1].startForcingHero(Arena1Q[1].HeroList[Arena1Q[1].HeroNumber])
    wait(0.05)
    Arena1Q[1].setUltCharge(Arena1Q[1].UltCharge)
    lbl_4:


def Arena2Dies():
    @Name "SUB: Arena 2 Player dies - Arena2Q[1] = Winner"
    
    heal(Arena2Q[1], null, 1000)
    Arena2Q[1].UltCharge = Arena2Q[1].getUltCharge()
    wait(0.1)
    Arena2Q[1].startForcingHero(Hero.SYMMETRA)
    wait(0.2)
    Arena2Q[1].startForcingHero(Arena2Q[1].HeroList[Arena2Q[1].HeroNumber])
    wait(0.05)
    Arena2Q[1].setUltCharge(Arena2Q[1].UltCharge)
    if Arena2Q[1] == false:
        goto lbl_0
    Arena1Q.append(Arena2Q[1])
    lbl_0:
    Arena2Q[1]._spectating = true
    heal(Arena2Q[1], null, 1000)
    if Arena2Q[1].Score >= 48:
        goto lbl_1
    Arena2Q[1].Score += 2
    lbl_1:
    Arena2Q[1].setScore(Arena2Q[1].Score)
    Arena2Q[1].clearStatusEffect(Status.BURNING)
    if Arena2Q[1] == false:
        goto lbl_2
    del Arena2Q[1]
    lbl_2:
    eventPlayer.clearStatusEffect(Status.BURNING)
    Arena2Match = false


def Arena3Dies():
    @Name "SUB: Arena 3 Player dies - Arena3Q[1] = Winner (toimiiks tää skip if 5)"
    
    heal(Arena3Q[1], null, 300)
    Arena3Q[1].UltCharge = Arena3Q[1].getUltCharge()
    wait(0.1)
    Arena3Q[1].startForcingHero(Hero.SYMMETRA)
    wait(0.2)
    Arena3Q[1].startForcingHero(Arena3Q[1].HeroList[Arena3Q[1].HeroNumber])
    wait(0.05)
    Arena3Q[1].setUltCharge(Arena3Q[1].UltCharge)
    if Arena3Q[1] == false:
        goto lbl_0
    if len(getAllPlayers()) <= 3:
        Arena1Q.append(Arena3Q[1])
    else:
        Arena2Q.append(Arena3Q[1])
    lbl_0:
    Arena3Q[1]._spectating = true
    if Arena3Q[1].Score == 49:
        goto lbl_1
    Arena3Q[1].Score += 1
    lbl_1:
    Arena3Q[1].setScore(Arena3Q[1].Score)
    heal(Arena3Q[1], null, 300)
    Arena3Q[1].clearStatusEffect(Status.BURNING)
    if Arena3Q[1] == false:
        goto lbl_2
    del Arena3Q[1]
    lbl_2:
    eventPlayer.clearStatusEffect(Status.BURNING)
    Arena3Match = false


rule "Arena 1: Player Dies, 1-3 Players":
    @Event playerDied
    @Condition len(getAllPlayers()) < 4
    @Condition (eventPlayer == Arena1Q[1] or eventPlayer == Arena1Q[2]) == true
    @Condition eventPlayer.DeadHelper == false
    
    eventPlayer.DeadHelper = true
    Arena1Q.remove(eventPlayer)
    Arena1Q.append(eventPlayer)
    Arena1Dies()


rule "Arena 1: Player Dies, 4-X Players":
    @Event playerDied
    @Condition len(getAllPlayers()) >= 4
    @Condition (eventPlayer == Arena1Q[1] or eventPlayer == Arena1Q[2]) == true
    @Condition eventPlayer.DeadHelper == false
    
    eventPlayer.DeadHelper = true
    Arena1Q.remove(eventPlayer)
    Arena2Q.append(eventPlayer)
    Arena1Dies()


rule "Arena 2: Player Dies, 1-3 Players (vääräs järkäs menee Q)":
    @Event playerDied
    @Condition len(getAllPlayers()) < 4
    @Condition (eventPlayer == Arena2Q[1] or eventPlayer == Arena2Q[2]) == true
    @Condition eventPlayer.DeadHelper == false
    
    eventPlayer.DeadHelper = true
    Arena2Q.remove(eventPlayer)
    Arena1Q.append(eventPlayer)
    Arena2Dies()


rule "Arena 2: Player Dies, 4-5 Players":
    @Event playerDied
    @Condition len(getAllPlayers()) < 6
    @Condition len(getAllPlayers()) > 3
    @Condition (eventPlayer == Arena2Q[1] or eventPlayer == Arena2Q[2]) == true
    @Condition eventPlayer.DeadHelper == false
    
    eventPlayer.DeadHelper = true
    Arena2Q.remove(eventPlayer)
    Arena2Q.append(eventPlayer)
    Arena2Dies()


rule "Arena 2: Player Dies, 6-12 Players":
    @Event playerDied
    @Condition len(getAllPlayers()) > 5
    @Condition (eventPlayer == Arena2Q[1] or eventPlayer == Arena2Q[2]) == true
    @Condition eventPlayer.DeadHelper == false
    
    eventPlayer.DeadHelper = true
    Arena2Q.remove(eventPlayer)
    Arena3Q.append(eventPlayer)
    Arena2Dies()


rule "Arena 3: Player Dies, 1-3 Players (vääräs järkäs menee Q)":
    @Event playerDied
    @Condition len(getAllPlayers()) < 4
    @Condition (eventPlayer == Arena3Q[1] or eventPlayer == Arena3Q[2]) == true
    @Condition eventPlayer.DeadHelper == false
    
    eventPlayer.DeadHelper = true
    Arena3Q.remove(eventPlayer)
    Arena1Q.append(eventPlayer)
    Arena3Dies()


rule "Arena 3: Player Dies, 4-5 Players (vääräs järkäs menee Q)":
    @Event playerDied
    @Condition len(getAllPlayers()) < 6
    @Condition len(getAllPlayers()) > 3
    @Condition (eventPlayer == Arena3Q[1] or eventPlayer == Arena3Q[2]) == true
    @Condition eventPlayer.DeadHelper == false
    
    eventPlayer.DeadHelper = true
    Arena3Q.remove(eventPlayer)
    Arena2Q.append(eventPlayer)
    Arena3Dies()


rule "Arena 3: Player Dies, 6-12 Players":
    @Event playerDied
    @Condition len(getAllPlayers()) > 5
    @Condition (eventPlayer == Arena3Q[1] or eventPlayer == Arena3Q[2]) == true
    @Condition eventPlayer.DeadHelper == false
    
    eventPlayer.DeadHelper = true
    Arena3Q.remove(eventPlayer)
    Arena3Q.append(eventPlayer)
    Arena3Dies()


rule "Player attributes":


rule "Refreshing Hero if player was under anti heal after winning":
    @Event playerTookDamage
    @Condition (attacker.getCurrentHero() == Hero.ANA and (eventDamage == 60 or eventDamage == 90)) == true
    @Condition eventPlayer._spectating == false
    @Condition eventPlayer in Arena1Q == true
    
    eventPlayer.AntiHealDebuffed = true
    wait(4)
    eventPlayer.AntiHealDebuffed = false


rule "Queue Hud Arena 1":
    @Event eachPlayer
    @Condition eventPlayer._spectating == true
    @Condition eventPlayer in Arena1Q == true
    @Condition isGameInProgress() == true
    
    destroyHudText(eventPlayer.Hud)
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena1Q.index(eventPlayer) - 2)), "Score per kill: 3", "Arena: 1", HudPosition.TOP, 2, Color.GREEN, Color.WHITE, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    eventPlayer.Hud = getLastCreatedText()


rule "Queue Hud Arena 2":
    @Event eachPlayer
    @Condition eventPlayer._spectating == true
    @Condition eventPlayer in Arena2Q == true
    @Condition isGameInProgress() == true
    
    destroyHudText(eventPlayer.Hud)
    if eventPlayer.Score >= 48:
        goto lbl_0
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena2Q.index(eventPlayer) - 2)), "Score per kill: 2", "Arena: 2", HudPosition.TOP, 2, Color.RED, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    lbl_0:
    if eventPlayer.Score < 48:
        goto lbl_1
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena2Q.index(eventPlayer) - 2)), "To win you need to get a kill in Arena 1", "Arena: 2", HudPosition.TOP, 2, Color.RED, Color.WHITE, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    lbl_1:
    eventPlayer.Hud = getLastCreatedText()


rule "Queue Hud Arena 3":
    @Event eachPlayer
    @Condition eventPlayer._spectating == true
    @Condition eventPlayer in Arena3Q == true
    @Condition isGameInProgress() == true
    
    destroyHudText(eventPlayer.Hud)
    if eventPlayer.Score == 49:
        goto lbl_0
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena3Q.index(eventPlayer) - 2)), "Score per kill: 1", "Arena: 3", HudPosition.TOP, 2, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    lbl_0:
    if eventPlayer.Score != 49:
        goto lbl_1
    hudText(eventPlayer, l"{0}: {1}".format("Position in Queue", abs(Arena3Q.index(eventPlayer) - 2)), "To win you need to get a kill in Arena 1", "Arena: 3", HudPosition.TOP, 2, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    lbl_1:
    eventPlayer.Hud = getLastCreatedText()


rule "Destory Queue Hud when not Spectating":
    @Event eachPlayer
    @Condition eventPlayer._spectating == false
    @Condition isGameInProgress() == true
    
    destroyHudText(eventPlayer.Hud)


rule "Arena is decided by death of one player":


rule "Safe Zone Check Arena 1 Center":
    @Event eachPlayer
    @Condition distance(eventPlayer, MainHigh) >= 16.4
    @Condition distance(eventPlayer, MainCenter) >= 15.1
    @Condition (Arena1Q[1] == eventPlayer or Arena1Q[2] == eventPlayer) == true
    @Condition (eventPlayer.getAltitude() >= 30 or eventPlayer.getAltitude() <= 6) == true
    @Condition eventPlayer._spectating == false
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BurnDamage)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Safe Zone Check Arena 1 Top":
    @Event eachPlayer
    @Condition distance(eventPlayer, MainTopDeck) <= 3.75
    @Condition eventPlayer._spectating == false
    @Condition (Arena1Q[1] == eventPlayer or Arena1Q[2] == eventPlayer) == true
    @Condition (eventPlayer.getAltitude() >= 30 or eventPlayer.getAltitude() <= 6) == true
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BurnDamage)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Safe Zone Check Arena 2":
    @Event eachPlayer
    @Condition distance(eventPlayer, SideArenaCenter[1]) >= 17.4
    @Condition (Arena2Q[1] == eventPlayer or Arena2Q[2] == eventPlayer) == true
    @Condition eventPlayer._spectating == false
    @Condition Arena2Match == true
    @Condition (eventPlayer.getAltitude() >= 30 or eventPlayer.getAltitude() <= 6) == true
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BurnDamage)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Safe Zone Check Arena 3":
    @Event eachPlayer
    @Condition distance(eventPlayer, SideArenaCenter[3]) >= 17.4
    @Condition eventPlayer._spectating == false
    @Condition (Arena3Q[1] == eventPlayer or Arena3Q[2] == eventPlayer) == true
    @Condition Arena3Match == true
    @Condition (eventPlayer.getAltitude() >= 30 or eventPlayer.getAltitude() <= 6) == true
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BurnDamage)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START
