#!mainFile "../dev_main.opy"

#!define GAMEMODE_VERSION "Dev Build"
#!define GAMEMODE_NAME "Overwatch 1 Emulator"
#!define GAMEMODE_CODE "KHTG0"
#!define STAGING_CODE "ESMXJ"
#!define DISCORD_SHORT_LINK "dsc.gg/ow1"
#!define DISCORD_LONG_LINK "discord.gg/GMVqwYXbWB"
#!define SOURCE_CODE_LINK "github.com/Overwatch-1-Emulator/ow1-emulator"
macro GAMDMODE_DESCRIPTION = (GAMEMODE_NAME" "GAMEMODE_VERSION"\n"\
                               "\n"\
                               "ecksdee#11729's attempt to accurately recreate ""\n"\
                               "the last version of Overwatch 1 using workshop.""\n"\
                               "\n"\
                               "Check out 6v6 Adjustment (7HSKW)""\n"\
                               "for Overwatch 2 in 6v6 format.""\n"\
                               "\n"\
                               "Stable build: "GAMEMODE_CODE"\n"\
                               "Latest build: "STAGING_CODE"\n"\
                               "\n"\
                               "Codebase Contributors:""\n"\
                               "ecksdee#11729""\n"\
                               "Snappy#11809""\n"\
                               "KingDonMike#2694""\n"\
                               "thenova#21104""\n"\
                               "pretz#11551""\n"\
                               "Hikigaeru#11863""\n"\
                               "Ciach795#2589""\n"\
                               "\n"\
                               "workshop.codes/ow1-emulator""\n"\
                               "\n"\
                               "Discord:""\n"\
                               DISCORD_SHORT_LINK"\n"\
                               DISCORD_LONG_LINK"\n"\
                               "\n"\
                               "Source code:""\n"\
                               SOURCE_CODE_LINK)


rule "Copyright (c) 2024 Overwatch 1 Emulator. See github.com/Overwatch-1-Emulator/ow1-emulator for license to use this code.":
    @Disabled
    disableInspector()


