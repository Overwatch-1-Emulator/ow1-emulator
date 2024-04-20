# 6v6 Adjustments decompiled to Overpy on April 19, 2024

settings {
    "main": {
        "description": "Intended for 6v6 gameplay, by Toastie#11770\n\nPrimary workshop development provided \nby LemonHead#11820\n\nGamemode forked from \nOverwatch 1 Emulator v1.12.2 (KHTG0)\n\nCome join the discord server! We host 6v6\ncustom lobbies every weekend! (6v6.info)\nhttps://discord.gg/uzFUQu7G4s",
        "modeName": "Overwatch 6v6 Adjustments 7HSKW"
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
            "enableCompetitiveRules": true,
            "randomHeroRoleLimitPerTeam": 2
        },
        "bountyHunter": {
            "enabled": false,
            "randomHeroRoleLimitPerTeam": 2
        },
        "ctf": {
            "enabled": false,
            "randomHeroRoleLimitPerTeam": 2
        },
        "clash": {
            "enabled": false,
            "enableCompetitiveRules": true,
            "randomHeroRoleLimitPerTeam": 2
        },
        "control": {
            "disabledMaps": [
                "lijiangTowerLny"
            ],
            "enableCompetitiveRules": true,
            "randomHeroRoleLimitPerTeam": 2
        },
        "ffa": {
            "enabled": false,
            "randomHeroRoleLimitPerTeam": 2
        },
        "escort": {
            "enableCompetitiveRules": true,
            "randomHeroRoleLimitPerTeam": 2
        },
        "flashpoint": {
            "enableCompetitiveRules": true,
            "randomHeroRoleLimitPerTeam": 2,
            "scoringSpeed%": 85
        },
        "hybrid": {
            "disabledMaps": [
                "blizzWorldWinter",
                "eichenwaldeHalloween",
                "hollywoodHalloween",
                "kingsRowWinter"
            ],
            "enableCompetitiveRules": true,
            "randomHeroRoleLimitPerTeam": 2
        },
        "practiceRange": {
            "enabled": false,
            "randomHeroRoleLimitPerTeam": 2
        },
        "push": {
            "disabledMaps": [
                "colosseo"
            ],
            "enableCompetitiveRules": true,
            "randomHeroRoleLimitPerTeam": 2
        },
        "skirmish": {
            "enabled": false,
            "randomHeroRoleLimitPerTeam": 2
        },
        "tdm": {
            "enabled": false,
            "randomHeroRoleLimitPerTeam": 2
        },
        "general": {
            "roleLimit": "2OfEachRolePerTeam"
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
    },
    "workshop": {
        "Damage Role Cap": 2,
        "Support Role Cap": 2,
        "Tank Role Cap": 2
    }
}

#Global variables

globalvar MaxRoles 0
globalvar Setting_echo_tank_hp 1


#Player variables

playervar hero_setup 0
playervar hero_check 1
playervar heal_state 2
playervar ult_change_check 4
playervar overhealth_check 5
playervar balance_change_check 6
playervar duplicate_leftover_health 7
playervar self_bubble_cooldown 8
playervar self_bubble_cd_text 9
playervar ally_bubble_cooldown 10
playervar ally_bubble_cd_text 11
playervar Ana_damage_check 12
playervar AllowedHeroes 13


#Subroutine names

subroutine healPassiveReset 0
subroutine startHealPassiveBackUp 1
subroutine enableAllAbilities 2
subroutine disableAllAbilities 3
subroutine resetStats 4
subroutine resetStatuses 5
subroutine endHealPassiveBackUp 6
subroutine removeTankPassive 7
subroutine resetHealth 8
subroutine resetUltCharge 9
subroutine initSelfBubble 10
subroutine showSelfBubbleCD 11
subroutine hideSelfBubbleCD 12
subroutine initAllyBubble 13
subroutine showAllyBubbleCD 14
subroutine hideAllyBubbleCD 15


