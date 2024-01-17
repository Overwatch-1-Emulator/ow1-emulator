#!mainFile "../main.opy"

globalvar DEBUG_MODE = createWorkshopSetting(bool, "Dev Tools", "debug mode", false)

rule "[debug.opy] Disable Inspector for performance":
    @Event global
    @Condition not DEBUG_MODE

    disableInspector()


rule "[debug.opy]: global debug (Top Left)":
    @Event global
    @Condition DEBUG_MODE == true

    hudHeader(getAllPlayers(), "Global", HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load: {}%".format(getServerLoad()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load Average: {}%".format(getAverageServerLoad()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load Peak: {}%".format(getPeakServerLoad()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "isInSetup(): {}".format(isInSetup()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "[debug.opy]: player debug (Top Right)":
    @Event eachPlayer
    @Condition DEBUG_MODE == true

    hudHeader(eventPlayer, "Event Player", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "call_init = {}".format(eventPlayer.call_init), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getAltitude() = {}".format(eventPlayer.getAltitude()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "hasStatusEffect(Status.HACKED) = {}".format(eventPlayer.hasStatusEffect(Status.HACKED)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "hasStatusEffect(Status.STUNNED) = {}".format(eventPlayer.hasStatusEffect(Status.STUNNED)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getStatistic(Stat.HERO_DAMAGE_DEALT) = {}".format(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "len(allowed_heroes) = {}".format(len(eventPlayer.allowed_heroes)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "len(getAllowedHeroes()) = {}".format(len(eventPlayer.getAllowedHeroes())), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isUsingUltimate() = {}".format(eventPlayer.isUsingUltimate()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "_missing_ult_points = {}".format(eventPlayer._missing_ult_points), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "getUltPoints() = {}".format(getUltPoints(eventPlayer)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getUltCharge() = {}".format(eventPlayer.getUltCharge()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getUltCharge() >= 100 = {}".format(eventPlayer.getUltCharge() >= 100), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isFiringPrimaryFire() = {}".format(eventPlayer.isFiringPrimaryFire()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isFiringSecondaryFire() = {}".format(eventPlayer.isFiringSecondaryFire()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isHoldingButton(Button.ABILITY_1) = {}".format(eventPlayer.isHoldingButton(Button.ABILITY_1)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isUsingAbility1() = {}".format(eventPlayer.isUsingAbility1()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "Ability 1 Cooldown = {}".format(eventPlayer.getAbilityCooldown(Button.ABILITY_1)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isUsingAbility2() = {}".format(eventPlayer.isUsingAbility2()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "Ability 2 Cooldown = {}".format(eventPlayer.getAbilityCooldown(Button.ABILITY_2)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "getAbilityCharge(ABILITY_2) = {}".format(eventPlayer.getAbilityCharge(Button.ABILITY_2)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "getSpeed() = {}".format(eventPlayer.getSpeed()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "_ult_cost = {}".format(eventPlayer._ult_cost), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "_ult_percent_compensated = {}".format(eventPlayer._ult_percent_compensated), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getMaxHealth() = {}".format(eventPlayer.getMaxHealth()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getHealth() = {}".format(eventPlayer.getHealth()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "orisa_ammo = {}".format(eventPlayer.orisa_ammo), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isReloading() = {}".format(eventPlayer.isReloading()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getAmmo(0) = {}".format(eventPlayer.getAmmo(0)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isHoldingButton(Button.PRIMARY_FIRE) = {}".format(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "Jump Cooldown = {}".format(eventPlayer.getAbilityCooldown(Button.JUMP)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "Crouch Cooldown = {}".format(eventPlayer.getAbilityCooldown(Button.CROUCH)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "Melee Cooldown = {}".format(eventPlayer.getAbilityCooldown(Button.MELEE)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "Ultimate Cooldown = {}".format(eventPlayer.getAbilityCooldown(Button.ULTIMATE)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isOnGround() = {}".format(eventPlayer.isOnGround()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isHoldingButton(Button.JUMP) = {}".format(eventPlayer.isHoldingButton(Button.JUMP)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "len(self_healing_source) = {}".format(len(eventPlayer.self_healing_source)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "self_healing_percent = {}".format(eventPlayer.self_healing_percent), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "getPosition() = {}".format(eventPlayer.getPosition()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "role = {}".format(eventPlayer.role), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "isInAlternateForm() = {}".format(eventPlayer.isInAlternateForm()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "Primary Fire Cooldown = {}".format(eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "is_using_guardian_angel = {}".format(eventPlayer.is_using_guardian_angel), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "is_slingshotting = {}".format(eventPlayer.is_slingshotting), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "slam_damage = {}".format(eventPlayer.slam_damage), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "is_using_uppercut = {}".format(eventPlayer.is_using_uppercut), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "uppercut_shields = {}".format(eventPlayer.uppercut_shields), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "is_using_self_repair = {}".format(eventPlayer.is_using_self_repair), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "barrier_damage_block_id = {}".format(eventPlayer.barrier_damage_block_id), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "len(enemies_behind_barrier) = {}".format(len(eventPlayer.enemies_behind_barrier)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "ow1_adaptive_shield_n = {}".format(eventPlayer.ow1_adaptive_shield_n), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "ow2_adaptive_shield_n = {}".format(eventPlayer.ow2_adaptive_shield_n), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "is_using_shield_bash = {}".format(eventPlayer.is_using_shield_bash), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    # hudSubheader(eventPlayer, "shield_bash_through_barrier = {}".format(eventPlayer.shield_bash_through_barrier), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "transloc_time = {}".format(eventPlayer.transloc_time), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "transloc_position = {}".format(eventPlayer.transloc_position), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "trasnloc_velocity = {}".format(eventPlayer.trasnloc_velocity), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "seed_hit_surface_normal = {}".format(eventPlayer.seed_hit_surface_normal), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "is_using_translocator = {}".format(eventPlayer.is_using_translocator), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    

rule "[debug.opy]: print to console on interact":
    @Event eachPlayer
    @Condition DEBUG_MODE == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true

    for i in range(len(eventPlayer.allowed_heroes)):
        printLog("eventPlayer.allowed_heroes[{}] = {}".format(i, eventPlayer.allowed_heroes[i]))


rule "[debug.opy]: give ultimate on interact":
    @Event eachPlayer
    @Condition DEBUG_MODE == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true

    eventPlayer.setUltCharge(100)


rule "[debug.opy]: Debug damage instance":
    @Event playerDealtDamage
    @Condition DEBUG_MODE == true

    printLog("hero={}, ability={}, amount={}".format(eventPlayer.getCurrentHero(), eventAbility, eventDamage))


rule "[debug.opy]: Debug healing instance":
    @Event playerDealtHealing
    @Condition DEBUG_MODE == true

    printLog("hero={}, ability={}, amount={}".format(eventPlayer.getCurrentHero(), eventAbility, eventHealing))
