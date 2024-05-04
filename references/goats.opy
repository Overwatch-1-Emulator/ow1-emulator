settings {
    "main": {
        "description": "CGL GOATS\nMeant To Replicate Overwatch Patch 1.24\nVersion: 2.0.15\nMade By Aria Boyce, Hibachi and Headrammer",
        "modeName": "CGL GOATs"
    },
    "lobby": {
        "spectatorSlots": 12,
        "team1Slots": 6,
        "team2Slots": 6,
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "assault": {},
        "control": {},
        "escort": {},
        "hybrid": {},
        "push": {},
        "general": {
            "enableCompetitiveRules": true,
            "gamemodeStartTrigger": "immediately",
            "enableKillCam": false,
            "tankPassiveHealthBonus": "alwaysEnabled"
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "ammoClipSize%": 93
            },
            "brigitte": {
                "secondaryFireCooldown%": 60,
                "secondaryFireRechargeRate%": 125,
                "health%": 200,
                "combatUltGen%": 0,
                "passiveUltGen%": 0,
                "ultGen%": 10,
                "ability1Kb%": 75
            },
            "dva": {
                "ability1Cooldown%": 125,
                "secondaryFireRechargeRate%": 78
            },
            "lucio": {
                "healingReceived%": 80
            },
            "moira": {
                "primaryFireMaximumTime%": 500,
                "primaryFireRechargeRate%": 0,
                "ability2Cooldown%": 120,
                "ability2MaxHealing%": 120
            },
            "reinhardt": {
                "secondaryFireRechargeRate%": 138,
                "damageReceived%": 200
            },
            "winston": {
                "ability2Cooldown%": 108,
                "damageReceived%": 200,
                "enableSecondaryFire": false
            },
            "zarya": {
                "damageDealt%": 112,
                "damageReceived%": 200,
                "ability1Cooldown%": 0,
                "ability2Cooldown%": 0
            },
            "zenyatta": {
                "ammoClipSize%": 80
            },
            "enabledHeroes": [
                "ana",
                "brigitte",
                "dva",
                "lucio",
                "moira",
                "reinhardt",
                "winston",
                "zarya",
                "zenyatta"
            ],
            "general": {
                "ultGen%": 110
            }
        }
    }
}

#Global variables

globalvar temp_count 0
globalvar server_stress_time 1
globalvar scrim_mode_state 2
globalvar scrim_mode 3
globalvar healee_ 4
globalvar healer_ 5
globalvar amount 6


#Player variables

playervar effect_scale 0
playervar health_reference 1
playervar armor_reference 2
playervar damage_var 4
playervar damage_taken 5
playervar move_modify 7
playervar role 8
playervar dam_modify 9
playervar player_hero 10
playervar healing_recieved 11
playervar array_sum_temp 12
playervar hero_list 13
playervar booped 14
playervar interact_button 15
playervar damage_float 16
playervar nano_check 17
playervar anti_nade_check 18
playervar anti_nade_effect 19
playervar is_asleep 20
playervar ana_healing_nade_healing 21
playervar brig_hud_ref 22
playervar brig_ult 23
playervar brig_ult_ref 24
playervar brig_ult_armor_ref 25
playervar brig_ult_armor_amount 26
playervar ult_charge 27
playervar ult_charge_max 28
playervar armor_pack_ref 33
playervar moira_resource 34
playervar zarya_shield_cooldown_1 35
playervar zarya_shield_cooldown_2 36
playervar healing_dealt 37
playervar zarya_hud_ref 38
playervar zen_discord_hud_ref 39
playervar time_since_damage 40
playervar time_since_damage_shield 41
playervar max_shield_health 42
playervar current_shield_health 43
playervar DiscordTarget 45
playervar discord_timer 46
playervar zen_discord_reference 47
playervar Discorder 48
playervar temp_player 49
playervar temp_player_0 50
playervar temp_player_1 51
playervar temp_player_2 52
playervar temp_player_3 53
playervar temp_player_4 54
playervar temp_player_5 55
playervar temp_player_6 56
playervar temp_player_7 57
playervar temp_team_hero 58
playervar temp_team_hero_0 59
playervar i 60
playervar temp_health 61
playervar heal_amount 62
playervar temp_health_0 63
playervar heal_amount_0 64
playervar temp_damage 65
playervar temp_health_1 66
playervar temp_armor 67


#Subroutine names

subroutine workshopHeal 0


rule "Disable Inspector":
    disableInspector()
    scrim_mode_state = 0
    scrim_mode = createWorkshopSetting(bool, "Scrim Mode", "Active", false, 0)


rule "Anti Crash":
    if getServerLoad() > 240:
        server_stress_time += 1
    else:
        server_stress_time = 0
    if server_stress_time == 6:
        smallMessage(getAllPlayers(), "Anti Crash Slow Mode")
        setSlowMotion(10)
    if server_stress_time == 0:
        setSlowMotion(100)
    wait(0.5)
    goto RULE_START