settings {
    "main": {
        "modeName": GAMEMODE_NAME" "GAMEMODE_VERSION,
        "description": GAMDMODE_DESCRIPTION,
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "spectatorSlots": 12,
        "team1Slots": 6,
        "team2Slots": 0,
        "returnToLobby": "afterGame",
        "teamBalancing": "off",
        # "minimumLatencyInNs": 50000000
    },
    "gamemodes": {
        "practiceRange": {
            "enabledMaps": [ "practiceRange" ]
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
                "ultGen%": percent(OW2_ASHE_ULT_COST/OW1_ASHE_ULT_COST)
            },
            "baptiste": {
                "ability1Cooldown%": percent(OW1_BAPTISTE_REGEN_BURST_COOLDOWN/OW2_BAPTISTE_REGEN_BURST_COOLDOWN),
                "ability2Cooldown%": percent(OW1_BAPTISTE_LAMP_COOLDOWN_TIME/OW2_BAPTISTE_LAMP_COOLDOWN_TIME),
                "ultGen%": percent(OW2_BAPTISTE_ULT_COST/OW1_BAPTISTE_ULT_COST)
            },
            "bastion": {
                "ability1Cooldown%": percent(OW1_BASTION_RECONFIGURE_COOLDOWN/OW2_BASTION_RECONFIGURE_COOLDOWN),
                "ultGen%": percent(OW2_BASTION_ULT_COST/OW1_BASTION_ULT_COST)
            },
            "brigitte": {
                "shieldBashCooldown%": percent(OW1_BRIGITTE_SHIELD_BASH_COOLDOWN/OW2_BRIGITTE_SHIELD_BASH_COOLDOWN),
                "shieldBashKb%": percent(OW1_BRIGITTE_SHIELD_BASH_KNOCKBACK/OW2_BRIGITTE_SHIELD_BASH_KNOCKBACK),
                "ability2Cooldown%": percent(OW1_BRIGITTE_REPAIR_PACK_COOLDOWN/OW2_BRIGITTE_REPAIR_PACK_COOLDOWN),
                "ultGen%": percent(OW2_BRIGITTE_ULT_COST/OW1_BRIGITTE_ULT_COST)
            },
            "cassidy": {
                "ability2Cooldown%": percent(OW1_MCCREE_FLASHBANG_COOLDOWN/OW2_MCCREE_FLASHBANG_COOLDOWN),
                "ultGen%": percent(OW2_MCCREE_ULT_COST/OW1_MCCREE_ULT_COST)
            },
            "doomfist": {
                "ammoRegenerationTime%": percent(OW1_DOOMFIST_AMMO_REGEN/OW2_DOOMFIST_AMMO_REGEN),
                "secondaryFireKb%": 0,
                "ability1Cooldown%": percent(OW1_DOOMFIST_UPPERCUT_COOLDOWN_DEFAULT/OW2_DOOMFIST_POWER_BLOCK_COOLDOWN),
                "ability2Cooldown%": percent(OW1_DOOMFIST_SLAM_COOLDOWN/OW2_DOOMFIST_SEISMIC_SLAM_COOLDOWN),
                "ultGen%": percent(OW2_DOOMFIST_ULT_COST/OW1_DOOMFIST_ULT_COST)
            },
            "dva": {
                "health%": percent(OW1_DVA_PILOT_HEALTH/OW2_DVA_PILOT_HEALTH),
                "secondaryFireMaximumTime%": percent(OW1_DVA_MATRIX_DURATION/OW2_DVA_MATRIX_DURATION),
                "ability1Cooldown%": percent(OW1_DVA_BOOSTER_COOLDOWN_TIME/OW2_DVA_BOOSTER_COOLDOWN_TIME),
                "ability2Cooldown%": percent(OW1_DVA_MICRO_MISSILES_COOLDOWN_TIME/OW2_DVA_MICRO_MISSILES_COOLDOWN_TIME),
                "ultGen%": percent(OW2_DVA_ULT_COST/OW1_DVA_ULT_COST)
            },
            "echo": {
                "ultGen%": percent(OW2_ECHO_ULT_COST/OW1_ECHO_ULT_COST)
            },
            "freja": {
                "ultGen%": percent(OW2_FREJA_ULT_COST/OW1_FREJA_ULT_COST)
            },
            "genji": {
                "ultGen%": percent(OW2_GENJI_ULT_COST/OW1_GENJI_ULT_COST),
                "ability2Cooldown%": percent(OW1_GENJI_DEFLECT_COOLDOWN/OW2_GENJI_DEFLECT_COOLDOWN),
                "projectileSpeed%": percent(OW1_GENJI_PROJECTILE_SPEED/OW2_GENJI_PROJECTILE_SPEED)
            },
            "hanzo": {
                "ability2Cooldown%": percent(OW1_HANZO_STORM_COOLDOWN/OW2_HANZO_STORM_COOLDOWN),
                "ultGen%": percent(OW2_HANZO_ULT_COST/OW1_HANZO_ULT_COST)
            },
            "hazard": {
                "ultGen%": percent(OW2_HAZARD_ULT_COST/OW1_HAZARD_ULT_COST)
            },
            "illari": {
                "ability1Cooldown%": percent(OW1_ILLARI_OUTBURST_COOLDOWN/OW2_ILLARI_OUTBURST_COOLDOWN),
                "ability2Cooldown%": percent(OW1_ILLARI_PYLON_COOLDOWN/OW2_ILLARI_PYLON_COOLDOWN),
                "ultGen%": percent(OW2_ILLARI_ULT_COST/OW1_ILLARI_ULT_COST)
            },
            "junkerQueen": {
                "secondaryFireCooldown%": percent(OW1_JUNKERQUEEN_BLADE_COOLDOWN/OW2_JUNKERQUEEN_BLADE_COOLDOWN),
                "ability1Cooldown%": percent(OW1_JUNKERQUEEN_SHOUT_COOLDOWN_TIME/OW2_JUNKERQUEEN_SHOUT_COOLDOWN_TIME),
                "ultGen%": percent(OW2_JUNKERQUEEN_ULT_COST/OW1_JUNKERQUEEN_ULT_COST)
            },
            "junkrat": {
                "ability1Cooldown%": percent(OW1_JUNKRAT_CONCUSSION_MINE_COOLDOWN/OW2_JUNKRAT_CONCUSSION_MINE_COOLDOWN),
                "ultGen%": percent(OW2_JUNKRAT_ULT_COST/OW1_JUNKRAT_ULT_COST)
            },
            "juno": {
                "ultGen%": percent(OW2_JUNO_ULT_COST/OW1_JUNO_ULT_COST)
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
                "ammoClipSize%": percent(OW1_ORISA_CLIP_SIZE/OW2_ORISA_CLIP_SIZE),
                "enableInfiniteAmmo": true,
                "ability1Cooldown%": percent(OW1_ORISA_FORTIFY_COOLDOWN/OW2_ORISA_FORTIFY_COOLDOWN),
                "ability2Cooldown%": 50,
                "ultGen%": percent(OW2_ORISA_ULT_COST/OW1_ORISA_ULT_COST)
            },
            "pharah": {
                "enablePassiveUnlimitedFuel": true,
                "ability1RefuelScalar": 0,
                "ability1Cooldown%": percent(OW1_PHARAH_JUMP_JET_COOLDOWN/OW2_PHARAH_JUMP_JET_COOLDOWN),
                "ability2Cooldown%": percent(OW1_PHARAH_CONCUSSIVE_BLAST_COOLDOWN/OW2_PHARAH_CONCUSSIVE_BLAST_COOLDOWN),
                "passiveExtraFuel%": 0,
                "passiveMaxTime%": 20,
                "passiveRechargeRate%": 100,
                "ultGen%": percent(OW2_PHARAH_ULT_COST/OW1_PHARAH_ULT_COST)
            },
            "ramattra": {
                "ability1Cooldown%": percent(OW1_RAMATTRA_NEMESIS_COOLDOWN/OW2_RAMATTRA_NEMESIS_COOLDOWN),
                "ability2Cooldown%": percent(OW1_RAMATTRA_VORTEX_COOLDOWN/OW2_RAMATTRA_VORTEX_COOLDOWN),
                "secondaryFireCooldown%": percent(OW1_RAMATTRA_VOID_BARRIER_COOLDOWN/OW2_RAMATTRA_VOID_BARRIER_COOLDOWN),
                "ultGen%": percent(OW2_RAMATTRA_ULT_COST/OW1_RAMATTRA_ULT_COST)
            },
            "reaper": {
                "ultGen%": percent(OW2_REAPER_ULT_COST/OW1_REAPER_ULT_COST)
            },
            "reinhardt": {
                "health%": percent(OW1_REINHARDT_BARRIER_HEALTH/OW2_REINHARDT_BARRIER_HEALTH),
                "secondaryFireRechargeRate%": percent(OW1_REINHARDT_BARRIER_REGEN/OW2_REINHARDT_BARRIER_REGEN),
                "ability1Cooldown%": percent(OW1_REINHARDT_CHARGE_COOLDOWN_TIME/OW2_REINHARDT_CHARGE_COOLDOWN_TIME),
                "ability2Cooldown%": percent(OW1_REINHARDT_FIRESTRIKE_COOLDOWN_TIME/OW2_REINHARDT_FIRESTRIKE_COOLDOWN),
                "ultGen%": percent(OW2_REINHARDT_ULT_COST/OW1_REINHARDT_ULT_COST)
            },
            "roadhog": {
                "secondaryFireMaximumTime%": percent((OW1_ROADHOG_BREATHER_DURATION)/OW2_ROADHOG_BREATHER_DURATION),
                "secondaryFireRechargeRate%": 500,
                "ammoClipSize%": percent((OW1_ROADHOG_CLIP_SIZE)/OW2_ROADHOG_CLIP_SIZE),
                "ability1Cooldown%": percent(OW1_ROADHOG_HOOK_COOLDOWN_TIME/OW2_ROADHOG_HOOK_COOLDOWN_TIME),
                "ultGen%": percent(OW2_ROADHOG_ULT_COST/OW1_ROADHOG_ULT_COST)
            },
            "sigma": {
                # barrier recharge rate scales with health scalar for some reason
                "health%": percent(OW1_SIGMA_BARRIER_HEALTH/OW2_SIGMA_BARRIER_HEALTH),
                "secondaryFireRechargeRate%": percent((OW1_SIGMA_BARRIER_REGEN/OW2_SIGMA_BARRIER_REGEN)/(OW1_SIGMA_SHIELDS/OW2_SIGMA_SHIELDS)),
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
                "ultGen%": percent(OW2_SYMMETRA_ULT_COST/OW1_SYMMETRA_ULT_COST)
            },
            "torbjorn": {
                "ultGen%": percent(OW2_TORBJORN_ULT_COST/OW1_TORBJORN_ULT_COST)
            },
            "tracer": {
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
                "ammoClipSize%": percent(OW1_WINSTON_AMMO/OW2_WINSTON_AMMO),
                "ability1Cooldown%": percent(OW1_WINSTON_JUMP_PACK_COOLDOWN_TIME/OW2_WINSTON_JUMP_PACK_COOLDOWN_TIME),
                "ability2Cooldown%": percent(OW1_WINSTON_BARRIER_COOLDOWN/OW2_WINSTON_BARRIER_COOLDOWN),
                "ultGen%": percent(OW2_WINSTON_ULT_COST/OW1_WINSTON_ULT_COST)
            },
            "hammond": {
                "ability1Kb%": percent(1/OW2_WRECKING_BALL_FIREBALL_KB),
                "ability3Cooldown%": percent(OW1_WRECKING_BALL_PILEDRIVER_COOLDOWN_TIME/OW2_WRECKING_BALL_PILEDRIVER_COOLDOWN_TIME),
                "ultGen%": percent(OW2_WRECKING_BALL_ULT_COST/OW1_WRECKING_BALL_ULT_COST),
            },
            "zarya": {
                "ultGen%": percent(OW2_ZARYA_ULT_COST/OW1_ZARYA_ULT_COST),
            },
            "zenyatta": {
                "ultGen%": percent(OW2_ZENYATTA_ULT_COST/OW1_ZENYATTA_ULT_COST)
            },
        }
    }
}
