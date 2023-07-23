settings {
    "main": {
        "description": "Doomfist Sumo Ow1 recreation v2.0 -> Made by Bebel, Hikiru and Xponit!! Join the Discord for other versions or tournaments!",
        "modeName": "Doom Sumo Ow1 2.0"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "paused",
        "enableMatchVoiceChat": true,
        "ffaSlots": 10,
        "spectatorSlots": 6,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "workshopIsland"
            ],
            "gameLengthInMn": 15,
            "scoreToWin": 10
        },
        "tdm": {
            "enabled": false,
            "scoreToWin": 3
        },
        "general": {
            "enableHeroSwitching": false,
            "enableEnemyHealthBars": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableKillCam": false,
            "enableRandomHeroes": true,
            "enableSelfInitiatedRespawn": false,
            "spawnHealthPacks": "disabled"
        }
    },
    "heroes": {
        "allTeams": {
            "doomfist": {
                "ammoClipSize%": 100,
                "ammoRegenerationTime%": 100,
                "damageDealt%": 100,
                "damageReceived%": 100,
                "health%": 500,
                "ability1ChargeRate%": 10,
                "ability1Cooldown%": 36,
                "secondaryFireCooldown%": 60,
                "secondaryFireKb%": 300,
                "ability2Cooldown%": 51,
                "combatUltGen%": 0,
                "passiveUltGen%": 0,
                "ultGen%": 10
            },
            "enabledHeroes": [
                "doomfist"
            ],
            "general": {
                "health%": 500
            }
        }
    }
}

#!define MAX_CORRECTION_ANGLE 15
#!define ALTITUDE 3
#!define FALLING_SLAM_SPEED_LIMIT 5
#!define MAX_UPDWARDS_SLAM_ANGLE 0.1
#!define SLAM_TIMER_YPOS -0.1
#!define SLAM_TIMER_XPOS 0

#!define SLAM_ENDPOS raycast(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.tickedFacingDirection * 15, null, null, false).getHitPosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.tickedFacingDirection * 15, null, null, false).getHitPosition() - vect(0, 15, 0), null, null, false).getHitPosition()

#Global variables

globalvar vectorArray 0
globalvar matchStatus 1
globalvar nextMatchStatus 2
globalvar oneVoneMode 3
globalvar oneVoneUsed 4
globalvar circle_spawning 5
globalvar totalRounds 6
globalvar kickFromUltimate 7
globalvar calculateScores 8
globalvar corner_spawning 9
globalvar corner_used 10
globalvar campSpot 11
globalvar campArea 12
globalvar gameIsReady 13
globalvar pickCornerDiagonal 14
globalvar pickRandomPlayer 15
globalvar different_text_trigger 27
globalvar corner_timer 28
globalvar get_ready_text 29
globalvar timer_progress_bar 30
globalvar color 31
globalvar go_text 32
globalvar start_text 33
globalvar myNuts 34
globalvar ultimateChargeTimer 35
globalvar discordColor 36


#Player variables

playervar active 0
playervar kills 1
playervar roundsPlayed 2
playervar roundsWon 3
playervar winrate 4
playervar deathEffect 5
playervar fireEffect 6
playervar hudToggle 7
playervar campCount 8
playervar campTimer 9
playervar randomEffectNumber 10
playervar aimingBeam 11
playervar afterUltHp 12

playervar holdingPrimary 13
playervar holdingSecondary 14
playervar holdingAbility1 15
playervar holdingAbility2 16
playervar holdingUltimate 17
playervar reloading 18

playervar isUppercutting 40
playervar uppercuttingEffect 41
playervar uppercutHitPlayers 42
playervar uppTickHitPlayers 43
playervar upperHitRuleTrigger 44
playervar iUpp 45
playervar immuneToUppercut 46

playervar slamRingUp 20
playervar slamRingRight 21
playervar slamRingDown 22
playervar slamRingLeft 23
playervar slamEndPosition 24
playervar nearestSlamEndPosition 25
playervar slamBeingProcessed 28
playervar slamTimer 29
playervar hasSlamTimer 30
playervar slamTimerVisible 31
playervar slamTimerTEXT 32
playervar isCloseSlam 34
playervar slamMeleeTimer 35
playervar slamDirection 36
playervar slamRequested0g 37
playervar showIndicator 38
playervar stuckStart 39
playervar tickedFacingDirection 47

#Activated extensions

#!extension beamEffects
#!extension kineticExplosionEffects
#!extension energyExplosionEffects
#!extension explosionSounds
#!extension buffStatusEffects
#!extension debuffStatusEffects
#!extension buffAndDebuffSounds


rule "GlobalVariables":
    gameIsReady = false
    vectorArray = []
    vectorArray.append(vect(0, 1.5, 0))
    matchStatus = []
    nextMatchStatus = 2
    oneVoneMode = false
    wait(4)
    bigMessage(getAllPlayers(), "Game is about to start!")
    wait(2)
    matchStatus = nextMatchStatus
    kickFromUltimate = false
    calculateScores = false
    campSpot[0] = vect(-4.818, -19.5, -22.434)
    campSpot[1] = vect(11.7, -13, -22.433)
    campSpot[2] = vect(-18, -6, -22.065)
    campArea[0] = vect(-20.555, -11.443, -6.168)
    campArea[1] = vect(5.5, -17.5, -21.5)
    wait(1)
    gameIsReady = true
    chase(myNuts, 999999, duration=3600, ChaseReeval.NONE)


rule "PlayerVariables":
    @Event eachPlayer
    
    if not isGameInProgress():
        eventPlayer.active = true
    else:
        eventPlayer.active = false
    eventPlayer.kills = 0
    eventPlayer.roundsPlayed = 0
    eventPlayer.roundsWon = 0
    eventPlayer.hudToggle = 0
    eventPlayer.campCount = 0
    eventPlayer.campTimer = 0


rule "Disable Announcer, Music, Completion, Scoring":
    disableAnnouncer()
    disableMusic()
    disableGamemodeCompletion()
    disableScoring()
    setMatchTime(4)
    chase(discordColor, 999999, duration=999999, ChaseReeval.NONE)