rule "Has Spawned Setup":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    
    destroyHudText(eventPlayer.zarya_hud_ref)
    destroyHudText(eventPlayer.brig_hud_ref)
    destroyHudText(eventPlayer.zen_discord_hud_ref)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setUltCharge(0)
    eventPlayer.healing_dealt = 100
    eventPlayer.damage_float = 1
    eventPlayer.hero_list = [Hero.DVA, Hero.REINHARDT, Hero.WINSTON, Hero.ZARYA, Hero.ANA, Hero.BRIGITTE, Hero.LUCIO, Hero.MOIRA, Hero.ZENYATTA]
    eventPlayer.removeAllHealthPools()
    eventPlayer.move_modify[0] = 0
    eventPlayer.move_modify[1] = 0
    eventPlayer.move_modify[2] = 0
    eventPlayer.dam_modify[0] = 0
    eventPlayer.dam_modify[1] = 0
    eventPlayer.dam_modify[2] = 0
    eventPlayer.dam_modify[3] = 0
    eventPlayer.ult_charge = 0
    eventPlayer.setHealingReceived(100)
    eventPlayer.healing_recieved = 1
    eventPlayer.brig_ult_armor_amount = 0
    eventPlayer.brig_ult = 0
    eventPlayer.setUltEnabled(true)
    destroyEffect(eventPlayer.brig_ult_ref)
    eventPlayer.setMaxHealth(100)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.removeAllHealthPools()
    removeHealthPool(eventPlayer.brig_ult_armor_ref)
    eventPlayer.player_hero = eventPlayer.getCurrentHero()
    wait()
    if eventPlayer.getCurrentHero() == Hero.ANA:
        eventPlayer.effect_scale = 0.5
        eventPlayer.role = 1
        eventPlayer.ana_healing_nade_healing = 26.667
        eventPlayer.damage_float = 1
    elif eventPlayer.getCurrentHero() == Hero.BRIGITTE:
        eventPlayer.role = 1
        eventPlayer.effect_scale = 1
        eventPlayer.ult_charge_max = 2550
        eventPlayer.healing_recieved = 1
        eventPlayer.setHealingReceived(100)
        eventPlayer.setHealingDealt(1)
        eventPlayer.setMaxHealth(50)
        eventPlayer.addHealthPool(Health.NORMAL, 50, true, true)
        eventPlayer.health_reference = getLastCreatedHealthPool()
        destroyHudText(eventPlayer.brig_hud_ref)
        eventPlayer.damage_float = 1
        eventPlayer.healing_dealt = 100
    elif eventPlayer.getCurrentHero() == Hero.LUCIO:
        eventPlayer.effect_scale = 0.5
        eventPlayer.role = 1
        eventPlayer.damage_float = 1
        eventPlayer.healing_dealt = 100
    elif eventPlayer.getCurrentHero() == Hero.MOIRA:
        eventPlayer.effect_scale = 1
        eventPlayer.role = 1
        eventPlayer.moira_resource = 100
        eventPlayer.ult_charge_max = 2390
        eventPlayer.healing_dealt = 115
        eventPlayer.setHealingDealt(115)
        eventPlayer.damage_float = 1
    elif eventPlayer.getCurrentHero() == Hero.ZENYATTA:
        eventPlayer.effect_scale = 0.5
        eventPlayer.ult_charge_max = 2310
        eventPlayer.damage_var = 95.833
        eventPlayer.max_shield_health = 150
        eventPlayer.current_shield_health = 150
        eventPlayer.role = 1
        eventPlayer.setDamageDealt(eventPlayer.damage_var)
    wait()
    if eventPlayer.getCurrentHero() == Hero.DVA:
        eventPlayer.role = 0
        wait(1)
        eventPlayer.startForcingButton(Button.INTERACT)
        eventPlayer.interact_button = 3
        wait(0.5)
        eventPlayer.stopForcingButton(Button.INTERACT)
        smallMessage(eventPlayer, "Forced Reset at spawn to deal with rare health issue. :)")
    elif eventPlayer.getCurrentHero() == Hero.REINHARDT:
        wait(0.1)
        eventPlayer.effect_scale = 1
        eventPlayer.role = 0
        eventPlayer.setMaxHealth(166.667)
        eventPlayer.temp_player = eventPlayer
        eventPlayer.temp_player.array_sum_temp = 100
        temp_count = 0
        while temp_count < 2:
            eventPlayer.temp_player.array_sum_temp += eventPlayer.temp_player.dam_modify[temp_count]
            wait(0.017)
            temp_count += 1
        eventPlayer.temp_player.damage_taken = eventPlayer.temp_player.array_sum_temp
        eventPlayer.temp_player.damage_float = eventPlayer.temp_player.damage_taken / 100
        eventPlayer.setDamageReceived(eventPlayer.damage_taken)
        eventPlayer.setHealingReceived(200)
        eventPlayer.damage_float = 2
        eventPlayer.healing_recieved = 2
    elif eventPlayer.getCurrentHero() == Hero.WINSTON:
        eventPlayer.effect_scale = 1
        eventPlayer.ult_charge_max = 1540
        eventPlayer.role = 0
        eventPlayer.setMaxHealth(92.308)
        eventPlayer.addHealthPool(Health.NORMAL, 476.92, true, true)
        eventPlayer.health_reference = getLastCreatedHealthPool()
        eventPlayer.addHealthPool(Health.ARMOR, 15.39, true, true)
        eventPlayer.armor_reference = getLastCreatedHealthPool()
        eventPlayer.temp_player_0 = eventPlayer
        eventPlayer.temp_player_0.array_sum_temp = 100
        temp_count = 0
        while temp_count < 2:
            eventPlayer.temp_player_0.array_sum_temp += eventPlayer.temp_player_0.dam_modify[temp_count]
            wait(0.017)
            temp_count += 1
        eventPlayer.temp_player_0.damage_taken = eventPlayer.temp_player_0.array_sum_temp
        eventPlayer.temp_player_0.damage_float = eventPlayer.temp_player_0.damage_taken / 100
        eventPlayer.setDamageReceived(eventPlayer.damage_taken)
        eventPlayer.healing_recieved = 2
        eventPlayer.damage_float = 2
    elif eventPlayer.getCurrentHero() == Hero.ZARYA:
        eventPlayer.effect_scale = 1
        eventPlayer.max_shield_health = 200
        eventPlayer.ult_charge_max = 2100
        eventPlayer.current_shield_health = 200
        eventPlayer.zarya_shield_cooldown_1 = 0
        eventPlayer.zarya_shield_cooldown_2 = 0
        eventPlayer.role = 0
        eventPlayer.healing_recieved = 2
        eventPlayer.setHealingReceived(200)
        eventPlayer.addHealthPool(Health.NORMAL, 150, true, true)
        eventPlayer.addHealthPool(Health.SHIELDS, 175, true, true)
        eventPlayer.temp_player_1 = eventPlayer
        eventPlayer.temp_player_1.array_sum_temp = 100
        temp_count = 0
        while temp_count < 2:
            eventPlayer.temp_player_1.array_sum_temp += eventPlayer.temp_player_1.dam_modify[temp_count]
            wait(0.017)
            temp_count += 1
        eventPlayer.temp_player_1.damage_taken = eventPlayer.temp_player_1.array_sum_temp
        eventPlayer.temp_player_1.damage_float = eventPlayer.temp_player_1.damage_taken / 100
        eventPlayer.setDamageReceived(eventPlayer.damage_taken)
        eventPlayer.damage_float = 2
        hudSubtext(eventPlayer, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n    {0}                                                                    {1}             {2}".format("                                                                                                                      ", "{0}{1}".format("                                                                                ", ceil(eventPlayer.zarya_shield_cooldown_1)), ceil(eventPlayer.zarya_shield_cooldown_2)), HudPosition.LEFT, 1, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
        eventPlayer.zarya_hud_ref = getLastCreatedText()
    smallMessage(eventPlayer, "Patch Version: 2.0.15 6/16/2023")


rule "Remove Effects On Death":
    @Event playerDied
    
    destroyEffect(eventPlayer.anti_nade_effect)
    destroyEffect(eventPlayer.ana_healing_nade_healing)
    destroyEffect(eventPlayer.brig_ult_ref)
    eventPlayer.brig_ult = 0
    destroyEffect(eventPlayer.zen_discord_reference)
    eventPlayer.Discorder.discord_timer = 3
    eventPlayer.discord_timer = 3
    eventPlayer.dam_modify[0] = 0
    eventPlayer.temp_player_2 = eventPlayer
    eventPlayer.temp_player_2.array_sum_temp = 100
    temp_count = 0
    while temp_count < 2:
        eventPlayer.temp_player_2.array_sum_temp += eventPlayer.temp_player_2.dam_modify[temp_count]
        wait(0.017)
        temp_count += 1
    eventPlayer.temp_player_2.damage_taken = eventPlayer.temp_player_2.array_sum_temp
    eventPlayer.temp_player_2.damage_float = eventPlayer.temp_player_2.damage_taken / 100
    eventPlayer.setDamageReceived(eventPlayer.damage_taken)
    destroyEffect(eventPlayer.zen_discord_reference)
    wait(1)
    eventPlayer.Discorder.DiscordTarget = null


rule "Increased Knockback":
    @Event eachPlayer
    @Condition eventPlayer.booped == 1
    @Condition eventPlayer.role == 0
    
    wait(0.05)
    eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.getPosition() + eventPlayer.getVelocity() * vect(1, [], 1)), eventPlayer.getSpeed() * 0.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.booped = 0