rule "Anticrash":
    @Condition getServerLoad() >= 200
    
    wait(5.5, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Crash protection in progress...")
    setSlowMotion(10)
    waitUntil(getServerLoad() < 110, 99999)
    setSlowMotion(100)


rule "Workshop Setting: Echo Tank Hp":
    @Condition createWorkshopSetting(bool, "General Changes", "Full Echo Tank HP", false, 0) == true
    
    Setting_echo_tank_hp = true


/*
rule "Workshop Setting: Set Role Limits":
    MaxRoles = [createWorkshopSetting(int[0:5], "Role limits", "Tank Role Cap", 0, 0), createWorkshopSetting(int[0:5], "Role limits", "Damage Role Cap", 0, 1), createWorkshopSetting(int[0:5], "Role limits", "Support Role Cap", 0, 2)]
*/

/*
rule "Skip Hero Assembly Phase":
    @Condition isAssemblingHeroes() == true
    
    setMatchTime(0.1)
*/

/*
rule "Initialize Role Limits":
    @Event eachPlayer
    
    eventPlayer.AllowedHeroes = getAllHeroes()
*/

/*
rule "Lock/Unlock Tank heroes at role limit":
    @Event eachPlayer
    @Condition len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getTankHeroes()]).exclude(eventPlayer)) >= MaxRoles[0]
    @Condition MaxRoles[0] > 0
    
    eventPlayer.AllowedHeroes.remove(getTankHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.AllowedHeroes)
    waitUntil(len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getTankHeroes()]).exclude(eventPlayer)) < MaxRoles[0], 99999)
    eventPlayer.AllowedHeroes.append(getTankHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.AllowedHeroes)
*/

/*
rule "Lock/Unlock Damage heroes at role limit":
    @Event eachPlayer
    @Condition len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getDamageHeroes()]).exclude(eventPlayer)) >= MaxRoles[1]
    @Condition MaxRoles[1] > 0
    
    eventPlayer.AllowedHeroes.remove(getDamageHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.AllowedHeroes)
    waitUntil(len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getDamageHeroes()]).exclude(eventPlayer)) < MaxRoles[1], 99999)
    eventPlayer.AllowedHeroes.append(getDamageHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.AllowedHeroes)
*/

/*
rule "Lock/Unlock Support heroes at role limit":
    @Event eachPlayer
    @Condition len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getSupportHeroes()]).exclude(eventPlayer)) >= MaxRoles[2]
    @Condition MaxRoles[2] > 0
    
    eventPlayer.AllowedHeroes.remove(getSupportHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.AllowedHeroes)
    waitUntil(len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getSupportHeroes()]).exclude(eventPlayer)) < MaxRoles[2], 99999)
    eventPlayer.AllowedHeroes.append(getSupportHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.AllowedHeroes)
*/

def resetHealth():
    @Name "resethealth()"
    
    eventPlayer.setHealingReceived(0)
    eventPlayer.setHealth(1)
    eventPlayer.addHealthPool(Health.NORMAL, 1, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 1, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 1, true, true)
    eventPlayer.removeAllHealthPools()


def enableAllAbilities():
    @Name "enableAllAbilities()"
    
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.allowButton(Button.INTERACT)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setUltEnabled(true)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setJumpEnabled(true)
    eventPlayer.setCrouchEnabled(true)
    eventPlayer.setReloadEnabled(true)


def disableAllAbilities():
    @Name "disableAllAbilities()"
    
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.disallowButton(Button.INTERACT)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setUltEnabled(false)
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setJumpEnabled(false)
    eventPlayer.setCrouchEnabled(false)
    eventPlayer.setReloadEnabled(false)


def resetStats():
    @Name "resetStats()"
    
    eventPlayer.stopScalingSize()
    eventPlayer.stopScalingBarriers()
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setHealingDealt(0)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setKnockbackDealt(100)
    eventPlayer.setGravity(100)
    eventPlayer.setJumpVerticalSpeed(100)
    eventPlayer.setMoveSpeed(100)
    heal(eventPlayer, null, 1)
    eventPlayer.heal_state = 0


def resetStatuses():
    @Name "resetStatuses()"
    
    eventPlayer.clearStatusEffect(Status.ASLEEP)
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.clearStatusEffect(Status.FROZEN)
    eventPlayer.clearStatusEffect(Status.HACKED)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.clearStatusEffect(Status.STUNNED)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)
    eventPlayer.stopScalingSize()


def resetUltCharge():
    @Name "resetUltCharge()"
    
    wait(eventPlayer.getUltCharge() > 0)
    eventPlayer.setUltCharge(0)


def removeTankPassive():
    @Name "removeTankPassive()"
    
    eventPlayer.setKnockbackReceived(135.857)


def healPassiveReset():
    @Name "healPassiveReset()"
    
    damage(eventPlayer, null, 0.001 / 1000)
    heal(eventPlayer, null, 0.001 / 1000)


rule "Check for hero setup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup != eventPlayer.getCurrentHero()
    @Condition eventPlayer.isDuplicatingAHero() == false
    @Condition isMatchBetweenRounds() == false
    @Condition eventPlayer.isAlive() == true
    
    #This wait time may be needed for some gameodes 
    #wait(0.024)
    eventPlayer.hero_setup = eventPlayer.getCurrentHero()


rule "Check for hero change":
    @Event eachPlayer
    @Condition eventPlayer.hero_check != eventPlayer.getCurrentHero()
    
    #This wait time may be needed for some gameodes 
    #wait(0.024)
    eventPlayer.hero_check = eventPlayer.getCurrentHero()
    resetUltCharge()


rule "Hero reset on death":
    @Event playerDied
    
    eventPlayer.hero_setup = -1


rule "Hero reset after round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    
    eventPlayer.hero_setup = -1


/*
rule "Hero reset after game starts (needed for gamemodes with no hero select/bots)":
    @Event eachPlayer
    @Condition isInSetup() == true
    
    eventPlayer.hero_setup = -1
*/

rule "Remove DPS Passive":
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() in getDamageHeroes() == true
    @Condition attacker != victim
    
    eventPlayer.setHealingReceived(117.65)
    wait(2, Wait.RESTART_WHEN_TRUE)
    eventPlayer.setHealingReceived(100)


rule "When to stop self-heal":
    @Event eachPlayer
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS) == eventPlayer.getMaxHealthOfType(Health.SHIELDS)
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth()
    @Condition eventPlayer.heal_state != 0
    
    healPassiveReset()
    wait(2.484 if eventPlayer.getCurrentHero() in getSupportHeroes() else 4.984, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START


rule "D.va (mech)":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.DVA
    @Condition eventPlayer.isInAlternateForm() == false
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 299 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 349, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 150 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 200, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    if eventPlayer.getMaxHealth() != (450 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 550):
        goto RULE_START


rule "D.va (pilot)":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.DVA
    @Condition eventPlayer.isInAlternateForm() == true
    
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(85.714)
    eventPlayer.removeAllHealthPools()
    #resetHealth()
    #eventPlayer.addHealthPool(Health.NORMAL, 149, true, true)
    #resetStats()
    #resetStatuses()
    #resetUltCharge()
    #enableAllAbilities()
    removeTankPassive()
    #Reset ultimate charge when DVa pops out of Mech
    if eventPlayer.isUsingUltimate():
        return
    resetUltCharge()


rule "Doomfist":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.DOOMFIST
    
    eventPlayer.ult_change_check = 0.97
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 349 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 399, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setHealingDealt(0)
    eventPlayer.setKnockbackDealt(80)
    eventPlayer.setDamageDealt(90)


rule "Increase Doomfist melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.DOOMFIST
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.128 - eventDamage)


