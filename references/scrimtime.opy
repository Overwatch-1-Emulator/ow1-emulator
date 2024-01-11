settings {
    "main": {
        "description": "ScrimTime v1.43\nStandard Preset\nworkshop.codes/scrimtime\n\nConfigure in Workshop Settings\n\nReady Up: Interact + Reload (Press)\nForce Team Ready: Interact + Reload (Hold)\nAdd Setup Time: Interact + Ultimate\nTeleport to Objective: Interact + Jump\nChange Language: Interact + Crouch",
        "modeName": "ScrimTime"
    },
    "lobby": {
        "mapRotation": "afterGame",
        "spectatorSlots": 12,
        "pauseGameOnDisconnect": true,
        "returnToLobby": "afterGame"
    },
    "gamemodes": {
        "control": {
            "scoreToWin": 3
        },
        "escort": {},
        "hybrid": {},
        "push": {},
        "general": {
            "enableCompetitiveRules": true,
            "gamemodeStartTrigger": "immediately",
            "enableKillCam": false,
            "roleLimit": "1Tank2Offense2Support",
            "enableSkins": false
        }
    },
    "workshop": {
        "Add Setup Time": [
            4
        ],
        "Change Language": [
            7
        ],
        "Command": [
            5
        ],
        "Control Point Progress Increment": 33.3,
        "Defender Teleport": [
            6
        ],
        "Payload Progress Increment": 10,
        "Ready Up Toggle  Force Team Ready": [
            9
        ]
    }
}

#Global variables

globalvar Keybind_ButtonArray 0
globalvar Keybind_Command 1
globalvar Keybind_Ready 2
globalvar Keybind_DefenderTeleport 3
globalvar Keybind_AddSetupTime 4
globalvar Keybind_ChangeLanguage 5
globalvar Text_LanguageTextArray 6
globalvar Text_EnableChangeLanguage 7
globalvar Text_DefaultLanguage 8
globalvar Colour_TeamOne 9
globalvar Colour_TeamTwo 10
globalvar Colour_TextTypeA 11
globalvar Colour_TextTypeB 12
globalvar Colour_TextTypeC 13
globalvar Debug_EnableDebugMode 14
globalvar Debug_DisplayServerLoad 15
globalvar Match_CurrentMatchTime 16
globalvar Setup_RemoveAssemblingHeroes 17
globalvar Setup_SetupTimeOverride 18
globalvar Setup_AllowDefendersTeleport 19
globalvar ReadyUp_FreqMode 20
globalvar ReadyUp_CaptainMode 21
globalvar ReadyUp_EnableReadyVoiceLine 22
globalvar ReadyUp_MinimumPlayersToStart 23
globalvar ReadyUp_SetupCountdownTime 24
globalvar ReadyUp_FreezeSetupTime 25
globalvar ReadyUp_AllowForceTeamReady 26
globalvar ReadyUp_ForceTeamReadyHoldTime 27
globalvar MapComp_EnableMapCompletion 28
globalvar MapComp_ForceNonControlTwoRounds 29
globalvar MapComp_ForceControlThreeRounds 30
globalvar MapComp_TeamOneScore 31
globalvar MapComp_TeamTwoScore 32
globalvar Scoreboard_EnableScoreboard 33
globalvar Scoreboard_StatsPreset 34
globalvar Scoreboard_AllowHideScoreboard 35
globalvar Scoreboard_HideScoreboardID 36
globalvar Scoreboard_DisplayLegend 37
globalvar Scoreboard_GroupMode 38
globalvar Scoreboard_Size 39
globalvar Scoreboard_DisplayMatchTime 40
globalvar SetupAddTime_CaptainMode 41
globalvar SetupAddTime_Step 42
globalvar SetupAddTime_Max 43
globalvar Logs_EnableLogGenerator 44
globalvar Logs_OutputFormat 45
globalvar Logs_AutoMatchEndTime 46
globalvar Logs_CurrentObjectiveIndex 47
globalvar Logs_CurrentControlScoringTeam 48
globalvar Logs_TrackKills 49
globalvar Logs_TrackHeroSwaps 50
globalvar Logs_TrackObjectiveCapture 51
globalvar Logs_PointCaptureProgressStep 52
globalvar Logs_PayloadCaptureProgressStep 53
globalvar Logs_PointCaptureProgress 54
globalvar Logs_PayloadCaptureProgress 55
globalvar Logs_TrackAbilities 56
globalvar Logs_TrackUltimates 57
globalvar Logs_TrackOffensiveAssists 58
globalvar Logs_TrackDefensiveAssists 59
globalvar Logs_TrackDamage 60
globalvar Logs_TrackHealing 61
globalvar Logs_TrackDvaDemechs 62
globalvar Logs_TrackEchoDuplicates 63
globalvar Logs_TrackMercyRez 64
globalvar Logs_TrackRoundStartEnd 65
globalvar Logs_TrackMatchStartEnd 66
globalvar Logs_PlayerSummaryFrequency 67
globalvar Logs_PlayerSummaryCount 68


#Player variables

playervar Text_PlayerLanguage 0
playervar ReadyUp_PlayerReady 1
playervar ReadyUp_CurrentHoldTime 2
playervar Logs_LastHero 3
playervar Logs_LastHeroTime 4
playervar Logs_HeroesPlayedTimeArray 5
playervar Logs_HeroesPlayedArray 6
playervar Logs_OffensiveAssists 7
playervar Logs_DefensiveAssists 8
playervar Logs_CurrentHeroIterator 9
playervar Logs_CurrentHeroIterated 10
playervar Logs_UltimateID 11
playervar Logs_DuplicateID 12


#Subroutine names

subroutine CalcHeroPlayedTime 0


rule "Settings: Language Options":
    Text_EnableChangeLanguage = createWorkshopSetting(bool, "1. Language", "Allow players to change language", true, 0)
    Text_DefaultLanguage = createWorkshopSetting(enum["English", "Korean (한국어)", "Simplified Chinese (简体中文)", "Japanese (**語)", "Spanish (Español)", "French (Français)", "Turkish (Türkçe)"], "1. Language", "Default Language", 0, 0)


rule "Settings: Ready Up Options":
    ReadyUp_FreqMode = createWorkshopSetting(enum["Every Round", "Only Round One", "Off"], "2. Ready Up System", "Enable Ready Up System", 0, 0)
    ReadyUp_CaptainMode = createWorkshopSetting(enum["All Players", "Only Players in First Slot"], "2. Ready Up System", "Who Needs To Ready Up", 0, 1)
    ReadyUp_AllowForceTeamReady = createWorkshopSetting(bool, "2. Ready Up System", "Allow Players to Force Team Ready", true, 2)
    ReadyUp_ForceTeamReadyHoldTime = createWorkshopSetting(int[1:5], "2. Ready Up System", "Force Team Ready Button Hold Time", 3, 3)
    ReadyUp_SetupCountdownTime = createWorkshopSetting(int[5:10], "2. Ready Up System", "Countdown Timer", 5, 4)
    ReadyUp_MinimumPlayersToStart = createWorkshopSetting(int[1:10], "2. Ready Up System", "Minimum Number of Players in Game", 10, 5)
    ReadyUp_FreezeSetupTime = createWorkshopSetting(bool, "2. Ready Up System", "Freeze Setup Timer", false, 6)
    ReadyUp_EnableReadyVoiceLine = createWorkshopSetting(bool, "2. Ready Up System", "Play Voice Line When Readying", true, 7)


rule "Settings: Setup Phase Options":
    Setup_RemoveAssemblingHeroes = createWorkshopSetting(bool, "3. Setup Phase", "Remove Assembling Heroes Phase", true, 0)
    Setup_AllowDefendersTeleport = createWorkshopSetting(bool, "3. Setup Phase", "Allow Defenders to Teleport Between Objective and Spawn", true, 1)
    Setup_SetupTimeOverride = createWorkshopSetting(int[45:300], "3. Setup Phase", "Base Setup Time", 60, 2)
    SetupAddTime_CaptainMode = createWorkshopSetting(enum["All Players", "Only Players in First Slot", "Off"], "3. Setup Phase", "Who Can Add Setup Time", 0, 3)
    SetupAddTime_Step = createWorkshopSetting(int[1:60], "3. Setup Phase", "Setup Time Added", 30, 4)
    SetupAddTime_Max = createWorkshopSetting(int[45:600], "3. Setup Phase", "Setup Time Maximum", 90, 5)


rule "Settings: Map Completion Options":
    MapComp_EnableMapCompletion = createWorkshopSetting(bool, "4. Map Completion", "Ensure Full Map is Attacked on Round 2 for Non-Control Maps", true, 0)
    MapComp_ForceNonControlTwoRounds = createWorkshopSetting(enum["If either team fails to complete map", "Always", "Off"], "4. Map Completion", "End Non-Control Maps After Two Rounds", 0, 1)
    MapComp_ForceControlThreeRounds = createWorkshopSetting(bool, "4. Map Completion", "End Control Maps After Three Rounds", true, 2)


rule "Settings: Spectator Scoreboard Options":
    Scoreboard_EnableScoreboard = createWorkshopSetting(bool, "5. Spectator Scoreboard", "Enable Spectator Scoreboard", true, 0)
    Scoreboard_StatsPreset = createWorkshopSetting(enum["Standard", "Legacy Standard", "Legacy OWL/OWC"], "5. Spectator Scoreboard", "Stats Displayed Preset", 0, 1)
    Scoreboard_Size = createWorkshopSetting(enum["Small", "Medium", "Large"], "5. Spectator Scoreboard", "Size", 0, 2)
    Scoreboard_GroupMode = createWorkshopSetting(enum["Group by role, sort by team", "Group by team, sort by role", "Group by team, sort by slot"], "5. Spectator Scoreboard", "Player Grouping Style", 0, 3)
    Scoreboard_DisplayLegend = createWorkshopSetting(bool, "5. Spectator Scoreboard", "Display Legend", true, 4)
    Scoreboard_DisplayMatchTime = createWorkshopSetting(bool, "5. Spectator Scoreboard", "Display Match Time", true, 5)
    Scoreboard_AllowHideScoreboard = createWorkshopSetting(bool, "5. Spectator Scoreboard", "Allow Host Spectator to Toggle Scoreboard", true, 6)