rule "Check For Hero Swap":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != eventPlayer.player_hero
    @Condition eventPlayer.getCurrentHero() != Hero.SOLDIER
    
    destroyHudText(eventPlayer.zarya_hud_ref)
    destroyHudText(eventPlayer.brig_hud_ref)
    destroyHudText(eventPlayer.zen_discord_hud_ref)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setUltCharge(0)
    eventPlayer.healing_dealt = 100
    eventPlayer.damage_float = 1
    eventPlayer.hero_list = [Hero.DVA, Hero.REINHARDT, Hero.WINSTON, Hero.ZARYA, Hero.ANA, Hero.BRIGITTE, Hero.LUCIO, Hero.MOIRA, Hero.ZENYATTA]
    eventPlayer.removeAllHealthPools()
    eventPlayer.move_modify[0] = 0
    eventPlayer.move_modify[1] = 0
    eventPlayer.move_modify[2] = 0
    eventPlayer.dam_modify[0] = 0
    eventPlayer.dam_modify[1] = 0
    eventPlayer.dam_modify[2] = 0
    eventPlayer.dam_modify[3] = 0
    eventPlayer.ult_charge = 0
    eventPlayer.setHealingReceived(100)
    eventPlayer.healing_recieved = 1
    eventPlayer.brig_ult_armor_amount = 0
    eventPlayer.brig_ult = 0
    eventPlayer.setUltEnabled(true)
    destroyEffect(eventPlayer.brig_ult_ref)
    eventPlayer.setMaxHealth(100)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.removeAllHealthPools()
    removeHealthPool(eventPlayer.brig_ult_armor_ref)
    eventPlayer.player_hero = eventPlayer.getCurrentHero()
    wait()
    if eventPlayer.getCurrentHero() == Hero.ANA:
        eventPlayer.effect_scale = 0.5
        eventPlayer.role = 1
        eventPlayer.ana_healing_nade_healing = 26.667
        eventPlayer.damage_float = 1
    elif eventPlayer.getCurrentHero() == Hero.BRIGITTE:
        eventPlayer.role = 1
        eventPlayer.effect_scale = 1
        eventPlayer.ult_charge_max = 2550
        eventPlayer.healing_recieved = 1
        eventPlayer.setHealingReceived(100)
        eventPlayer.setHealingDealt(1)
        eventPlayer.setMaxHealth(50)
        eventPlayer.addHealthPool(Health.NORMAL, 50, true, true)
        eventPlayer.health_reference = getLastCreatedHealthPool()
        destroyHudText(eventPlayer.brig_hud_ref)
        eventPlayer.damage_float = 1
        eventPlayer.healing_dealt = 100
    elif eventPlayer.getCurrentHero() == Hero.LUCIO:
        eventPlayer.effect_scale = 0.5
        eventPlayer.role = 1
        eventPlayer.damage_float = 1
        eventPlayer.healing_dealt = 100
    elif eventPlayer.getCurrentHero() == Hero.MOIRA:
        eventPlayer.effect_scale = 1
        eventPlayer.role = 1
        eventPlayer.moira_resource = 100
        eventPlayer.ult_charge_max = 2390
        eventPlayer.healing_dealt = 115
        eventPlayer.setHealingDealt(115)
        eventPlayer.damage_float = 1
    elif eventPlayer.getCurrentHero() == Hero.ZENYATTA:
        eventPlayer.effect_scale = 0.5
        eventPlayer.ult_charge_max = 2310
        eventPlayer.damage_var = 95.833
        eventPlayer.max_shield_health = 150
        eventPlayer.current_shield_health = 150
        eventPlayer.role = 1
        eventPlayer.setDamageDealt(eventPlayer.damage_var)
    wait()
    if eventPlayer.getCurrentHero() == Hero.DVA:
        eventPlayer.role = 0
        wait(1)
        eventPlayer.startForcingButton(Button.INTERACT)
        eventPlayer.interact_button = 3
        wait(0.5)
        eventPlayer.stopForcingButton(Button.INTERACT)
        smallMessage(eventPlayer, "Forced Reset at spawn to deal with rare health issue. :)")
    elif eventPlayer.getCurrentHero() == Hero.REINHARDT:
        wait(0.1)
        eventPlayer.effect_scale = 1
        eventPlayer.role = 0
        eventPlayer.setMaxHealth(166.667)
        eventPlayer.temp_player_3 = eventPlayer
        eventPlayer.temp_player_3.array_sum_temp = 100
        temp_count = 0
        while temp_count < 2:
            eventPlayer.temp_player_3.array_sum_temp += eventPlayer.temp_player_3.dam_modify[temp_count]
            wait(0.017)
            temp_count += 1
        eventPlayer.temp_player_3.damage_taken = eventPlayer.temp_player_3.array_sum_temp
        eventPlayer.temp_player_3.damage_float = eventPlayer.temp_player_3.damage_taken / 100
        eventPlayer.setDamageReceived(eventPlayer.damage_taken)
        eventPlayer.setHealingReceived(200)
        eventPlayer.damage_float = 2
        eventPlayer.healing_recieved = 2
    elif eventPlayer.getCurrentHero() == Hero.WINSTON:
        eventPlayer.effect_scale = 1
        eventPlayer.ult_charge_max = 1540
        eventPlayer.role = 0
        eventPlayer.setMaxHealth(92.308)
        eventPlayer.addHealthPool(Health.NORMAL, 476.92, true, true)
        eventPlayer.health_reference = getLastCreatedHealthPool()
        eventPlayer.addHealthPool(Health.ARMOR, 15.39, true, true)
        eventPlayer.armor_reference = getLastCreatedHealthPool()
        eventPlayer.temp_player_4 = eventPlayer
        eventPlayer.temp_player_4.array_sum_temp = 100
        temp_count = 0
        while temp_count < 2:
            eventPlayer.temp_player_4.array_sum_temp += eventPlayer.temp_player_4.dam_modify[temp_count]
            wait(0.017)
            temp_count += 1
        eventPlayer.temp_player_4.damage_taken = eventPlayer.temp_player_4.array_sum_temp
        eventPlayer.temp_player_4.damage_float = eventPlayer.temp_player_4.damage_taken / 100
        eventPlayer.setDamageReceived(eventPlayer.damage_taken)
        eventPlayer.healing_recieved = 2
        eventPlayer.damage_float = 2
    elif eventPlayer.getCurrentHero() == Hero.ZARYA:
        eventPlayer.effect_scale = 1
        eventPlayer.max_shield_health = 200
        eventPlayer.ult_charge_max = 2100
        eventPlayer.current_shield_health = 200
        eventPlayer.zarya_shield_cooldown_1 = 0
        eventPlayer.zarya_shield_cooldown_2 = 0
        eventPlayer.role = 0
        eventPlayer.healing_recieved = 2
        eventPlayer.setHealingReceived(200)
        eventPlayer.addHealthPool(Health.NORMAL, 150, true, true)
        eventPlayer.addHealthPool(Health.SHIELDS, 175, true, true)
        eventPlayer.temp_player_5 = eventPlayer
        eventPlayer.temp_player_5.array_sum_temp = 100
        temp_count = 0
        while temp_count < 2:
            eventPlayer.temp_player_5.array_sum_temp += eventPlayer.temp_player_5.dam_modify[temp_count]
            wait(0.017)
            temp_count += 1
        eventPlayer.temp_player_5.damage_taken = eventPlayer.temp_player_5.array_sum_temp
        eventPlayer.temp_player_5.damage_float = eventPlayer.temp_player_5.damage_taken / 100
        eventPlayer.setDamageReceived(eventPlayer.damage_taken)
        eventPlayer.damage_float = 2
        hudSubtext(eventPlayer, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n    {0}                                                                    {1}             {2}".format("                                                                                                                      ", "{0}{1}".format("                                                                                ", ceil(eventPlayer.zarya_shield_cooldown_1)), ceil(eventPlayer.zarya_shield_cooldown_2)), HudPosition.LEFT, 1, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
        eventPlayer.zarya_hud_ref = getLastCreatedText()
    smallMessage(eventPlayer, "Patch Version: 2.0.12 6/8/2023")


rule "Healing Check Default":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.LUCIO
    
    if eventPlayer.anti_nade_check == 0:
        eventPlayer.setHealingReceived(eventPlayer.healing_recieved * 100)
    eventPlayer.setHealingDealt(eventPlayer.healing_dealt)
    eventPlayer.temp_player_6 = eventPlayer
    eventPlayer.temp_player_6.array_sum_temp = 100
    temp_count = 0
    while temp_count < 2:
        eventPlayer.temp_player_6.array_sum_temp += eventPlayer.temp_player_6.dam_modify[temp_count]
        wait(0.017)
        temp_count += 1
    eventPlayer.temp_player_6.damage_taken = eventPlayer.temp_player_6.array_sum_temp
    eventPlayer.temp_player_6.damage_float = eventPlayer.temp_player_6.damage_taken / 100
    eventPlayer.setDamageReceived(eventPlayer.damage_taken)
    wait(5)
    goto RULE_START


rule "Healing Check Lucio":
    @Event eachPlayer
    @Hero lucio
    
    if eventPlayer.anti_nade_check == 0:
        eventPlayer.setHealingReceived(80)
    eventPlayer.setHealingDealt(100)
    wait(5)
    goto RULE_START


rule "Brig: Ult Charge":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition isGameInProgress() == true
    @Condition (not isMatchBetweenRounds()) == true
    
    if eventPlayer.ult_charge >= eventPlayer.ult_charge_max:
        eventPlayer.ult_charge = eventPlayer.ult_charge_max
    eventPlayer.ult_charge += 0.667
    wait(0.2)
    eventPlayer.setUltCharge(min(99, eventPlayer.ult_charge / eventPlayer.ult_charge_max * 100))
    goto RULE_START


rule "Ult Charge Raise from Damage":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition victim != attacker
    
    eventPlayer.ult_charge += eventDamage / victim.damage_float


rule "Ult Charge Raise from Healing":
    @Event playerDealtHealing
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition (not isMatchBetweenRounds()) == true
    
    eventPlayer.ult_charge += eventHealing / healee.healing_recieved


rule "Reset on Round End":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    
    eventPlayer.ult_charge = 0
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    destroyAllEffects()
    eventPlayer.brig_ult = false
    eventPlayer.brig_ult_armor_amount = 0
    wait(10)
    destroyAllEffects()
    eventPlayer.dam_modify[0] = 0
    eventPlayer.temp_player_7 = eventPlayer
    eventPlayer.temp_player_7.array_sum_temp = 100
    temp_count = 0
    while temp_count < 2:
        eventPlayer.temp_player_7.array_sum_temp += eventPlayer.temp_player_7.dam_modify[temp_count]
        wait(0.017)
        temp_count += 1
    eventPlayer.temp_player_7.damage_taken = eventPlayer.temp_player_7.array_sum_temp
    eventPlayer.temp_player_7.damage_float = eventPlayer.temp_player_7.damage_taken / 100
    eventPlayer.setDamageReceived(eventPlayer.damage_taken)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setJumpEnabled(true)
    destroyAllEffects()


def workshopHeal():
    @Name "Nade-safe heal for workshop purposes"
    
    if eventPlayer.anti_nade_check == 1 and healer_ == null:
        healee_.setHealingReceived(100)
        heal(healee_, healer_, amount)
        healee_.setHealingReceived(0)
    else:
        heal(healee_, healer_, amount)


rule "Remove Support Passive":
    @Event eachPlayer
    @Condition eventPlayer.role == 1
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth()
    @Condition eventPlayer.is_asleep == false
    
    healee_ = eventPlayer
    healer_ = null
    amount = 0.01
    workshopHeal()
    damage(eventPlayer, null, 0.01)
    wait(1.46)
    if RULE_CONDITION:
        goto RULE_START


rule "Comp Check Tank":
    @Event eachPlayer
    @Condition (eventPlayer.getCurrentHero() == Hero.REINHARDT or eventPlayer.getCurrentHero() == Hero.WINSTON) == true
    
    eventPlayer.temp_team_hero = getPlayers(eventPlayer.getTeam())
    temp_count = 0
    while temp_count < 6:
        if eventPlayer.temp_team_hero[temp_count] != eventPlayer:
            eventPlayer.temp_team_hero[temp_count].setAllowedHeroes(eventPlayer.temp_team_hero[temp_count].hero_list)
        temp_count += 1


rule "Comp Check Support":
    @Event eachPlayer
    @Condition (eventPlayer.getCurrentHero() == Hero.ANA or eventPlayer.getCurrentHero() == Hero.MOIRA or eventPlayer.getCurrentHero() == Hero.ZENYATTA) == true
    
    eventPlayer.temp_team_hero_0 = getPlayers(eventPlayer.getTeam())
    temp_count = 0
    while temp_count < 6:
        if eventPlayer.temp_team_hero_0[temp_count] != eventPlayer:
            eventPlayer.temp_team_hero_0[temp_count].setAllowedHeroes(eventPlayer.temp_team_hero_0[temp_count].hero_list)
        temp_count += 1


rule "Hold F for 3 seconds":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isInSpawnRoom() == true
    
    eventPlayer.interact_button += 0.5
    if eventPlayer.interact_button > 3:
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setAbility2Enabled(true)
        if eventPlayer.getCurrentHero() == Hero.DVA and eventPlayer.isInAlternateForm() == true:
            eventPlayer.startForcingHero(Hero.SOJOURN)
            eventPlayer.stopForcingCurrentHero()
            wait(0.1)
            eventPlayer.startForcingHero(eventPlayer.player_hero)
            eventPlayer.stopForcingCurrentHero()
            eventPlayer.interact_button = 0
        else:
            eventPlayer.startForcingHero(Hero.SOLDIER)
            eventPlayer.stopForcingCurrentHero()
            wait(0.1)
            eventPlayer.startForcingHero(eventPlayer.player_hero)
            eventPlayer.stopForcingCurrentHero()
            eventPlayer.interact_button = 0
    if not eventPlayer.isHoldingButton(Button.INTERACT):
        eventPlayer.interact_button = 0
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Ana Primary Fire":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    healee_ = victim
    healer_ = null
    amount = eventDamage * 0.07
    workshopHeal()


rule "Ana Anti Nade":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2
    
    victim.anti_nade_check = 1
    wait(3.5)
    victim.anti_nade_check = 0
    eventPlayer.anti_nade_effect = null


rule "Ana: Healing Nade":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2
    
    heal(healee, healer, eventPlayer.ana_healing_nade_healing)


rule "Ana Sleep Dart Duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    
    wait(0.017)
    victim.is_asleep = true
    wait(2)
    if victim.is_asleep == true:
        victim.clearStatusEffect(Status.ASLEEP)
        victim.setStatusEffect(attacker, Status.ASLEEP, 100)
        wait(3)
        victim.clearStatusEffect(Status.ASLEEP)
        victim.is_asleep = false


rule "Ana: Slept Target gets woken up":
    @Event playerTookDamage
    @Condition eventPlayer.is_asleep == true
    
    eventPlayer.is_asleep = false


rule "Ana: Remove Nano Heal":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ULTIMATE
    @Condition healee.nano_check == 0
    
    healee.nano_check = 1
    if healee.anti_nade_check == 0:
        damage(healee, null, eventHealing)
    wait(8)
    healee.nano_check = 0


rule "Brig: Increased Boop Range":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.ABILITY_1
    
    victim.booped = 1


rule "Brig: Try and cancel ult":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() >= 99
    
    bigMessage(getPlayers(getOppositeTeam(eventPlayer.getTeam())), "RAID BOSS INCOMING")
    bigMessage(getPlayers(eventPlayer.getTeam()), "RALLY TO ME")
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 100)
    eventPlayer.setMoveSpeed(130)
    eventPlayer.ult_charge = 0
    eventPlayer.brig_ult = true
    createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, eventPlayer.getPosition(), 8.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.brig_ult_ref = getLastCreatedEntity()
    wait(10)
    eventPlayer.brig_ult = false
    destroyEffect(eventPlayer.brig_ult_ref)
    eventPlayer.setMoveSpeed(100)