rule "Increase Rocket Punch damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.DOOMFIST
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    damage(victim, attacker, eventDamage * 1.128 - eventDamage)


rule "Increase Meteor Strike damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.DOOMFIST
    @Condition eventAbility == Button.ULTIMATE
    
    damage(victim, attacker, eventDamage * 1.126 - eventDamage)


rule "Junker Queen":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.JUNKER_QUEEN
    
    eventPlayer.ult_change_check = 1.07
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxAmmo(0, 6)
    eventPlayer.setAmmo(0, 6)
    eventPlayer.overhealth_check = false
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 349 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 399, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setHealingDealt(74.29)
    eventPlayer.setDamageDealt(87.5)
    eventPlayer.heal_state = 1


rule "Correct Commanding Shout overhealth while outside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.JUNKER_QUEEN
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.overhealth_check == false
    
    damage(eventPlayer, null, 50)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility1() == false, 99999)
    eventPlayer.overhealth_check = false


rule "Correct Commanding Shout overhealth while inside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.JUNKER_QUEEN
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition eventPlayer.overhealth_check == false
    
    eventPlayer.setHealth(eventPlayer.getMaxHealth() - 50)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility1() == false, 99999)
    eventPlayer.overhealth_check = false


rule "Reduce Rampage Damage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.JUNKER_QUEEN
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(66.777)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setDamageDealt(87.5)


rule "Mauga":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MAUGA
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 299 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 399, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 100, true, true)
    eventPlayer.overhealth_check = false
    eventPlayer.balance_change_check = false
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setDamageDealt(87.5)
    eventPlayer.setHealingDealt(72)
    eventPlayer.startScalingSize(0.94, true)
    eventPlayer.setJumpVerticalSpeed(101)
    eventPlayer.heal_state = 1


rule "Increase Mauga melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.MAUGA
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.14 - eventDamage)


rule "Remove Cardiac Overdrive allied damage reduction and set cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MAUGA
    @Condition eventPlayer.isUsingAbility2() == true
    
    startDamageModification(getPlayersInRadius(eventPlayer, 10.5, eventPlayer.getTeam(), LosCheck.SURFACES).exclude(eventPlayer), getAllPlayers(), 142.8, DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.balance_change_check = getLastDamageModification()
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 16)
    stopDamageModification(eventPlayer.balance_change_check)


rule "Reduce Cage Fight duration":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MAUGA
    @Condition eventPlayer.isUsingUltimate() == true
    
    wait(7)
    eventPlayer.forceButtonPress(Button.ULTIMATE)


rule "Orisa":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ORISA
    
    eventPlayer.ult_change_check = 1.12
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 299, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 150 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 200, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()


rule "Correct Fortify overhealth while outside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ORISA
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.overhealth_check == false
    #@Condition eventPlayer.getHealthOfType(Health.ARMOR) >= 0.1
    
    damage(eventPlayer, null, 181.8)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility1() == false, 99999)
    eventPlayer.overhealth_check = false


rule "Correct Fortify overhealth while inside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ORISA
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition eventPlayer.overhealth_check == false
    
    eventPlayer.setHealth(eventPlayer.getMaxHealth() - 100)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility1() == false, 99999)
    eventPlayer.overhealth_check = false


rule "Reduce Terra Surge damage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ORISA
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(80)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setDamageDealt(100)


rule "Ramattra":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(65)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 349 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 399, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.startScalingSize(0.94, true)
    eventPlayer.setJumpVerticalSpeed(101)


rule "Correct Nemesis Form armor, movement speed, and cooldown for duplicate":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.getMaxHealthOfType(Health.ARMOR) == true
    
    eventPlayer.setMoveSpeed(83.4)
    eventPlayer.addHealthPool(Health.ARMOR, 28, true, true)
    waitUntil(eventPlayer.getMaxHealthOfType(Health.ARMOR) < 29, 99999)
    eventPlayer.setMoveSpeed(100)
    if not RULE_CONDITION:
        return
    removeHealthPool(getLastCreatedHealthPool())
    #if eventPlayer.getHeroOfDuplication() == Hero.RAMATTRA:
    #waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) != 0, 99999)
    #eventPlayer.setAbilityCooldown(Button.ABILITY_1, 9)


rule "Increase Pummel damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.getMaxHealthOfType(Health.ARMOR) == true
    @Condition eventDamage >= 50
    @Condition eventAbility != Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.169 - eventDamage)


rule "Disable Block after use":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.getMaxHealthOfType(Health.ARMOR) == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 999999986991104)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(false)
    waitUntil(eventPlayer.getMaxHealthOfType(Health.ARMOR) < 29, 99999)
    wait(0.25)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)


rule "Set Ravenous Vortex cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.isUsingAbility2() == true
    
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0, 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 12)


rule "Bonus Annihilation movement speed":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.isUsingUltimate() == true
    
    wait()
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)


/*
rule "Reset Nemesis bonus armor when going into Annihilation":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.RAMATTRA
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getMaxHealthOfType(Health.ARMOR) == true
    
    removeHealthPool(getLastCreatedHealthPool())
    eventPlayer.addHealthPool(Health.ARMOR, 15, true, true)
*/