rule "Player HUD":
    #hudSubtext([player for player in getAllPlayers() if player.hudToggle < 2], "{0} {1}{2}".format("Server load:", getPeakServerLoad() / 2.55, "%"), HudPosition.LEFT, 0, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    #info on the left
    hudSubtext([player for player in getAllPlayers() if player.hudToggle < 2], "Remaining: {0}/{1}".format(getNumberOfLivingPlayers(Team.ALL), len([player for player in getAllPlayers() if player.active == true])), HudPosition.LEFT, 0, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    hudSubtext([player for player in getAllPlayers() if player.hudToggle < 2], "winrate: {0}%".format(localPlayer.winrate), HudPosition.LEFT, 1, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if player.hudToggle < 2], l"{0}: {1}".format("Rounds won", localPlayer.roundsWon), HudPosition.LEFT, 2, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if player.hudToggle != 2], l"{0}: {1}".format("Rounds played", localPlayer.roundsPlayed), HudPosition.LEFT, 3, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if player.hudToggle < 2], l"{0}: {1}".format("Eliminations", localPlayer.kills), HudPosition.LEFT, 4, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #info on the right
    hudSubtext([player for player in getAllPlayers() if player.hudToggle < 2], "### Doom Sumo Ow1 v 2.0 ###", HudPosition.RIGHT, 0.01, rgb(255, 165, 0), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if player.hudToggle < 2], "Doomfist Sumo Ow1 Abilities" if localPlayer.isHoldingButton(Button.RELOAD) else "by Bebel, Hikiru and Xponit", HudPosition.RIGHT, 0.03, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if player.hudToggle < 2], " ", HudPosition.RIGHT, 0.03, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if player.hudToggle < 2], "discord: DSC.GG/DOOM-SUMO", HudPosition.RIGHT, 0.031, rgb(0, max(255 * cos(discordColor) + 150, 100), 0), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if player.hudToggle < 2], " ", HudPosition.RIGHT, 0.032, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #Hold R for info
    hudSubtext(getAllPlayers() if not localPlayer.isHoldingButton(Button.RELOAD) and localPlayer.hudToggle != 2 else [], "Hold R for more info", HudPosition.RIGHT, 0.04, Color.GRAY, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers() if localPlayer.isHoldingButton(Button.RELOAD) else [], "=== Commands ===", HudPosition.RIGHT, 0.05, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers() if localPlayer.isHoldingButton(Button.RELOAD) else [], "Display Mode: Hold F (interact)", HudPosition.RIGHT, 0.07, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers() if localPlayer.isHoldingButton(Button.RELOAD) else [], " ", HudPosition.RIGHT, 0.08, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers() if localPlayer.isHoldingButton(Button.RELOAD) else [], "=== Abilities ===", HudPosition.RIGHT, 0.09, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers() if localPlayer.isHoldingButton(Button.RELOAD) else [], "Shoot = Hack [1.5 sec]", HudPosition.RIGHT, 0.1, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers() if localPlayer.isHoldingButton(Button.RELOAD) else [], "Slam = Stun [2 sec]", HudPosition.RIGHT, 0.11, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers() if localPlayer.isHoldingButton(Button.RELOAD) else [], "Shoot + using slam = stun [2 sec]", HudPosition.RIGHT, 0.12, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers() if localPlayer.isHoldingButton(Button.RELOAD) else [], "", HudPosition.RIGHT, 0.13, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers() if localPlayer.isHoldingButton(Button.RELOAD) else [], "F (Interact) + R (Reload) -> 3rd person", HudPosition.RIGHT, 0.13, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #camp timer
    hudSubtext([player for player in getAllPlayers() if player.campTimer != 0], " ", HudPosition.RIGHT, 0.14, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader([player for player in getAllPlayers() if player.campTimer != 0], "{0} {1}".format(iconString(Icon.WARNING), localPlayer.campTimer), HudPosition.RIGHT, 0.15, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Toggle HUD 0":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.hudToggle == 2
    
    wait(0.7, Wait.ABORT_WHEN_FALSE)
    eventPlayer.hudToggle = 0
    smallMessage(eventPlayer, "normal mode")
    eventPlayer.enableGamemodeHud()


rule "Toggle HUD 1":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.hudToggle == 0
    
    wait(0.7, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "scoreboard off")
    eventPlayer.hudToggle = 1
    eventPlayer.disableGamemodeHud()


rule "Toggle HUD 2":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.hudToggle == 1
    
    wait(0.7, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "simple mode")
    eventPlayer.hudToggle = 2
    eventPlayer.disableGamemodeHud()

    hudSubtext([i for i in [eventPlayer] if i.isUsingUltimate() and i.isHoldingButton(Button.SECONDARY_FIRE)], "Height: {0}".format(eventPlayer.getPosition().y), HudPosition.TOP, 0.51, rgb(-2.8 * (abs(eventPlayer.getPosition().y - 100)) + 255, -2.8 * (abs(eventPlayer.getPosition().y + 20)) + 255, -2.8 * (abs(eventPlayer.getPosition().y - 40)) + 255), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)


rule "Circle spawn":
    @Event eachPlayer
    @Condition circle_spawning == true
    @Condition eventPlayer.active == true
    
    getAllPlayers().setStatusEffect(null, Status.UNKILLABLE, 999999)
    getAllPlayers().setDamageDealt(500)
    eventPlayer.startForcingPosition(vect(vectorArray[0].x + (6 * (cosDeg((getAllPlayers().index(eventPlayer) + totalRounds) * (360 / getNumberOfPlayers(Team.ALL))))), vectorArray[0].y, vectorArray[0].z + (6 * (sinDeg((getAllPlayers().index(eventPlayer) + totalRounds) * (360 / getNumberOfPlayers(Team.ALL)))))), true)
    wait(0.25)
    eventPlayer.startFacing(vectorTowards(eventPlayer.getPosition(), vectorArray[0]), 2000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    wait(0.75)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 3)
    eventPlayer.setStatusEffect(null, Status.FROZEN, 3)
    wait(0.25)
    getAllPlayers().setAbilityCooldown(Button.ABILITY_2, 0)
    getAllPlayers().stopForcingPosition()
    getAllPlayers().stopFacing()
    circle_spawning = false


rule "Corner spawn":
    @Event eachPlayer
    @Condition corner_spawning == true
    @Condition eventPlayer.active == true
    
    getAllPlayers().setStatusEffect(null, Status.UNKILLABLE, 999999)
    getAllPlayers().setDamageDealt(500)
    if corner_used == false:
        if pickCornerDiagonal == 0:
            getLivingPlayers(Team.ALL)[pickRandomPlayer[0]].startForcingPosition(vect(-17.5, 1.5, 17.5), true)
            getLivingPlayers(Team.ALL)[pickRandomPlayer[1]].startForcingPosition(vect(17.5, 1.5, -17.5), true)
        else:
            getLivingPlayers(Team.ALL)[pickRandomPlayer[0]].startForcingPosition(vect(-17.5, 1.5, -17.5), true)
            getLivingPlayers(Team.ALL)[pickRandomPlayer[1]].startForcingPosition(vect(17.5, 1.5, 17.5), true)
    else:
        if pickCornerDiagonal == 0:
            getAllPlayers()[pickRandomPlayer[0]].startForcingPosition(vect(-17.5, 1.5, 17.5), true)
            getAllPlayers()[pickRandomPlayer[1]].startForcingPosition(vect(17.5, 1.5, -17.5), true)
        else:
            getAllPlayers()[pickRandomPlayer[0]].startForcingPosition(vect(-17.5, 1.5, -17.5), true)
            getAllPlayers()[pickRandomPlayer[1]].startForcingPosition(vect(17.5, 1.5, 17.5), true)
    wait(0.25)
    eventPlayer.startFacing(vectorTowards(eventPlayer.getPosition(), vectorArray[0]), 10000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    wait(0.75)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 3)
    eventPlayer.setStatusEffect(null, Status.FROZEN, 3)
    wait(0.25)
    getAllPlayers().setAbilityCooldown(Button.ABILITY_2, 0)
    getAllPlayers().stopForcingPosition()
    getAllPlayers().stopFacing()
    corner_spawning = false
    corner_used = true


rule "Event inactive player kill":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.active == false
    
    eventPlayer.teleport(vect(0, -2, 0))
    kill(eventPlayer, null)
    eventPlayer.disableRespawn()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()


rule "Event active player kill":
    @Event playerDied
    @Condition eventPlayer.active == true
    
    createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET, Color.TEAM_2, eventPlayer.getPosition() + vect(0, 2, 0), 20, EffectReeval.VISIBILITY)
    eventPlayer.deathEffect = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.WRECKING_BALL_PILEDRIVER_FIRE, Color.TEAM_1, eventPlayer, 2, EffectReeval.VISIBILITY)
    eventPlayer.fireEffect = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_EMP_EXPLOSION_SOUND, Color.TEAM_2, eventPlayer.getPosition(), 150)
    playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT, Color.TEAM_2, eventPlayer.getPosition(), 1)
    eventPlayer.applyImpulse(vect(0, 1, 0), 100, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(2)
    destroyEffect(eventPlayer.deathEffect)
    destroyEffect(eventPlayer.fireEffect)
    eventPlayer.deathEffect = null
    eventPlayer.disableRespawn()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()


rule "Kill counter":
    @Event playerEarnedElimination
    @Condition isGameInProgress() == true
    
    eventPlayer.kills += 1


rule "CampTimer":
    @Event eachPlayer
    
    chase(eventPlayer.campTimer, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)


rule "CampSpots (kill)":
    @Event eachPlayer
    @Condition gameIsReady == true
    @Condition eventPlayer.isAlive() == true
    @Condition any([distance(eventPlayer, player) <= 4.5 for player in campSpot]) == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    wait(4, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "Stop stalling here, or die!")
    eventPlayer.campTimer = 4
    #imposter
    waitUntil(true in (all([distance(eventPlayer, player) > 4 for player in campSpot])), 4)
    if any([distance(eventPlayer, player) <= 4 for player in campSpot]):
        if matchStatus != 0:
            eventPlayer.clearStatusEffect(Status.UNKILLABLE)
            kill(eventPlayer, null)
    eventPlayer.campTimer = 0


rule "CampAreas (impulse)":
    @Event eachPlayer
    @Condition gameIsReady == true
    @Condition eventPlayer.isAlive() == true
    @Condition any([distance(eventPlayer, player) <= 4 for player in campArea]) == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    wait(4, Wait.ABORT_WHEN_FALSE)
    smallMessage(eventPlayer, "Leave this spot!")
    eventPlayer.campTimer = 4
    waitUntil(true in (all([distance(eventPlayer, player) > 4 for player in campArea])), 4)
    if distance(eventPlayer, campArea[0]) <= 4:
        eventPlayer.applyImpulse(directionTowards(campArea[0] * vect(1, 0.001, 1), campArea[0] * vect(1, 0.001, 1) + vect(-1, 0, 0)), 70, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    elif distance(eventPlayer, campArea[1]) <= 4:
        eventPlayer.applyImpulse(directionTowards(campArea[1] * vect(1, 0.001, 1), campArea[1] * vect(1, 0.001, 1) + vect(0, 0, -1)), 70, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    eventPlayer.campTimer = 0


rule "Global.CampArea[0], CampCount[0]":
    @Event eachPlayer
    @Condition gameIsReady == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(eventPlayer, campArea[0]) <= 4
    @Condition eventPlayer.isUsingUltimate() == false
    
    wait(1.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.campCount[0] += 1
    if eventPlayer.campCount[0] == 3:
        smallMessage(eventPlayer, "Stop stalling so fast!")
        if getNumberOfLivingPlayers(Team.ALL) == 2:
            smallMessage(getAllPlayers().exclude(eventPlayer), "opponent is warned")
    if eventPlayer.campCount[0] == 4:
        smallMessage(eventPlayer, "Last warning!")
        if getNumberOfLivingPlayers(Team.ALL) == 2:
            smallMessage(getAllPlayers().exclude(eventPlayer), "Second warning for opponent")
    if eventPlayer.campCount[0] >= 5:
        smallMessage(eventPlayer, "Not today!")
        eventPlayer.applyImpulse(directionTowards(campArea[0] * vect(1, 0.001, 1), campArea[0] * vect(1, 0.001, 1) + vect(-1, 0, 0)), 70, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)


rule "Global.CampArea[1], CampCount[1]":
    @Event eachPlayer
    @Condition gameIsReady == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(eventPlayer, campArea[1]) <= 4
    @Condition eventPlayer.isUsingUltimate() == false
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.campCount[1] += 1
    if eventPlayer.campCount[1] == 3:
        if getNumberOfLivingPlayers(Team.ALL) == 2:
            smallMessage(getAllPlayers().exclude(eventPlayer), "Anti-camp system is watching")
    if eventPlayer.campCount[1] == 4:
        smallMessage(eventPlayer, "Try to get up!")
        if getNumberOfLivingPlayers(Team.ALL) == 2:
            smallMessage(getAllPlayers().exclude(eventPlayer), "your opponent is warned!")
    if eventPlayer.campCount[1] == 5:
        smallMessage(eventPlayer, "Stop using the same stalls!")
        if getNumberOfLivingPlayers(Team.ALL) == 2:
            smallMessage(getAllPlayers().exclude(eventPlayer), "second warning for opponent")
    if eventPlayer.campCount[1] == 6:
        smallMessage(eventPlayer, "Last warning, go somewhere else!")
        if getNumberOfLivingPlayers(Team.ALL) == 2:
            smallMessage(getAllPlayers().exclude(eventPlayer), "Last warning for opponent")
    if eventPlayer.campCount[1] >= 7:
        smallMessage(eventPlayer, "Not today!")
        eventPlayer.applyImpulse(directionTowards(campArea[1] * vect(1, 0.001, 1), campArea[1] * vect(1, 0.001, 1) + vect(0, 0, -1)), 70, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)


rule "Global.CampSpot[0], CampCount[1]":
    @Event eachPlayer
    @Condition gameIsReady == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(eventPlayer, campSpot[0]) <= 4.5
    @Condition eventPlayer.isUsingUltimate() == false
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.campCount[1] += 1
    if eventPlayer.campCount[1] == 3:
        if getNumberOfLivingPlayers(Team.ALL) == 2:
            smallMessage(getAllPlayers().exclude(eventPlayer), "Anti-camp system is watching")
    if eventPlayer.campCount[1] == 4:
        smallMessage(eventPlayer, "Try to get up!")
        if getNumberOfLivingPlayers(Team.ALL) == 2:
            smallMessage(getAllPlayers().exclude(eventPlayer), "your opponent is warned!")
    if eventPlayer.campCount[1] == 5:
        smallMessage(eventPlayer, "Stop using the same stalls!")
        if getNumberOfLivingPlayers(Team.ALL) == 2:
            smallMessage(getAllPlayers().exclude(eventPlayer), "second warning for opponent")
    if eventPlayer.campCount[1] == 6:
        smallMessage(eventPlayer, "Last warning, go somewhere else!")
        if getNumberOfLivingPlayers(Team.ALL) == 2:
            smallMessage(getAllPlayers().exclude(eventPlayer), "Last warning for opponent")
    if eventPlayer.campCount[1] >= 7:
        smallMessage(eventPlayer, "Not today!")
        eventPlayer.applyImpulse(directionTowards(campSpot[0] * vect(1, 0.001, 1), campSpot[0] * vect(1, 0.001, 1) + vect(0, 0, -1)), 70, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)


rule "CampCount[0] Reset":
    @Event eachPlayer
    @Condition gameIsReady == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(eventPlayer, campArea[0]) <= 4
    @Condition eventPlayer.isUsingUltimate() == false
    
    waitUntil(distance(eventPlayer, campArea[0]) > 4, 999)
    wait(2.5, Wait.RESTART_WHEN_TRUE)
    eventPlayer.campCount[0] = 0


rule "CampCount[1] Reset":
    @Event eachPlayer
    @Condition gameIsReady == true
    @Condition eventPlayer.isAlive() == true
    @Condition (distance(eventPlayer, campSpot[0]) <= 4.5 or distance(eventPlayer, campArea[1]) <= 4) == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    waitUntil(distance(eventPlayer, campSpot[0]) > 4.5 and distance(eventPlayer, campArea[1]) > 4, 999)
    wait(10, Wait.RESTART_WHEN_TRUE)
    eventPlayer.campCount[1] = 0


rule "CampCount[1] Reset when (almost) on ground":
    @Event eachPlayer
    @Condition gameIsReady == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.campCount != 0
    @Condition eventPlayer.getPosition().y >= -1
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.campCount = 0


rule "Melee slam combo":
    @Event playerDealtKnockback
    @Condition eventAbility == Button.MELEE
    @Condition victim.hasStatusEffect(Status.STUNNED) == true
    @Condition victim.isCloseSlam == true
    @Condition victim.isOnGround() == true
    
    if victim.slamMeleeTimer < 1 and victim.getVelocity() != vect(0, 0, 0):
        victim.applyImpulse(victim.getVelocity(), 8, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "Melee effect":
    @Event playerDealtDamage
    @Condition eventAbility == Button.MELEE
    
    playEffect(getAllPlayers(), DynamicEffect.DVA_MICRO_MISSILES_EXPLOSION, Color.WHITE, victim, 1)
    eventPlayer.randomEffectNumber = random.randint(0, 4)
    if eventPlayer.randomEffectNumber == 0:
        playEffect(getAllPlayers(), DynamicEffect.JUNKRAT_CONCUSSION_MINE_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 100)
    elif eventPlayer.randomEffectNumber == 1:
        playEffect(getAllPlayers(), DynamicEffect.ANA_BIOTIC_GRENADE_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 50)
    elif eventPlayer.randomEffectNumber == 2:
        playEffect(getAllPlayers(), DynamicEffect.LUCIO_SOUND_BARRIER_CAST_SOUND, Color.WHITE, eventPlayer.getPosition(), 75)
    elif eventPlayer.randomEffectNumber == 3:
        playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 200)
    elif eventPlayer.randomEffectNumber == 4:
        playEffect(getAllPlayers(), DynamicEffect.ZARYA_PARTICLE_CANNON_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 75)


rule "Visuals & variables":
    #chase(timer_progress_bar, 100, duration=3, ChaseReeval.DESTINATION_AND_DURATION)
    chase(corner_timer, 0, duration=3, ChaseReeval.DESTINATION_AND_DURATION)
    #Variables
    color = rgb(215, 215, 215)
    #Visuals Corner
    createInWorldText(getAllPlayers() if corner_timer != false else [], corner_timer, vect(0, 6, 0), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers() if go_text == true else [], "Go!", vect(0, 6, 0), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.GREEN, SpecVisibility.DEFAULT)
    #Visuals Circle
    createProgressBarInWorldText(getAllPlayers() if timer_progress_bar != false else [], timer_progress_bar, "", vect(0, 2.3, 0), 0.25, Clip.SURFACES, Color.GREEN if timer_progress_bar == 100 else color, Color.WHITE, ProgressWorldTextReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers() if get_ready_text != false else [], get_ready_text, vect(0, 2.6, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_STRING_AND_COLOR, color, SpecVisibility.DEFAULT)
    createInWorldText(getAllPlayers() if start_text == true else [], "Start!", vect(0, 2.6, 0), 2.1, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, rgb(230, 230, 230), SpecVisibility.DEFAULT)


rule "Get ready visuals":
    @Condition get_ready_text == true
    
    different_text_trigger = random.randint(1, 450)
    if different_text_trigger > 220:
        different_text_trigger = "Get ready"
    elif different_text_trigger >= 1 and different_text_trigger <= 17:
        different_text_trigger = "Overwatch 1 remake 2.0 by Bebel, Hikiru, MuzzleBreak & Xponit"
    elif different_text_trigger > 17 and different_text_trigger <= 32:
        different_text_trigger = "Join our discord"
    elif different_text_trigger > 32 and different_text_trigger <= 35:
        color = Color.ORANGE
        different_text_trigger = "Hold Interact [F]"
    elif different_text_trigger > 35 and different_text_trigger <= 38:
        different_text_trigger = "When is tournament??"
    elif different_text_trigger > 38 and different_text_trigger <= 41:
        different_text_trigger = "Passive or agressive"
    elif different_text_trigger > 41 and different_text_trigger <= 44:
        different_text_trigger = "Biep Boop"
    elif different_text_trigger > 44 and different_text_trigger <= 47:
        different_text_trigger = "Get ready, to die"
    elif different_text_trigger > 47 and different_text_trigger <= 50:
        different_text_trigger = "The sky is the limit"
    elif different_text_trigger > 50 and different_text_trigger <= 53:
        different_text_trigger = "G3t R34DYYY"
    elif different_text_trigger > 53 and different_text_trigger <= 56:
        different_text_trigger = "Bear waves hi"
    elif different_text_trigger > 56 and different_text_trigger <= 59:
        different_text_trigger = "Hold my beer"
    elif different_text_trigger > 59 and different_text_trigger <= 62:
        different_text_trigger = "On your marks"
    elif different_text_trigger > 62 and different_text_trigger <= 65:
        different_text_trigger = "16bits4bits1bit >"
    elif different_text_trigger > 65 and different_text_trigger <= 68:
        different_text_trigger = "Here we go again.."
    elif different_text_trigger > 68 and different_text_trigger <= 71:
        color = Color.ORANGE
        different_text_trigger = "Respect your elders"
    elif different_text_trigger > 71 and different_text_trigger <= 74:
        different_text_trigger = "Get yourself some coffee"
    elif different_text_trigger > 74 and different_text_trigger <= 77:
        different_text_trigger = "It's gonna be start"
    elif different_text_trigger > 77 and different_text_trigger <= 80:
        different_text_trigger = "stunhack = important"
    elif different_text_trigger > 80 and different_text_trigger <= 83:
        different_text_trigger = "and they say"
    elif different_text_trigger > 83 and different_text_trigger <= 86:
        different_text_trigger = "abcdefghijklmnopqrstufvxyz"
    elif different_text_trigger > 86 and different_text_trigger <= 89:
        different_text_trigger = "Any second now"
    elif different_text_trigger > 89 and different_text_trigger <= 92:
        different_text_trigger = "Have you joined discord?!"
    elif different_text_trigger > 92 and different_text_trigger <= 95:
        different_text_trigger = "Stop right there"
    elif different_text_trigger > 95 and different_text_trigger <= 98:
        different_text_trigger = "Dude"
    elif different_text_trigger > 98 and different_text_trigger <= 100:
        color = Color.SKY_BLUE
        different_text_trigger = "Uhm, Cheesed to meet you?"
    elif different_text_trigger > 100 and different_text_trigger <= 102:
        color = Color.SKY_BLUE
        different_text_trigger = "#!@?/%:3$-__-!??"
    elif different_text_trigger > 102 and different_text_trigger <= 103:
        color = Color.ROSE
        different_text_trigger = "this message = rare!"
    elif different_text_trigger > 103 and different_text_trigger <= 106:
        different_text_trigger = "Version Ow1 2.0 by Bebel, Hikiru & Xponit"
    elif different_text_trigger > 106 and different_text_trigger <= 108:
        color = Color.TURQUOISE
        different_text_trigger = "Any pro's here??"
    elif different_text_trigger > 108 and different_text_trigger <= 110:
        color = Color.TURQUOISE
        different_text_trigger = "no, grass = green"
    elif different_text_trigger > 110 and different_text_trigger <= 112:
        color = Color.YELLOW
        different_text_trigger = "sunflowers"
    elif different_text_trigger > 112 and different_text_trigger <= 114:
        color = Color.YELLOW
        different_text_trigger = ":dbrugL::dbrugR:"
    elif different_text_trigger > 114 and different_text_trigger <= 116:
        color = Color.SKY_BLUE
        different_text_trigger = "WH!!?% R3@LY??! | ¿?¿ | ."
    elif different_text_trigger > 116 and different_text_trigger <= 118:
        color = rgb(255, 125, 125)
        different_text_trigger = "Any royals here??"
    elif different_text_trigger == 119:
        color = Color.LIME_GREEN
        different_text_trigger = "Balls2"
    elif different_text_trigger == 120:
        color = Color.ROSE
        different_text_trigger = "this message = rarer!"
    elif different_text_trigger == 121:
        color = Color.VIOLET
        different_text_trigger = "Where is the shift guys"
    elif different_text_trigger == 122:
        color = Color.RED
        different_text_trigger = "classic gilbert moment"
    elif different_text_trigger == 123:
        color = Color.BLACK
        different_text_trigger = "bishops zigzag rooks go straight and queens do it all"
    elif different_text_trigger > 123 and different_text_trigger <= 128:
        different_text_trigger = "This lobby is home to {0} rounds".format(totalRounds)
    elif different_text_trigger > 128 and different_text_trigger <= 150:
        color = Color.ORANGE
        different_text_trigger = ":disguised_face::metal: yo guys"
    elif different_text_trigger > 150 and different_text_trigger <= 175:
        color = Color.RED
        different_text_trigger = "aou"
    elif different_text_trigger > 175 and different_text_trigger <= 180:
        color = Color.BLUE
        different_text_trigger = "WATER WINS"
    elif different_text_trigger > 180 and different_text_trigger <= 185:
        color = Color.SKY_BLUE
        different_text_trigger = "guys i found mouse trap hard counter"
    elif different_text_trigger > 185 and different_text_trigger <= 190:
        color = Color.BLUE
        different_text_trigger = "Tax the rich"
    elif different_text_trigger > 190 and different_text_trigger <= 195:
        color = Color.RED
        different_text_trigger = "Real estate needs to be controlled"
    elif different_text_trigger > 195 and different_text_trigger <= 200:
        color = Color.RED
        different_text_trigger = "Legalize weed (recreational drugs reference)"
    elif different_text_trigger > 200 and different_text_trigger <= 205:
        color = Color.GREEN
        different_text_trigger = "Free healthcare = human right"
    elif different_text_trigger > 205 and different_text_trigger <= 210:
        color = Color.RED
        different_text_trigger = "Ban guns, **** 2nd amendment."
    elif different_text_trigger > 210 and different_text_trigger <= 215:
        color = Color.RED
        different_text_trigger = "Union busting = ILLEGAL"
    elif different_text_trigger > 215 and different_text_trigger <= 220:
        color = Color.BLUE
        different_text_trigger = "stand for workers rights"
    get_ready_text = different_text_trigger
    wait(0.7)
    get_ready_text = "{0}{1}".format(different_text_trigger, ".")
    wait(0.1)
    get_ready_text = "{0}{1}".format(different_text_trigger, "..")
    wait(0.1)
    get_ready_text = "{0}{1}".format(different_text_trigger, "...")
    wait(0.5)
    get_ready_text = "{0}{1}".format(different_text_trigger, "..")
    wait(0.5)
    get_ready_text = "{0}{1}".format(different_text_trigger, "...")
    wait(0.5)
    get_ready_text = "{0}{1}".format(different_text_trigger, "..")
    wait(0.5)
    get_ready_text = false
    start_text = true
    wait(1.15)
    start_text = false
    color = rgb(215, 215, 215)


rule "Progress bar visuals":
    @Condition timer_progress_bar == true
    
    timer_progress_bar = 0
    chase(timer_progress_bar, 100, duration=3, ChaseReeval.DESTINATION_AND_DURATION)
    wait(3)
    stopChasingVariable(timer_progress_bar)
    wait(1.15)
    timer_progress_bar = false


rule "Corner spawn visuals":
    @Condition corner_timer == true
    
    corner_timer = 3
    #chase(corner_timer, 0, duration=3, ChaseReeval.DESTINATION_AND_DURATION)
    wait(3)
    corner_timer = false
    go_text = true
    wait(1.5)
    go_text = false


rule "Hit by ultimate":
    @Event playerDealtDamage
    @Condition eventAbility == Button.ULTIMATE
    
    damage(victim, attacker, 999999)
    victim.applyImpulse(normalize(vect(vectorTowards(eventPlayer, victim).x, 0, vectorTowards(eventPlayer, victim).z)) + vect(0, 0.25, 0), 15, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 3)

rule "Hit by ultimate HP animation":
    @Event playerDealtDamage
    @Condition eventAbility == Button.ULTIMATE
    
    victim.afterUltHp = 0
    chase(victim.afterUltHp, victim.getMaxHealthOfType(Health.NORMAL), duration=2, ChaseReeval.NONE)
    while victim.getHealthOfType(Health.NORMAL) < victim.getMaxHealthOfType(Health.NORMAL) and getNumberOfLivingPlayers(Team.ALL) == 2:
        victim.setHealth(victim.afterUltHp)
        wait()
    if getNumberOfLivingPlayers(Team.ALL) != 2:
        victim.setHealth(victim.getMaxHealthOfType(Health.NORMAL))
    victim.setMoveSpeed(100)

rule "Ow 1 delay":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setMoveSpeed(0)
    wait(1)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setAmmo(0, 4)

    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)

    waitUntil(not eventPlayer.isUsingUltimate(), 999999)

    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "Ultimate going up bug":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.getPosition().y > 100
    
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)


rule "Ultimate wheel animation":
    @Condition getNumberOfLivingPlayers(Team.ALL) == 2
    @Condition getLivingPlayers(Team.ALL)[0].hasStatusEffect(Status.FROZEN) == true
    
    waitUntil(not getLivingPlayers(Team.ALL)[0].hasStatusEffect(Status.FROZEN), 999999)
    ultimateChargeTimer = 0
    chase(ultimateChargeTimer, 100, duration=2.5, ChaseReeval.NONE)
    while ultimateChargeTimer < 100 and getNumberOfLivingPlayers(Team.ALL) == 2:
        getLivingPlayers(Team.ALL).setUltCharge(ultimateChargeTimer)
        wait()
    getLivingPlayers(Team.ALL).setUltCharge(100)
    stopChasingVariable(ultimateChargeTimer)


rule "Exit ult on round restart":
    @Event eachPlayer
    @Condition kickFromUltimate == true
    @Condition eventPlayer.isUsingUltimate() == true
    
    wait(0.5)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "uppercut ability":
    @Event eachPlayer
    @Condition updateEveryTick(eventPlayer.isUsingAbility2()) == true

    eventPlayer.uppercutHitPlayers = []

    eventPlayer.disablePlayerCollision()
    eventPlayer.setMoveSpeed(0)

    playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_LEAP_SOUND, Color.WHITE, eventPlayer.getPosition(), 100)
    playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_LEAP, Color.WHITE, eventPlayer.getPosition(), 5)

    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -0.01, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setAbility1Enabled(false)

    eventPlayer.disallowButton(Button.ULTIMATE)

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)

    createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET, eventPlayer.getTeam(), eventPlayer, 1, EffectReeval.NONE)
    eventPlayer.uppercuttingEffect = getLastCreatedEntity()

    wait()

    eventPlayer.isUppercutting = true

    eventPlayer.setGravity(0)

    eventPlayer.applyImpulse(eventPlayer.getFacingDirection() * vect(1, 0, 1), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

    waitUntil(eventPlayer.hasStatusEffect(Status.STUNNED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN), 0.05)

    if eventPlayer.hasStatusEffect(Status.STUNNED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN):

        if not eventPlayer.slamRequested0g:
            eventPlayer.setGravity(100)
            
        eventPlayer.cancelPrimaryAction()
        eventPlayer.setMoveSpeed(100)
        eventPlayer.enablePlayerCollision()

        eventPlayer.setSecondaryFireEnabled(true)
        eventPlayer.setMeleeEnabled(true)
        eventPlayer.setAbility1Enabled(true)

        eventPlayer.allowButton(Button.ULTIMATE)
        eventPlayer.allowButton(Button.PRIMARY_FIRE)

        if updateEveryTick(eventPlayer.getAltitude()) <= ALTITUDE:
            eventPlayer.allowButton(Button.ABILITY_1)

        destroyEffect(eventPlayer.uppercuttingEffect)

        eventPlayer.isUppercutting = false
        return
    

    eventPlayer.applyImpulse(vect(0, 1, 0), 40, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

    wait(0.1)

    eventPlayer.isUppercutting = false
    eventPlayer.applyImpulse(vect(0, 1, 0), 5 - updateEveryTick(eventPlayer.getSpeedInDirection(vect(0, 1, 0))), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)

    # eventPlayer.applyImpulse(vect(0, 1, 0), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

    wait(0.23)

    eventPlayer.setGravity(50)

    eventPlayer.cancelPrimaryAction()
    eventPlayer.setMoveSpeed(100)
    eventPlayer.enablePlayerCollision()

    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setAbility1Enabled(true)

    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)

    if eventPlayer.isHoldingButton(Button.ULTIMATE):
        eventPlayer.stopForcingButton(Button.ULTIMATE)
        eventPlayer.startForcingButton(Button.ULTIMATE)
        eventPlayer.holdingUltimate = true

        wait()

        eventPlayer.stopForcingButton(Button.ULTIMATE)

    eventPlayer.holdingUltimate = false

    if updateEveryTick(eventPlayer.getAltitude()) <= ALTITUDE:
        eventPlayer.allowButton(Button.ABILITY_1)

    destroyEffect(eventPlayer.uppercuttingEffect)
    wait(0.5)

    if not eventPlayer.slamRequested0g:
        eventPlayer.setGravity(100)

rule "uppercut hitbox":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isUppercutting == true

    while eventPlayer.isUppercutting == true:
        eventPlayer.uppTickHitPlayers = [localPlayer for localPlayer in updateEveryTick(eventPlayer.getPlayersInViewAngle(getOppositeTeam(eventPlayer.getTeam()), 60)) \
        if not (localPlayer in eventPlayer.uppercutHitPlayers) and distance(eventPlayer, localPlayer) <= 5\
         and isInLoS(eventPlayer, localPlayer, BarrierLos.PASS_THROUGH_BARRIERS)]

        if eventPlayer.uppTickHitPlayers != []:
            eventPlayer.uppercutHitPlayers.append(eventPlayer.uppTickHitPlayers)

            damage(eventPlayer.uppTickHitPlayers, eventPlayer, 50)
            
            eventPlayer.uppTickHitPlayers.upperHitRuleTrigger = true

            eventPlayer.uppTickHitPlayers.applyImpulse(vect(0, 1, 0), 14, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.uppTickHitPlayers.applyImpulse(eventPlayer.getFacingDirection() * vect(1, 0, 1), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

        wait()

rule "uppercut hit":
    @Event eachPlayer
    @Condition eventPlayer.upperHitRuleTrigger == true
    
    eventPlayer.upperHitRuleTrigger = false
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)

    playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT, eventPlayer.getTeam(), eventPlayer, 1)
    playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_RISING_UPPERCUT_IMPACT_SOUND, eventPlayer.getTeam(), eventPlayer.getPosition(), 100)

    wait(0.6, Wait.RESTART_WHEN_TRUE)

    eventPlayer.stopForcingThrottle()


