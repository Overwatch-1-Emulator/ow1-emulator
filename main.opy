settings {
    "main": {
        "description": "ecksdee#11729's attempt to accurately recreate Overwatch 1 in Overwatch 2 using workshop. See https://workshop.codes/KHTG0 for details",
        "modeName": "Overwatch 1 Emulator v0.0.1.a8"
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
            "enableCompetitiveRules": true,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "bountyHunter": {
            "enabled": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "ctf": {
            "enabled": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "control": {
            "enableCompetitiveRules": true,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "ffa": {
            "enabled": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "escort": {
            "enableCompetitiveRules": true,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "hybrid": {
            "enableCompetitiveRules": true,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "practiceRange": {
            "enabledMaps": [],
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "push": {
            "enabled": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "skirmish": {
            "enabled": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        },
        "tdm": {
            "enabled": false,
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
                "ability1Cooldown%": 86
            },
            "baptiste": {
                "ammoClipSize%": 87,
                "ability2Cooldown%": 109
            },
            "dva": {
                "secondaryFireMaximumTime%": 67,
                "ability2Cooldown%": 114
            },
            "genji": {
                "ammoClipSize%": 125,
                "damageDealt%": 107
            },
            "reinhardt": {
                "secondaryFireRechargeRate%": 139,
                "ability1Cooldown%": 143
            },
            "roadhog": {
                "ammoClipSize%": 83,
                "ability1Cooldown%": 133,
                "damageDealt%": 110
            },
            "sigma": {
                "secondaryFireRechargeRate%": 80
            },
            "symmetra": {
                "ammoClipSize%": 70
            },
            "tracer": {
                "damageDealt%": 109
            },
            "winston": {
                "ability2Cooldown%": 108,
                "ability1Cooldown%": 120,
                "enableSecondaryFire": false
            },
            "zarya": {
                "ability2Cooldown%": 80
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
            "general": {
                "combatUltGen%": 0,
                "passiveUltGen%": 0
            }
        }
    }
}

#Global variables

globalvar ow1_hero_health 0
globalvar ow2_hero_health 1
globalvar ow1_ult_cost 2


#Player variables

playervar ult_points 0
playervar last_hero_played 1
playervar hero_switched 2
playervar allow_ult_charge 3
playervar ult_points_backup 4


rule "detect hero switch":
    @Event eachPlayer
    @Condition eventPlayer.last_hero_played != eventPlayer.getCurrentHero()
    
    eventPlayer.hero_switched = true
    eventPlayer.last_hero_played = eventPlayer.getCurrentHero()
    wait()
    eventPlayer.hero_switched = false


rule "initialize overwatch 1 hero healths":
    ow1_hero_health[getAllHeroes().index(Hero.DVA)] = 600
    ow1_hero_health[getAllHeroes().index(Hero.REINHARDT)] = 500
    ow1_hero_health[getAllHeroes().index(Hero.ROADHOG)] = 600
    ow1_hero_health[getAllHeroes().index(Hero.SIGMA)] = 400
    ow1_hero_health[getAllHeroes().index(Hero.WINSTON)] = 500
    ow1_hero_health[getAllHeroes().index(Hero.HAMMOND)] = 600
    ow1_hero_health[getAllHeroes().index(Hero.ZARYA)] = 400


rule "modify hero health to overwatch 1":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true
    
    eventPlayer.setMaxHealth(100)
    wait()
    ow2_hero_health[getAllHeroes().index(eventPlayer.getCurrentHero())] = eventPlayer.getMaxHealth()
    if ow1_hero_health[getAllHeroes().index(eventPlayer.getCurrentHero())] != 0:
        eventPlayer.setMaxHealth(100 * (ow1_hero_health[getAllHeroes().index(eventPlayer.getCurrentHero())] / ow2_hero_health[getAllHeroes().index(eventPlayer.getCurrentHero())]))


rule "initialize overwatch 1 ultimate costs":
    ow1_ult_cost[getAllHeroes().index(Hero.DVA)] = 1540
    ow1_ult_cost[getAllHeroes().index(Hero.REINHARDT)] = 1540
    ow1_ult_cost[getAllHeroes().index(Hero.ROADHOG)] = 2240
    ow1_ult_cost[getAllHeroes().index(Hero.SIGMA)] = 1960
    ow1_ult_cost[getAllHeroes().index(Hero.WINSTON)] = 1540
    ow1_ult_cost[getAllHeroes().index(Hero.HAMMOND)] = 1540
    ow1_ult_cost[getAllHeroes().index(Hero.ZARYA)] = 2100
    ow1_ult_cost[getAllHeroes().index(Hero.ASHE)] = 2240
    ow1_ult_cost[getAllHeroes().index(Hero.BASTION)] = 2310
    ow1_ult_cost[getAllHeroes().index(Hero.MCCREE)] = 1680
    ow1_ult_cost[getAllHeroes().index(Hero.ECHO)] = 2254
    ow1_ult_cost[getAllHeroes().index(Hero.GENJI)] = 1932
    ow1_ult_cost[getAllHeroes().index(Hero.HANZO)] = 1680
    ow1_ult_cost[getAllHeroes().index(Hero.JUNKRAT)] = 1925
    ow1_ult_cost[getAllHeroes().index(Hero.MEI)] = 1610
    ow1_ult_cost[getAllHeroes().index(Hero.PHARAH)] = 2100
    ow1_ult_cost[getAllHeroes().index(Hero.REAPER)] = 2100
    ow1_ult_cost[getAllHeroes().index(Hero.SOLDIER)] = 2310
    ow1_ult_cost[getAllHeroes().index(Hero.SOMBRA)] = 1400
    ow1_ult_cost[getAllHeroes().index(Hero.SYMMETRA)] = 1680
    ow1_ult_cost[getAllHeroes().index(Hero.TORBJORN)] = 2142
    ow1_ult_cost[getAllHeroes().index(Hero.TRACER)] = 1260
    ow1_ult_cost[getAllHeroes().index(Hero.WIDOWMAKER)] = 1540
    ow1_ult_cost[getAllHeroes().index(Hero.ANA)] = 2100
    ow1_ult_cost[getAllHeroes().index(Hero.BAPTISTE)] = 2310
    ow1_ult_cost[getAllHeroes().index(Hero.BRIGITTE)] = 2800
    ow1_ult_cost[getAllHeroes().index(Hero.LUCIO)] = 2940
    ow1_ult_cost[getAllHeroes().index(Hero.MERCY)] = 1820
    ow1_ult_cost[getAllHeroes().index(Hero.MOIRA)] = 2800
    ow1_ult_cost[getAllHeroes().index(Hero.ZENYATTA)] = 2310


rule "pilot dva ult cost":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.getMaxHealth() < 300
    @Condition eventPlayer.isUsingUltimate() == false
    
    ow1_ult_cost[getAllHeroes().index(Hero.DVA)] = 280.9
    eventPlayer.ult_points_backup = eventPlayer.ult_points
    eventPlayer.ult_points = 0


rule "regular dva ult cost":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.getMaxHealth() >= 300
    
    ow1_ult_cost[getAllHeroes().index(Hero.DVA)] = 1540
    eventPlayer.ult_points = eventPlayer.ult_points_backup
    eventPlayer.ult_points_backup = 0


rule "allow ult charge by default":
    @Event eachPlayer
    
    eventPlayer.allow_ult_charge = true


rule "disable ult charge when entering ult":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.allow_ult_charge = false


rule "allow ult charge when exiting ult":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate() == false
    
    wait(2)
    eventPlayer.allow_ult_charge = true


rule "disable ult charge before game begins":
    @Event eachPlayer
    @Condition isGameInProgress() == false
    @Condition isWaitingForPlayers() == false
    
    eventPlayer.allow_ult_charge = false


rule "enable ult charge after game begins":
    @Event eachPlayer
    @Condition (isGameInProgress() or isWaitingForPlayers()) == true
    
    eventPlayer.allow_ult_charge = true


rule "damage ult charge":
    @Event playerDealtDamage
    @Condition victim != eventPlayer
    @Condition eventPlayer.allow_ult_charge == true
    @Condition eventPlayer.getUltCharge() < 100
    
    eventPlayer.ult_points += eventDamage
    eventPlayer.setUltCharge(100 * (eventPlayer.ult_points / ow1_ult_cost[getAllHeroes().index(eventPlayer.getCurrentHero())]))


rule "healing ult charge":
    @Event playerDealtHealing
    @Condition eventPlayer.allow_ult_charge == true
    @Condition eventPlayer.getUltCharge() < 100
    
    eventPlayer.ult_points += eventHealing
    eventPlayer.setUltCharge(100 * (eventPlayer.ult_points / ow1_ult_cost[getAllHeroes().index(eventPlayer.getCurrentHero())]))


rule "passive ult charge":
    @Event eachPlayer
    @Condition eventPlayer.allow_ult_charge == true
    @Condition eventPlayer.getUltCharge() < 100
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.ult_points += 5
    eventPlayer.setUltCharge(100 * (eventPlayer.ult_points / ow1_ult_cost[getAllHeroes().index(eventPlayer.getCurrentHero())]))
    if RULE_CONDITION:
        goto RULE_START


rule "reset ult charge after using ult":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setUltCharge(0)
    eventPlayer.ult_points = 0


rule "reset ult after switching hero":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true
    
    eventPlayer.setUltCharge(0)
    eventPlayer.ult_points = 0
    eventPlayer.ult_points_backup = 0