rule "Reinhardt":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    
    eventPlayer.ult_change_check = 1.07
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(114.3)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 150 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 250, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setKnockbackReceived(115)
    eventPlayer.stopForcingThrottle()
    eventPlayer.setDamageDealt(80)


rule "Force single Firestrike":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setDamageDealt(83.4)
    waitUntil(not eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setDamageDealt(80)
    #Every time rein uses firestrike, reset the resource to 0
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 0)
    wait(6)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)


/*
rule "Increase Firestrike damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventAbility == Button.ABILITY_2
    @Condition (not eventPlayer.isUsingAbility2()) == false
    
    damage(victim, attacker, eventDamage * 1.053 - eventDamage)
*/

rule "Increase Charge damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventAbility == Button.ABILITY_1
    #Checks for pin vs boop damage
    @Condition eventDamage > 100
    
    damage(victim, attacker, eventDamage * 1.321 - eventDamage)


rule "Reduce Charge radius":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.startForcingThrottle(0, 0.667, 0, 0.667, 0, 0.667)
    waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    eventPlayer.stopForcingThrottle()


rule "Increase Earthshatter damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 100
    
    damage(victim, attacker, eventDamage * 1.708 - eventDamage)


rule "Roadhog":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    
    eventPlayer.ult_change_check = 1.07
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAmmo(0, 5)
    eventPlayer.setMaxAmmo(0, 5)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 499 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 599, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setDamageDealt(87.5)


rule "Increase Roadhog melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.138 - eventDamage)


rule "Increase Chain Hook damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventAbility == Button.ABILITY_1
    
    damage(victim, attacker, eventDamage * 3.91 - eventDamage)


rule "Force Chain Hook cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 7)


rule "Increase Pigpen damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventPlayer.isUsingUltimate() == false
    
    damage(victim, attacker, eventDamage * 1.333 - eventDamage)


rule "Wholehog abilities check":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setKnockbackDealt(100)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    enableAllAbilities()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.setDamageDealt(90.625)
    eventPlayer.setKnockbackDealt(35)


rule "Wholehog force autofire":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)


rule "Sigma":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SIGMA
    
    eventPlayer.ult_change_check = 1.07
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 299, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 150, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.balance_change_check = 0


rule "Remove Kinetic Grasp overhealth":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SIGMA
    @Condition eventPlayer.isUsingAbility1() == true
    
    wait(1.92)
    if not RULE_CONDITION:
        return
    eventPlayer.setStatusEffect(null, Status.STUNNED, 0.001)
    if eventPlayer.isInSpawnRoom():
        wait(0.1)
        eventPlayer.balance_change_check = eventPlayer.getMaxHealth()
        eventPlayer.balance_change_check -= 450
        eventPlayer.setHealth(eventPlayer.getMaxHealth() - eventPlayer.balance_change_check)


rule "Increase Accretion damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.SIGMA
    @Condition eventAbility == Button.ABILITY_2
    
    damage(victim, attacker, eventDamage * 1.125 - eventDamage)


rule "Winston":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.WINSTON
    
    eventPlayer.ult_change_check = 1.13
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 299 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 399, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 100, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setDamageDealt(80)


rule "Increase Winston other forms of damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.WINSTON
    @Condition eventAbility != Button.PRIMARY_FIRE
    @Condition eventAbility != Button.ULTIMATE
    
    damage(victim, attacker, eventDamage * 1.25 - eventDamage)


rule "Set default Leap cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.WINSTON
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 6)


rule "Reset Leap cooldown after Primal Rage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.WINSTON
    @Condition eventPlayer.isUsingUltimate() == true
    
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)


rule "Wrecking Ball":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    
    eventPlayer.ult_change_check = 1.05
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(75)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 399 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 449, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 50 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 100, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    #eventPlayer.startScalingSize(0.9, true)
    #eventPlayer.setJumpVerticalSpeed(104)


rule "Force Grappling Hook cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0.1, 999999986991104)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 5)


/*
rule "Correct Adaptive Shields overhealth while outside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.overhealth_check == false
    
    damage(eventPlayer, null, 100)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility2() == false, 99999)
    eventPlayer.overhealth_check = false
*/

/*
rule "Correct Adaptive Shields overhealth while inside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition eventPlayer.overhealth_check == false
    
    eventPlayer.setHealth(eventPlayer.getMaxHealth() - 100)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility2() == false, 99999)
    eventPlayer.overhealth_check = false
*/

/*
rule "Enable Adaptive Shields when near enemy players":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition getPlayersInRadius(eventPlayer, 8.9, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF) >= 1
    
    eventPlayer.setAbility2Enabled(true)
*/

/*
rule "Disable Adaptive Shields when not near enemy players":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition getPlayersInRadius(eventPlayer, 8.9, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF) <= 0
    
    eventPlayer.setAbility2Enabled(false)
*/

rule "Remove Adaptive Shields overhealth transfer":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HAMMOND
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.setAbility2Enabled(false)
    waitUntil(not eventPlayer.isUsingAbility2(), 999999986991104)
    enableAllAbilities()
    eventPlayer.allowButton(Button.ABILITY_2)


rule "Zarya":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 150 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 200, true, true)
    initSelfBubble()
    initAllyBubble()
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setKnockbackDealt(73.607)
    eventPlayer.setDamageDealt(84.211)


rule "Increase Zarya Alternate Fire and melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition (eventAbility == Button.MELEE or eventAbility == Button.SECONDARY_FIRE) == true
    
    damage(victim, attacker, eventDamage * 1.188 - eventDamage)


def initSelfBubble():
    @Name "initSelfBubble()"
    
    eventPlayer.self_bubble_cooldown = 0


