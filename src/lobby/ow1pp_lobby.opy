#!mainFile "../ow1pp_main.opy"

settings {
    "main": {
        "modeName": GAMEMODE_NAME + " " + GAMEMODE_VERSION,
        "description": GAMDMODE_DESCRIPTION,
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "spectatorSlots": 12,
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
                    "antarcticPeninsula": []
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
                },
                # {
                #     "samoa": []
                # }
            ]
        },
        "escort": {
            "enabledMaps": [
                # {
                #     "circuitRoyal": [
                #         "night"
                #     ]
                # },
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
                    "shambaliMonastery": []
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
                # {
                #     "midtown": [
                #         "morning"
                #     ]
                # },
                {
                    "numbani": []
                },
                # {
                #     "paraiso": [
                #         "morning"
                #     ]
                # },
            ]
        },
        # "practiceRange": {
        #     "enabledMaps": []
        # },
        "flashpoint": {
            "captureSpeed%": 75,
            "scoringSpeed%": 100,
            "enabledMaps": [
                # {
                #     "newJunkCity": []
                # },
                {
                    "suravasa": []
                },
            ]
        },
        "push": {
            "enabledMaps": [
                # {
                #     "colosseo": [
                #         "evening"
                #     ]
                # },
                # {
                #     "esperanca": []
                # },
                # {
                #     "newQueenStreet": [
                #         "morning"
                #     ]
                # },
            ]
        },
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
                "ammoRegenerationTime%": percent(OW1_DOOMFIST_AMMO_REGEN/OW2_DOOMFIST_AMMO_REGEN),
                "secondaryFireKb%": 0,
                "ability1Cooldown%": percent(OW1_DOOMFIST_SLAM_CD/OW2_DOOMFIST_SLAM_CD),
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
            "illari": {
                "health%": percent(OW1_ILLARI_PYLON_HP/OW2_ILLARI_PYLON_HP), # for pylon hp
                "ability1Cooldown%": percent(OW1_ILLARI_OUTBURST_COOLDOWN/OW2_ILLARI_OUTBURST_COOLDOWN),
                "ability2Cooldown%": percent(OW1_ILLARI_PYLON_COOLDOWN/OW2_ILLARI_PYLON_COOLDOWN),
                "ultGen%": percent(OW2_ILLARI_ULT_COST/OW1_ILLARI_ULT_COST)
            },
            "junkerQueen": {
                "health%": percent(OW1_JUNKERQUEEN_SHOUT_OVERHEALTH/OW2_JUNKERQUEEN_SHOUT_OVERHEALTH), # for shout overhealth
                "secondaryFireCooldown%": percent(OW1_JUNKERQUEEN_BLADE_COOLDOWN/OW2_JUNKERQUEEN_BLADE_COOLDOWN),
                "ability1Cooldown%": percent(OW1_JUNKERQUEEN_SHOUT_COOLDOWN_TIME/OW2_JUNKERQUEEN_SHOUT_COOLDOWN_TIME),
                "ultGen%": percent(OW2_JUNKERQUEEN_ULT_COST/OW1_JUNKERQUEEN_ULT_COST)
            },
            "junkrat": {
                "ability1Cooldown%": percent(OW1_JUNKRAT_CONCUSSION_MINE_COOLDOWN/OW2_JUNKRAT_CONCUSSION_MINE_COOLDOWN),
                "ultGen%": percent(OW2_JUNKRAT_ULT_COST/OW1_JUNKRAT_ULT_COST)
            },
            "kiriko": {
                "ability1Cooldown%": percent(OW1_KIRIKO_SWIFT_STEP_COOLDOWN/OW2_KIRIKO_SWIFT_STEP_COOLDOWN),
                "ability2Cooldown%": percent(OW1_KIRIKO_SUZU_COOLDOWN/OW2_KIRIKO_SUZU_COOLDOWN),
                "ultGen%": percent(OW2_KIRIKO_ULT_COST/OW1_KIRIKO_ULT_COST)
            },
            "lifeweaver": {
                "ultGen%": percent(OW2_LIFEWEAVER_ULT_COST/OW1_LIFEWEAVER_ULT_COST)
            },
            "lucio": {
                "ultGen%": percent(OW2_LUCIO_ULT_COST/OW1_LUCIO_ULT_COST)
            },
            "mauga": {
                "ultGen%": percent(OW2_MAUGA_ULT_COST/OW1_MAUGA_ULT_COST)
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
            "ramattra": {
                "health%": percent(OW1_RAMATTRA_NEMESIS_ARMOR/OW2_RAMATTRA_NEMESIS_ARMOR), # for nemesis hp
                "ability1Cooldown%": percent(OW1_RAMATTRA_NEMESIS_COOLDOWN/OW2_RAMATTRA_NEMESIS_COOLDOWN),
                "ability2Cooldown%": percent(OW1_RAMATTRA_VORTEX_COOLDOWN/OW2_RAMATTRA_VORTEX_COOLDOWN),
                "secondaryFireCooldown%": percent(OW1_RAMATTRA_VOID_BARRIER_COOLDOWN/OW2_RAMATTRA_VOID_BARRIER_COOLDOWN),
                "ultGen%": percent(OW2_RAMATTRA_ULT_COST/OW1_RAMATTRA_ULT_COST)
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
            "sojourn": {
                "ultGen%": percent(OW2_SOJOURN_ULT_COST/OW1_SOJOURN_ULT_COST)
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
                "ability2Cooldown%": percent(OW1_TRACER_RECALL_COOLDOWN/OW2_TRACER_RECALL_COOLDOWN),
                "ultGen%": percent(OW2_TRACER_ULT_COST/OW1_TRACER_ULT_COST)
            },
            "venture": {
                "ultGen%": percent(OW2_VENTURE_ULT_COST/OW1_VENTURE_ULT_COST),
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
                "ability3Cooldown%": percent(OW1_WRECKING_BALL_PILEDRIVER_COOLDOWN_TIME/OW2_WRECKING_BALL_PILEDRIVER_COOLDOWN_TIME),
                "ultGen%": percent(OW2_WRECKING_BALL_ULT_COST/OW1_WRECKING_BALL_ULT_COST),
            },
            "zarya": {
                "health%": percent(OW1_ZARYA_BARRIER_HEALTH/OW2_ZARYA_BARRIER_HEALTH),
                "ultGen%": percent(OW2_ZARYA_ULT_COST/OW1_ZARYA_ULT_COST),
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
                "illari",
                "junkerQueen",
                "junkrat",
                "kiriko",
                # "lifeweaver",
                "lucio",
                # "mauga",
                "mei",
                "mercy",
                "moira",
                "orisa",
                "pharah",
                "ramattra",
                "reaper",
                "reinhardt",
                "roadhog",
                "sigma",
                "sojourn",
                "soldier",
                "sombra",
                "symmetra",
                "torbjorn",
                "tracer",
                "venture",
                "widowmaker",
                "winston",
                "hammond",
                "zarya",
                "zenyatta",
            ]
        }
    }
}