rule "Brig: Ult Armor Gen":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.brig_ult == true
    
    eventPlayer.time_since_damage = getPlayersInRadius(eventPlayer.getPosition(), 10, eventPlayer.getTeam(), LosCheck.SURFACES_AND_ENEMY_BARRIERS)
    eventPlayer.ult_charge = 0
    eventPlayer.i = 0
    while eventPlayer.i < 6:
        eventPlayer.time_since_damage[eventPlayer.i].brig_ult_armor_amount += 15 * eventPlayer.time_since_damage[eventPlayer.i].healing_recieved
        if eventPlayer.time_since_damage[eventPlayer.i].brig_ult_armor_amount > 150 * eventPlayer.time_since_damage[eventPlayer.i].healing_recieved:
            eventPlayer.time_since_damage[eventPlayer.i].brig_ult_armor_amount = 150 * eventPlayer.time_since_damage[eventPlayer.i].healing_recieved
        removeHealthPool(eventPlayer.time_since_damage[eventPlayer.i].brig_ult_armor_ref)
        eventPlayer.time_since_damage[eventPlayer.i].addHealthPool(Health.ARMOR, eventPlayer.time_since_damage[eventPlayer.i].brig_ult_armor_amount, false, true)
        eventPlayer.time_since_damage[eventPlayer.i].brig_ult_armor_ref = getLastCreatedHealthPool()
        eventPlayer.i += 1
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Brig: Repair Pack Default":
    @Event playerDealtHealing
    @Hero brigitte
    @Condition eventAbility == Button.ABILITY_2
    @Condition healee.getCurrentHero() != Hero.LUCIO
    
    eventPlayer.temp_health = healee.getMaxHealth() - healee.getHealth()
    eventPlayer.heal_amount = 150
    eventPlayer.heal_amount -= eventPlayer.temp_health / healee.healing_recieved
    if eventPlayer.temp_health > 150:
        healee_ = healee
        healer_ = healer
        amount = 150
        workshopHeal()
    else:
        healee_ = healee
        healer_ = healer
        amount = eventPlayer.temp_health
        workshopHeal()
    if eventPlayer.heal_amount > 75:
        eventPlayer.heal_amount = 75
    if eventPlayer.heal_amount < 1:
        eventPlayer.heal_amount = 0
    healee.addHealthPool(Health.ARMOR, eventPlayer.heal_amount * healee.healing_recieved, false, true)
    healee.armor_pack_ref = getLastCreatedHealthPool()
    eventPlayer.setAbility2Enabled(false)
    wait(6)
    eventPlayer.setAbility2Enabled(true)