def showSelfBubbleCD():
    @Name "showSelfBubbleCD()"
    
    createInWorldText(eventPlayer, "{0}".format(ceil(eventPlayer.self_bubble_cooldown)), updateEveryTick(eventPlayer.getEyePosition() + (100 * (1.99 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + (-1.64 * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.self_bubble_cd_text = getLastCreatedText()


def hideSelfBubbleCD():
    @Name "hideSelfBubbleCD()"
    
    destroyInWorldText(eventPlayer.self_bubble_cd_text)


rule "Set Particle Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 2)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.self_bubble_cooldown = 12
    chase(eventPlayer.self_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)


rule "Disable Particle Barrier if on cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.self_bubble_cooldown > 0
    
    eventPlayer.setAbility1Enabled(false)


rule "Enable Particle Barrier if not on cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.self_bubble_cooldown <= 0
    
    eventPlayer.setAbility1Enabled(true)


rule "Show Particle Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.self_bubble_cooldown > 0
    
    showSelfBubbleCD()


rule "Erase Particle Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.self_bubble_cooldown <= 0
    
    hideSelfBubbleCD()


def initAllyBubble():
    @Name "initAllyBubble()"
    
    eventPlayer.ally_bubble_cooldown = 0


def showAllyBubbleCD():
    @Name "showAllyBubbleCD()"
    
    createInWorldText(eventPlayer, "{0}".format(ceil(eventPlayer.ally_bubble_cooldown)), updateEveryTick(eventPlayer.getEyePosition() + (100 * (2.3 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + (-1.66 * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.ally_bubble_cd_text = getLastCreatedText()


def hideAllyBubbleCD():
    @Name "hideAllyBubbleCD()"
    
    destroyInWorldText(eventPlayer.ally_bubble_cd_text)


rule "Set Projected Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.ally_bubble_cooldown = 10
    chase(eventPlayer.ally_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)


rule "Disable Projected Barrier if on cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.ally_bubble_cooldown > 0
    
    eventPlayer.setAbility2Enabled(false)


rule "Enable Projected Barrier if not on cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.ally_bubble_cooldown <= 0
    
    eventPlayer.setAbility2Enabled(true)


rule "Show Projected Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.ally_bubble_cooldown > 0
    
    showAllyBubbleCD()


rule "Erase Projected Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.ally_bubble_cooldown <= 0
    
    hideAllyBubbleCD()


rule "Clean up Zarya":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup != Hero.ZARYA
    
    hideSelfBubbleCD()
    hideAllyBubbleCD()


rule "Ashe":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ASHE
    
    eventPlayer.ult_change_check = 1.21
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()


rule "Bastion":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.BASTION
    
    eventPlayer.ult_change_check = 1.21
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 100, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()


rule "Cassidy":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MCCREE
    
    eventPlayer.ult_change_check = 1.22
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()


rule "Reduce damage reduction during Combat Roll":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MCCREE
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setDamageReceived(200)
    waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    eventPlayer.setDamageReceived(100)


rule "Remove damage reduction during Deadeye":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MCCREE
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageReceived(133.333)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setDamageReceived(100)


rule "Echo":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ECHO
    
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(94.444)
    if eventPlayer.isInSpawnRoom() == false:
        damage(eventPlayer, null, eventPlayer.duplicate_leftover_health)


rule "Increase Tri-Shot and Echo melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ECHO
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.MELEE) == true
    
    damage(victim, attacker, eventDamage * 1.064 - eventDamage)


rule "Bonus Ultimate charge while in Duplicate":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero() == true
    @Condition eventPlayer.getUltCharge() == 0
    
    wait()
    eventPlayer.setUltCharge(4 + (16 * (eventPlayer.ult_change_check - 1)))


rule "Check health when exiting Duplicate":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero() == true
    
    eventPlayer.hero_setup = eventPlayer.getHeroOfDuplication()
    eventPlayer.duplicate_leftover_health = 100
    wait(15)
    eventPlayer.duplicate_leftover_health = 0


rule "(Duplicate) Seismic Slam cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DOOMFIST
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 7)


rule "(Duplicate) Power Block cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DOOMFIST
    @Condition eventPlayer.isUsingAbility2() == true
    
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 9)


rule "(Duplicate) Cardiac Overdrive cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MAUGA
    @Condition eventPlayer.isUsingAbility2() == true
    
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 16)


rule "(Duplicate) Overrun cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.MAUGA
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)


rule "(Duplicate) Charge cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)


rule "(Duplicate) Kinetic Grasp cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.SIGMA
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) != 0, 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 13)


rule "(Duplicate) Storm Arrow cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.HANZO
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)


rule "(Duplicate) Concussion Mine cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.JUNKRAT
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)


/*
rule "(Duplicate) Shadow Step cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.REAPER
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 8)
*/

rule "(Duplicate) Biotic Field cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.SOLDIER
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 15)


rule "(Duplicate) Recall cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.TRACER
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 12)


rule "(Duplicate) Sleep Dart cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.ANA
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) != 0, 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 12)


rule "Genji":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.GENJI
    
    eventPlayer.ult_change_check = 1.2
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()


rule "Increase Shurikens damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.GENJI
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.SECONDARY_FIRE) == true
    
    damage(victim, attacker, eventDamage * 1.074 - eventDamage)


rule "Hanzo":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.HANZO
    
    eventPlayer.ult_change_check = 1.21
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(93.333)


rule "Increase Storm Bow and Hanzo melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.HANZO
    @Condition (eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.MELEE) == true
    
    damage(victim, attacker, eventDamage * 1.085 - eventDamage)


