#!mainFile "main.opy"

settings {
    "main": {
        "description": "ecksdee#11729's attempt to accurately recreate the last version of Overwatch 1 using workshop.\r\n\r\nGamemode Description: \r\nhttps://workshop.codes/overwatch1-emulator\r\n\r\nSource Code: \r\nhttps://github.com/MaxwellJung/ow1_emulator\r\n\r\nRelease build: KHTG0\r\nTesting build: ESMXJ",
        "modeName": "Overwatch 1 Emulator"
    },
    "lobby": {
        "enableMatchVoiceChat": true,
        "spectatorSlots": 12,
        "team1Slots": 6,
        "team2Slots": 6,
        "returnToLobby": "never",
        "teamBalancing": "afterGame"
    },
    "gamemodes": {
        "assault": {
            "disabledMaps": [
                "hanamuraWinter"
            ],
            "enableCompetitiveRules": true
        },
        "control": {
            "disabledMaps": [
                "antarcticPeninsula",
                "lijiangTowerLny"
            ],
            "enableCompetitiveRules": true
        },
        "escort": {
            "disabledMaps": [
                "circuitRoyal",
                "shambaliMonastery"
            ],
            "enableCompetitiveRules": true
        },
        "hybrid": {
            "enabledMaps": [
                "blizzWorld",
                "eichenwalde",
                "hollywood",
                "kingsRow",
                "numbani"
            ],
            "enableCompetitiveRules": true
        },
        "practiceRange": {
            "enabledMaps": []
        },
        "general": {
            "roleLimit": "2OfEachRolePerTeam",
            "tankPassiveHealthBonus": "alwaysEnabled"
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "ultGen%": percent(ow2_ult_cost_ANA/ow1_ult_cost_ANA)
            },
            "ashe": {
                "ultGen%": percent(ow2_ult_cost_ASHE/ow1_ult_cost_ASHE)
            },
            "baptiste": {
                "ultGen%": percent(ow2_ult_cost_BAPTISTE/ow1_ult_cost_BAPTISTE)
            },
            "bastion": {
                "ultGen%": percent(ow2_ult_cost_BASTION/ow1_ult_cost_BASTION)
            },
            "brigitte": {
                "health%": percent(ow1_barrier_health_BRIGITTE/ow2_barrier_health_BRIGITTE), # for barrier hp
                "ultGen%": percent(ow2_ult_cost_BRIGITTE/ow1_ult_cost_BRIGITTE)
            },
            "mccree": {
                "ultGen%": percent(ow2_ult_cost_MCCREE/ow1_ult_cost_MCCREE)
            },
            "dva": {
                "secondaryFireMaximumTime%": 67,
                "ultGen%": percent(ow2_ult_cost_DVA/ow1_ult_cost_DVA)
            },
            "echo": {
                "ultGen%": percent(ow2_ult_cost_ECHO/ow1_ult_cost_ECHO)
            },
            "genji": {
                "ultGen%": percent(ow2_ult_cost_GENJI/ow1_ult_cost_GENJI)
            },
            "hanzo": {
                "ultGen%": percent(ow2_ult_cost_HANZO/ow1_ult_cost_HANZO)
            },
            "junkrat": {
                "ultGen%": percent(ow2_ult_cost_JUNKRAT/ow1_ult_cost_JUNKRAT)
            },
            "lucio": {
                "ultGen%": percent(ow2_ult_cost_LUCIO/ow1_ult_cost_LUCIO)
            },
            "mei": {
                "ultGen%": percent(ow2_ult_cost_MEI/ow1_ult_cost_MEI)
            },
            "mercy": {
                "ultGen%": percent(ow2_ult_cost_MERCY/ow1_ult_cost_MERCY)
            },
            "moira": {
                "ultGen%": percent(ow2_ult_cost_MOIRA/ow1_ult_cost_MOIRA)
            },
            "pharah": {
                "ultGen%": percent(ow2_ult_cost_PHARAH/ow1_ult_cost_PHARAH)
            },
            "reaper": {
                "ultGen%": percent(ow2_ult_cost_REAPER/ow1_ult_cost_REAPER)
            },
            "reinhardt": {
                "secondaryFireRechargeRate%": 139,
                "health%": percent(ow1_barrier_health_REINHARDT/ow2_barrier_health_REINHARDT), # for barrier
                "ultGen%": percent(ow2_ult_cost_REINHARDT/ow1_ult_cost_REINHARDT)
            },
            "roadhog": {
                "ultGen%": percent(ow2_ult_cost_ROADHOG/ow1_ult_cost_ROADHOG)
            },
            "sigma": {
                "secondaryFireRechargeRate%": 80,
                "health%": percent(ow1_barrier_health_SIGMA/ow2_barrier_health_SIGMA),  # for barrier
                "ultGen%": percent(ow2_ult_cost_SIGMA/ow1_ult_cost_SIGMA)
            },
            "soldier": {
                "ultGen%": percent(ow2_ult_cost_SOLDIER/ow1_ult_cost_SOLDIER)
            },
            "sombra": {
                "ultGen%": percent(ow2_ult_cost_SOMBRA/ow1_ult_cost_SOMBRA)
            },
            "symmetra": {
                "ultGen%": percent(ow2_ult_cost_SYMMETRA/ow1_ult_cost_SYMMETRA)
            },
            "torbjorn": {
                "ultGen%": percent(ow2_ult_cost_TORBJORN/ow1_ult_cost_TORBJORN)
            },
            "tracer": {
                "ultGen%": percent(ow2_ult_cost_TRACER/ow1_ult_cost_TRACER)
            },
            "widowmaker": {
                "ultGen%": percent(ow2_ult_cost_WIDOWMAKER/ow1_ult_cost_WIDOWMAKER)
            },
            "winston": {
                "health%": percent(ow1_barrier_health_WINSTON/ow2_barrier_health_WINSTON), # for barrier hp
                "ultGen%": percent(OW2_WINSTON_ULT_COST/OW1_WINSTON_ULT_COST)
            },
            "hammond": {
                "ultGen%": percent(ow2_ult_cost_HAMMOND/ow1_ult_cost_HAMMOND)
            },
            "zarya": {
                "health%": percent(ow1_barrier_health_ZARYA/ow2_barrier_health_ZARYA),
            },
            "zenyatta": {
                "ultGen%": percent(ow2_ult_cost_ZENYATTA/ow1_ult_cost_ZENYATTA)
            },
            "disabledHeroes": [
                "doomfist",
                "junkerQueen",
                "kiriko",
                "lifeweaver",
                "orisa",
                "ramattra",
                "sojourn"
            ],
        }
    }
}