rule "Settings: Log Options":
    Logs_EnableLogGenerator = createWorkshopSetting(bool, "6. Log Generator", "Enable Log Generator", false, 0)
    Logs_OutputFormat = createWorkshopSetting(enum["CSV"], "6. Log Generator", "Output Format", 0, 1)
    Logs_TrackKills = createWorkshopSetting(bool, "6. Log Generator", "Kills and Deaths", true, 2)
    Logs_TrackOffensiveAssists = createWorkshopSetting(bool, "6. Log Generator", "Offensive Assists", true, 3)
    Logs_TrackDefensiveAssists = createWorkshopSetting(bool, "6. Log Generator", "Defensive Assists", true, 4)
    Logs_TrackHeroSwaps = createWorkshopSetting(bool, "6. Log Generator", "Hero Swaps", true, 5)
    Logs_TrackUltimates = createWorkshopSetting(bool, "6. Log Generator", "Ultimates", true, 6)
    Logs_TrackAbilities = createWorkshopSetting(bool, "6. Log Generator", "Abilities*", true, 7)
    Logs_TrackDamage = createWorkshopSetting(bool, "6. Log Generator", "Damage*", true, 8)
    Logs_TrackHealing = createWorkshopSetting(bool, "6. Log Generator", "Healing*", true, 9)
    Logs_TrackDvaDemechs = createWorkshopSetting(bool, "6. Log Generator", "D.Va Demechs & Remechs", true, 10)
    Logs_TrackEchoDuplicates = createWorkshopSetting(bool, "6. Log Generator", "Echo Duplicates", true, 11)
    Logs_TrackMercyRez = createWorkshopSetting(bool, "6. Log Generator", "Mercy Resurrects", true, 12)
    Logs_TrackMatchStartEnd = createWorkshopSetting(bool, "6. Log Generator", "Match Start & End", true, 13)
    Logs_TrackRoundStartEnd = createWorkshopSetting(bool, "6. Log Generator", "Round Start & End", true, 14)
    Logs_TrackObjectiveCapture = createWorkshopSetting(bool, "6. Log Generator", "Objective Captures", true, 15)
    Logs_PointCaptureProgressStep = createWorkshopSetting(float[0:100], "6. Log Generator", "Control Point Progress Increment", 33.333, 16)
    Logs_PayloadCaptureProgressStep = createWorkshopSetting(float[0:100], "6. Log Generator", "Payload Progress Increment", 10, 17)
    Logs_PlayerSummaryFrequency = createWorkshopSetting(enum["Every Round End", "Only Match End", "Off"], "6. Log Generator", "Player Stat Summary Frequency", 0, 18)


rule "Settings: Keybind Options":
    Keybind_ButtonArray = [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.ULTIMATE, Button.INTERACT, Button.JUMP, Button.CROUCH, Button.MELEE, Button.RELOAD]
    Keybind_Command = Keybind_ButtonArray[createWorkshopSetting(enum["Primary Fire", "Secondary Fire", "Ability 1", "Ability 2", "Ultimate", "Interact", "Jump", "Crouch", "Melee", "Reload"], "7. Keybinds", "Command", 5, 0)]
    Keybind_Ready = Keybind_ButtonArray[createWorkshopSetting(enum["Primary Fire", "Secondary Fire", "Ability 1", "Ability 2", "Ultimate", "Interact", "Jump", "Crouch", "Melee", "Reload"], "7. Keybinds", "Ready Up Toggle / Force Team Ready", 9, 1)]
    Keybind_DefenderTeleport = Keybind_ButtonArray[createWorkshopSetting(enum["Primary Fire", "Secondary Fire", "Ability 1", "Ability 2", "Ultimate", "Interact", "Jump", "Crouch", "Melee", "Reload"], "7. Keybinds", "Defender Teleport", 6, 2)]
    Keybind_AddSetupTime = Keybind_ButtonArray[createWorkshopSetting(enum["Primary Fire", "Secondary Fire", "Ability 1", "Ability 2", "Ultimate", "Interact", "Jump", "Crouch", "Melee", "Reload"], "7. Keybinds", "Add Setup Time", 4, 3)]
    Keybind_ChangeLanguage = Keybind_ButtonArray[createWorkshopSetting(enum["Primary Fire", "Secondary Fire", "Ability 1", "Ability 2", "Ultimate", "Interact", "Jump", "Crouch", "Melee", "Reload"], "7. Keybinds", "Change Language", 7, 4)]


rule "Settings: Debug Options":
    Debug_EnableDebugMode = createWorkshopSetting(bool, "8. Debug", "Enable Debug Mode", false, 0)
    Debug_DisplayServerLoad = createWorkshopSetting(bool, "8. Debug", "Display Server Load", true, 1)
    Logs_AutoMatchEndTime = createWorkshopSetting(int[10:3600], "8. Debug", "Automatically End Match Time", 3600, 2)


rule "Initialisation: Match":
    if not Logs_EnableLogGenerator:
        disableInspector()


rule "Initialisation: Colours":
    Colour_TeamOne = rgb(50, 185, 240)
    Colour_TeamTwo = rgb(250, 5, 30)
    Colour_TextTypeA = rgb(255, 255, 255)
    Colour_TextTypeB = rgb(255, 155, 0)
    Colour_TextTypeC = rgb(40, 205, 60)