rule "Junkrat":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.JUNKRAT
    
    eventPlayer.ult_change_check = 1.18
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    #resetHealth()
    #Version or the "resetHealth" subroutine that keeps tire at 100 hp
    wait()
    eventPlayer.setHealingReceived(0)
    eventPlayer.setHealth(200)
    eventPlayer.addHealthPool(Health.NORMAL, 1, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 1, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 1, true, true)
    eventPlayer.removeAllHealthPools()
    #eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()


rule "Mei":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MEI
    
    eventPlayer.ult_change_check = 1.18
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(80)
    eventPlayer.setMaxAmmo(0, 120)
    eventPlayer.setAmmo(0, 120)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()


rule "Pharah":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.PHARAH
    
    eventPlayer.ult_change_check = 1.19
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setProjectileSpeed(87.5)


rule "Reset projectile speed for Barrage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.PHARAH
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setProjectileSpeed(100)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setProjectileSpeed(87.5)


rule "Reaper":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REAPER
    
    eventPlayer.ult_change_check = 1.14
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 249, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


rule "Increase Hellfire Shotgun damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REAPER
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isUsingUltimate() == false
    
    damage(victim, attacker, eventDamage * 1.094 - eventDamage)


rule "Reduce Death Blossom damage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REAPER
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(91.891)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setDamageDealt(100)


rule "Sojourn":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SOJOURN
    
    eventPlayer.ult_change_check = 1.1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()


rule "Soldier 76":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SOLDIER
    
    eventPlayer.ult_change_check = 1.2
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    heal(eventPlayer, null, 1)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(86.4)
    eventPlayer.heal_state = 1


rule "Increase Heavy Pulse Rifle damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REAPER
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, eventDamage * 1.026 - eventDamage)


rule "Sombra":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SOMBRA
    
    eventPlayer.ult_change_check = 1.14
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(1)


rule "Symmetra":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SYMMETRA
    
    eventPlayer.ult_change_check = 1.17
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(75)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 99, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 125, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    startHealingModification(eventPlayer, eventPlayer, 0, HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)


rule "Torbjorn":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.TORBJORN
    
    eventPlayer.ult_change_check = 1.17
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(111.11)
    eventPlayer.setAmmo(0, 15)
    eventPlayer.setMaxAmmo(0, 15)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 50, true, true)
    eventPlayer.overhealth_check = false
    resetStats()
    resetStatuses()
    enableAllAbilities()


rule "Increase Rivet Gun alternate fire ammo cost":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.TORBJORN
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) - 1)


rule "Correct Overload overhealth while outside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.TORBJORN
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.overhealth_check == false
    
    damage(eventPlayer, null, 12)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility2() == false, 99999)
    eventPlayer.overhealth_check = false


rule "Correct Overload overhealth while inside spawn rooms":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.TORBJORN
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition eventPlayer.overhealth_check == false
    
    eventPlayer.setHealth(eventPlayer.getMaxHealth() - 12)
    eventPlayer.overhealth_check = true
    waitUntil(eventPlayer.isUsingAbility2() == false, 99999)
    eventPlayer.overhealth_check = false


rule "Tracer":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.TRACER
    
    eventPlayer.ult_change_check = 1.18
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 5)
    eventPlayer.setMaxHealth(85.714)
    #resetHealth()
    #eventPlayer.addHealthPool(Health.NORMAL, 174, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(91.667)
    eventPlayer.startScalingSize(0.96, true)


rule "Increase Tracer melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.TRACER
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.117 - eventDamage)


rule "Increase Pulse Bomb damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.TRACER
    @Condition eventAbility == Button.ULTIMATE
    
    damage(victim, attacker, eventDamage * 1.1 - eventDamage)


rule "Venture":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.VENTURE
    
    eventPlayer.ult_change_check = 1.13
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(62.5)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(75)


rule "Correct Venture bonus shields":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.VENTURE
    @Condition eventPlayer.getMaxHealthOfType(Health.SHIELDS) >= 46
    
    eventPlayer.addHealthPool(Health.SHIELDS, 3.125, true, true)
    waitUntil(eventPlayer.getMaxHealthOfType(Health.SHIELDS) < 49, 99999)
    removeHealthPool(getLastCreatedHealthPool())


rule "Increase Venture melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.VENTURE
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.325 - eventDamage)


rule "Increase Smart Excavator damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.VENTURE
    @Condition eventPlayer.isMeleeing() == false
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isUsingAbility2() == false
    @Condition eventPlayer.isUsingUltimate() == false
    
    damage(victim, attacker, eventDamage * 1.107 - eventDamage)


rule "Reduce Burrow damage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.VENTURE
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setDamageDealt(72.73)
    waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    if not eventPlayer.isUsingUltimate():
        eventPlayer.setDamageDealt(75)
    elif eventPlayer.isUsingUltimate():
        eventPlayer.setDamageDealt(84.62)


rule "Increase Tectonic Shock damage":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.VENTURE
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(84.62)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setDamageDealt(75)


rule "Widowmaker":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.WIDOWMAKER
    
    eventPlayer.ult_change_check = 1.19
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 174, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()


rule "Ana":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ANA
    
    eventPlayer.ult_change_check = 1.06
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    eventPlayer.Ana_damage_check = false
    eventPlayer.setMaxAmmo(0, 12)
    eventPlayer.setAmmo(0, 12)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(66.667)
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


rule "Increase Ana melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ANA
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.778 - eventDamage)


rule "Increase Biotic Rifle damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ANA
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.Ana_damage_check == false
    
    eventPlayer.Ana_damage_check = true
    victim.startDoT(attacker, 0.55, 64.404)
    wait(0.6)
    eventPlayer.Ana_damage_check = false