rule "diamond indicator":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true

    /*chase(eventPlayer.slamEndPosition, SLAM_ENDPOS, rate=999999, ChaseReeval.DESTINATION_AND_RATE)
    chase(eventPlayer.nearestSlamEndPosition, nearestWalkablePosition(SLAM_ENDPOS), rate=999999, ChaseReeval.DESTINATION_AND_RATE)*/

    #[eventPlayer if eventPlayer.getAltitude() > ALTITUDE and eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0 and eventPlayer.isUsingUltimate() == false and eventPlayer.isUsingAbility2() == false and eventPlayer.isUppercutting == false and eventPlayer.isFiringSecondaryFire() == false and eventPlayer.isUsingAbility1() == false and eventPlayer.getFacingDirection().y < MAX_UPDWARDS_SLAM_ANGLE and eventPlayer.nearestSlamEndPosition == eventPlayer.slamEndPosition and angleBetweenVectors(eventPlayer.getFacingDirection(), vectorTowards(eventPlayer.getEyePosition(), eventPlayer.slamEndPosition)) < MAX_CORRECTION_ANGLE else null]

    #BOTTOM LINE
    createBeam(eventPlayer if eventPlayer.showIndicator or eventPlayer.slamRequested0g else null, \
    Beam.ORISA_AMPLIFIER, eventPlayer.slamEndPosition + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1),\
    vect(0, 1, 0)) * 0.75) + vect(0, 0.25, 0), eventPlayer.slamEndPosition + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1),\
    vect(0, 1, 0))) * -0.75 + vect(0, 0.25, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    eventPlayer.slamRingDown = getLastCreatedEntity()

    #TOP LINE
    createBeam(eventPlayer if eventPlayer.showIndicator or eventPlayer.slamRequested0g else null, \
    Beam.ORISA_AMPLIFIER, \
    eventPlayer.slamEndPosition + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), \
    vect(0, 1, 0))) * 4.463 + vect(0, 0.25, 0), eventPlayer.slamEndPosition + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 \
    + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * -4.463 + vect(0, 0.25, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    eventPlayer.slamRingUp = getLastCreatedEntity()

    #RIGHT SIDE

    createBeam(eventPlayer if eventPlayer.showIndicator or eventPlayer.slamRequested0g else null, \
    Beam.ORISA_AMPLIFIER, eventPlayer.slamEndPosition + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0)) \
    * 0.75) + vect(0, 0.25, 0), eventPlayer.slamEndPosition + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 \
    + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * 4.463 + vect(0, 0.25, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    eventPlayer.slamRingRight = getLastCreatedEntity()

    #LEFT SIDE

    createBeam(eventPlayer if eventPlayer.showIndicator or eventPlayer.slamRequested0g else null, \
    Beam.ORISA_AMPLIFIER, eventPlayer.slamEndPosition + normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) * 8 \
    + normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * -4.463 + vect(0, 0.25, 0), eventPlayer.slamEndPosition + \
    normalize(crossProduct(eventPlayer.getFacingDirection() * vect(1, 0, 1), vect(0, 1, 0))) * -0.75 + vect(0, 0.25, 0), Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    eventPlayer.slamRingLeft = getLastCreatedEntity()

    waitUntil(eventPlayer.getCurrentHero() != Hero.DOOMFIST or eventPlayer.isDead(), 999999)

    destroyEffect(eventPlayer.slamRingUp)
    destroyEffect(eventPlayer.slamRingRight)
    destroyEffect(eventPlayer.slamRingDown)
    destroyEffect(eventPlayer.slamRingLeft)

rule "delete indicator":
    @Event playerLeft

    destroyEffect(eventPlayer.slamRingUp)
    destroyEffect(eventPlayer.slamRingRight)
    destroyEffect(eventPlayer.slamRingDown)
    destroyEffect(eventPlayer.slamRingLeft)

rule "indicator slam":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.showIndicator == true
    @Condition eventPlayer.slamBeingProcessed == false

    eventPlayer.slamBeingProcessed = true

    eventPlayer.setMoveSpeed(0)
    eventPlayer.setGravity(0)
    eventPlayer.slamRequested0g = true

    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setSecondaryFireEnabled(false)

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.ULTIMATE)

    eventPlayer.applyImpulse(-updateEveryTick(eventPlayer.getVelocity()), updateEveryTick(eventPlayer.getSpeed()), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.slamEndPosition), 25, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)

    wait()

    while distance(eventPlayer.getPosition(), eventPlayer.slamEndPosition) > 0.4 and eventPlayer.isUsingAbility1():
        if eventPlayer.getSpeedInDirection(vectorTowards(eventPlayer.getPosition(), eventPlayer.slamEndPosition)) > FALLING_SLAM_SPEED_LIMIT:
            eventPlayer.stuckStart = eventPlayer.getPosition()
        if distance(eventPlayer.stuckStart, eventPlayer.getPosition()) < 4:
            eventPlayer.applyImpulse(-updateEveryTick(eventPlayer.getVelocity()), updateEveryTick(eventPlayer.getSpeed()), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.slamEndPosition), 30, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        else:
            break
        wait()

    eventPlayer.slamRequested0g = false
    eventPlayer.setGravity(100)

    eventPlayer.applyImpulse(-eventPlayer.getVelocity(), 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

    if eventPlayer.isUsingAbility1():
        waitUntil(eventPlayer.isUsingAbility1() == false, 99999)

    eventPlayer.setMoveSpeed(100)

    eventPlayer.slamBeingProcessed = false

    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setSecondaryFireEnabled(true)

    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.ULTIMATE)

    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.reloading == false:
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
        eventPlayer.holdingPrimary = true

    if eventPlayer.isHoldingButton(Button.ULTIMATE):
        eventPlayer.stopForcingButton(Button.ULTIMATE)
        eventPlayer.startForcingButton(Button.ULTIMATE)
        eventPlayer.holdingUltimate = true

    wait()

    if eventPlayer.holdingPrimary:
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)

    if eventPlayer.holdingUltimate:
        eventPlayer.stopForcingButton(Button.ULTIMATE)

    eventPlayer.holdingPrimary = false
    eventPlayer.holdingUltimate = false