rule "Brig: Repair Pack Lucio":
    @Event playerDealtHealing
    @Hero brigitte
    @Condition eventAbility == Button.ABILITY_2
    @Condition healee.getCurrentHero() == Hero.LUCIO
    
    eventPlayer.temp_health_0 = healee.getMaxHealth() - healee.getHealth()
    eventPlayer.heal_amount_0 = 150
    eventPlayer.heal_amount_0 -= eventPlayer.temp_health_0
    if eventPlayer.temp_health_0 > 150:
        healee_ = healee
        healer_ = healer
        amount = 234
        workshopHeal()
    else:
        healee_ = healee
        healer_ = healer
        amount = eventPlayer.temp_health_0 / 0.8
        workshopHeal()
    if eventPlayer.heal_amount_0 > 75:
        eventPlayer.heal_amount_0 = 75
    healee.addHealthPool(Health.ARMOR, eventPlayer.heal_amount_0, false, true)
    healee.armor_pack_ref = getLastCreatedHealthPool()
    eventPlayer.setAbility2Enabled(false)
    wait(6)
    eventPlayer.setAbility2Enabled(true)


rule "Brig: Remove Repair Pack Health":
    @Event eachPlayer
    @Condition eventPlayer.armor_pack_ref != null
    
    wait(6)
    removeHealthPool(eventPlayer.armor_pack_ref)
    eventPlayer.armor_pack_ref = null