rule "Increase Biotic Grenade healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.ANA
    @Condition eventAbility == Button.ABILITY_2
    
    heal(healee, healer, eventHealing * 1.111 - eventHealing)


rule "Sleep Dart self-heal backup":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.ASLEEP) == true
    
    healPassiveReset()
    startHealPassiveBackUp()
    waitUntil(eventPlayer.hasStatusEffect(Status.ASLEEP) == false, 99999)
    endHealPassiveBackUp()
    healPassiveReset()


rule "Baptiste":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    
    eventPlayer.ult_change_check = 0.93
    eventPlayer.removeAllHealthPools()
    #eventPlayer.setAmmo(1, 10)
    #eventPlayer.setMaxAmmo(1, 10)
    eventPlayer.setMaxHealth(80)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    #eventPlayer.addHealthPool(Health.SHIELDS, 25, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(100)
    eventPlayer.setHealingDealt(70)
    eventPlayer.heal_state = 1
    eventPlayer.balance_change_check = true


/*
rule "Increase Baptiste melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.045 - eventDamage)
*/

rule "Increase Biotic Launcher healing":
    @Event playerDealtHealing
    @Condition eventPlayer.balance_change_check == true
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventHealing <= 34
    
    eventPlayer.balance_change_check = false
    heal(healee, healer, eventHealing * 2.857 - eventHealing)
    wait(0.25)
    eventPlayer.balance_change_check = true


rule "Remove initial burst healing from Regenerative Burst and set cooldown for duplicate":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setHealingDealt(0)
    waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    eventPlayer.setHealingDealt(70)
    if eventPlayer.getHeroOfDuplication() == Hero.BAPTISTE:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 13)


rule "Increase Regenerative Burst self healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition healee == healer
    @Condition eventAbility == Button.ABILITY_1
    
    heal(healee, healer, eventHealing * 5.357 - eventHealing)


rule "Increase Regenerative Burst ally healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventAbility == Button.ABILITY_1
    @Condition healee != healer
    
    heal(healee, healer, eventHealing * 2.67 - eventHealing)


rule "Brigitte":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.BRIGITTE
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 149, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 50, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(77.888)
    eventPlayer.setHealingDealt(80)
    eventPlayer.heal_state = 1


rule "Increase Brigitte damage on most abilities":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.BRIGITTE
    @Condition eventAbility != Button.PRIMARY_FIRE
    
    damage(victim, attacker, eventDamage * 1.286 - eventDamage)


rule "Increase Inspire self healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BRIGITTE
    @Condition healee == healer
    
    heal(healee, null, eventHealing * 1.246 - eventHealing)


rule "Increase Repair Pack healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BRIGITTE
    @Condition eventAbility == Button.ABILITY_2
    
    heal(healee, healer, eventHealing * 1.25 - eventHealing)


rule "Extra Repair Pack burst healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BRIGITTE
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventHealing >= 19
    
    heal(healee, healer, 10)


rule "Illari":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ILLARI
    
    eventPlayer.ult_change_check = 1.04
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxAmmo(0, 14)
    eventPlayer.setAmmo(0, 14)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(75)
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


rule "Increase Illari melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ILLARI
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.34 - eventDamage)


rule "Increase Solar Rifle damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ILLARI
    @Condition eventWasCriticalHit == false
    @Condition eventDamage < 119
    @Condition eventAbility != Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.267 - eventDamage)


rule "Increase Solar Rifle critical hit damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ILLARI
    @Condition eventWasCriticalHit == true
    
    damage(victim, attacker, eventDamage * 1.327 - eventDamage)


rule "Reduce Solar Rifle healing":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ILLARI
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.setHealingDealt(91.27)
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 99999)
    eventPlayer.setHealingDealt(100)


rule "Kiriko":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 5)
    eventPlayer.setAmmo(1, 12)
    eventPlayer.setMaxAmmo(1, 12)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


rule "Heal when using Swift Step":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.startHoT(eventPlayer, 0.25, 200)


/*
rule "Heal when using Protection Suzu":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    eventPlayer.startHoT(eventPlayer, 0.65, 123)
*/

/*
rule "Unlock Swift Step while in LoS":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    @Condition isInLoS(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()), BarrierLos.PASS_THROUGH_BARRIERS) == true
    
    eventPlayer.setAbility1Enabled(true)
*/

/*
rule "Lock Swift Step while not in LoS":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    @Condition isInLoS(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()), BarrierLos.PASS_THROUGH_BARRIERS) == false
    
    eventPlayer.setAbility1Enabled(false)
*/

rule "Lifeweaver":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.LIFEWEAVER
    
    eventPlayer.ult_change_check = 1.04
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxAmmo(0, 14)
    eventPlayer.setAmmo(0, 14)
    eventPlayer.setMaxAmmo(1, 60)
    eventPlayer.setAmmo(1, 60)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 149, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 50, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(120)
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


rule "Reduce Lifeweaver melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.LIFEWEAVER
    @Condition eventAbility == Button.MELEE
    
    #heal(victim, null, eventDamage / 6 - eventDamage)
    #heal(victim, null, eventDamage * 0.167 - eventDamage)
    heal(victim, null, 8)


rule "Reduce Tree of Life healing":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.LIFEWEAVER
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setHealingDealt(83.333)
    waitUntil(eventPlayer.getUltCharge() != 0, 99999)
    eventPlayer.setHealingDealt(100)