rule "ground slam":
    @Event eachPlayer
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.showIndicator == false
    @Condition eventPlayer.slamBeingProcessed == false

    eventPlayer.slamBeingProcessed = true

    eventPlayer.setMoveSpeed(0)

    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility2Enabled(false)

    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)

    wait()

    eventPlayer.applyImpulse(eventPlayer.getVelocity() * -1, eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)

    eventPlayer.applyImpulse(normalize(eventPlayer.getFacingDirection() * vect(1, 0, 1)) + vect(0, 0.4, 0), 20, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), 999999)

    eventPlayer.setMoveSpeed(100)

    waitUntil(eventPlayer.isUsingAbility1() == false, 999999)

    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility2Enabled(true)

    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.ULTIMATE)

    eventPlayer.slamBeingProcessed = false

    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.reloading == false:
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
        eventPlayer.holdingPrimary = true

    if eventPlayer.isHoldingButton(Button.ULTIMATE):
        eventPlayer.stopForcingButton(Button.ULTIMATE)
        eventPlayer.startForcingButton(Button.ULTIMATE)
        eventPlayer.holdingUltimate = true

    wait()

    if eventPlayer.holdingPrimary:
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)

    if eventPlayer.holdingUltimate:
        eventPlayer.stopForcingButton(Button.ULTIMATE)

    eventPlayer.holdingPrimary = false
    eventPlayer.holdingUltimate = false