rule "Initialisation: Language Strings":
    Text_LanguageTextArray[0] = ["ScrimTime", "ScrimTime", "ScrimTime", "ScrimTime", "ScrimTime", "ScrimTime", "ScrimTime"]
    Text_LanguageTextArray[1] = ["Countdown will start when", "카운트다운 시작 조건", "倒计时将在", "カウントダウンの開始条件", "La cuenta regresiva comenzará cuando", "Le compte à rebours commencera quand", "GERİ SAYIM"]
    Text_LanguageTextArray[2] = ["both teams are ready", "양쪽 팀 모두 준비", "双方队伍准备时开始", "両チームの準備が整い次第", "ambos equipos están listos", "les deux équipes sont prêtes", "HER İKİ TAKIM HAZIR OLDUĞUNDA BAŞLAYACAK"]
    Text_LanguageTextArray[3] = ["all players are ready", "모든 플레이어 준비", "所有玩家已准备时开始", "全員の準備が整い次第", "todos los jugadores están listos", "tous les joueurs sont prêts", "TÜM OYUNCULAR HAZIR OLDUĞUNDA BAŞLAYACAK"]
    Text_LanguageTextArray[4] = ["For full documentation visit", "상세한 지침은 방문해주세요", "有关完整文档请访问", "フルドキュメンテーションは", "Para la documentación completa visita", "Pour une documentation complète visitez", "DAHA FAZLA BİLGİ İÇİN:"]
    Text_LanguageTextArray[5] = ["workshop.codes/scrimtime", "workshop.codes/scrimtime", "workshop.codes/scrimtime", "workshop.codes/scrimtime", "workshop.codes/scrimtime", "workshop.codes/scrimtime", "workshop.codes/scrimtime"]
    Text_LanguageTextArray[6] = ["Import code", "코드 가져 오기", "导入代码", "コードの読み込み", "Importar código", "Importer le code", "ATÖLYE KODU"]
    Text_LanguageTextArray[7] = ["DKEEH", "DKEEH", "DKEEH", "DKEEH", "DKEEH", "DKEEH", "DKEEH"]
    Text_LanguageTextArray[8] = ["You are readied up", "준비 완료 상태입니다", "你已准备就绪", "あなたは準備完了です", "Estás Preparado", "Vous êtes prêt", "HAZIRSIN"]
    Text_LanguageTextArray[9] = ["You are not readied up", "준비되지 않았습니다", "你未准备就绪", "あなたは準備中です", "No estás Preparado", "Vous n'êtes pas prêt", "HAZIR DEĞİLSİN"]
    Text_LanguageTextArray[10] = ["Ready Up", "준비 완료", "准备就绪", "準備完了", "Marcar Preparado", "Prêt", "HAZIR OL"]
    Text_LanguageTextArray[11] = ["Unready", "준비 취소", "取消准备", "準備中", "Desmarcar Preparado", "Pas prêt", "HAZIR DEĞİL"]
    Text_LanguageTextArray[12] = ["(Press) Ready Up / (Hold) Force Team Ready", "(누르기) 준비 완료 / (길게 누르기) 강제 팀 준비", "(按)准备就绪 / (按住)强制队伍准备", "(押して) 準備完了 / (押し続けて) チームを準備完了にする", "(Presione) Preparado / (Mantener presionado) Forzar Equipo Preparado", "(Appuyez) Prêt / (Maintenez) Forcer le prêt de l'équipe", "(BAS) HAZIR OL / (BASILI TUT) TAKIMI ZORLA HAZIRLA"]
    Text_LanguageTextArray[13] = ["(Press) Unready / (Hold) Force Team Ready", "(누르기) 준비 취소 / (길게 누르기) 강제 팀 준비", "(按)取消准备 / (按住)强制队伍准备", "(押して) 準備中 / (押し続けて) チームを準備完了にする", "(Presione) No preparado / (Mantener presionado) Forzar Equipo Preparado", "(Appuyez) Pas prêt / (Maintenez) Forcer la prêt de l'équipe", "(BAS) HAZIR DEĞİL / (BASILI TUT) TAKIMI ZORLA HAZIRLA"]
    Text_LanguageTextArray[14] = ["All players ready, starting countdown", "모두 준비됐습니다, 카운트다운 시작합니다", "所有玩家已准备就绪，开始倒计时", "全員の準備が整いました　カウントダウンを開始します", "Todos los jugadores están listos, comenzando la cuenta regresiva", "Tous les joueurs sont prêts, début du compte à rebours", "TÜM OYUNCULAR HAZIR, GERİ SAYIM BAŞLIYOR"]
    Text_LanguageTextArray[15] = ["Both teams ready, starting countdown", "양 팀 모두 준비됐습니다 카운트다운 시작합니다", "双方队伍都已准备就绪，开始倒计时", "両チームの準備が整いました　カウントダウンを開始します", "Ambos equipos están listos, comenzando la cuenta regresiva", "Les deux équipes sont prêtes, début du compte à rebours", "HER İKİ TAKIM DA HAZIR, GERİ SAYIM BAŞLIYOR"]
    Text_LanguageTextArray[16] = ["All players ready, but not enough players in game ([MIN_PLAYERS_TO_START])", "모든 플레이어가 준비되었지만 게임 플레이어 수가 충분하지 않음 ([MIN_PLAYERS_TO_START] 명 이상 필요)", "所有玩家已准备就绪，但游戏中玩家数不足([MIN_PLAYERS_TO_START])", "すべてのプレイヤーが準備完了していますが、ゲーム内のプレイヤーが足りません ([MIN_PLAYERS_TO_START])", "Todos los jugadores están listos, pero no hay suficientes jugadores en el juego ([MIN_PLAYERS_TO_START])", "Tous les joueurs sont prêts, mais il n'y a pas assez de joueurs dans le jeu ([MIN_PLAYERS_TO_START])", "TÜM OYUNCULAR HAZIR ANCAK OYUNDA YETERLİ SAYIDA OYUNCU YOK ([MIN_PLAYERS_TO_START])"]
    Text_LanguageTextArray[17] = ["Both teams ready, but not enough players in game ([MIN_PLAYERS_TO_START]", "양 팀 모두 준비되었지만 게임 플레이어 수가 충분하지 않음 ([MIN_PLAYERS_TO_START] 명 이상 필요)", "双方队伍都已准备就绪，但游戏中玩家数不足([MIN_PLAYERS_TO_START])", "両チームが準備完了していますが、ゲーム内のプレイヤーが足りません ([MIN_PLAYERS_TO_START])", "Ambos equipos están listos, pero no hay suficientes jugadores en el juego ([MIN_PLAYERS_TO_START]", "Les deux équipes sont prêtes, mais il n'y a pas assez de joueurs dans le jeu ([MIN_PLAYERS_TO_START])", "HER İKİ TAKIM DA HAZIR ANCAK OYUNDA YETERLİ SAYIDA OYUNCU YOK ([MIN_PLAYERS_TO_START])"]
    Text_LanguageTextArray[18] = ["[EVENT_PLAYER] unreadied, setup timer reset", "[EVENT_PLAYER]님이 준비 취소되었습니다 설정 타이머가 다시 시작합니다", "[EVENT_PLAYER] 取消准备，设置计时器重置", "[EVENT_PLAYER] が準備中になったため、マッチ準備時間がリセットされます", "[EVENT_PLAYER] no está preparado, temporizador de configuración reiniciado", "[EVENT_PLAYER] n'est plus prêt, le minuteur est remis à zéro", "[EVENT_PLAYER] HAZIR DEĞİL, HAZIRLIK SÜRESİ SIFIRLANIYOR"]
    Text_LanguageTextArray[19] = ["A team unreadied, setup timer reset", "한 팀이 준비 취소되었습니다 설정 타이머가 다시 시작합니다", "一支队伍取消准备，设置计时器重置", "チームが準備中になり、マッチ準備時間がリセットされます", "Un equipo no está preparado, temporizador de configuración reiniciado", "Une équipe n'est pas prête, le minuteur est remis à zéro", "BİR TAKIM ARTIK HAZIR DEĞİL, HAZIRLIK SÜRESİ SIFIRLANIYOR"]
    Text_LanguageTextArray[20] = ["[EVENT_PLAYER] set all players on [EVENT_PLAYER_TEAM] ready", "[EVENT_PLAYER]가 [EVENT_PLAYER_TEAM]의 모든 플레이어를 준비 상태로 강제로 변경했습니다", "[EVENT_PLAYER] 将所有玩家设置为 [EVENT_PLAYER_TEAM] 准备", "[EVENT_PLAYER] が [EVENT_PLAYER_TEAM] のメンバーを準備完了にしました", "[EVENT_PLAYER] estableció que todos los jugadores de [EVENT_PLAYER_TEAM] están preparados", "[EVENT_PLAYER] a mis tous les joueurs de [EVENT_PLAYER_TEAM] prêts", "[EVENT_PLAYER] [EVENT_PLAYER_TEAM] TAKIMINDAKİ TÜM OYUNCULARI HAZIR HALE GETİRDİ"]
    Text_LanguageTextArray[21] = ["Teleport to the objective", "목표지점으로 순간이동합니다", "传送到目标地点", "目標地点にテレポートします", "Teletransportarse al objetivo", "Téléporter à l'objectif", "HEDEFE IŞINLAN"]
    Text_LanguageTextArray[22] = ["Teleport back to spawn", "스폰 지점으로 순간이동합니다", "传送回重生点", "スポーンにテレポートします", "Teletransportarse de vuelta al spawn", "Téléporter au spawn", "BAŞLANGIÇ NOKTASINA GERİ IŞINLAN"]
    Text_LanguageTextArray[23] = ["Teleported to objective", "목표지점으로 순간이동했습니다", "传送到目标地点", "目標地点にテレポートしました", "Teletransportado al objetivo", "Téléporté à l'objectif", "HEDEFE IŞINLANDI"]
    Text_LanguageTextArray[24] = ["Teleported to spawn", "스폰 지점으로 순간이동했습니다", "传送到重生点", "スポーンにテレポートしました", "Teletransportado al spawn", "Téléporté à l'apparition", "BAŞLANGIÇ NOKTASINA IŞINLANDI"]
    Text_LanguageTextArray[25] = ["Unable to teleport, please try again later", "순간이동이 불가능합니다 나중에 다시 시도해주세요", "无法传送，请稍后重试", "テレポートできません、もう一度試してください", "No se puede teletransportar, inténtalo de nuevo más tarde", "Impossible de se téléporter, veuillez réessayer à un autre moment", "IŞINLANAMIYOR, LÜTFEN DAHA SONRA TEKRAR DENEYİN"]
    Text_LanguageTextArray[26] = ["Add [SETUP_TIME_STEP] sec to setup timer", "설정 타이머에 [SETUP_TIME_STEP] 초를 추가합니다", "将 [SETUP_TIME_STEP] 秒添加到设置计时器中", "マッチ準備時間に[SETUP_TIME_STEP]秒追加します", "Añadir [SETUP_TIME_STEP] segundos al temporizador de configuración", "Ajouter [SETUP_TIME_STEP] sec au minuteur de configuration", "HAZIRLIK SÜRESİNE [SETUP_TIME_STEP] SN EKLE"]
    Text_LanguageTextArray[27] = ["[TEAM_1_CAPTAIN] and [TEAM_2_CAPTAIN] can add [SETUP_TIME_STEP] sec to the setup timer", "[TEAM_1_CAPTAIN]과(와) [TEAM_2_CAPTAIN]은(는) 설정 타이머에 [SETUP_TIME_STEP]초를 추가할 수 있습니다", "[TEAM_1_CAPTAIN] 和 [TEAM_2_CAPTAIN] 可以将 [SETUP_TIME_STEP] 秒添加到设置计时器中", "[TEAM_1_CAPTAIN] と [TEAM_2_CAPTAIN] はマッチ準備時間に[SETUP_TIME_STEP]秒追加できます", "[TEAM_1_CAPTAIN] y [TEAM_2_CAPTAIN] pueden agregar [SETUP_TIME_STEP] segundos al temporizador de configuración", "[TEAM_1_CAPTAIN] et [TEAM_2_CAPTAIN] peuvent ajouter [SETUP_TIME_STEP] sec au minuteur de configuration", "[TEAM_1_CAPTAIN] VE [TEAM_2_CAPTAIN] HAZIRLIK SÜRESİNE [SETUP_TIME_STEP] SN EKLEYEBİLİR"]
    Text_LanguageTextArray[28] = ["[EVENT_PLAYER] added [SETUP_TIME_STEP] sec to setup timer", "[EVENT_PLAYER] 이(가) 설정 타이머에 [SETUP_TIME_STEP]초를 추가했습니다", "[EVENT_PLAYER] 将 [SETUP_TIME_STEP] 秒添加到设置计时器中", "[EVENT_PLAYER] がマッチ準備時間に[SETUP_TIME_STEP]秒追加しました", "[EVENT_PLAYER] agregó [SETUP_TIME_STEP] segundos al temporizador de configuración", "[EVENT_PLAYER] a ajouté [SETUP_TIME_STEP] sec au minuteur de configuration", "[EVENT_PLAYER] HAZIRLIK SÜRESİNE [SETUP_TIME_STEP] SN EKLEDİ"]
    Text_LanguageTextArray[29] = ["Setup timer cannot be extended beyond [SETUP_TIME_MAX]", "설정 타이머는 [SETUP_TIME_MAX] 이상으로 연장할 수 없습니다", "设置计时器不能超过 [SETUP_TIME_MAX]", "マッチ準備時間の限界は [SETUP_TIME_MAX] 秒です、これ以上の延長はできません", "El temporizador de configuración no puede extenderse más allá de [SETUP_TIME_MAX]", "Le minuteur de configuration ne peut pas être prolongé au-delà de [SETUP_TIME_MAX]", "HAZIRLIK SÜRESİ EN FAZLA[SETUP_TIME_MAX] OLABİLİR"]
    Text_LanguageTextArray[30] = ["Setting [ATTACKING_TEAM]'s score to [MAP_COMPLETION_SCORE] to ensure map completion", "[ATTACKING_TEAM]의 점수를 [MAP_COMPLETION_SCORE]로 설정하여 맵 완료를 보장합니다", "将 [ATTACKING_TEAM] 的得分设置为 [MAP_COMPLETION_SCORE]，以确保地图完成", "最終目標まで進めれるように、[ATTACKING_TEAM] のスコアを [MAP_COMPLETION_SCORE] に設定します", "Estableciendo la puntuación del equipo [ATTACKING_TEAM] en [MAP_COMPLETION_SCORE] para asegurar la finalización del mapa", "Définir le score de [ATTACKING_TEAM] à [MAP_COMPLETION_SCORE] pour assurer l'achèvement de la carte", "HARİTANIN TAMAMLANMASI İÇİN [ATTACKING_TEAM] TAKIMININ SKORU [MAP_COMPLETION_SCORE] OLARAK AYARLANDI"]
    Text_LanguageTextArray[31] = ["Both teams completed map, match will proceed as normal", "양 팀 모두 맵을 완료했습니다 매치는 일반적으로 진행됩니다", "双方队伍都完成了地图，比赛将按照正常进行", "両チームが最終目標まで進みました、マッチは通常通りに進行します", "Ambos equipos completaron el mapa, el partido continuará normalmente", "Les deux équipes ont terminé la carte, le match se poursuivra normalement", "HER İKİ TAKIM DA HARİTAYI TAMAMLADI, MAÇ NORMAL ŞEKİLDE DEVAM EDECEK"]
    Text_LanguageTextArray[32] = ["Ending match after two rounds", "2라운드 이후 매치를 종료합니다", "进行两轮比赛后结束比赛", "2ラウンド後にマッチを終了します", "Finalizando el partido después de dos rondas", "Fin de la partie après deux rounds", "İKİ TUR SONUNDA MAÇ SONLANDIRILIYOR"]
    Text_LanguageTextArray[33] = ["Ending match after three rounds", "3라운드 이후 매치를 종료합니다", "进行三轮比赛后结束比赛", "3ラウンド後にマッチを終了します", "Finalizando el partido después de tres rondas", "Fin de la partie après trois rounds", "ÜÇ TUR SONUNDA MAÇ SONLANDIRILIYOR"]
    Text_LanguageTextArray[34] = ["Host toggled scoreboard on", "호스트가 스코어보드를 켰습니다", "主持人打开了记分牌", "ホストがスコアボードをオンにしました", "El anfitrión activó el marcador", "L'hôte a activé le tableau des scores", "YÖNETİCİ SKOR TABLOSUNU AÇTI"]
    Text_LanguageTextArray[35] = ["Host toggled scoreboard off", "호스트가 스코어보드를 껐습니다", "主持人关闭了记分牌", "ホストがスコアボードをオフにしました", "El anfitrión desactivó el marcador", "L'hôte a désactivé le tableau des scores", "YÖNETİCİ SKOR TABLOSUNU KAPATTI"]
    Text_LanguageTextArray[36] = ["● EN   ○ KR   ○ CN   ○ JP   ○ ES   ○ FR   ○ TR", "○ EN   ● KR   ○ CN   ○ JP   ○ ES   ○ FR   ○ TR", "○ EN   ○ KR   ● CN   ○ JP   ○ ES   ○ FR   ○ TR", "○ EN   ○ KR   ○ CN   ● JP   ○ ES   ○ FR   ○ TR", "○ EN   ○ KR   ○ CN   ○ JP   ● ES   ○ FR   ○ TR", "○ EN   ○ KR   ○ CN   ○ JP   ○ ES   ● FR   ○ TR", "○ EN   ○ KR   ○ CN   ○ JP   ○ ES   ○ FR   ● TR"]
    Text_LanguageTextArray[37] = ["Changed language to English", "한국어로 언어 변경됨", "已更改语言为简体中文", "言語が**語に変更されました", "Cambiado el idioma a español", "Langue changée en français", "DİL İNGİLİZCE OLARAK DEĞİŞTİRİLDİ"]
    Text_LanguageTextArray[38] = ["Debug Mode is enabled", "디버그 모드가 활성화되었습니다", "调试模式已启用", "デバッグモードが有効です", "El modo de depuración está habilitado", "Le mode de débuggage est activé", "HATA AYIKLAMA MODU ETKİN"]


rule "Initialisation: Player":
    @Event eachPlayer
    
    eventPlayer.Text_PlayerLanguage = Text_DefaultLanguage
    eventPlayer.ReadyUp_PlayerReady = false
    eventPlayer.Logs_HeroesPlayedArray = []