rule "Brig: Used Shield Bash":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    eventPlayer.setMoveSpeed(50)
    wait(0.25)
    eventPlayer.setMoveSpeed(100)


rule "Brig: Shield Bash Stun":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    victim.setStatusEffect(attacker, Status.STUNNED, 0.9)


rule "Brig: Reduce Armor From Damage":
    @Event playerTookDamage
    @Condition eventPlayer.brig_ult_armor_amount > 0
    
    eventPlayer.temp_damage = eventDamage
    eventPlayer.temp_damage -= eventPlayer.getHealthOfType(Health.SHIELDS)
    eventPlayer.brig_ult_armor_amount -= eventPlayer.temp_damage
    if eventPlayer.brig_ult_armor_amount < 0:
        eventPlayer.brig_ult_armor_amount = 0


rule "Brig: Raise Self Healing":
    @Event playerReceivedHealing
    @Hero brigitte
    @Condition healer == healee
    @Condition eventAbility != null
    
    heal(healee, healer, eventHealing * 100)


rule "Reset on Round End":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    
    eventPlayer.ult_charge = 0


rule "Dva: Increased Dva booster boop range":
    @Event playerDealtDamage
    @Hero dva
    @Condition eventAbility == Button.ABILITY_1
    
    victim.booped = 1