rule "ground slam allowance":
    @Event eachPlayer
    @Condition updateEveryTick(eventPlayer.getAltitude()) <= ALTITUDE

    eventPlayer.allowButton(Button.ABILITY_1)

rule "indicator slam":
    @Event eachPlayer
    @Condition updateEveryTick(eventPlayer.getAltitude()) > ALTITUDE
    @Condition eventPlayer.isAlive() == true

    eventPlayer.showIndicator = false

    eventPlayer.tickedFacingDirection = updateEveryTick(eventPlayer.getFacingDirection())
    
    if updateEveryTick(eventPlayer.getAltitude()) > ALTITUDE and eventPlayer.tickedFacingDirection.y < MAX_UPDWARDS_SLAM_ANGLE and eventPlayer.isUppercutting == false and eventPlayer.isUsingAbility1() == false \
    and eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0 and eventPlayer.isUsingUltimate() == false and eventPlayer.isFiringSecondaryFire() == false:
        eventPlayer.slamEndPosition = SLAM_ENDPOS
        eventPlayer.nearestSlamEndPosition = nearestWalkablePosition(SLAM_ENDPOS)
        if eventPlayer.slamEndPosition == eventPlayer.nearestSlamEndPosition \
        and angleBetweenVectors(eventPlayer.tickedFacingDirection, vectorTowards(eventPlayer.getEyePosition(), eventPlayer.slamEndPosition)) < MAX_CORRECTION_ANGLE:
            eventPlayer.allowButton(Button.ABILITY_1)
            eventPlayer.showIndicator = true
        else:
            eventPlayer.disallowButton(Button.ABILITY_1)
    else:
        if updateEveryTick(eventPlayer.getAltitude()) > ALTITUDE:
            eventPlayer.disallowButton(Button.ABILITY_1)
        else:
            eventPlayer.allowButton(Button.ABILITY_1)
            return

    wait()

    goto RULE_START


    # waitUntil(eventPlayer.isUppercutting or updateEveryTick(eventPlayer.getAltitude()) <= ALTITUDE or updateEveryTick(eventPlayer.getFacingDirection().y) >= MAX_UPDWARDS_SLAM_ANGLE or eventPlayer.slamEndPosition != eventPlayer.nearestSlamEndPosition or angleBetweenVectors(eventPlayer.getFacingDirection(), vectorTowards(eventPlayer.getEyePosition(), eventPlayer.slamEndPosition)) >= MAX_CORRECTION_ANGLE, \
    # 999999)