rule "HUD Setup: Setup Info":
    @Condition ReadyUp_FreqMode != 2
    @Condition (getMatchRound() == 1 or ReadyUp_FreqMode == 0) == true
    @Condition isInSetup() == true
    
    #ScrimTime
    hudSubtext(getAllPlayers(), Text_LanguageTextArray[0][localPlayer.Text_PlayerLanguage], HudPosition.LEFT, 0, Colour_TextTypeB, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #Countdown will start when
    hudSubheader(getAllPlayers(), Text_LanguageTextArray[1][localPlayer.Text_PlayerLanguage], HudPosition.LEFT, 0.1, Colour_TextTypeA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #both teams are ready / all players are ready
    hudSubheader(getAllPlayers(), Text_LanguageTextArray[2][localPlayer.Text_PlayerLanguage] if ReadyUp_CaptainMode == 1 else "{2} [{0}/{1}]".format(len([player for player in getAllPlayers() if player.ReadyUp_PlayerReady]), max(getNumberOfPlayers(Team.ALL), ReadyUp_MinimumPlayersToStart), Text_LanguageTextArray[3][localPlayer.Text_PlayerLanguage]), HudPosition.LEFT, 0.1, Colour_TextTypeA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #Team 1 Header
    hudSubtext(getAllPlayers(), Team.1, HudPosition.LEFT, 1, Colour_TeamOne, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #Team 2 Header
    hudSubtext(getAllPlayers(), Team.2, HudPosition.LEFT, 3, Colour_TeamTwo, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #Import Code
    hudSubheader(getAllPlayers(), "{0}".format(Text_LanguageTextArray[6][localPlayer.Text_PlayerLanguage]), HudPosition.RIGHT, 0, Colour_TextTypeA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #DKEEH
    hudSubheader(getAllPlayers(), "{0}".format(Text_LanguageTextArray[7][localPlayer.Text_PlayerLanguage]), HudPosition.RIGHT, 0.1, Colour_TextTypeB, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #For full documentation visit
    hudSubheader(getAllPlayers(), "{0}".format(Text_LanguageTextArray[4][localPlayer.Text_PlayerLanguage]), HudPosition.RIGHT, 0.2, Colour_TextTypeA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #workshop.codes/scrimtime
    hudSubheader(getAllPlayers(), "{0}".format(Text_LanguageTextArray[5][localPlayer.Text_PlayerLanguage]), HudPosition.RIGHT, 0.3, Colour_TextTypeB, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    if Debug_EnableDebugMode:
        #Debug mode is enabled
        hudSubtext(getAllPlayers(), "{0} {1} {0}".format(iconString(Icon.WARNING), Text_LanguageTextArray[38][localPlayer.Text_PlayerLanguage]), HudPosition.TOP, 6.1, Colour_TextTypeB, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "HUD Setup: Ready Toggle":
    @Event eachPlayer
    @Condition ReadyUp_FreqMode != 2
    @Condition (getMatchRound() == 1 or ReadyUp_FreqMode == 0) == true
    @Condition isInSetup() == true
    
    if ReadyUp_CaptainMode == 0 or ReadyUp_CaptainMode == 1 and eventPlayer.getSlot() == 0:
        #Player Ready Status
        hudSubheader(getAllPlayers(), " {0} {1}".format("●" if eventPlayer.ReadyUp_PlayerReady else "○", eventPlayer), HudPosition.LEFT, (2 if eventPlayer.getTeam() == Team.1 else 4) + eventPlayer.getSlot() * 0.1, Colour_TextTypeC if eventPlayer.ReadyUp_PlayerReady else Colour_TextTypeB, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.ALWAYS)
        #You are readied up / You are not readied up
        hudSubtext(eventPlayer, Text_LanguageTextArray[8][localPlayer.Text_PlayerLanguage] if eventPlayer.ReadyUp_PlayerReady else Text_LanguageTextArray[9][localPlayer.Text_PlayerLanguage], HudPosition.TOP, 5.1, Colour_TextTypeC if eventPlayer.ReadyUp_PlayerReady else Colour_TextTypeB, HudReeval.STRING_AND_COLOR, SpecVisibility.NEVER)
        if ReadyUp_CaptainMode == 0 and ReadyUp_AllowForceTeamReady:
            #(Press) Ready Up / Unready • (Hold) Force Team Ready
            hudSubheader(eventPlayer, "[{0} + {1}] {2}".format(buttonString(Keybind_Command), buttonString(Keybind_Ready), Text_LanguageTextArray[13][localPlayer.Text_PlayerLanguage] if eventPlayer.ReadyUp_PlayerReady else Text_LanguageTextArray[12][localPlayer.Text_PlayerLanguage]), HudPosition.TOP, 5.2, Colour_TextTypeB if eventPlayer.isHoldingButton(Keybind_Command) and eventPlayer.isHoldingButton(Keybind_Ready) else Colour_TextTypeA, HudReeval.STRING_AND_COLOR, SpecVisibility.NEVER)
        else:
            #Ready Up / Unready
            hudSubheader(eventPlayer, "[{0} + {1}] {2}".format(buttonString(Keybind_Command), buttonString(Keybind_Ready), Text_LanguageTextArray[11][localPlayer.Text_PlayerLanguage] if eventPlayer.ReadyUp_PlayerReady else Text_LanguageTextArray[10][localPlayer.Text_PlayerLanguage]), HudPosition.TOP, 5.2, Colour_TextTypeB if eventPlayer.isHoldingButton(Keybind_Command) and eventPlayer.isHoldingButton(Keybind_Ready) else Colour_TextTypeA, HudReeval.STRING_AND_COLOR, SpecVisibility.NEVER)


rule "HUD Setup: Force Ready Hold Bar":
    @Event eachPlayer
    @Condition ReadyUp_FreqMode != 2
    @Condition ReadyUp_AllowForceTeamReady == true
    
    progressBarHud(eventPlayer if eventPlayer.ReadyUp_CurrentHoldTime >= 0.2 else null, eventPlayer.ReadyUp_CurrentHoldTime / ReadyUp_ForceTeamReadyHoldTime * 100, null, HudPosition.TOP, 5.5, Colour_TextTypeA, null, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.NEVER)


rule "HUD Setup: Defender Teleport":
    @Event eachPlayer
    @Condition Setup_AllowDefendersTeleport == true
    @Condition isInSetup() == true
    @Condition getCurrentGamemode() != Gamemode.PUSH
    @Condition isTeamOnDefense(eventPlayer.getTeam()) == true
    
    #Teleport to the objective / Teleport back to spawn
    hudSubheader(eventPlayer, "[{0} + {1}] {2}".format(buttonString(Keybind_Command), buttonString(Keybind_DefenderTeleport), Text_LanguageTextArray[21][localPlayer.Text_PlayerLanguage] if eventPlayer.isInSpawnRoom() else Text_LanguageTextArray[22][localPlayer.Text_PlayerLanguage]), HudPosition.TOP, 5.3, Colour_TextTypeB if eventPlayer.isHoldingButton(Keybind_Command) and eventPlayer.isHoldingButton(Keybind_DefenderTeleport) else Colour_TextTypeA, HudReeval.STRING_AND_COLOR, SpecVisibility.NEVER)


rule "HUD Setup: Add Setup Time":
    @Event eachPlayer
    @Condition ReadyUp_FreqMode != 2
    @Condition (getMatchRound() == 1 or ReadyUp_FreqMode == 0) == true
    @Condition SetupAddTime_CaptainMode != 2
    @Condition isInSetup() == true
    
    if eventPlayer.getSlot() == 0 or SetupAddTime_CaptainMode == 0:
        #Add {0} sec to setup timer
        hudSubheader(eventPlayer, "[{0} + {1}] {2}".format(buttonString(Keybind_Command), buttonString(Keybind_AddSetupTime), Text_LanguageTextArray[26][localPlayer.Text_PlayerLanguage].replace("[SETUP_TIME_STEP]", SetupAddTime_Step)), HudPosition.TOP, 5.4, Colour_TextTypeB if eventPlayer.isHoldingButton(Keybind_Command) and eventPlayer.isHoldingButton(Keybind_AddSetupTime) else Colour_TextTypeA, HudReeval.STRING_AND_COLOR, SpecVisibility.NEVER)
    else:
        #Add {0} sec to setup timer
        hudSubheader(eventPlayer, Text_LanguageTextArray[27][localPlayer.Text_PlayerLanguage].replace("[TEAM_1_CAPTAIN]", "{0}".format(getPlayersInSlot(0, Team.1))).replace("[TEAM_2_CAPTAIN]", "{0}".format(getPlayersInSlot(0, Team.2))).replace("[SETUP_TIME_STEP]", SetupAddTime_Step), HudPosition.TOP, 5.4, Colour_TextTypeA, HudReeval.STRING, SpecVisibility.NEVER)


rule "HUD Setup: Change Language":
    @Event eachPlayer
    @Condition Text_EnableChangeLanguage == true
    @Condition isInSetup() == true
    
    #○ EN   ○ KR   ○ CN   ○ JP   ○ ES   ○ FR   ○ TR
    hudSubheader(eventPlayer, "[{0} + {1}] {2}".format(buttonString(Keybind_Command), buttonString(Keybind_ChangeLanguage), Text_LanguageTextArray[36][eventPlayer.Text_PlayerLanguage]), HudPosition.TOP, 5.5, Colour_TextTypeB if eventPlayer.isHoldingButton(Keybind_Command) and eventPlayer.isHoldingButton(Keybind_ChangeLanguage) else Colour_TextTypeA, HudReeval.STRING_AND_COLOR, SpecVisibility.NEVER)


rule "Setup: Remove Assembling Heroes":
    @Condition Setup_RemoveAssemblingHeroes == true
    @Condition isAssemblingHeroes() == true
    
    setMatchTime(0)


rule "Setup: Override Setup Time":
    @Condition isInSetup() == true
    
    wait()
    setMatchTime(Setup_SetupTimeOverride)


rule "Setup: Freeze Setup Time":
    @Condition ReadyUp_FreqMode != 2
    @Condition ReadyUp_FreezeSetupTime == true
    @Condition (getMatchRound() == 1 or ReadyUp_FreqMode == 0) == true
    @Condition isInSetup() == true
    
    pauseMatchTime()


rule "Setup: Add Setup Time":
    @Event eachPlayer
    @Condition ReadyUp_FreqMode != 2
    @Condition (getMatchRound() == 1 or ReadyUp_FreqMode == 0) == true
    @Condition SetupAddTime_CaptainMode != 2
    @Condition isInSetup() == true
    @Condition (eventPlayer.getSlot() == 0 or SetupAddTime_CaptainMode == 0) == true
    @Condition eventPlayer.isHoldingButton(Keybind_Command) == true
    @Condition eventPlayer.isHoldingButton(Keybind_AddSetupTime) == true
    
    if getMatchTime() < SetupAddTime_Max:
        if isInSetup():
            setMatchTime(min(SetupAddTime_Max + 0.9, SetupAddTime_Step + getMatchTime()))
            smallMessage(getAllPlayers(), Text_LanguageTextArray[28][localPlayer.Text_PlayerLanguage].replace("[SETUP_TIME_STEP]", SetupAddTime_Step).replace("[EVENT_PLAYER]", "{0}".format(eventPlayer)))
    else:
        #Setup timer cannot be extended beyond [SETUP_TIME_MAX]
        smallMessage(eventPlayer, Text_LanguageTextArray[29][localPlayer.Text_PlayerLanguage].replace("[SETUP_TIME_MAX]", "{0}:{1}{2}".format(floor(SetupAddTime_Max / 60), "0" if SetupAddTime_Max % 60 < 10 else "", floor(SetupAddTime_Max % 60))))


rule "Setup: Teleport to Objective/Spawn (Defenders Only)":
    @Event eachPlayer
    @Condition Setup_AllowDefendersTeleport == true
    @Condition getCurrentGamemode() != Gamemode.PUSH
    @Condition isTeamOnDefense(eventPlayer.getTeam()) == true
    @Condition isInSetup() == true
    @Condition eventPlayer.isHoldingButton(Keybind_Command) == true
    @Condition eventPlayer.isHoldingButton(Keybind_DefenderTeleport) == true
    
    if eventPlayer.isInSpawnRoom():
        if nearestWalkablePosition(getObjectivePosition(getCurrentObjective())) != null:
            eventPlayer.teleport(nearestWalkablePosition(getObjectivePosition(getCurrentObjective())))
            #Teleported to objective
            smallMessage(eventPlayer, "{0}".format(Text_LanguageTextArray[23][localPlayer.Text_PlayerLanguage]))
        else:
            #Unable to teleport, please try again later
            smallMessage(eventPlayer, "{0}".format(Text_LanguageTextArray[25][localPlayer.Text_PlayerLanguage]))
    else:
        eventPlayer.teleport(getSpawnPoints(eventPlayer.getTeam()))
        #Teleported to spawn
        smallMessage(eventPlayer, "{0}".format(Text_LanguageTextArray[24][localPlayer.Text_PlayerLanguage]))


rule "Setup: Change Player Language":
    @Event eachPlayer
    @Condition Text_EnableChangeLanguage == true
    @Condition isInSetup() == true
    @Condition eventPlayer.isHoldingButton(Keybind_Command) == true
    @Condition eventPlayer.isHoldingButton(Keybind_ChangeLanguage) == true
    
    eventPlayer.Text_PlayerLanguage = (eventPlayer.Text_PlayerLanguage + 1) % len(Text_LanguageTextArray[0])
    #Changed language to English
    smallMessage(eventPlayer, Text_LanguageTextArray[37][eventPlayer.Text_PlayerLanguage])


rule "Setup: Toggle Player Ready / Force Team Ready":
    @Event eachPlayer
    @Condition ReadyUp_FreqMode != 2
    @Condition (getMatchRound() == 1 or ReadyUp_FreqMode == 0) == true
    @Condition (eventPlayer.getSlot() == 0 or ReadyUp_CaptainMode == 0) == true
    @Condition isInSetup() == true
    @Condition eventPlayer.isHoldingButton(Keybind_Command) == true
    @Condition eventPlayer.isHoldingButton(Keybind_Ready) == true
    
    if ReadyUp_CaptainMode == 0 and ReadyUp_AllowForceTeamReady:
        eventPlayer.ReadyUp_CurrentHoldTime = 0
        chase(eventPlayer.ReadyUp_CurrentHoldTime, ReadyUp_ForceTeamReadyHoldTime, duration=ReadyUp_ForceTeamReadyHoldTime, ChaseReeval.NONE)
        waitUntil(not (eventPlayer.isHoldingButton(Keybind_Command) and eventPlayer.isHoldingButton(Keybind_Ready)), ReadyUp_ForceTeamReadyHoldTime)
        stopChasingVariable(eventPlayer.ReadyUp_CurrentHoldTime)
        eventPlayer.ReadyUp_CurrentHoldTime = 0
        if eventPlayer.isHoldingButton(Keybind_Command) and eventPlayer.isHoldingButton(Keybind_Ready):
            if isInSetup():
                #[EVENT_PLAYER] set all players on [EVENT_PLAYER_TEAM] ready
                smallMessage(getAllPlayers(), Text_LanguageTextArray[20][localPlayer.Text_PlayerLanguage].replace("[EVENT_PLAYER]", "{0}".format(eventPlayer)).replace("[EVENT_PLAYER_TEAM]", "{0}".format(eventPlayer.getTeam())))
                getPlayers(eventPlayer.getTeam()).ReadyUp_PlayerReady = true
                if ReadyUp_EnableReadyVoiceLine:
                    eventPlayer.communicate(Comms.GO)
            return
    if eventPlayer.ReadyUp_PlayerReady:
        eventPlayer.ReadyUp_PlayerReady = false
    else:
        eventPlayer.ReadyUp_PlayerReady = true
        if ReadyUp_EnableReadyVoiceLine:
            eventPlayer.communicate(Comms.READY)


rule "Setup: Both Teams Ready, Start Match (Captain-Only Mode)":
    @Condition ReadyUp_FreqMode != 2
    @Condition ReadyUp_CaptainMode == 1
    @Condition (getMatchRound() == 1 or ReadyUp_FreqMode == 0) == true
    @Condition isInSetup() == true
    @Condition getPlayersInSlot(0, Team.1).ReadyUp_PlayerReady == true
    @Condition getPlayersInSlot(0, Team.2).ReadyUp_PlayerReady == true
    
    if getNumberOfPlayers(Team.ALL) < ReadyUp_MinimumPlayersToStart:
        #Both teams ready, but not enough players in game ([MIN_PLAYERS_TO_START])
        smallMessage(getAllPlayers(), Text_LanguageTextArray[17][localPlayer.Text_PlayerLanguage].replace("[MIN_PLAYERS_TO_START]", ReadyUp_MinimumPlayersToStart))
        return
    #Both teams ready, starting countdown
    smallMessage(getAllPlayers(), Text_LanguageTextArray[15][localPlayer.Text_PlayerLanguage])
    if ReadyUp_FreezeSetupTime:
        unpauseMatchTime()
    setMatchTime(ReadyUp_SetupCountdownTime)
    waitUntil(getPlayersInSlot(0, Team.1).ReadyUp_PlayerReady == false or getPlayersInSlot(0, Team.2).ReadyUp_PlayerReady == false, ReadyUp_SetupCountdownTime)
    if isInSetup() and getPlayersInSlot(0, Team.1).ReadyUp_PlayerReady == false or getPlayersInSlot(0, Team.2).ReadyUp_PlayerReady == false:
        #A team unreadied, setup timer reset
        smallMessage(getAllPlayers(), Text_LanguageTextArray[19][localPlayer.Text_PlayerLanguage])
        if ReadyUp_FreezeSetupTime:
            pauseMatchTime()
        setMatchTime(Setup_SetupTimeOverride)


rule "Setup: Both Teams Ready, Start Match (All Players Mode)":
    @Condition ReadyUp_FreqMode != 2
    @Condition ReadyUp_CaptainMode == 0
    @Condition (getMatchRound() == 1 or ReadyUp_FreqMode == 0) == true
    @Condition isInSetup() == true
    @Condition all([player.ReadyUp_PlayerReady for player in getAllPlayers()]) == true
    
    if getNumberOfPlayers(Team.ALL) < ReadyUp_MinimumPlayersToStart:
        #All players ready, but not enough players in game ([MIN_PLAYERS_TO_START])
        smallMessage(getAllPlayers(), Text_LanguageTextArray[16][localPlayer.Text_PlayerLanguage].replace("[MIN_PLAYERS_TO_START]", ReadyUp_MinimumPlayersToStart))
        return
    #All players ready, starting countdown
    smallMessage(getAllPlayers(), Text_LanguageTextArray[14][localPlayer.Text_PlayerLanguage])
    if ReadyUp_FreezeSetupTime:
        unpauseMatchTime()
    setMatchTime(ReadyUp_SetupCountdownTime)
    waitUntil(len([player for player in getAllPlayers() if player.ReadyUp_PlayerReady == true]) < len(getAllPlayers()), ReadyUp_SetupCountdownTime)
    if isInSetup() and len([player for player in getAllPlayers() if player.ReadyUp_PlayerReady == true]) < len(getAllPlayers()):
        #[EVENT_PLAYER] unreadied, setup timer reset
        smallMessage(getAllPlayers(), Text_LanguageTextArray[18][localPlayer.Text_PlayerLanguage].replace("[EVENT_PLAYER]", ([player for player in getAllPlayers() if player.ReadyUp_PlayerReady == false])[0]))
        if ReadyUp_FreezeSetupTime:
            pauseMatchTime()
        setMatchTime(Setup_SetupTimeOverride)


rule "Game: Clean Up HUD Text":
    while true:
        waitUntil(isGameInProgress(), 99999)
        destroyAllHudTexts()
        waitUntil(isMatchBetweenRounds(), 99999)
        destroyAllHudTexts()


rule "Game: Reset Player Ready Status":
    @Condition ReadyUp_FreqMode != 2
    @Condition isGameInProgress() == true
    
    wait()
    getAllPlayers().ReadyUp_PlayerReady = false
    stopChasingVariable(getAllPlayers().ReadyUp_CurrentHoldTime)
    getAllPlayers().ReadyUp_CurrentHoldTime = 0


rule "Scoreboard: Update Match Time":
    Match_CurrentMatchTime = 0
    while true:
        waitUntil(isGameInProgress(), 99999)
        chase(Match_CurrentMatchTime, 99999, rate=1, ChaseReeval.NONE)
        waitUntil(not isGameInProgress(), 99999)
        stopChasingVariable(Match_CurrentMatchTime)


rule "Scoreboard: Create Match Time Display":
    @Condition Scoreboard_DisplayMatchTime == true
    @Condition isGameInProgress() == true
    
    wait()
    if Scoreboard_Size == 0:
        hudSubheader(null, "{0} Match Time: {1}".format(abilityIconString(Hero.LUCIO, Button.ABILITY_2), "{0}:{1}{2}".format(floor(Match_CurrentMatchTime / 60), "0" if Match_CurrentMatchTime % 60 < 10 else "", floor(Match_CurrentMatchTime % 60))), HudPosition.LEFT, 4, Colour_TextTypeA, HudReeval.STRING, SpecVisibility.ALWAYS)
    else:
        hudSubtext(null, "{0} Match Time: {1}".format(abilityIconString(Hero.LUCIO, Button.ABILITY_2), "{0}:{1}{2}".format(floor(Match_CurrentMatchTime / 60), "0" if Match_CurrentMatchTime % 60 < 10 else "", floor(Match_CurrentMatchTime % 60))), HudPosition.LEFT, 4, Colour_TextTypeA, HudReeval.STRING, SpecVisibility.ALWAYS)


rule "Scoreboard A (Standard): Create Legend":
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_DisplayLegend == true
    @Condition Scoreboard_StatsPreset == 0
    
    wait()
    if Scoreboard_Size == 0:
        if Scoreboard_GroupMode == 0:
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • DD • DT • ACC • UU"), HudPosition.LEFT, 1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • DD • DT • DB • UU"), HudPosition.LEFT, 2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • DD • DT • HD • UU"), HudPosition.LEFT, 3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
        else:
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • DD • DT • ACC • UU"), HudPosition.LEFT, 1.1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • DD • DT • DB • UU"), HudPosition.LEFT, 1.2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • DD • DT • HD • UU"), HudPosition.LEFT, 1.3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
    else:
        if Scoreboard_GroupMode == 0:
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • DD • DT • ACC • UU"), HudPosition.LEFT, 1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • DD • DT • DB • UU"), HudPosition.LEFT, 2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • DD • DT • HD • UU"), HudPosition.LEFT, 3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
        else:
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • DD • DT • ACC • UU"), HudPosition.LEFT, 1.1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • DD • DT • DB • UU"), HudPosition.LEFT, 1.2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • DD • DT • HD • UU"), HudPosition.LEFT, 1.3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)


rule "Scoreboard A (Standard): Create Player Entries (Small)":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_Size == 0
    @Condition Scoreboard_StatsPreset == 0
    
    wait()
    if Scoreboard_GroupMode == 0:
        hudSubheader(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else "{0}%".format(round(eventPlayer.getHeroStatistic(eventPlayer.getCurrentHero(), HeroStat.WEAPON_ACCURACY) * 100)), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, (1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) + (0.1 if eventPlayer.getTeam() == Team.1 else 0.2), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    elif Scoreboard_GroupMode == 1:
        hudSubheader(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else "{0}%".format(round(eventPlayer.getHeroStatistic(eventPlayer.getCurrentHero(), HeroStat.WEAPON_ACCURACY) * 100)), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, ((1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) * 0.1) + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    else:
        hudSubheader(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else "{0}%".format(round(eventPlayer.getHeroStatistic(eventPlayer.getCurrentHero(), HeroStat.WEAPON_ACCURACY) * 100)), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, eventPlayer.getSlot() * 0.1 + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)


rule "Scoreboard A (Standard): Create Player Entries (Medium)":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_Size == 1
    @Condition Scoreboard_StatsPreset == 0
    
    wait()
    if Scoreboard_GroupMode == 0:
        hudSubtext(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else "{0}%".format(round(eventPlayer.getHeroStatistic(eventPlayer.getCurrentHero(), HeroStat.WEAPON_ACCURACY) * 100)), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, (1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) + (0.1 if eventPlayer.getTeam() == Team.1 else 0.2), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    elif Scoreboard_GroupMode == 1:
        hudSubtext(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else "{0}%".format(round(eventPlayer.getHeroStatistic(eventPlayer.getCurrentHero(), HeroStat.WEAPON_ACCURACY) * 100)), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, ((1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) * 0.1) + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    else:
        hudSubtext(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else "{0}%".format(round(eventPlayer.getHeroStatistic(eventPlayer.getCurrentHero(), HeroStat.WEAPON_ACCURACY) * 100)), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, eventPlayer.getSlot() * 0.1 + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)


rule "Scoreboard A (Standard): Create Player Entries (Large)":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_Size == 2
    @Condition Scoreboard_StatsPreset == 0
    
    wait()
    if Scoreboard_GroupMode == 0:
        hudText(null, heroIcon(eventPlayer.getCurrentHero()), eventPlayer, "{1} • {2}".format("{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else "{0}%".format(round(eventPlayer.getHeroStatistic(eventPlayer.getCurrentHero(), HeroStat.WEAPON_ACCURACY) * 100)), eventPlayer.getStatistic(Stat.ULTIMATES_USED)), null), HudPosition.LEFT, (1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) + (0.1 if eventPlayer.getTeam() == Team.1 else 0.2), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TextTypeA, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    elif Scoreboard_GroupMode == 1:
        hudText(null, heroIcon(eventPlayer.getCurrentHero()), eventPlayer, "{1} • {2}".format("{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else "{0}%".format(round(eventPlayer.getHeroStatistic(eventPlayer.getCurrentHero(), HeroStat.WEAPON_ACCURACY) * 100)), eventPlayer.getStatistic(Stat.ULTIMATES_USED)), null), HudPosition.LEFT, ((1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) * 0.1) + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TextTypeA, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    else:
        hudText(null, heroIcon(eventPlayer.getCurrentHero()), eventPlayer, "{1} • {2}".format("{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else "{0}%".format(round(eventPlayer.getHeroStatistic(eventPlayer.getCurrentHero(), HeroStat.WEAPON_ACCURACY) * 100)), eventPlayer.getStatistic(Stat.ULTIMATES_USED)), null), HudPosition.LEFT, eventPlayer.getSlot() * 0.1 + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TextTypeA, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)


rule "Scoreboard B (Legacy Standard): Create Legend":
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_DisplayLegend == true
    @Condition Scoreboard_StatsPreset == 1
    
    wait()
    if Scoreboard_Size == 0:
        if Scoreboard_GroupMode == 0:
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • DD • DT • OA • UU"), HudPosition.LEFT, 1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • DD • DT • DB • UU"), HudPosition.LEFT, 2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • HP • DT • OA • UU"), HudPosition.LEFT, 3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
        else:
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • DD • DT • OA • UU"), HudPosition.LEFT, 1.1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • DD • DT • DB • UU"), HudPosition.LEFT, 1.2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • HP • DT • OA • UU"), HudPosition.LEFT, 1.3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
    else:
        if Scoreboard_GroupMode == 0:
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • DD • DT • OA • UU"), HudPosition.LEFT, 1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • DD • DT • DB • UU"), HudPosition.LEFT, 2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • HP • DT • OA • UU"), HudPosition.LEFT, 3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
        else:
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • DD • DT • OA • UU"), HudPosition.LEFT, 1.1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • DD • DT • DB • UU"), HudPosition.LEFT, 1.2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • HP • DT • OA • UU"), HudPosition.LEFT, 1.3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)


rule "Scoreboard B (Legacy Standard): Create Player Entries (Small)":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_Size == 0
    @Condition Scoreboard_StatsPreset == 1
    
    wait()
    if Scoreboard_GroupMode == 0:
        hudSubheader(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, (1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) + (0.1 if eventPlayer.getTeam() == Team.1 else 0.2), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    elif Scoreboard_GroupMode == 1:
        hudSubheader(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, ((1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) * 0.1) + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    else:
        hudSubheader(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, eventPlayer.getSlot() * 0.1 + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)


rule "Scoreboard B (Legacy Standard): Create Player Entries (Medium)":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_Size == 1
    @Condition Scoreboard_StatsPreset == 1
    
    wait()
    if Scoreboard_GroupMode == 0:
        hudSubtext(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, (1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) + (0.1 if eventPlayer.getTeam() == Team.1 else 0.2), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    elif Scoreboard_GroupMode == 1:
        hudSubtext(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, ((1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) * 0.1) + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    else:
        hudSubtext(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, eventPlayer.getSlot() * 0.1 + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)


rule "Scoreboard B (Legacy Standard): Create Player Entries (Large)":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_Size == 2
    @Condition Scoreboard_StatsPreset == 1
    
    wait()
    if Scoreboard_GroupMode == 0:
        hudText(null, heroIcon(eventPlayer.getCurrentHero()), eventPlayer, "{1} • {2}".format(null, "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, (1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) + (0.1 if eventPlayer.getTeam() == Team.1 else 0.2), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TextTypeA, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    elif Scoreboard_GroupMode == 1:
        hudText(null, heroIcon(eventPlayer.getCurrentHero()), eventPlayer, "{1} • {2}".format(null, "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, ((1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) * 0.1) + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TextTypeA, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    else:
        hudText(null, heroIcon(eventPlayer.getCurrentHero()), eventPlayer, "{1} • {2}".format(null, "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, eventPlayer.getSlot() * 0.1 + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TextTypeA, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)


rule "Scoreboard C (Legacy OWL/OWC): Create Legend":
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_DisplayLegend == true
    @Condition Scoreboard_StatsPreset == 2
    
    wait()
    if Scoreboard_Size == 0:
        if Scoreboard_GroupMode == 0:
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • E • DD • DT • UU"), HudPosition.LEFT, 1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • E • DD • DT • UU"), HudPosition.LEFT, 2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • E • DD • HP • UU"), HudPosition.LEFT, 3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
        else:
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • E • DD • DT • UU"), HudPosition.LEFT, 1.1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • E • DD • DT • UU"), HudPosition.LEFT, 1.2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubheader(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • E • DD • HP • UU"), HudPosition.LEFT, 1.3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
    else:
        if Scoreboard_GroupMode == 0:
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • E • DD • DT • UU"), HudPosition.LEFT, 1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • E • DD • DT • UU"), HudPosition.LEFT, 2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • E • DD • HP • UU"), HudPosition.LEFT, 3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
        else:
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.GENJI, Button.ULTIMATE), "K • D • E • DD • DT • UU"), HudPosition.LEFT, 1.1, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), "K • D • E • DD • DT • UU"), HudPosition.LEFT, 1.2, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)
            hudSubtext(null, "{0} {1}".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_1), "K • D • E • DD • HP • UU"), HudPosition.LEFT, 1.3, Colour_TextTypeA, HudReeval.NONE, SpecVisibility.ALWAYS)


rule "Scoreboard C (Legacy OWL/OWC): Create Player Entries (Small)":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_Size == 0
    @Condition Scoreboard_StatsPreset == 2
    
    wait()
    if Scoreboard_GroupMode == 0:
        hudSubheader(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), eventPlayer.getStatistic(Stat.ELIMINATIONS)), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT)), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, (1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) + (0.1 if eventPlayer.getTeam() == Team.1 else 0.2), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    elif Scoreboard_GroupMode == 1:
        hudSubheader(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, ((1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) * 0.1) + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    else:
        hudSubheader(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, eventPlayer.getSlot() * 0.1 + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)


rule "Scoreboard C (Legacy OWL/OWC): Create Player Entries (Medium)":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_Size == 1
    @Condition Scoreboard_StatsPreset == 2
    
    wait()
    if Scoreboard_GroupMode == 0:
        hudSubtext(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, (1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) + (0.1 if eventPlayer.getTeam() == Team.1 else 0.2), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    elif Scoreboard_GroupMode == 1:
        hudSubtext(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, ((1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) * 0.1) + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    else:
        hudSubtext(null, "{0} {1} • {2}".format(heroIcon(eventPlayer.getCurrentHero()), "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, eventPlayer.getSlot() * 0.1 + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)


rule "Scoreboard C (Legacy OWL/OWC): Create Player Entries (Large)":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_Size == 2
    @Condition Scoreboard_StatsPreset == 2
    
    wait()
    if Scoreboard_GroupMode == 0:
        hudText(null, heroIcon(eventPlayer.getCurrentHero()), eventPlayer, "{1} • {2}".format(null, "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), eventPlayer.getStatistic(Stat.ELIMINATIONS)), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT)), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, (1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) + (0.1 if eventPlayer.getTeam() == Team.1 else 0.2), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TextTypeA, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    elif Scoreboard_GroupMode == 1:
        hudText(null, heroIcon(eventPlayer.getCurrentHero()), eventPlayer, "{1} • {2}".format(null, "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, ((1 if eventPlayer.getCurrentHero() in getDamageHeroes() else 2 if eventPlayer.getCurrentHero() in getTankHeroes() else 3) * 0.1) + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TextTypeA, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    else:
        hudText(null, heroIcon(eventPlayer.getCurrentHero()), eventPlayer, "{1} • {2}".format(null, "{0} • {1} • {2}".format(eventPlayer.getStatistic(Stat.FINAL_BLOWS), eventPlayer.getStatistic(Stat.DEATHS), round(eventPlayer.getStatistic(Stat.HEALING_DEALT)) if eventPlayer.getCurrentHero() in getSupportHeroes() else round(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT))), "{0} • {1} • {2}".format(round(eventPlayer.getStatistic(Stat.DAMAGE_TAKEN)), round(eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)) if eventPlayer.getCurrentHero() in getTankHeroes() else eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS), eventPlayer.getStatistic(Stat.ULTIMATES_USED))), HudPosition.LEFT, eventPlayer.getSlot() * 0.1 + (2 if eventPlayer.getTeam() == Team.1 else 3), Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TeamOne if eventPlayer.getTeam() == Team.1 else Colour_TeamTwo, Colour_TextTypeA, HudReeval.SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)


rule "Scoreboard: Host Spectator Toggle":
    @Condition Scoreboard_EnableScoreboard == true
    @Condition Scoreboard_AllowHideScoreboard == true
    @Condition isGameInProgress() == true
    @Condition hostPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition hostPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition hostPlayer.getTeam() == Team.ALL
    
    if Scoreboard_HideScoreboardID == null:
        #Host Toggled Scoreboard Off
        smallMessage(getAllPlayers(), Text_LanguageTextArray[35][localPlayer.Text_PlayerLanguage])
        hudSubtext(null, " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", HudPosition.LEFT, 0, Colour_TextTypeA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
        Scoreboard_HideScoreboardID = getLastCreatedText()
    else:
        #Host Toggled Scoreboard On
        smallMessage(getAllPlayers(), Text_LanguageTextArray[34][localPlayer.Text_PlayerLanguage])
        destroyHudText(Scoreboard_HideScoreboardID)
        Scoreboard_HideScoreboardID = null


rule "Map Completion: Save Team Scores on Round End":
    @Condition getCurrentGamemode() != Gamemode.CONTROL
    @Condition isMatchBetweenRounds() == true
    
    if isTeamOnOffense(Team.1):
        MapComp_TeamOneScore = teamScore(Team.1)
    else:
        MapComp_TeamTwoScore = teamScore(Team.2)


rule "Map Completion: Ensure Map Completion (Non-Control)":
    @Condition MapComp_EnableMapCompletion == true
    @Condition isMatchBetweenRounds() == true
    @Condition getCurrentGamemode() != Gamemode.CONTROL
    @Condition (teamScore(Team.1 if isTeamOnOffense(Team.1) else Team.2)) < (2 if getCurrentGamemode() == Gamemode.ASSAULT else 3)
    
    wait()
    if getCurrentGamemode() == Gamemode.ASSAULT:
        smallMessage(getAllPlayers(), (Text_LanguageTextArray[30][localPlayer.Text_PlayerLanguage].replace("[ATTACKING_TEAM]", Team.1 if isTeamOnOffense(Team.1) else Team.2)).replace("[MAP_COMPLETION_SCORE]", 2 + 0))
        setTeamScore(Team.1 if isTeamOnOffense(Team.1) else Team.2, 2)
    else:
        smallMessage(getAllPlayers(), (Text_LanguageTextArray[30][localPlayer.Text_PlayerLanguage].replace("[ATTACKING_TEAM]", Team.1 if isTeamOnOffense(Team.1) else Team.2)).replace("[MAP_COMPLETION_SCORE]", 3 + 0))
        setTeamScore(Team.1 if isTeamOnOffense(Team.1) else Team.2, 3)


rule "Map Completion: Force Match End After Two Rounds (Non-Control)":
    @Condition MapComp_ForceNonControlTwoRounds != 2
    @Condition getCurrentGamemode() != Gamemode.CONTROL
    @Condition isMatchBetweenRounds() == true
    @Condition getMatchRound() == 2
    
    if MapComp_ForceNonControlTwoRounds == 0 and (MapComp_TeamOneScore + MapComp_TeamTwoScore == (4 if getCurrentGamemode() == Gamemode.ASSAULT else 6)):
        #Both teams completed map, match will proceed as normal
        smallMessage(getAllPlayers(), Text_LanguageTextArray[31][localPlayer.Text_PlayerLanguage])
    else:
        #Ending match after two rounds
        smallMessage(getAllPlayers(), Text_LanguageTextArray[32][localPlayer.Text_PlayerLanguage])
        wait(1)
        declareDraw()


rule "Map Completion: Force Match End After Three Rounds (Control)":
    @Condition MapComp_ForceControlThreeRounds == true
    @Condition getCurrentGamemode() == Gamemode.CONTROL
    @Condition teamScore(Team.1) + teamScore(Team.2) == 3
    
    #Ending match after three rounds
    smallMessage(getAllPlayers(), Text_LanguageTextArray[33][localPlayer.Text_PlayerLanguage])
    wait(1)
    declareTeamVictory(Team.1 if teamScore(Team.1) > teamScore(Team.2) else Team.2)


rule "Logs: Match Start":
    @Condition Logs_EnableLogGenerator == true
    @Condition getMatchRound() == 1
    
    if Logs_TrackMatchStartEnd:
        printLog(",match_start,{0},{1}".format("{0},{1},{2}".format(Match_CurrentMatchTime, getCurrentMap(), getCurrentGamemode()), "{0},{1}".format(Team.1, Team.2)))


rule "Logs: Round Start":
    @Condition Logs_EnableLogGenerator == true
    @Condition isInSetup() == true
    
    Logs_CurrentControlScoringTeam = Team.ALL
    Logs_CurrentObjectiveIndex = getCurrentObjective()
    if Logs_TrackRoundStartEnd == true:
        printLog(",round_start,{0},{1},{2}".format("{0},{1},{2}".format(Match_CurrentMatchTime, getMatchRound(), (Team.1 if isTeamOnOffense(Team.1) else Team.2) if getCurrentGamemode() != Gamemode.CONTROL else null), "{0},{1}".format(teamScore(Team.1), teamScore(Team.2)), "{0}".format(getCurrentObjective())))
        waitUntil(isGameInProgress(), 99999)
        printLog(",setup_complete,{0}".format("{0},{1},{2}".format(Match_CurrentMatchTime, getMatchRound(), getMatchTime())))


rule "Logs: Round Complete":
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackRoundStartEnd == true
    @Condition isMatchBetweenRounds() == true
    
    printLog(",round_end,{0},{1},{2}".format("{0},{1},{2}".format(Match_CurrentMatchTime, getMatchRound(), (Team.1 if isTeamOnOffense(Team.1) else Team.2) if getCurrentGamemode() != Gamemode.CONTROL else null), "{0},{1}".format(teamScore(Team.1), teamScore(Team.2)), "{0},{1},{2}".format(getCurrentObjective(), "{0},{1}".format(getControlScorePercentage(Team.1), getControlScorePercentage(Team.2)), getMatchTime())))


rule "Logs: Match Complete":
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackMatchStartEnd == true
    @Condition isMatchComplete() == true
    
    printLog(",match_end,{0},{1},{2}".format("{0},{1}".format(Match_CurrentMatchTime, getMatchRound()), "{0}".format(teamScore(Team.1)), "{0}".format(teamScore(Team.2))))


rule "Logs: Control Point Increment":
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_PointCaptureProgressStep > 0
    @Condition isGameInProgress() == true
    @Condition getCapturePercentage() >= Logs_PointCaptureProgress + Logs_PointCaptureProgressStep
    
    printLog(",point_progress,{0},{1}".format("{0},{1}".format(Match_CurrentMatchTime, getMatchRound()), "{0},{1},{2}".format(getOppositeTeam(getControlScoringTeam()) if getCurrentGamemode() == Gamemode.CONTROL else Team.1 if isTeamOnOffense(Team.1) else Team.2, getCurrentObjective(), getCapturePercentage())))
    Logs_PointCaptureProgress += Logs_PointCaptureProgressStep


rule "Logs: Payload Increment":
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_PayloadCaptureProgressStep > 0
    @Condition isGameInProgress() == true
    @Condition getPayloadProgressPercentage() >= Logs_PayloadCaptureProgress + Logs_PayloadCaptureProgressStep
    
    printLog(",payload_progress,{0},{1}".format("{0},{1}".format(Match_CurrentMatchTime, getMatchRound()), "{0},{1},{2}".format(Team.1 if isTeamOnOffense(Team.1) else Team.2, getCurrentObjective(), getPayloadProgressPercentage())))
    Logs_PayloadCaptureProgress += Logs_PayloadCaptureProgressStep


rule "Logs: Reset Control Point Progress":
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_PointCaptureProgressStep > 0
    @Condition isGameInProgress() == true
    @Condition getCapturePercentage() == 0
    
    Logs_PointCaptureProgress = 0


rule "Logs: Reset Payload Progress":
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_PayloadCaptureProgressStep > 0
    @Condition isGameInProgress() == true
    @Condition getPayloadProgressPercentage() == 0
    
    Logs_PayloadCaptureProgress = 0


rule "Logs: Objective Captured (Non-Control)":
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackObjectiveCapture == true
    @Condition getCurrentGamemode() != Gamemode.CONTROL
    @Condition isObjectiveComplete(Logs_CurrentObjectiveIndex) == true
    
    printLog(",objective_captured,{0},{1},{2}".format("{0},{1}".format(Match_CurrentMatchTime, getMatchRound()), "{0},{1}".format(Team.1 if isTeamOnOffense(Team.1) else Team.2, getCurrentObjective()), "{0},{1},{2}".format(null, null, getMatchTime())))
    Logs_CurrentObjectiveIndex = getCurrentObjective()


rule "Logs: Objective Captured (Control)":
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackObjectiveCapture == true
    @Condition isGameInProgress() == true
    @Condition getCurrentGamemode() == Gamemode.CONTROL
    @Condition getControlScoringTeam() != Logs_CurrentControlScoringTeam
    
    printLog(",objective_captured,{0},{1},{2}".format("{0},{1}".format(Match_CurrentMatchTime, getMatchRound()), "{0},{1}".format(getControlScoringTeam(), getCurrentObjective()), "{0},{1},{2}".format(getControlScorePercentage(Team.1), getControlScorePercentage(Team.2), getMatchTime())))
    Logs_CurrentControlScoringTeam = getControlScoringTeam()


rule "Logs: Kills":
    @Event playerDied
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackKills == true
    @Condition isGameInProgress() == true
    
    printLog(",kill,{0},{1}".format(Match_CurrentMatchTime, "{0},{1},{2}".format("{0},{1},{2}".format(attacker.getTeam(), attacker, attacker.getCurrentHero()), "{0},{1},{2}".format(victim.getTeam(), victim, victim.getCurrentHero()), "{0},{1},{2}".format("{0},{1}".format(eventAbility, eventDamage), eventWasCriticalHit, eventWasEnvironment))))


rule "Logs: Hero Spawn/Swap":
    @Event eachPlayer
    @Condition Logs_EnableLogGenerator == true
    @Condition (Logs_TrackHeroSwaps or Logs_PlayerSummaryCount != 2) == true
    @Condition eventPlayer.getCurrentHero() != eventPlayer.Logs_LastHero
    @Condition isMatchComplete() == false
    
    if Logs_TrackHeroSwaps and eventPlayer.getCurrentHero() in getAllHeroes():
        if eventPlayer.Logs_LastHero in getAllHeroes():
            printLog(",hero_swap,{0},{1},{2}".format(Match_CurrentMatchTime, "{0},{1}".format(eventPlayer.getTeam(), eventPlayer), "{0},{1},{2}".format(eventPlayer.getCurrentHero(), eventPlayer.Logs_LastHero, Match_CurrentMatchTime - eventPlayer.Logs_LastHeroTime)))
        else:
            printLog(",hero_spawn,{0},{1},{2}".format(Match_CurrentMatchTime, "{0},{1}".format(eventPlayer.getTeam(), eventPlayer), "{0},{1},{2}".format(eventPlayer.getCurrentHero(), eventPlayer.Logs_LastHero, Match_CurrentMatchTime - eventPlayer.Logs_LastHeroTime)))
    if not eventPlayer.getCurrentHero() in eventPlayer.Logs_HeroesPlayedArray and eventPlayer.getCurrentHero() in getAllHeroes():
        eventPlayer.Logs_HeroesPlayedArray.append(eventPlayer.getCurrentHero())
    if eventPlayer.getCurrentHero() in getAllHeroes() and eventPlayer.Logs_LastHero in getAllHeroes():
        CalcHeroPlayedTime()
    eventPlayer.Logs_LastHero = eventPlayer.getCurrentHero()
    eventPlayer.Logs_LastHeroTime = Match_CurrentMatchTime


def CalcHeroPlayedTime():
    @Name "Logs: Calculate Hero Played Time (Subroutine)"
    
    eventPlayer.Logs_HeroesPlayedTimeArray[eventPlayer.Logs_HeroesPlayedArray.index(eventPlayer.Logs_LastHero)] += Match_CurrentMatchTime - eventPlayer.Logs_LastHeroTime


rule "Logs: Damage":
    @Event playerDealtDamage
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackDamage == true
    @Condition isGameInProgress() == true
    
    printLog(",damage,{0},{1}".format(Match_CurrentMatchTime, "{0},{1},{2}".format("{0},{1},{2}".format(attacker.getTeam(), attacker, attacker.getCurrentHero()), "{0},{1},{2}".format(victim.getTeam(), victim, victim.getCurrentHero()), "{0},{1},{2}".format("{0},{1}".format(eventAbility, eventDamage), eventWasCriticalHit, eventWasEnvironment))))


rule "Logs: Healing":
    @Event playerReceivedHealing
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackHealing == true
    @Condition isGameInProgress() == true
    
    printLog(",healing,{0},{1}".format(Match_CurrentMatchTime, "{0},{1},{2}".format("{0},{1},{2}".format(healer.getTeam(), healer, healer.getCurrentHero()), "{0},{1},{2}".format(healee.getTeam(), healee, healee.getCurrentHero()), "{0},{1},{2}".format(eventAbility, eventHealing, eventWasHealthPack))))


rule "Logs: Offensive Assists":
    @Event eachPlayer
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackOffensiveAssists == true
    @Condition eventPlayer.Logs_OffensiveAssists < eventPlayer.getStatistic(Stat.OFFENSIVE_ASSISTS)
    @Condition isGameInProgress() == true
    
    printLog(",offensive_assist,{0},{1},{2}".format("{0}".format(Match_CurrentMatchTime), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0}".format(eventPlayer.getHeroOfDuplication())))
    eventPlayer.Logs_OffensiveAssists += 1
    if RULE_CONDITION:
        goto RULE_START


rule "Logs: Defensive Assists":
    @Event eachPlayer
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackDefensiveAssists == true
    @Condition eventPlayer.Logs_DefensiveAssists < eventPlayer.getStatistic(Stat.DEFENSIVE_ASSISTS)
    @Condition isGameInProgress() == true
    
    printLog(",defensive_assist,{0},{1},{2}".format("{0}".format(Match_CurrentMatchTime), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0}".format(eventPlayer.getHeroOfDuplication())))
    eventPlayer.Logs_DefensiveAssists += 1
    if RULE_CONDITION:
        goto RULE_START


rule "Logs: Ability 1 Used":
    @Event eachPlayer
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackAbilities == true
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition isGameInProgress() == true
    
    printLog(",ability_1_used,{0},{1},{2}".format("{0}".format(Match_CurrentMatchTime), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0}".format(eventPlayer.getHeroOfDuplication())))


rule "Logs: Ability 2 Used":
    @Event eachPlayer
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackAbilities == true
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition isGameInProgress() == true
    
    printLog(",ability_2_used,{0},{1},{2}".format("{0}".format(Match_CurrentMatchTime), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0}".format(eventPlayer.getHeroOfDuplication())))


rule "Logs: Ultimate Charged":
    @Event eachPlayer
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackUltimates == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition isGameInProgress() == true
    
    eventPlayer.Logs_UltimateID += 1
    if eventPlayer.getCurrentHero() == Hero.DVA and eventPlayer.isInAlternateForm() and Logs_TrackDvaDemechs:
        printLog(",remech_charged,{0},{1},{2}".format("{0}".format(Match_CurrentMatchTime), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0},{1}".format(eventPlayer.getHeroOfDuplication(), eventPlayer.Logs_UltimateID)))
    else:
        printLog(",ultimate_charged,{0},{1},{2}".format("{0}".format(Match_CurrentMatchTime), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0},{1}".format(eventPlayer.getHeroOfDuplication(), eventPlayer.Logs_UltimateID)))


rule "Logs: Ultimate Used":
    @Event eachPlayer
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackUltimates == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getCurrentHero() != Hero.DVA
    @Condition isGameInProgress() == true
    
    printLog(",ultimate_start,{0},{1},{2}".format("{0}".format(Match_CurrentMatchTime), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0},{1}".format(eventPlayer.getHeroOfDuplication(), eventPlayer.Logs_UltimateID)))
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    printLog(",ultimate_end,{0},{1},{2}".format("{0}".format(Match_CurrentMatchTime), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0},{1}".format(eventPlayer.getHeroOfDuplication(), eventPlayer.Logs_UltimateID)))


rule "Logs: D.Va Remech/Self-Destruct Used":
    @Event eachPlayer
    @Condition Logs_EnableLogGenerator == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getCurrentHero() == Hero.DVA
    @Condition isGameInProgress() == true
    
    wait(1.74)
    if Logs_TrackDvaDemechs and not eventPlayer.isInAlternateForm():
        printLog(",dva_remech,{0},{1},{2}".format("{0}".format(Match_CurrentMatchTime), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0}".format(eventPlayer.Logs_UltimateID)))
    elif Logs_TrackUltimates:
        printLog(",ultimate_start,{0},{1},{2}".format("{0}".format(Match_CurrentMatchTime), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0},{1}".format(eventPlayer.getHeroOfDuplication(), eventPlayer.Logs_UltimateID)))
        waitUntil(not eventPlayer.isUsingUltimate(), 99999)
        printLog(",ultimate_end,{0},{1},{2}".format("{0}".format(Match_CurrentMatchTime), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0},{1}".format(eventPlayer.getHeroOfDuplication(), eventPlayer.Logs_UltimateID)))


rule "Logs: Echo Duplicate":
    @Event eachPlayer
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackEchoDuplicates == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isDuplicatingAHero() == true
    
    eventPlayer.Logs_DuplicateID = eventPlayer.Logs_UltimateID
    printLog(",echo_duplicate_start,{0},{1},{2}".format(Match_CurrentMatchTime, "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), "{0},{1}".format(eventPlayer.getHeroOfDuplication(), eventPlayer.Logs_DuplicateID)))
    waitUntil(not eventPlayer.isDuplicatingAHero(), 99999)
    printLog(",echo_duplicate_end,{0},{1},{2}".format(Match_CurrentMatchTime, "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()), eventPlayer.Logs_DuplicateID))


rule "Logs: Mercy Resurrect":
    @Event eachPlayer
    @Condition Logs_EnableLogGenerator == true
    @Condition Logs_TrackMercyRez == true
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isDead() == true
    
    waitUntil(eventPlayer.isAlive(), 99999)
    wait(0.24)
    if not eventPlayer.isInSpawnRoom() and isGameInProgress():
        printLog(",mercy_rez,{0},{1}".format(Match_CurrentMatchTime, "{0},{1}".format("{0},{1},{2}".format(eventPlayer.getTeam(), getPlayersOnHero(Hero.MERCY, eventPlayer.getTeam()), Hero.MERCY), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.getCurrentHero()))))


rule "Logs: Player Stat Summary":
    @Event eachPlayer
    @Condition Logs_EnableLogGenerator == true
    @Condition (Logs_PlayerSummaryFrequency == 0 or Logs_PlayerSummaryFrequency == 1 and isMatchComplete()) == true
    @Condition isMatchBetweenRounds() == true
    
    CalcHeroPlayedTime()
    eventPlayer.Logs_LastHero = eventPlayer.getCurrentHero()
    eventPlayer.Logs_LastHeroTime = Match_CurrentMatchTime
    for eventPlayer.Logs_CurrentHeroIterator in range(len(eventPlayer.Logs_HeroesPlayedArray)):
        eventPlayer.Logs_CurrentHeroIterated = eventPlayer.Logs_HeroesPlayedArray[eventPlayer.Logs_CurrentHeroIterator]
        printLog(",player_stat,{0},{1},{2}".format("{0},{1}".format(Match_CurrentMatchTime, getMatchRound()), "{0},{1},{2}".format(eventPlayer.getTeam(), eventPlayer, eventPlayer.Logs_CurrentHeroIterated), "{0},{1}".format("{0},{1},{2}".format("{0},{1},{2}".format("{0},{1},{2}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.ELIMINATIONS), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.FINAL_BLOWS), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.DEATHS)), "{0},{1},{2}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.DAMAGE_DEALT), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.BARRIER_DAMAGE_DEALT), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.HERO_DAMAGE_DEALT)), "{0},{1},{2}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.HEALING_DEALT), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.HEALING_RECEIVED), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.SELF_HEALING))), "{0},{1},{2}".format("{0},{1}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.DAMAGE_TAKEN), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.DAMAGE_BLOCKED)), "{0},{1}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.DEFENSIVE_ASSISTS), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.OFFENSIVE_ASSISTS)), "{0},{1}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.ULTIMATES_EARNED), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.ULTIMATES_USED))), "{0},{1}".format("{0},{1},{2}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.MULTIKILL_BEST), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.MULTIKILLS), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.SOLO_KILLS)), "{0},{1},{2}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.OBJECTIVE_KILLS), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.ENVIRONMENTAL_KILLS), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.ENVIRONMENTAL_DEATHS)))), "{0},{1}".format("{0},{1},{2}".format("{0},{1}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.CRITICAL_HITS), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.CRITICAL_HIT_ACCURACY)), "{0},{1},{2}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.SCOPED_ACCURACY), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.SCOPED_CRITICAL_HIT_ACCURACY), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.SCOPED_CRITICAL_HIT_KILLS)), "{0},{1},{2}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.SHOTS_FIRED), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.SHOTS_HIT), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.SHOTS_MISSED))), "{0},{1}".format("{0},{1},{2}".format(eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.SCOPED_SHOTS), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.SCOPED_HITS), eventPlayer.getHeroStatistic(eventPlayer.Logs_CurrentHeroIterated, HeroStat.WEAPON_ACCURACY)), eventPlayer.Logs_HeroesPlayedTimeArray[eventPlayer.Logs_CurrentHeroIterator])))))
    Logs_PlayerSummaryCount += 1


rule "Debug: Force Ready (Interact + Ability 1)":
    @Event eachPlayer
    @Condition Debug_EnableDebugMode == true
    @Condition isInSetup() == true
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition hostPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    getAllPlayers().ReadyUp_PlayerReady = true


rule "Debug: Reduce Timer to 5 (Interact + Alt Fire)":
    @Event eachPlayer
    @Condition Debug_EnableDebugMode == true
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition hostPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    setMatchTime(5)


rule "Debug: Spawn Test Bot (Interact + Melee)":
    @Condition Debug_EnableDebugMode == true
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == true
    
    createDummy(Hero.REAPER, getOppositeTeam(hostPlayer.getTeam()), -1, hostPlayer.getPosition(), vect(0, 0, 0))


rule "Debug: Automatically End Match":
    @Condition Debug_EnableDebugMode == true
    @Condition Logs_AutoMatchEndTime < 3600
    
    wait(Logs_AutoMatchEndTime)
    declareTeamVictory(Team.ALL)


rule "Debug: Display Server Loads":
    @Condition Debug_EnableDebugMode == true
    @Condition Debug_DisplayServerLoad == true
    @Condition isGameInProgress() == true
    
    wait()
    hudSubheader(getAllPlayers(), "{0} Current Server Load\r\n{1} Average Server Load\r\n{2} Peak Server Load".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), HudPosition.LEFT, 100, Colour_TextTypeA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)


