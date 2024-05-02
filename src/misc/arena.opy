#!mainFile "../1v1_main.opy"

globalvar arena_gvar
#!defineMember MAIN_CENTER arena_gvar[0]
#!defineMember MAIN_HIGH arena_gvar[1]
#!defineMember MAIN_TOP_DECK arena_gvar[2]
#!defineMember side_arena_center arena_gvar[3]
#!defineMember side_arena_spawns_facing arena_gvar[4]
#!defineMember MAIN_FACING arena_gvar[5]
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
#!defineMember HOST_HERO_ROSTER arena_gvar[102]
#!defineMember ALWAYS_REFRESH_HERO arena_gvar[103]

playervar arena_pvar
#!defineMember randomizer arena_pvar[2]
#!defineMember _is_spectating arena_pvar[3]
#!defineMember dead_helper arena_pvar[4]
#!defineMember Hud arena_pvar[7]
#!defineMember Score arena_pvar[18]
#!defineMember ult_charge arena_pvar[20]
#!defineMember anti_heal_debuffed arena_pvar[26]

#!define ARENA_COUNT 3
#!define DEQUEUE_TIME 0.016

globalvar _king
globalvar _arena0_ready
globalvar _arena0_fighters
globalvar _arena0_winner
globalvar _arena0_loser
globalvar _arena0_queue_temp
globalvar _arena0_queue
globalvar _arena1_ready
globalvar _arena1_fighters
globalvar _arena1_winner
globalvar _arena1_loser
globalvar _arena1_queue
globalvar _arena2_ready
globalvar _arena2_fighters
globalvar _arena2_winner
globalvar _arena2_loser
globalvar _arena2_queue

globalvar arena_gvar1
#!defineMember _arena0_players arena_gvar1[0]
#!defineMember _arena1_players arena_gvar1[2]
#!defineMember _arena2_players arena_gvar1[4]
#!defineMember UNIVERSAL_HERO_ROSTER arena_gvar1[5]

playervar arena_pvar1
#!defineMember _current_arena arena_pvar1[0]
#!defineMember hero_bag arena_pvar1[1]
#!defineMember hero_number arena_pvar1[2]
#!defineMember _arena_ult_charge arena_pvar1[3]

subroutine processArena0Result
subroutine processArena1Result
subroutine processArena2Result

#!define initQueue(q) (q = [])

#!define enqueue(q, value) \
    if value != null: q.append(value)

#!define dequeue(q) (del q[0])

#!define isEmpty(q) (len(q) <= 0)

#!define nextHero(player)\
    player.hero_number = (player.hero_number + 1) % len(player.hero_bag)\
    if player.hero_number == 0: player.hero_bag = random.shuffle(UNIVERSAL_HERO_ROSTER)\
    player.startForcingHero(player.hero_bag[player.hero_number])