rule "Reduce Tree of Life duration":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.LIFEWEAVER
    @Condition eventPlayer.isUsingUltimate() == true
    
    wait(12)
    eventPlayer.forceButtonPress(Button.ULTIMATE)


rule "Lucio":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.LUCIO
    
    eventPlayer.ult_change_check = 1.02
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setKnockbackDealt(89.286)
    eventPlayer.setHealingDealt(100)
    eventPlayer.setDamageDealt(66.667)
    eventPlayer.heal_state = 1


rule "Increase Lucio melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.LUCIO
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.778 - eventDamage)


rule "Increase Sonic Amplifier damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.LUCIO
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, eventDamage * 2.018 - eventDamage)


rule "Mercy":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MERCY
    
    eventPlayer.ult_change_check = 1.04
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAmmo(0, 20)
    eventPlayer.setMaxAmmo(0, 20)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(109.1)


rule "Reduce Valkyrie healing":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MERCY
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setHealingDealt(100)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setHealingDealt(109.1)


rule "Moira":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MOIRA
    
    eventPlayer.ult_change_check = 0.95
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


rule "Prevent fading during coalescence":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MOIRA
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setMoveSpeed(107.143)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setAbility1Enabled(true)


rule "Zenyatta":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZENYATTA
    
    eventPlayer.ult_change_check = 0.97
    eventPlayer.removeAllHealthPools()
    eventPlayer.setAmmo(0, 20)
    eventPlayer.setMaxAmmo(0, 20)
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 99, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 100, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setKnockbackDealt(7)
    eventPlayer.setHealingDealt(100)
    eventPlayer.heal_state = 1


/*
rule "Debug: Display movement speed":
    @Event eachPlayer
    
    hudHeader(eventPlayer, l"({0})".format(eventPlayer.getSpeed()), HudPosition.LEFT, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #wait(0.25)
    #destroyHudText(getLastCreatedText())
    #goto RULE_START
*/

/*
rule "Debug: Display hero_check":
    @Event eachPlayer
    
    hudHeader(eventPlayer, eventPlayer.hero_setup, HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
*/

/*
rule "Debug: Display server load":
    @Event eachPlayer
    
    hudHeader(eventPlayer, l"({0})".format(getServerLoad()), HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #wait(0.25)
    #destroyHudText(getLastCreatedText())
    #goto RULE_START
*/

/*
rule "Debug: 100% Ultimate on Interact":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    eventPlayer.setUltCharge(100)
*/

/*
rule "Debug: Teleport to other players":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    
    eventPlayer.teleport(getFarthestPlayer(eventPlayer, Team.ALL))
*/

/*
rule "Debug: Set HP to 1 on crouch":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    damage(eventPlayer, null, eventPlayer.getHealth() - 1)
*/

/*
rule "(Duplicate) d.va dm fix a":
    @Event eachPlayer
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DVA
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) > 66
    
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, 66)
*/

/*
rule "(Duplicate) d.va dm fix b":
    @Event eachPlayer
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DVA
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) > 66
    
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, 100)
*/

/*
rule "(Duplicate) pile cooldown":
*/

/*
rule "(Duplicate) Healing Pylon cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.ILLARI
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)
*/

/*
rule "(Duplicate) Plat cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.LIFEWEAVER
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) != 0, 99999)
*/

/*
rule "76 backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SOLDIER
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.heal_state == 0
    
    eventPlayer.heal_state = 1
    eventPlayer.setHealingDealt(1)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0, 9999999)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0, 9999999)
    eventPlayer.setHealingDealt(0)
    eventPlayer.heal_state = 0
*/

/*
rule "76 heal":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.SOLDIER
    @Condition eventAbility == Button.ABILITY_2
    
    heal(eventPlayer, null, eventHealing * 87.6)
*/

rule "hog backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.heal_state == 0
    
    eventPlayer.heal_state = 1
    eventPlayer.setHealingDealt(1)
    waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) != 0, 9999999)
    waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0, 9999999)
    eventPlayer.setHealingDealt(0)
    eventPlayer.heal_state = 0


rule "hog heal":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    heal(eventPlayer, eventPlayer, eventHealing * 65.5)


rule "reaper backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REAPER
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2()) == true
    
    healPassiveReset()
    eventPlayer.setHealingDealt(0)
    waitUntil(not (eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2()), 99999)
    healPassiveReset()
    eventPlayer.setHealingDealt(100)


rule "hacked health packs":
    @Event playerReceivedHealing
    @Condition eventWasHealthPack == true
    @Condition eventHealing <= 70
    
    heal(eventPlayer, eventPlayer, eventHealing * 99)


rule "mei backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MEI
    @Condition eventPlayer.isUsingAbility1() == true
    
    healPassiveReset()
    eventPlayer.setHealingDealt(1)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    healPassiveReset()
    eventPlayer.setHealingDealt(0)


rule "mei heal (up to 1 bugged heal)":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.MEI
    @Condition eventAbility == Button.ABILITY_1
    
    heal(eventPlayer, eventPlayer, eventHealing * 79)


rule "kiri suzu backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    
    if eventPlayer.getMaxHealth() != eventPlayer.getHealth():
        healPassiveReset()


rule "moira backup (up to 18 bugged heal)":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MOIRA
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.heal_state == 1
    
    eventPlayer.heal_state = 0
    healPassiveReset()
    waitUntil(eventPlayer.isUsingAbility1(), 99999)
    waitUntil(not eventPlayer.isUsingAbility1(), 9999999)
    healPassiveReset()
    eventPlayer.heal_state = 1


rule "Increase Firestrike damage (early animation)":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setDamageDealt(83.333)
    wait(1)
    eventPlayer.setDamageDealt(80)


