#!mainFile "../main.opy"

globalvar DEBUG_MODE = createWorkshopSetting(bool, "Dev Tools", "debug mode", true)
#!define STAT_KEEP_ALIVE (2)
#!define STAT_SPACING (0.5)

playervar debug_pvar
#!define _total_damage_received debug_pvar[0]
#!define _last_damage_received debug_pvar[1]
#!define _total_healing_received debug_pvar[2]
#!define _last_healing_received debug_pvar[3]


rule "[utilities/debug.opy] Disable Inspector for performance":
    @Event global
    @Condition not DEBUG_MODE

    disableInspector()


rule "[utilities/debug.opy]: global debug (Top Left)":
    @Event global
    @Condition DEBUG_MODE == true

    hudHeader(getAllPlayers(), "Global", HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load = {}%".format(getServerLoad()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load Average = {}%".format(getAverageServerLoad()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load Peak = {}%".format(getPeakServerLoad()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "isInSetup() = {}".format(isInSetup()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "getTotalTimeElapsed() = {}".format(getTotalTimeElapsed()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "len(_available_heroes) = {}".format(len(_available_heroes)), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "[utilities/debug.opy]: player debug (Top Right)":
    @Event eachPlayer
    @Condition DEBUG_MODE == true

    hudHeader(eventPlayer, "Event Player", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "call_init = {}".format(eventPlayer.call_init), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_hero_switched = {}".format(switchedHero(eventPlayer)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getAltitude() = {}".format(eventPlayer.getAltitude()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "hasStatusEffect(Status.HACKED) = {}".format(eventPlayer.hasStatusEffect(Status.HACKED)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "hasStatusEffect(Status.STUNNED) = {}".format(eventPlayer.hasStatusEffect(Status.STUNNED)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getStatistic(Stat.HERO_DAMAGE_DEALT) = {}".format(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "len(allowed_heroes) = {}".format(len(eventPlayer.allowed_heroes)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "len(getAllowedHeroes()) = {}".format(len(eventPlayer.getAllowedHeroes())), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isUsingUltimate() = {}".format(eventPlayer.isUsingUltimate()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_is_casting_emp = {}".format(eventPlayer._is_casting_emp), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_passive_healing_active = {}".format(eventPlayer._passive_healing_active), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_missing_ult_points = {}".format(eventPlayer._missing_ult_points), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getUltPoints() = {}".format(getUltPoints(eventPlayer)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getUltCharge() = {}".format(eventPlayer.getUltCharge()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getUltCharge() >= 100 = {}".format(eventPlayer.getUltCharge() >= 100), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isHoldingButton(Button.PRIMARY_FIRE) = {}".format(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isFiringPrimaryFire() = {}".format(eventPlayer.isFiringPrimaryFire()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isHoldingButton(Button.SECONDARY_FIRE) = {}".format(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isFiringSecondaryFire() = {}".format(eventPlayer.isFiringSecondaryFire()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isHoldingButton(Button.ABILITY_1) = {}".format(eventPlayer.isHoldingButton(Button.ABILITY_1)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isUsingAbility1() = {}".format(eventPlayer.isUsingAbility1()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "Ability 1 Cooldown = {}".format(eventPlayer.getAbilityCooldown(Button.ABILITY_1)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isUsingAbility2() = {}".format(eventPlayer.isUsingAbility2()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "Ability 2 Cooldown = {}".format(eventPlayer.getAbilityCooldown(Button.ABILITY_2)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getAbilityCharge(ABILITY_2) = {}".format(eventPlayer.getAbilityCharge(Button.ABILITY_2)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getSpeed() = {}".format(eventPlayer.getSpeed()), HudPosition.RIGHT, 1, Color.WHITE, Hud Reeval.STRING)
    # hudSubheader(eventPlayer, "_ult_cost = {}".format(eventPlayer._ult_cost), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_ult_percent_compensated = {}".format(eventPlayer._ult_percent_compensated), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getMaxHealth() = {}".format(eventPlayer.getMaxHealth()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getHealth() = {}".format(eventPlayer.getHealth()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "orisa_ammo = {}".format(eventPlayer.orisa_ammo), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isReloading() = {}".format(eventPlayer.isReloading()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getAmmo(0) = {}".format(eventPlayer.getAmmo(0)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isHoldingButton(Button.PRIMARY_FIRE) = {}".format(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "len(_self_healing_source) = {}".format(len(eventPlayer._self_healing_source)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_self_healing_percent = {}".format(eventPlayer._self_healing_percent), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_passive_healing_active = {}".format(eventPlayer._passive_healing_active), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_suppress_passive_healing = {}".format(eventPlayer._suppress_passive_healing), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getPosition() = {}".format(eventPlayer.getPosition()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "role = {}".format(eventPlayer.role), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isInAlternateForm() = {}".format(eventPlayer.isInAlternateForm()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "Primary Fire Cooldown = {}".format(eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "is_using_guardian_angel = {}".format(eventPlayer.is_using_guardian_angel), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "is_slingshotting = {}".format(eventPlayer.is_slingshotting), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "slam_damage = {}".format(eventPlayer.slam_damage), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "is_using_uppercut = {}".format(eventPlayer.is_using_uppercut), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "uppercut_shields = {}".format(eventPlayer.uppercut_shields), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isUsingSelfRepair() = {}".format(isUsingSelfRepair(eventPlayer)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "barrier_damage_block_id = {}".format(eventPlayer.barrier_damage_block_id), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "len(enemies_behind_barrier) = {}".format(len(eventPlayer.enemies_behind_barrier)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isAimingAtOrisaBarrier() = {}".format(isAimingAtOrisaBarrier()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "ow1_adaptive_shield_n = {}".format(eventPlayer.ow1_adaptive_shield_n), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "ow2_adaptive_shield_n = {}".format(eventPlayer.ow2_adaptive_shield_n), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "is_using_shield_bash = {}".format(eventPlayer.is_using_shield_bash), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "shield_bash_through_barrier = {}".format(eventPlayer.shield_bash_through_barrier), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "transloc_time = {}".format(eventPlayer.transloc_time), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "transloc_position = {}".format(eventPlayer.transloc_position), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "trasnloc_velocity = {}".format(eventPlayer.trasnloc_velocity), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_seed_hit_surface_normal = {}".format(eventPlayer._seed_hit_surface_normal), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_is_using_translocator = {}".format(eventPlayer._is_using_translocator), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isOnGround() = {}".format(eventPlayer.isOnGround()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isJumping() = {}".format(eventPlayer.isJumping()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "jet_fuel = {}".format(eventPlayer.jet_fuel), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_hover_jet_button = {}".format(eventPlayer._hover_jet_button), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "is_using_hover_jets() = {}".format(is_using_hover_jets()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getAbilityCooldown(JUMP) = {}".format(eventPlayer.getAbilityCooldown(Button.JUMP)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getAbilityCooldown(SECONDARY) = {}".format(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_is_exiting_wholehog = {}".format(eventPlayer._is_exiting_wholehog), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isGlidingOnRoof = {}".format(isGlidingOnRoof()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_tank_sleep_start_time = {}".format(eventPlayer._tank_sleep_start_time), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_tank_sleeping = {}".format(eventPlayer._tank_sleeping), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_scrap_last_fire_time = {}".format(eventPlayer._scrap_last_fire_time), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "distance(scrap_start, scrap_detonation) = {}".format(distance(eventPlayer._scrap_start_pos, eventPlayer._scrap_detonation_pos)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)


rule "[utilities/debug.opy]: do something on interact":
    @Event eachPlayer
    @Condition DEBUG_MODE
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)

    damage(eventPlayer, null, 25)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setUltCharge(100)


rule "[utilities/debug.opy]: Show Player Damage/Healing":
    @Event eachPlayer
    @Condition DEBUG_MODE

    # most recent damage
    createInWorldText(
        getAllPlayers() if eventPlayer._last_damage_received > 0 else null, 
        eventPlayer._last_damage_received, 
        eventPlayer.getEyePosition() + 1 * STAT_SPACING * Vector.UP, 
        1, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_AND_STRING, 
        Color.RED, 
        SpecVisibility.DEFAULT)

    # most recent healing
    createInWorldText(
        getAllPlayers() if eventPlayer._last_healing_received > 0 else null, 
        eventPlayer._last_healing_received, 
        eventPlayer.getEyePosition() + 2 * STAT_SPACING * Vector.UP, 
        1, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_AND_STRING, 
        Color.YELLOW, 
        SpecVisibility.DEFAULT)

    # total damage
    createInWorldText(
        getAllPlayers() if eventPlayer._total_damage_received > 0 else null, 
        eventPlayer._total_damage_received, 
        eventPlayer.getEyePosition() + 3 * STAT_SPACING * Vector.UP, 
        2, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_AND_STRING, 
        Color.RED, 
        SpecVisibility.DEFAULT)

    # total healing
    createInWorldText(
        getAllPlayers() if eventPlayer._total_healing_received > 0 else null, 
        eventPlayer._total_healing_received, 
        eventPlayer.getEyePosition() + 4 * STAT_SPACING * Vector.UP, 
        2, 
        Clip.NONE, 
        WorldTextReeval.VISIBILITY_POSITION_AND_STRING, 
        Color.YELLOW, 
        SpecVisibility.DEFAULT)


rule "[utilities/debug.opy]: Debug damage instance":
    @Event playerTookDamage
    @Condition DEBUG_MODE

    printLog("attacker={}, victim={}, ability={}, amount={}".format(attacker, victim, eventAbility, eventDamage))

    victim._last_damage_received = eventDamage
    victim._total_damage_received += eventDamage
    wait(STAT_KEEP_ALIVE, Wait.RESTART_WHEN_TRUE)
    victim._last_damage_received = 0
    victim._total_damage_received = 0


rule "[utilities/debug.opy]: Debug healing instance":
    @Event playerReceivedHealing
    @Condition DEBUG_MODE

    printLog("healer={}, healee={}, ability={}, amount={}".format(healer, healee, eventAbility, eventHealing))
    
    healee._last_healing_received = eventHealing
    healee._total_healing_received += eventHealing
    wait(STAT_KEEP_ALIVE, Wait.RESTART_WHEN_TRUE)
    healee._last_healing_received = 0
    healee._total_healing_received = 0


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