rule "slam knockback":
    @Event playerDealtDamage
    @Condition eventAbility == Button.ABILITY_1

    victim.setStatusEffect(attacker, Status.STUNNED, 2)

    if distance(eventPlayer, victim) < 2.5:
        victim.applyImpulse(normalize(vect(eventPlayer.getFacingDirection().x, 0, eventPlayer.getFacingDirection().z)) + vect(0, 0.5, 0), \
        10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        victim.isCloseSlam = true
        victim.slamMeleeTimer = 0
        chase(victim.slamMeleeTimer, 1.25, duration=1.25, ChaseReeval.NONE)

    else:
        victim.applyImpulse(normalize(vect(vectorTowards(victim, eventPlayer).x, 0, vectorTowards(victim, eventPlayer).z)) + vect(0, 0.5, 0), \
        5 + distance(eventPlayer, victim) / 4, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

rule "start slam timer (REVAMP)":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.slamTimer = 0

    /*
    if eventPlayer.GroundSlam == true:
        eventPlayer.slamTimer = -3.333
        chase(eventPlayer.slamTimer, 125, duration=1.283, ChaseReeval.NONE)
    else:
        eventPlayer.slamTimer = 4.927
        chase(eventPlayer.slamTimer, 125, duration=1.201, ChaseReeval.NONE)
    */

    chase(eventPlayer.slamTimer, 125, duration=1.25, ChaseReeval.NONE)

    wait(0.2)

    waitUntil(eventPlayer.isOnGround() or eventPlayer.isUsingAbility1() == false, 999999)

    stopChasingVariable(eventPlayer.slamTimer)

    eventPlayer.setDamageDealt(eventPlayer.slamTimer / 60 * 100)

    wait(0.35)

    eventPlayer.setDamageDealt(100)

rule "Remove EMP PUNCH from ult":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 4.8)
    waitUntil(not eventPlayer.isUsingUltimate(), 100000000)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setStatusEffect(null, Status.STUNNED, 0.016)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setSecondaryFireEnabled(false)
    wait()
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)

