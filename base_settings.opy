#!include "./utilities.opy"
#!include "./ow1_constants.opy"
#!include "./ow2_constants.opy"

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
            "enableCompetitiveRules": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "control": {
            "enableCompetitiveRules": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "escort": {
            "enableCompetitiveRules": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "hybrid": {
            "enableCompetitiveRules": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "practiceRange": {
            "enabledMaps": [],
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "general": {
            "roleLimit": "2OfEachRolePerTeam"
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "ammoClipSize%": 80,
                "damageDealt%": 93,
                "ability1Cooldown%": 86,
                "ultGen%": percent(ow1_ult_cost_ANA/ow2_ult_cost_ANA)
            },
            "ashe": {
                "ultGen%": percent(ow1_ult_cost_ASHE/ow2_ult_cost_ASHE)
            },
            "baptiste": {
                "ammoClipSize%": 87,
                "ability2Cooldown%": 109,
                "ultGen%": percent(ow1_ult_cost_BAPTISTE/ow2_ult_cost_BAPTISTE)
            },
            "bastion": {
                "ultGen%": percent(ow1_ult_cost_BASTION/ow2_ult_cost_BASTION)
            },
            "brigitte": {
                "ultGen%": percent(ow1_ult_cost_BRIGITTE/ow2_ult_cost_BRIGITTE)
            },
            "mccree": {
                "ultGen%": percent(ow1_ult_cost_MCCREE/ow2_ult_cost_MCCREE)
            },
            "dva": {
                "secondaryFireMaximumTime%": 67,
                "ability2Cooldown%": 114,
                "ultGen%": percent(ow1_ult_cost_DVA/ow2_ult_cost_DVA)
            },
            "echo": {
                "ultGen%": percent(ow1_ult_cost_ECHO/ow2_ult_cost_ECHO)
            },
            "genji": {
                "ammoClipSize%": 125,
                "damageDealt%": 107,
                "ultGen%": percent(ow1_ult_cost_GENJI/ow2_ult_cost_GENJI)
            },
            "hanzo": {
                "ultGen%": percent(ow1_ult_cost_HANZO/ow2_ult_cost_HANZO)
            },
            "junkrat": {
                "ultGen%": percent(ow1_ult_cost_JUNKRAT/ow2_ult_cost_JUNKRAT)
            },
            "lucio": {
                "ultGen%": percent(ow1_ult_cost_LUCIO/ow2_ult_cost_LUCIO)
            },
            "mei": {
                "ultGen%": percent(ow1_ult_cost_MEI/ow2_ult_cost_MEI)
            },
            "mercy": {
                "ultGen%": percent(ow1_ult_cost_MERCY/ow2_ult_cost_MERCY)
            },
            "moira": {
                "ultGen%": percent(ow1_ult_cost_MOIRA/ow2_ult_cost_MOIRA)
            },
            "pharah": {
                "ultGen%": percent(ow1_ult_cost_PHARAH/ow2_ult_cost_PHARAH)
            },
            "reaper": {
                "ultGen%": percent(ow1_ult_cost_REAPER/ow2_ult_cost_REAPER)
            },
            "reinhardt": {
                "secondaryFireRechargeRate%": 139,
                "ability1Cooldown%": 143,
                "health%": percent(ow1_barrier_health_REINHARDT/ow2_barrier_health_REINHARDT)
            },
            "roadhog": {
                "ammoClipSize%": 83,
                "ability1Cooldown%": 133,
                "damageDealt%": 110
            },
            "sigma": {
                "secondaryFireRechargeRate%": 80,
                "health%": percent(ow1_barrier_health_SIGMA/ow2_barrier_health_SIGMA),
            },
            "soldier": {
                "ultGen%": percent(ow1_ult_cost_SOLDIER/ow2_ult_cost_SOLDIER)
            },
            "sombra": {
                "ultGen%": percent(ow1_ult_cost_SOMBRA/ow2_ult_cost_SOMBRA)
            },
            "symmetra": {
                "ammoClipSize%": 70
            },
            "torbjorn": {
                "ultGen%": percent(ow1_ult_cost_TORBJORN/ow2_ult_cost_TORBJORN)
            },
            "tracer": {
                "damageDealt%": 109,
                "ultGen%": percent(ow1_ult_cost_TRACER/ow2_ult_cost_TRACER)
            },
            "widowmaker": {
                "ultGen%": percent(ow1_ult_cost_WIDOWMAKER/ow2_ult_cost_WIDOWMAKER)
            },
            "winston": {
                "ability2Cooldown%": 108,
                "ability1Cooldown%": 120,
                "enableSecondaryFire": false,
                "health%": percent(ow1_barrier_health_WINSTON/ow2_barrier_health_WINSTON),
            },
            "hammond": {
                "ultGen%": percent(ow1_ult_cost_HAMMOND/ow2_ult_cost_HAMMOND)
            },
            "zarya": {
                "ability2Cooldown%": 80,
                "health%": percent(ow1_barrier_health_ZARYA/ow2_barrier_health_ZARYA),
            },
            "zenyatta": {
                "ultGen%": percent(ow1_ult_cost_ZENYATTA/ow2_ult_cost_ZENYATTA)
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
