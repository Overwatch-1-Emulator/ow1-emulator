#!mainFile "../main.opy"

settings {
    "main": {
        "modeName": GAMEMODE_NAME + " " + GAMEMODE_VERSION,
        "description": GAMDMODE_DESCRIPTION,
    },
    "lobby": {
        "spectatorSlots": 12,
        "team1Slots": 6,
        "team2Slots": 6,
        "pauseGameOnDisconnect": true,
        "teamBalancing": "afterGame"
    },
    "gamemodes": {
        "assault": {
            "disabledMaps": [
                "horizonLunarColony",
                "paris"
            ],
            "captureSpeed%": 110,
        },
        "control": {
            "disabledMaps": [
                "lijiangTowerLny"
            ],
        },
        "escort": {
        },
        "flashpoint": {
            "scoringSpeed%": 85,
        },
        "hybrid": {
            "disabledMaps": [
                "blizzWorldWinter",
                "eichenwaldeHalloween",
                "hollywoodHalloween",
                "kingsRowWinter"
            ],
        },
        "push": {
            "disabledMaps": [
                "colosseo"
            ],
        },
        "general": {
            "heroLimit": "1PerTeam",
            "roleLimit": "off",
            "gamemodeStartTrigger": "allSlotsFilled",
            "tankPassiveHealthBonus": "disabled",
            "randomHeroRoleLimitPerTeam": 2,
            "enableCompetitiveRules": true,
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "ability1Cooldown%": 85,
                "ultGen%": 106
            },
            "ashe": {
                "ultGen%": 111
            },
            "baptiste": {
                "ability1Cooldown%": 86,
                "ultGen%": 98
            },
            "bastion": {
                "ultGen%": 111
            },
            "brigitte": {
                "ability2Cooldown%": 120,
                "ultGen%": 93
            },
            "mccree": {
                "ultGen%": 111
            },
            "dva": {
                "secondaryFireMaximumTime%": 66
            },
            "doomfist": {
                "ability1Cooldown%": 128,
                "ability2Cooldown%": 116,
                "ultGen%": 97
            },
            "echo": {
                "ultGen%": 96
            },
            "genji": {
                "ultGen%": 110
            },
            "hanzo": {
                "ability2Cooldown%": 125,
                "ability2Quantity%": 4,
                "ultGen%": 110
            },
            "illari": {
                "ability2Cooldown%": 133,
                "ultGen%": 106
            },
            "junkerQueen": {
                "ultGen%": 107
            },
            "junkrat": {
                "ability1Cooldown%": 114,
                "ultGen%": 110
            },
            "lifeweaver": {
                "secondaryFireCooldown%": 83,
                "secondaryFireHealth%": 75,
                "ultHealth%": 75,
                "ultGen%": 111
            },
            "lucio": {
                "ultGen%": 106
            },
            "mauga": {
                "primaryFireIgniteDamage": 152,
                "primaryFireIgniteRate": 125,
                "ability1Cooldown%": 166
            },
            "mei": {
                "ultFreezeMinimum%": 30,
                "ultGen%": 110
            },
            "moira": {
                "ultGen%": 95
            },
            "orisa": {
                "ultGen%": 116
            },
            "pharah": {
                "ability2Cooldown%": 114,
                "ultGen%": 110
            },
            "ramattra": {
                "ability1Cooldown%": 129
            },
            "reaper": {
                "ability2Cooldown%": 80,
                "ultGen%": 103
            },
            "reinhardt": {
                "secondaryFireRechargeRate%": 139,
                "ability1Cooldown%": 142,
                "ultGen%": 107
            },
            "roadhog": {
                "secondaryFireMaximumTime%": 43,
                "secondaryFireRechargeRate%": 50,
                "ultGen%": 107
            },
            "sigma": {
                "secondaryFireRechargeRate%": 94,
                "ability1Cooldown%": 108,
                "ultGen%": 107
            },
            "sojourn": {
                "ultGen%": 110
            },
            "soldier": {
                "ability2Cooldown%": 83,
                "ultGen%": 111
            },
            "sombra": {
                "ultGen%": 95
            },
            "symmetra": {
                "ultGen%": 112
            },
            "torbjorn": {
                "ultGen%": 110
            },
            "tracer": {
                "ability2Cooldown%": 92,
                "ultGen%": 110
            },
            "widowmaker": {
                "ultGen%": 110
            },
            "winston": {
                "ultGen%": 113
            },
            "hammond": {
                "ability1Kb%": 85,
                "ability3Cooldown%": 125,
                "ultGen%": 109
            },
            "general": {
                "ultGen%": 108
            }
        }
    }
}