rule "Dva: Boosters Damage":
    @Event playerDealtDamage
    @Hero dva
    @Condition eventAbility == Button.ABILITY_1
    
    healee_ = victim
    healer_ = null
    amount = 5
    workshopHeal()


rule "Dva: Reduce Remech Damage":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isInAlternateForm() == true
    
    removeHealthPool(eventPlayer.health_reference)
    eventPlayer.setDamageDealt(20)
    wait(1)
    eventPlayer.setDamageDealt(100)


rule "Dva: Baby Health":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == true
    
    eventPlayer.Discorder.discord_timer = 3
    removeHealthPool(eventPlayer.armor_reference)
    removeHealthPool(eventPlayer.health_reference)
    removeHealthPool(eventPlayer.brig_ult_armor_ref)
    removeHealthPool(eventPlayer.armor_pack_ref)
    eventPlayer.brig_ult_armor_amount = 0
    eventPlayer.addHealthPool(Health.NORMAL, 51, true, true)
    eventPlayer.health_reference = getLastCreatedHealthPool()


rule "Dva: Mech Health":
    @Event eachPlayer
    @Hero dva
    @Condition (not eventPlayer.isInAlternateForm()) == true
    
    eventPlayer.Discorder.discord_timer = 3
    eventPlayer.removeAllHealthPools()
    wait(0.033)
    eventPlayer.setMaxHealth(66)
    wait(0.033)
    healee_ = eventPlayer
    healer_ = null
    amount = 1000
    workshopHeal()
    eventPlayer.temp_health_1 = 400 - eventPlayer.getMaxHealthOfType(Health.NORMAL)
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.temp_health_1, true, true)
    eventPlayer.health_reference = getLastCreatedHealthPool()
    if eventPlayer.getMaxHealthOfType(Health.ARMOR) < 200:
        eventPlayer.temp_armor = 200 - eventPlayer.getMaxHealthOfType(Health.ARMOR)
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.temp_armor, true, true)
        eventPlayer.armor_reference = getLastCreatedHealthPool()


rule "Dva: Melee Cancels Boosters":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "Lucio: Increased Boop Range":
    @Event playerDealtDamage
    @Hero lucio
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    victim.booped = 1


rule "Lucio: Increase Healing From Others":
    @Event playerReceivedHealing
    @Hero lucio
    @Condition healer != eventPlayer
    @Condition eventAbility != null
    
    heal(healer, healee, eventHealing * 0.25)


rule "Moira: More Self Heal":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    heal(attacker, attacker, 1.1)
    wait(0.167)


rule "Moira: Resource":
    @Event eachPlayer
    @Hero moira
    
    if eventPlayer.isFiringPrimaryFire():
        eventPlayer.setHealingDealt(114.3)
        eventPlayer.moira_resource -= 3.4
    else:
        eventPlayer.setHealingDealt(100)
        eventPlayer.moira_resource += 0.749
    eventPlayer.setAbilityResource(Button.PRIMARY_FIRE, eventPlayer.moira_resource)
    if eventPlayer.moira_resource > 100:
        eventPlayer.moira_resource = 100
    wait(0.2)
    goto RULE_START


rule "Moira: Gain Resource From Damage":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    eventPlayer.moira_resource += 1


rule "Moira: Cant Fade while ulting":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setAbility1Enabled(false)
    waitUntil(eventPlayer.isUsingUltimate() == false, 8)
    eventPlayer.setAbility1Enabled(true)


rule "Moira: Cant super jump in Fade":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingAbility1() == true
    
    destroyEffect(eventPlayer.anti_nade_effect)
    eventPlayer.anti_nade_check = 0
    eventPlayer.setHealingReceived(eventPlayer.healing_recieved * 100)
    eventPlayer.anti_nade_effect = null
    eventPlayer.Discorder.discord_timer = 3
    eventPlayer.setJumpVerticalSpeed(50)
    waitUntil(eventPlayer.isUsingAbility1() == false, 10)
    eventPlayer.setJumpVerticalSpeed(100)


rule "Rein: 1 firestrike":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbility2Enabled(false)
    wait(7)
    eventPlayer.setAbility2Enabled(true)


