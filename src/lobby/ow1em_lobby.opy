#!mainFile "../ow1em_main.opy"

settings {
    "main": {
        "modeName": GAMEMODE_NAME + " " + GAMEMODE_VERSION,
        "description": GAMDMODE_DESCRIPTION,
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "spectatorSlots": 1,
        "team1Slots": 6,
        "team2Slots": 6,
        "returnToLobby": "afterGame",
        "teamBalancing": "off",
        # "minimumLatencyInNs": 50000000
    },
    "gamemodes": {
        "assault": {
            "enabledMaps": [
                "hanamura",
                # "horizonLunarColony",
                # "paris",
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
                {
                    "rialto": [
                        "morning"
                    ]
                },
                {
                    "junkertown" : []
                },
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
        # "practiceRange": {
        #     "enabledMaps": []
        # },
        "general": {
            "heroLimit": "1PerTeam",
            "roleLimit": "off",
            "gamemodeStartTrigger": "allSlotsFilled",
            "tankPassiveHealthBonus": "disabled",
            "enableCompetitiveRules": true
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "ability1Cooldown%": percent(OW1_ANA_SLEEP_DART_COOLDOWN_TIME/OW2_ANA_SLEEP_DART_COOLDOWN_TIME),
                "ability2Cooldown%": percent(OW1_ANA_BIOTIC_GRENADE_COOLDOWN/OW2_ANA_BIOTIC_GRENADE_COOLDOWN),
                "ultGen%": percent(OW2_ANA_ULT_COST/OW1_ANA_ULT_COST)
            },
            "ashe": {
                "health%": percent(OW1_ASHE_BOB_HEALTH/OW2_ASHE_BOB_HEALTH), # for BOB hp
                "ultGen%": percent(OW2_ASHE_ULT_COST/OW1_ASHE_ULT_COST)
            },
            "baptiste": {
                "health%": percent(OW1_BAPTISTE_LAMP_HP/OW2_BAPTISTE_LAMP_HP), # for immortality field hp
                "ability2Cooldown%": percent(OW1_BAPTISTE_LAMP_COOLDOWN_TIME/OW2_BAPTISTE_LAMP_COOLDOWN_TIME),
                "ultGen%": percent(OW2_BAPTISTE_ULT_COST/OW1_BAPTISTE_ULT_COST)
            },
            "bastion": {
                "ability1Cooldown%": percent(OW1_BASTION_RECONFIGURE_COOLDOWN/OW2_BASTION_RECONFIGURE_COOLDOWN),
                "ultGen%": percent(OW2_BASTION_ULT_COST/OW1_BASTION_ULT_COST)
            },
            "brigitte": {
                "health%": percent(OW1_BRIGITTE_BARRIER_HEALTH/OW2_BRIGITTE_BARRIER_HEALTH), # for barrier hp
                "shieldBashCooldown%": percent(OW1_BRIGITTE_SHIELD_BASH_COOLDOWN/OW2_BRIGITTE_SHIELD_BASH_COOLDOWN),
                "shieldBashKb%": percent(OW1_BRIGITTE_SHIELD_BASH_KNOCKBACK/OW2_BRIGITTE_SHIELD_BASH_KNOCKBACK),
                "ability2Cooldown%": percent(OW1_BRIGITTE_REPAIR_PACK_COOLDOWN/OW2_BRIGITTE_REPAIR_PACK_COOLDOWN),
                "ultGen%": percent(OW2_BRIGITTE_ULT_COST/OW1_BRIGITTE_ULT_COST)
            },
            "mccree": {
                "ultGen%": percent(OW2_MCCREE_ULT_COST/OW1_MCCREE_ULT_COST)
            },
            "doomfist": {
                "health%": percent(OW2_DOOMFIST_BEST_DEFENSE/OW2_DOOMFIST_BEST_DEFENSE), # for shield hp
                "ammoRegenerationTime%": 162,
                "secondaryFireKb%": 0,
                "ultGen%": percent(OW2_DOOMFIST_ULT_COST/OW1_DOOMFIST_ULT_COST)
            },
            "dva": {
                "health%": percent(OW1_DVA_PILOT_HEALTH/OW2_DVA_PILOT_HEALTH), # for pilot dva hp
                "secondaryFireMaximumTime%": percent(OW1_DVA_MATRIX_DURATION/OW2_DVA_MATRIX_DURATION),
                "ability1Cooldown%": percent(OW1_DVA_BOOSTER_COOLDOWN_TIME/OW2_DVA_BOOSTER_COOLDOWN_TIME),
                "ability2Cooldown%": percent(OW1_DVA_MICRO_MISSILES_COOLDOWN_TIME/OW2_DVA_MICRO_MISSILES_COOLDOWN_TIME),
                "ultGen%": percent(OW2_DVA_ULT_COST/OW1_DVA_ULT_COST)
            },
            "echo": {
                "ultGen%": percent(OW2_ECHO_ULT_COST/OW1_ECHO_ULT_COST)
            },
            "genji": {
                "ultGen%": percent(OW2_GENJI_ULT_COST/OW1_GENJI_ULT_COST)
            },
            "hanzo": {
                "ability2Cooldown%": percent(OW1_HANZO_STORM_COOLDOWN/OW2_HANZO_STORM_COOLDOWN),
                "ultGen%": percent(OW2_HANZO_ULT_COST/OW1_HANZO_ULT_COST)
            },
            "junkrat": {
                "ability1Cooldown%": percent(OW1_JUNKRAT_CONCUSSION_MINE_COOLDOWN/OW2_JUNKRAT_CONCUSSION_MINE_COOLDOWN),
                "ultGen%": percent(OW2_JUNKRAT_ULT_COST/OW1_JUNKRAT_ULT_COST)
            },
            "lucio": {
                "ultGen%": percent(OW2_LUCIO_ULT_COST/OW1_LUCIO_ULT_COST)
            },
            "mei": {
                "health%": percent(OW1_MEI_ICEWALL_HP/OW2_MEI_ICEWALL_HP), # for icewall
                "ultGen%": percent(OW2_MEI_ULT_COST/OW1_MEI_ULT_COST)
            },
            "mercy": {
                "ultGen%": percent(OW2_MERCY_ULT_COST/OW1_MERCY_ULT_COST),
                "enablePassive": false
            },
            "moira": {
                "ultGen%": percent(OW2_MOIRA_ULT_COST/OW1_MOIRA_ULT_COST),
                "primaryFireMaximumTime%": percent((OW2_MOIRA_HEAL_GRASP_AMMO_USAGE/OW1_MOIRA_HEAL_GRASP_AMMO_USAGE)*(OW1_MOIRA_HEAL_GRASP_AMMO/OW2_MOIRA_HEAL_GRASP_AMMO)),
            },
            "orisa": {
                "ultGen%": percent(OW2_ORISA_ULT_COST/OW1_ORISA_ULT_COST)
            },
            "pharah": {
                "enablePassiveUnlimitedFuel": true,
                "ability1RefuelScalar": 0,
                "ability1Cooldown%": percent(OW1_PHARAH_JUMP_JET_COOLDOWN/OW2_PHARAH_JUMP_JET_COOLDOWN),
                "ability2Cooldown%": percent(OW1_PHARAH_CONCUSSIVE_BLAST_COOLDOWN/OW2_PHARAH_CONCUSSIVE_BLAST_COOLDOWN),
                "ultGen%": percent(OW2_PHARAH_ULT_COST/OW1_PHARAH_ULT_COST)
            },
            "reaper": {
                "ultGen%": percent(OW2_REAPER_ULT_COST/OW1_REAPER_ULT_COST)
            },
            "reinhardt": {
                "secondaryFireRechargeRate%": percent(OW1_REINHARDT_BARRIER_REGEN/OW2_REINHARDT_BARRIER_REGEN),
                "health%": percent(OW1_REINHARDT_BARRIER_HEALTH/OW2_REINHARDT_BARRIER_HEALTH), # for barrier
                "ability1Cooldown%": percent(OW1_REINHARDT_CHARGE_COOLDOWN_TIME/OW2_REINHARDT_CHARGE_COOLDOWN_TIME),
                "ultGen%": percent(OW2_REINHARDT_ULT_COST/OW1_REINHARDT_ULT_COST)
            },
            "roadhog": {
                "secondaryFireMaximumTime%": percent((OW1_ROADHOG_BREATHER_CAST_TIME+OW1_ROADHOG_BREATHER_DURATION)/OW2_ROADHOG_BREATHER_DURATION),
                "secondaryFireRechargeRate%": 500,
                "ability1Cooldown%": percent(OW1_ROADHOG_HOOK_COOLDOWN_TIME/OW2_ROADHOG_HOOK_COOLDOWN_TIME),
                "ability2Cooldown%": percent(OW1_ROADHOG_BREATHER_COOLDOWN/OW2_ROADHOG_TRAP_COOLDOWN),
                "ultGen%": percent(OW2_ROADHOG_ULT_COST/OW1_ROADHOG_ULT_COST)
            },
            "sigma": {
                "secondaryFireRechargeRate%": percent(OW1_SIGMA_BARRIER_REGEN/OW2_SIGMA_BARRIER_REGEN),
                "health%": percent(OW1_SIGMA_BARRIER_HEALTH/OW2_SIGMA_BARRIER_HEALTH), # for barrier
                "ultGen%": percent(OW2_SIGMA_ULT_COST/OW1_SIGMA_ULT_COST),
            },
            "soldier": {
                "ability2Cooldown%": percent(OW1_SOLDIER_BIOTIC_FIELD_COOLDOWN/OW2_SOLDIER_BIOTIC_FIELD_COOLDOWN),
                "ultGen%": percent(OW2_SOLDIER_ULT_COST/OW1_SOLDIER_ULT_COST)
            },
            "sombra": {
                "secondaryFireCooldown%": percent(OW1_SOMBRA_HACK_COOLDOWN_TIME/OW2_SOMBRA_HACK_COOLDOWN_TIME),
                "ultGen%": percent(OW2_SOMBRA_ULT_COST/OW1_SOMBRA_ULT_COST)
            },
            "symmetra": {
                "health%": percent(OW1_SYMMETRA_TURRET_HEALTH/OW2_SYMMETRA_TURRET_HEALTH), # for turret hp
                "ultGen%": percent(OW2_SYMMETRA_ULT_COST/OW1_SYMMETRA_ULT_COST)
            },
            "torbjorn": {
                "health%": percent(OW1_TORBJORN_TURRET_HEALTH/OW2_TORBJORN_TURRET_HEALTH), # for turret hp
                "ultGen%": percent(OW2_TORBJORN_ULT_COST/OW1_TORBJORN_ULT_COST)
            },
            "tracer": {
                "health%": percent(OW1_TRACER_HEALTH/OW2_TRACER_HEALTH), # for recall hp
                "ultGen%": percent(OW2_TRACER_ULT_COST/OW1_TRACER_ULT_COST)
            },
            "widowmaker": {
                "ultGen%": percent(OW2_WIDOWMAKER_ULT_COST/OW1_WIDOWMAKER_ULT_COST)
            },
            "winston": {
                "health%": percent(OW1_WINSTON_BARRIER_HEALTH/OW2_WINSTON_BARRIER_HEALTH), # for barrier hp
                "ability1Cooldown%": percent(OW1_WINSTON_JUMP_PACK_COOLDOWN_TIME/OW2_WINSTON_JUMP_PACK_COOLDOWN_TIME),
                "ultGen%": percent(OW2_WINSTON_ULT_COST/OW1_WINSTON_ULT_COST)
            },
            "hammond": {
                "ability1Kb%": percent(1/OW2_WRECKING_BALL_FIREBALL_KB),
                "ultGen%": percent(OW2_WRECKING_BALL_ULT_COST/OW1_WRECKING_BALL_ULT_COST),
                "ability3Cooldown%": percent(OW1_WRECKING_BALL_PILEDRIVER_COOLDOWN_TIME/OW2_WRECKING_BALL_PILEDRIVER_COOLDOWN_TIME)
            },
            "zarya": {
                "health%": percent(OW1_ZARYA_BARRIER_HEALTH/OW2_ZARYA_BARRIER_HEALTH),
            },
            "zenyatta": {
                "ultGen%": percent(OW2_ZENYATTA_ULT_COST/OW1_ZENYATTA_ULT_COST)
            },
            "enabledHeroes": [
                "ana",
                "ashe",
                "baptiste",
                "bastion",
                "brigitte",
                "mccree",
                "doomfist",
                "dva",
                "echo",
                "genji",
                "hanzo",
                "junkrat",
                "lucio",
                "mei",
                "mercy",
                "moira",
                "orisa",
                "pharah",
                "reaper",
                "reinhardt",
                "roadhog",
                "sigma",
                "soldier",
                "sombra",
                "symmetra",
                "torbjorn",
                "tracer",
                "widowmaker",
                "winston",
                "hammond",
                "zarya",
                "zenyatta",
            ]
        }
    }
}