rule "============================================================= HUD THINGS =======================================================":


rule "slam timer hud":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    @Condition eventPlayer.hasSlamTimer == false
    
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)
    hudText(eventPlayer, "", " ", " ", HudPosition.TOP, 0.6, Color.BLUE, Color.BLUE, Color.BLUE, HudReeval.NONE, SpecVisibility.DEFAULT)

    hudText(eventPlayer if eventPlayer.slamTimerVisible else null, "", "{0}".format(round(eventPlayer.slamTimer)), "", HudPosition.TOP, 0.65, Color.BLUE, Color.WHITE, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    
    eventPlayer.hasSlamTimer = true


rule "slam timer visibility":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.slamTimerVisible = true

    wait(0.2)
    waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), 999999)

    eventPlayer.slamTimerVisible = false
    eventPlayer.slamTimerTEXT = true


rule "Final Slam Timer BOLD":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST
    @Condition eventPlayer.slamTimerTEXT == true
    
    #ROUNDING, NORMAL GAMEPLAY
    createInWorldText(eventPlayer if eventPlayer.slamTimerTEXT else null, round(eventPlayer.slamTimer), updateEveryTick(eventPlayer.getEyePosition() \
    + (100 * (SLAM_TIMER_XPOS * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((SLAM_TIMER_YPOS - 0.2) *\
        (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) \
        + 3 * eventPlayer.getFacingDirection()))), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.slamTimerTEXT = getLastCreatedText()
    
    #NO ROUNDING FOR BUG TESTING
    #createInWorldText(eventPlayer if eventPlayer.slamTimerTEXT else null, eventPlayer.slamTimer, updateEveryTick(eventPlayer.getEyePosition() + (100 * (SLAM_TIMER_XPOS * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((SLAM_TIMER_YPOS - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    
    wait(1)
    destroyInWorldText(eventPlayer.slamTimerTEXT)
    eventPlayer.slamTimerTEXT = false

rule "Shoot hack":
    @Event playerDealtDamage
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    victim.setStatusEffect(attacker, Status.HACKED, 1.5)


rule "Stun hack":
    @Event playerDealtDamage
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    if attacker.isUsingAbility1() or (attacker.isHoldingButton(Button.ABILITY_1) and \
                                        attacker.getAbilityCooldown(Button.ABILITY_1) == 0 and\
                                        not attacker.isFiringSecondaryFire() and\
                                        not attacker.isUsingAbility2() and\
                                        not attacker.isUsingUltimate() and\
                                        not attacker.isUppercutting\
                                        not attacker.hasStatusEffect(Status.HACKED) and\
                                        not attacker.hasStatusEffect(Status.STUNNED) and\
                                        not attacker.hasStatusEffect(Status.FROZEN) and\
                                        not attacker.hasStatusEffect(Status.KNOCKED_DOWN)):
        victim.setStatusEffect(attacker, Status.STUNNED, 2)
        victim.setStatusEffect(attacker, Status.HACKED, 2)


rule "Cancel damage":
    @Event playerDealtDamage
    
    if eventAbility != Button.ULTIMATE:
        victim.setHealth(victim.getMaxHealth())


rule "Slower shooting speed":
    @Event eachPlayer
    @Condition eventPlayer.getAmmo(0) == 3
    
    eventPlayer.setPrimaryFireEnabled(false)

    wait(3.28)
    eventPlayer.setAmmo(0, 4)
    if not eventPlayer.isUsingUltimate():
        eventPlayer.setPrimaryFireEnabled(true)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "1v1 mode on":
    @Condition isGameInProgress() == true
    @Condition getNumberOfLivingPlayers(Team.ALL) == 2
    @Condition matchStatus == 1
    @Condition oneVoneMode == false
    @Condition gameIsReady == true
    @Condition corner_used == false
    
    oneVoneMode = true


rule "1v1 mode off":
    @Condition isGameInProgress() == true
    @Condition getNumberOfLivingPlayers(Team.ALL) > 2
    @Condition oneVoneMode == true
    @Condition gameIsReady == true
    
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    oneVoneMode = false


rule "1v1 mode enabled":
    @Condition oneVoneMode == true
    @Condition oneVoneUsed == false
    
    oneVoneUsed = true
    corner_spawning = true
    smallMessage(getAllPlayers(), "Corner Spawning...")
    wait(1)
    corner_timer = true


rule "1v1 mode disabled":
    @Condition oneVoneMode == false
    
    getAllPlayers().setUltCharge(0)
    corner_used = false


rule "Start Round, Ressurect and Teleport":
    @Condition matchStatus == 2
    
    pickCornerDiagonal = random.randint(0, 1)
    pickRandomPlayer[0] = random.randint(0, 1)
    pickRandomPlayer[1] = 1 if pickRandomPlayer[0] == 0 else 0
    if getNumberOfPlayers(Team.ALL) <= 1:
        corner_used = true
    getAllPlayers().active = true
    totalRounds += 1
    if getNumberOfPlayers(Team.ALL) == 2:
        corner_used = true
        corner_spawning = true
        smallMessage(getAllPlayers(), "Corner Spawning...")
        wait(0.25)
        getAllPlayers().resurrect()
        getAllPlayers().setReloadEnabled(false)
        getAllPlayers().setHealth(getAllPlayers()[0].getMaxHealth())
        getAllPlayers().setKnockbackReceived(100)
        oneVoneMode = false
        oneVoneUsed = false
        wait(0.75)
        corner_timer = true
    else:
        circle_spawning = true
        wait(0.5)
        getAllPlayers().resurrect()
        getAllPlayers().setReloadEnabled(false)
        getAllPlayers().setHealth(getAllPlayers()[0].getMaxHealth())
        oneVoneMode = false
        oneVoneUsed = false
        wait(0.5)
        get_ready_text = true
        timer_progress_bar = true
    wait(3)
    matchStatus = 1


rule "End Round, Player Scoring":
    @Condition isGameInProgress() == true
    @Condition getNumberOfLivingPlayers(Team.ALL) <= 1
    @Condition getNumberOfDeadPlayers(Team.ALL) >= 1
    @Condition matchStatus == 1
    
    wait(0.05)
    if len([player for player in getAllPlayers() if player.active == true]) >= 2:
        getAllPlayers().roundsPlayed += 1
        getLivingPlayers(Team.ALL).roundsWon += 1
        if getNumberOfLivingPlayers(Team.ALL) > 0:
            bigMessage(getAllPlayers(), "{0} {1}".format(getLivingPlayers(Team.ALL), " wins!"))
        else:
            bigMessage(getAllPlayers(), "Water wins!")
    getAllPlayers().setUltCharge(0)
    kickFromUltimate = true
    calculateScores = true
    wait(2)
    kickFromUltimate = false
    calculateScores = false
    matchStatus = nextMatchStatus
    corner_used = false
    getAllPlayers().campCount = 0
    setMatchTime(900)


rule "Calculate scores":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition calculateScores == true
    
    eventPlayer.winrate = eventPlayer.roundsWon / eventPlayer.roundsPlayed * 100
    eventPlayer.setScore(eventPlayer.roundsWon)