#!define refreshHero(player)\
    player.startForcingHero(Hero.SYMMETRA)\
    wait()\
    player.startForcingHero(player.hero_bag[player.hero_number])\
    player.call_init = true\

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
    player.setStatusEffect(null, Status.UNKILLABLE, Math.INFINITY)\
    player.setInvisibility(Invis.ALL)\
    player.setStatusEffect(null, Status.PHASED_OUT, Math.INFINITY)\
    player.setStatusEffect(null, Status.ROOTED, Math.INFINITY)\
    player.setDamageDealt(0)\
    player.setFacing(localVector(MAIN_FACING, player, Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)\

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


rule "Respawn player immediately":
    @Event playerDied

    eventPlayer.respawn()


rule "Init arenas, queues, king":
    @Event global

    _arena0_fighters = []
    _arena0_winner = null
    _arena0_loser = null
    initQueue(_arena0_queue)

    _arena1_fighters = []
    _arena1_winner = null
    _arena1_loser = null
    initQueue(_arena1_queue)

    _arena2_fighters = []
    _arena2_winner = null
    _arena2_loser = null
    initQueue(_arena2_queue)


rule "Enqueue player to bottom queue":
    @Event eachPlayer
    @Condition eventPlayer not in _arena0_fighters
    @Condition eventPlayer not in _arena1_fighters
    @Condition eventPlayer not in _arena2_fighters
    @Condition eventPlayer not in _arena0_queue
    @Condition eventPlayer not in _arena1_queue
    @Condition eventPlayer not in _arena2_queue

    enqueue(_arena2_queue, eventPlayer)
    eventPlayer._current_arena = ARENA_COUNT - 1

    nextHero(eventPlayer)


rule "Remove player from queue on leave":
    @Event playerLeft

    _arena0_queue.remove(eventPlayer)
    _arena1_queue.remove(eventPlayer)
    _arena2_queue.remove(eventPlayer)

    if eventPlayer in _arena0_fighters:
        _arena0_winner = _arena0_fighters[0] if _arena0_fighters[0] != eventPlayer else _arena0_fighters[1]
        processArena0Result()
    else if eventPlayer in _arena1_fighters:
        _arena1_winner = _arena1_fighters[0] if _arena1_fighters[0] != eventPlayer else _arena1_fighters[1]
        processArena1Result()
    else if eventPlayer in _arena2_fighters:
        _arena2_winner = _arena2_fighters[0] if _arena2_fighters[0] != eventPlayer else _arena2_fighters[1]
        processArena2Result()


def processArena0Result():
    @Name "processArena0Result()"

    _arena0_winner.addToScore(3)
    _king = _arena0_winner

    # keep winner in arena 0
    # keep _king at the front of queue to guarantee they play next round
    _arena0_queue_temp = [_king]
    _arena0_queue_temp.append(_arena0_queue)
    _arena0_queue = _arena0_queue_temp

    # demote loser to bottom arena
    enqueue(_arena2_queue, _arena0_loser)
    _arena0_loser._current_arena = ARENA_COUNT - 1

    # swap loser hero
    nextHero(_arena0_loser)

    # clear arena0
    _arena0_fighters = []
    _arena0_winner = null
    _arena0_loser = null
    _arena0_ready = false


def processArena1Result():
    @Name "processArena1Result()"

    _arena1_winner.addToScore(2)

    # promote winner to arena 0
    enqueue(_arena0_queue, _arena1_winner)
    _arena1_winner._current_arena -= 1

    # demote loser to bottom arena
    enqueue(_arena2_queue, _arena1_loser)
    _arena1_loser._current_arena = ARENA_COUNT - 1

    # swap loser hero
    nextHero(_arena1_loser)

    # clear arena1
    _arena1_fighters = []
    _arena1_winner = null
    _arena1_loser = null
    _arena1_ready = false


def processArena2Result():
    @Name "processArena2Result()"

    _arena2_winner.addToScore(1)

    # promote winner to arena 1
    enqueue(_arena1_queue, _arena2_winner)
    _arena2_winner._current_arena -= 1

    # demote loser to bottom arena
    enqueue(_arena2_queue, _arena2_loser)
    _arena2_loser._current_arena = ARENA_COUNT - 1

    # swap loser hero
    nextHero(_arena2_loser)

    # clear arena2
    _arena2_fighters = []
    _arena2_winner = null
    _arena2_loser = null
    _arena2_ready = false


rule "Dequeue players if arena 0 is empty":
    @Event global
    @Condition isEmpty(_arena0_fighters)
    @Condition len(_arena0_queue) >= 2
    wait(DEQUEUE_TIME, Wait.ABORT_WHEN_FALSE)

    # arena0 player0
    _arena0_fighters.append(_arena0_queue[0])
    dequeue(_arena0_queue)
    # arena0 player1
    _arena0_fighters.append(_arena0_queue[0])
    dequeue(_arena0_queue)

    _arena0_ready = true


rule "Dequeue players if arena 1 is empty":
    @Event global
    @Condition isEmpty(_arena1_fighters)
    @Condition len(_arena1_queue) >= 2
    wait(DEQUEUE_TIME, Wait.ABORT_WHEN_FALSE)

    # arena1 player0
    _arena1_fighters.append(_arena1_queue[0])
    dequeue(_arena1_queue)
    # arena1 player1
    _arena1_fighters.append(_arena1_queue[0])
    dequeue(_arena1_queue)

    _arena1_ready = true


rule "Dequeue players if arena 2 is empty":
    @Event global
    @Condition isEmpty(_arena2_fighters)
    @Condition len(_arena2_queue) >= 2
    wait(DEQUEUE_TIME, Wait.ABORT_WHEN_FALSE)

    # arena2 player0
    _arena2_fighters.append(_arena2_queue[0])
    dequeue(_arena2_queue)
    # arena2 player1
    _arena2_fighters.append(_arena2_queue[0])
    dequeue(_arena2_queue)

    _arena2_ready = true


rule "Move players from arena 1 queue to arena 0 queue":
    @Event global
    @Condition len(_arena0_queue) < 2
    @Condition not isEmpty(_arena1_queue)

    do:
        _arena1_queue[0]._current_arena -= 1
        enqueue(_arena0_queue, _arena1_queue[0])
        dequeue(_arena1_queue)
        wait(DEQUEUE_TIME, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION


rule "Move player from arena 2 queue to arena 1 queue":
    @Event global
    @Condition len(_arena1_queue) < 2
    @Condition not isEmpty(_arena2_queue)

    do:
        _arena2_queue[0]._current_arena -= 1
        enqueue(_arena1_queue, _arena2_queue[0])
        dequeue(_arena2_queue)
        wait(DEQUEUE_TIME, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION


rule "Declare arena 0 winner on death":
    @Event playerDied
    @Condition eventPlayer in _arena0_fighters

    # declare arena 0 winner/loser
    _arena0_loser = eventPlayer
    _arena0_winner = _arena0_fighters[0] if _arena0_fighters[0] != eventPlayer else _arena0_fighters[1]
    processArena0Result()


rule "Declare arena 1 winner on death":
    @Event playerDied
    @Condition eventPlayer in _arena1_fighters

    # declare arena 1 winner/loser
    _arena1_loser = eventPlayer
    _arena1_winner = _arena1_fighters[0] if _arena1_fighters[0] != eventPlayer else _arena1_fighters[1]
    processArena1Result()


rule "Declare arena 2 winner on death":
    @Event playerDied
    @Condition eventPlayer in _arena2_fighters

    # declare arena 2 winner/loser
    _arena2_loser = eventPlayer
    _arena2_winner = _arena2_fighters[0] if _arena2_fighters[0] != eventPlayer else _arena2_fighters[1]
    processArena2Result()


rule "Workshop Settings --------------------------------------------------------------------------------------":
    disableInspector()

    BURN_DAMAGE = createWorkshopSetting(int[25:200], "Burn Damage", "Damage per tick", 25, 0)
    ALWAYS_REFRESH_HERO = createWorkshopSetting(bool, "Always refresh hero (cooldowns, shield, etc) after winning on arena 1", "Refresh hero after winning on arena 1", false, 0)
    HOST_DIFFERENT_HEROES = createWorkshopSetting(bool, "B Special settings for mode where players have different list of heroes", "Host player has different list of heroes", false, 0)


rule "Init UNIVERSAL_HERO_ROSTER and HOST_HERO_ROSTER":
    @Condition not isEmpty(_available_heroes)

    UNIVERSAL_HERO_ROSTER = _available_heroes
    HOST_HERO_ROSTER = [Hero.TRACER] if HOST_DIFFERENT_HEROES else _available_heroes


rule "Disable Scoring":
    disableScoring()
    hudText(getAllPlayers(), "Code: " GAMEMODE_CODE, DISCORD_SHORT_LINK, "Full details: workshop.codes/ow1-emulator", HudPosition.TOP, 22, Color.ORANGE, Color.BLUE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    INTRO_HUD = getLastCreatedText()


rule "Pause Timer":
    @Condition isGameInProgress()
    
    disableGamemodeCompletion()
    disableMusic()
    pauseMatchTime()
    setMatchTime(0)
    wait(1)
    destroyHudText(INTRO_HUD)


rule "Arena Locations":
    MAIN_CENTER = vect(0, 267, 280)
    MAIN_HIGH = vect(0, 280, 280)
    MAIN_TOP_DECK = vect(0, 279.5, 295.5)
    MAIN_FACING = vect(0, 268.5, 280)
    createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.RED, MAIN_CENTER, 16.7, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.RED, MAIN_TOP_DECK, 2.61, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
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


rule "Arena0 Match Start":
    @Condition _arena0_ready
    @Condition _arena0_fighters[0].hasSpawned()
    @Condition _arena0_fighters[1].hasSpawned()

    wait(0.25)
    _arena0_fighters[0].teleport(MAIN_OPPOSITE_SPAWNS[0])
    _arena0_fighters[1].teleport(MAIN_OPPOSITE_SPAWNS[1])
    wait(0.05)
    _arena0_fighters[0].setFacing(localVector(MAIN_FACING, _arena0_fighters[0], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    _arena0_fighters[1].setFacing(localVector(MAIN_FACING, _arena0_fighters[1], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    wait(0.05)
    stopForcingSpectator(_arena0_fighters[0])
    stopForcingSpectator(_arena0_fighters[1])
    # wait(0.3)
    refreshHero(_arena0_fighters[0])
    refreshHero(_arena0_fighters[1])


rule "Arena1 Match Start":
    @Condition _arena1_ready
    @Condition _arena1_fighters[0].hasSpawned()
    @Condition _arena1_fighters[1].hasSpawned()

    wait(0.25)
    _arena1_fighters[0].teleport(side_arena_spawns_facing[0])
    _arena1_fighters[1].teleport(side_arena_spawns_facing[1])
    wait(0.05)
    _arena1_fighters[0].setFacing(localVector(side_arena_spawns_facing[2], _arena1_fighters[0], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    _arena1_fighters[1].setFacing(localVector(side_arena_spawns_facing[2], _arena1_fighters[1], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    wait(0.05)
    stopForcingSpectator(_arena1_fighters[0])
    stopForcingSpectator(_arena1_fighters[1])
    # wait(0.3)
    refreshHero(_arena1_fighters[0])
    refreshHero(_arena1_fighters[1])


rule "Arena2 Match Start":
    @Condition _arena2_ready
    @Condition _arena2_fighters[0].hasSpawned()
    @Condition _arena2_fighters[1].hasSpawned()

    wait(0.25)
    _arena2_fighters[0].teleport(side_arena_spawns_facing[3])
    _arena2_fighters[1].teleport(side_arena_spawns_facing[4])
    wait(0.05)
    _arena2_fighters[0].setFacing(localVector(side_arena_spawns_facing[5], _arena2_fighters[0], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    _arena2_fighters[1].setFacing(localVector(side_arena_spawns_facing[5], _arena2_fighters[1], Transform.ROTATION_AND_TRANSLATION), Relativity.TO_PLAYER)
    wait(0.05)
    stopForcingSpectator(_arena2_fighters[0])
    stopForcingSpectator(_arena2_fighters[1])
    # wait(0.3)
    refreshHero(_arena2_fighters[0])
    refreshHero(_arena2_fighters[1])


rule "Spectate if in queue":
    @Event eachPlayer
    @Condition (eventPlayer in _arena0_queue) \
            or (eventPlayer in _arena1_queue) \
            or (eventPlayer in _arena2_queue)
    @Condition eventPlayer.hasSpawned()
    wait(0.25, Wait.ABORT_WHEN_FALSE)

    startForcingSpectator(eventPlayer)
    heal(eventPlayer, null, Math.INFINITY)


rule "Check Arena 0 Center OOB":
    @Event eachPlayer
    @Condition distance(eventPlayer, MAIN_HIGH) >= 16.4
    @Condition distance(eventPlayer, MAIN_CENTER) >= 15.1
    @Condition eventPlayer in _arena0_fighters
    @Condition (eventPlayer.getAltitude() >= 30) or (eventPlayer.getAltitude() <= 6)
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BURN_DAMAGE)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Check Arena 0 Top OOB":
    @Event eachPlayer
    @Condition distance(eventPlayer, MAIN_TOP_DECK) <= 3.75
    @Condition eventPlayer in _arena0_fighters
    @Condition (eventPlayer.getAltitude() >= 30) or (eventPlayer.getAltitude() <= 6)
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BURN_DAMAGE)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Check Arena 1 OOB":
    @Event eachPlayer
    @Condition distance(eventPlayer, side_arena_center[1]) >= 17.4
    @Condition eventPlayer in _arena1_fighters
    @Condition (eventPlayer.getAltitude() >= 30) or (eventPlayer.getAltitude() <= 6)
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BURN_DAMAGE)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Check Arena 2 OOB":
    @Event eachPlayer
    @Condition distance(eventPlayer, side_arena_center[3]) >= 17.4
    @Condition eventPlayer in _arena2_fighters
    @Condition (eventPlayer.getAltitude() >= 30) or (eventPlayer.getAltitude() <= 6)
    
    eventPlayer.setStatusEffect(null, Status.BURNING, 0.5)
    damage(eventPlayer, null, BURN_DAMAGE)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START

