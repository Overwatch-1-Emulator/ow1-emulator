#!mainFile "main.opy"

settings {
    "main": {
        "description": "ecksdee#11729's attempt to accurately recreate 6v6 Overwatch 1 in Overwatch 2 using workshop.\r\n\r\nFor gamemode details, see https://workshop.codes/overwatch1-emulator\r\nFor latest updates, see https://github.com/MaxwellJung/ow1_emulator\r\n\r\nmain build: KHTG0\r\nstaging build: ESMXJ",
        "modeName": "Overwatch 1 Emulator"
    },
    "lobby": {
        "enableMatchVoiceChat": true,
        "spectatorSlots": 12,
        "team1Slots": 6,
        "team2Slots": 6,
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
            "disabledMaps": [
                "blizzWorldWinter",
                "eichenwaldeHalloween",
                "hollywoodHalloween",
                "kingsRowWinter",
                "midtown"
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
                "ammoClipSize%": 80,
                "damageDealt%": percent(ow1_ana_dart_damage/ow2_ana_dart_damage),
                "ability1Cooldown%": 86,
                "ultGen%": percent(ow2_ult_cost_ANA/ow1_ult_cost_ANA)
            },
            "ashe": {
                "ultGen%": percent(ow2_ult_cost_ASHE/ow1_ult_cost_ASHE)
            },
            "baptiste": {
                "ammoClipSize%": 87,
                "ability2Cooldown%": 109,
                "ultGen%": percent(ow2_ult_cost_BAPTISTE/ow1_ult_cost_BAPTISTE)
            },
            "bastion": {
                "ultGen%": percent(ow2_ult_cost_BASTION/ow1_ult_cost_BASTION)
            },
            "brigitte": {
                "health%": percent(ow1_barrier_health_BRIGITTE/ow2_barrier_health_BRIGITTE),
                "ultGen%": percent(ow2_ult_cost_BRIGITTE/ow1_ult_cost_BRIGITTE)
            },
            "mccree": {
                "projectileSpeed%": percent(ow1_flashbang_speed/ow2_mag_grenade_speed),
                "ultGen%": percent(ow2_ult_cost_MCCREE/ow1_ult_cost_MCCREE)
            },
            "dva": {
                "secondaryFireMaximumTime%": 67,
                "ability2Cooldown%": 114,
                "ultGen%": percent(ow2_ult_cost_DVA/ow1_ult_cost_DVA)
            },
            "echo": {
                "ultGen%": percent(ow2_ult_cost_ECHO/ow1_ult_cost_ECHO)
            },
            "genji": {
                "ammoClipSize%": percent(ow1_ammo_count_GENJI/ow2_ammo_count_GENJI),
                "damageDealt%": 107,
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
                "ability1Cooldown%": 143,
                "health%": percent(ow1_barrier_health_REINHARDT/ow2_barrier_health_REINHARDT),
                "ultGen%": percent(ow2_ult_cost_REINHARDT/ow1_ult_cost_REINHARDT)
            },
            "roadhog": {
                "ammoClipSize%": 83,
                "ability1Cooldown%": 133,
                "damageDealt%": 110,
                "ultGen%": percent(ow2_ult_cost_ROADHOG/ow1_ult_cost_ROADHOG)
            },
            "sigma": {
                "secondaryFireRechargeRate%": 80,
                "health%": percent(ow1_barrier_health_SIGMA/ow2_barrier_health_SIGMA),
                "ultGen%": percent(ow2_ult_cost_SIGMA/ow1_ult_cost_SIGMA)
            },
            "soldier": {
                "ultGen%": percent(ow2_ult_cost_SOLDIER/ow1_ult_cost_SOLDIER)
            },
            "sombra": {
                "ultGen%": percent(ow2_ult_cost_SOMBRA/ow1_ult_cost_SOMBRA)
            },
            "symmetra": {
                "ammoClipSize%": 70,
                "ultGen%": percent(ow2_ult_cost_SYMMETRA/ow1_ult_cost_SYMMETRA)
            },
            "torbjorn": {
                "ultGen%": percent(ow2_ult_cost_TORBJORN/ow1_ult_cost_TORBJORN)
            },
            "tracer": {
                "damageDealt%": 109,
                "ultGen%": percent(ow2_ult_cost_TRACER/ow1_ult_cost_TRACER)
            },
            "widowmaker": {
                "ultGen%": percent(ow2_ult_cost_WIDOWMAKER/ow1_ult_cost_WIDOWMAKER)
            },
            "winston": {
                "ability2Cooldown%": 108,
                "ability1Cooldown%": 120,
                "enableSecondaryFire": false,
                "health%": percent(ow1_barrier_health_WINSTON/ow2_barrier_health_WINSTON),
            },
            "hammond": {
                "ultGen%": percent(ow2_ult_cost_HAMMOND/ow1_ult_cost_HAMMOND)
            },
            "zarya": {
                "ability2Cooldown%": 80,
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