rule "Rein: Movement Speed Penalty":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setMoveSpeed(75)
    waitUntil(eventPlayer.isFiringSecondaryFire() == false, 100)
    eventPlayer.setMoveSpeed(100)


rule "Rein: Hammer Damage":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    eventPlayer.setDamageDealt(88.235)


rule "Rein: Firestrike Damage":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setDamageDealt(100)


rule "Rein: Pin Damage":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setDamageDealt(133.333)


rule "Rein: Ult Damage":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isOnGround() == true
    
    eventPlayer.setDamageDealt(20)
    wait(3)


rule "Rein: Raise Outer Ult Damage":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage < 50
    
    damage(victim, attacker, 50 - eventDamage)


rule "Winston: Primal Range boop range":
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() == Hero.WINSTON
    @Condition attacker.isUsingUltimate() == true
    
    wait(0.05)
    if victim.role == 0:
        victim.applyImpulse(directionTowards(victim.getPosition(), victim.getPosition() + victim.getVelocity()), victim.getSpeed() * 0.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "Winston: Primal Rage Health Change":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingUltimate() == true
    
    removeHealthPool(eventPlayer.health_reference)
    eventPlayer.addHealthPool(Health.NORMAL, 1015.38, true, true)
    eventPlayer.health_reference = getLastCreatedHealthPool()
    wait(0.017)
    healee_ = eventPlayer
    healer_ = null
    amount = 2000
    workshopHeal()
    wait(10)
    removeHealthPool(eventPlayer.health_reference)
    eventPlayer.addHealthPool(Health.NORMAL, 476.92, true, true)
    eventPlayer.health_reference = getLastCreatedHealthPool()


rule "Zarya: Personal Bubble":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility1() == true
    
    wait(0.033)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.zarya_shield_cooldown_1 = 10
    while eventPlayer.zarya_shield_cooldown_1 > 0:
        wait(1)
        eventPlayer.zarya_shield_cooldown_1 -= 1
    eventPlayer.setAbility1Enabled(true)


rule "Zarya: Other Bubble":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility2() == true
    
    wait(0.033)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.zarya_shield_cooldown_2 = 8
    while eventPlayer.zarya_shield_cooldown_2 > 0:
        wait(1)
        eventPlayer.zarya_shield_cooldown_2 -= 1
    eventPlayer.setAbility2Enabled(true)


rule "Zarya: Recieved Bubble":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.INVINCIBLE) == true
    
    eventPlayer.Discorder.discord_timer = 3
    destroyEffect(eventPlayer.anti_nade_effect)
    eventPlayer.anti_nade_check = 0
    eventPlayer.setHealingReceived(eventPlayer.healing_recieved * 100)
    eventPlayer.anti_nade_effect = null


rule "Zen: Raise Damage from non kick attack":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition eventAbility == Button.MELEE
    
    healee_ = victim
    healer_ = null
    amount = 15
    workshopHeal()


rule "Shield Health Regen":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.current_shield_health < eventPlayer.max_shield_health
    
    eventPlayer.time_since_damage_shield += 0.5
    if eventPlayer.time_since_damage_shield >= 3:
        healee_ = eventPlayer
        healer_ = null
        amount = min(3.333, eventPlayer.max_shield_health - eventPlayer.current_shield_health)
        workshopHeal()
        eventPlayer.current_shield_health += min(3.333, eventPlayer.max_shield_health - eventPlayer.current_shield_health)
        if eventPlayer.current_shield_health > eventPlayer.max_shield_health:
            eventPlayer.current_shield_health = eventPlayer.max_shield_health
        eventPlayer.time_since_damage_shield = 2.5
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Shield Timer Reset":
    @Event playerTookDamage
    @Hero zenyatta
    @Condition attacker != null
    
    eventPlayer.time_since_damage_shield = 0
    eventPlayer.current_shield_health = eventPlayer.getHealthOfType(Health.SHIELDS)


rule "Zen: Decreased Boop Range":
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() == Hero.ZENYATTA
    @Condition eventAbility == Button.MELEE
    
    wait(0.05)
    victim.applyImpulse((directionTowards(victim.getPosition(), victim.getPosition() + victim.getVelocity())) * vect(-1, [], -1), victim.getSpeed() * 0.9, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "Round 1 Over":
    @Condition scrim_mode == true
    @Condition getCurrentGamemode() != Gamemode.CONTROL
    @Condition isMatchBetweenRounds() == true
    @Condition isTeamOnOffense(Team.2) == true
    @Condition scrim_mode_state == 0
    
    setTeamScore(Team.2, 3)
    scrim_mode_state = 1


rule "Round 2 Start":
    @Condition scrim_mode == true
    @Condition getCurrentGamemode() != Gamemode.CONTROL
    @Condition isMatchBetweenRounds() == false
    @Condition scrim_mode_state == 1
    
    scrim_mode_state = 2


rule "Round 2 Over":
    @Condition scrim_mode == true
    @Condition getCurrentGamemode() != Gamemode.CONTROL
    @Condition isMatchBetweenRounds() == true
    @Condition scrim_mode_state == 2
    
    setTeamScore(Team.2, 3)
    declareDraw()


rule "Reduce Select Hero":
    @Condition scrim_mode == true
    @Condition isAssemblingHeroes() == true
    
    setMatchTime(10)


rule "Control Score Count":
    @Condition scrim_mode == true
    @Condition getCurrentGamemode() == Gamemode.CONTROL
    @Condition isMatchBetweenRounds() == true
    
    scrim_mode_state += 1
    setTeamScore(Team.1, 0)
    setTeamScore(Team.2, 0)


rule "Control Declare Draw":
    @Condition scrim_mode == true
    @Condition getCurrentGamemode() == Gamemode.CONTROL
    @Condition scrim_mode_state == 3
    
    declareDraw()


