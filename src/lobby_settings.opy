#!mainFile "main.opy"

settings {
    "main": {
        "description": \
"Overwatch 1 Emulator v0.8.4 (staging build)\r\n\
\r\n\
ecksdee#11729's attempt to accurately recreate \r\n\
the last version of Overwatch 1 using workshop.\r\n\
\r\n\
Main build: KHTG0\r\n\
Staging build: ESMXJ\r\n\
\r\n\
Dev Team:\r\n\
ecksdee#11729\r\n\
Snappy#11809\r\n\
KingDonMike#2694\r\n\
thenova#21104\r\n\
pretz#11551\r\n\
\r\n\
Gamemode:\r\n\
workshop.codes/ow1-emulator\r\n\
\r\n\
Discord:\r\n\
dsc.gg/ow1\r\n\
discord.gg/GMVqwYXbWB\r\n\
\r\n\
Source code:\r\n\
github.com/MaxwellJung/ow1_emulator",
        "modeName": "Overwatch 1 Emulator"
    },
    "lobby": {
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "spectatorSlots": 12,
        "team1Slots": 6,
        "team2Slots": 6,
        "returnToLobby": "never",
        "teamBalancing": "afterGame"
    },
    "gamemodes": {
        "assault": {
            "enabledMaps": [
                "hanamura",
                "horizonLunarColony",
                "paris",
                "templeOfAnubis",
                "volskaya"
            ]
        },
        "control": {
            "enabledMaps": [
                {
                    "busan": [
                        "morning"
                    ]
                },
                {
                    "ilios": [
                        "morning"
                    ]
                },
                {
                    "lijiangTower": [
                        "night"
                    ]
                },
                {
                    "nepal": [
                        "morning"
                    ]
                },
                {
                    "oasis": [
                        "evening"
                    ]
                }
            ]
        },
        "escort": {
            "enabledMaps": [
                {
                    "dorado": [
                        "night"
                    ]
                },
                {
                    "havana": [
                        "morning"
                    ]
                },
                "rialto",
                {
                    "route66": [
                        "morning"
                    ]
                },
				{
                    "watchpointGibraltar": [
                        "evening"
                    ]
                }
            ]
        },
        "hybrid": {
            "enabledMaps": [
                {
                    "blizzWorld": [
                        "morning"
                    ]
                },
                {
                    "eichenwalde": [
                        "morning"
                    ]
                },
                {
                    "hollywood": [
                        "morning"
                    ]
                },
                {
                    "kingsRow": [
                        "night"
                    ]
                },
                "numbani"
            ]
        },
        "practiceRange": {
            "enabledMaps": []
        },
        "general": {
            "heroLimit": "1PerTeam",
            "roleLimit": "off",
            "tankPassiveHealthBonus": "alwaysEnabled",
            "enableCompetitiveRules": true
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "ultGen%": percent(OW2_ANA_ULT_COST/OW1_ANA_ULT_COST)
            },
            "ashe": {
                "ultGen%": percent(OW2_ASHE_ULT_COST/OW1_ASHE_ULT_COST)
            },
            "baptiste": {
                "ultGen%": percent(OW2_BAPTISTE_ULT_COST/OW1_BAPTISTE_ULT_COST)
            },
            "bastion": {
                "ultGen%": percent(OW2_BASTION_ULT_COST/OW1_BASTION_ULT_COST)
            },
            "brigitte": {
                "health%": percent(OW1_BRIGITTE_BARRIER_HEALTH/OW2_BRIGITTE_BARRIER_HEALTH), # for barrier hp
                "ultGen%": percent(OW2_BRIGITTE_ULT_COST/OW1_BRIGITTE_ULT_COST)
            },
            "mccree": {
                "ultGen%": percent(OW2_MCCREE_ULT_COST/OW1_MCCREE_ULT_COST)
            },
            "doomfist": {
                "ammoRegenerationTime%": 162,
            },
            "dva": {
                "secondaryFireMaximumTime%": 67,
                "ultGen%": percent(OW2_DVA_ULT_COST/OW1_DVA_ULT_COST)
            },
            "echo": {
                "ultGen%": percent(OW2_ECHO_ULT_COST/OW1_ECHO_ULT_COST)
            },
            "genji": {
                "ultGen%": percent(OW2_GENJI_ULT_COST/OW1_GENJI_ULT_COST)
            },
            "hanzo": {
                "ultGen%": percent(OW2_HANZO_ULT_COST/OW1_HANZO_ULT_COST)
            },
            "junkrat": {
                "ultGen%": percent(OW2_JUNKRAT_ULT_COST/OW1_JUNKRAT_ULT_COST)
            },
            "lucio": {
                "ultGen%": percent(OW2_LUCIO_ULT_COST/OW1_LUCIO_ULT_COST)
            },
            "mei": {
                "ultGen%": percent(OW2_MEI_ULT_COST/OW1_MEI_ULT_COST)
            },
            "mercy": {
                "ultGen%": percent(OW2_MERCY_ULT_COST/OW1_MERCY_ULT_COST),
                "enablePassive": false
            },
            "moira": {
                "ultGen%": percent(OW2_MOIRA_ULT_COST/OW1_MOIRA_ULT_COST)
            },
            "pharah": {
                "ultGen%": percent(OW2_PHARAH_ULT_COST/OW1_PHARAH_ULT_COST)
            },
            "ramattra": {
                "health%": percent(OW1_RAMATTRA_BARRIER_HEALTH/OW2_RAMATTRA_BARRIER_HEALTH) # for barrier
            },
            "reaper": {
                "ultGen%": percent(OW2_REAPER_ULT_COST/OW1_REAPER_ULT_COST)
            },
            "reinhardt": {
                "secondaryFireRechargeRate%": 139,
                "health%": percent(OW1_REINHARDT_BARRIER_HEALTH/OW2_REINHARDT_BARRIER_HEALTH), # for barrier
                "ultGen%": percent(OW2_REINHARDT_ULT_COST/OW1_REINHARDT_ULT_COST)
            },
            "roadhog": {
                "ultGen%": percent(OW2_ROADHOG_ULT_COST/OW1_ROADHOG_ULT_COST)
            },
            "sigma": {
                "secondaryFireRechargeRate%": 80,
                "health%": percent(OW1_SIGMA_BARRIER_HEALTH/OW2_SIGMA_BARRIER_HEALTH),  # for barrier
                "ultGen%": percent(OW2_SIGMA_ULT_COST/OW1_SIGMA_ULT_COST),
            },
            "soldier": {
                "ultGen%": percent(OW2_SOLDIER_ULT_COST/OW1_SOLDIER_ULT_COST)
            },
            "sombra": {
                "ultGen%": percent(OW2_SOMBRA_ULT_COST/OW1_SOMBRA_ULT_COST)
            },
            "symmetra": {
                "ultGen%": percent(OW2_SYMMETRA_ULT_COST/OW1_SYMMETRA_ULT_COST)
            },
            "torbjorn": {
                "health%": percent(OW1_TORBJORN_TURRET_HEALTH/OW2_TORBJORN_TURRET_HEALTH), # for turret hp
                "ultGen%": percent(OW2_TORBJORN_ULT_COST/OW1_TORBJORN_ULT_COST)
            },
            "tracer": {
                "ultGen%": percent(OW2_TRACER_ULT_COST/OW1_TRACER_ULT_COST)
            },
            "widowmaker": {
                "ultGen%": percent(OW2_WIDOWMAKER_ULT_COST/OW1_WIDOWMAKER_ULT_COST)
            },
            "winston": {
                "health%": percent(OW1_WINSTON_BARRIER_HEALTH/OW2_WINSTON_BARRIER_HEALTH), # for barrier hp
                "ultGen%": percent(OW2_WINSTON_ULT_COST/OW1_WINSTON_ULT_COST)
            },
            "hammond": {
                "ultGen%": percent(OW2_WRECKING_BALL_ULT_COST/OW1_WRECKING_BALL_ULT_COST),
                "ability3Cooldown%": percent(OW1_WRECKING_BALL_PILEDRIVER_COOLDOWN_TIME/OW2_WRECKING_BALL_PILEDRIVER_COOLDOWN_TIME)
            },
            "zarya": {
                "health%": percent(OW1_ZARYA_BARRIER_HEALTH/OW2_ZARYA_BARRIER_HEALTH),
            },
            "zenyatta": {
                "ultGen%": percent(OW2_ZENYATTA_ULT_COST/OW1_ZENYATTA_ULT_COST)
            }
        }
    }
}


