#!mainFile "../../main.opy"

playervar rally_pvar
#!defineMember _rally_armor_added   rally_pvar[0]
#!defineMember _rally_pool_id       rally_pvar[1]
#!defineMember rally_ally_ref       rally_pvar[2]
#!defineMember rally_team_cache     rally_pvar[3]
#!defineMember rally_armor_amount   rally_pvar[4]
#!defineMember rally_armor_ids      rally_pvar[5]
#!defineMember switch_hero_ana      rally_pvar[6]
#!defineMember start_rally          rally_pvar[7]
#!defineMember rally_bar_id         rally_pvar[8]
#!defineMember rally_ring_id        rally_pvar[9]
playervar rally_i
playervar rally_ally_i
playervar rally_timer
playervar shield_bash_cd
playervar whipshot_cd
playervar repair_pack_charges
playervar repair_pack_cd

macro getMissingHp():
    (eventPlayer.getMaxHealth() - eventPlayer.getHealth())
macro getNaturalArmor():
    ((eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR)) - eventPlayer.getHealthOfType(Health.NORMAL) - getMissingHp())
macro getExtraArmor():
    max(0, eventPlayer.getHealthOfType(Health.ARMOR) - getNaturalArmor())


# Swap to Ana to cancel OW2 Rally before it applies overhealth to allies
rule "[brigitte/rally.opy]: Cancel OW2 Rally via hero swap":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()


    wait (0.46)
    eventPlayer.shield_bash_cd = eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE)
    eventPlayer.whipshot_cd = eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    eventPlayer.repair_pack_cd = eventPlayer.getAbilityCooldown(Button.ABILITY_2)
    eventPlayer.repair_pack_charges = eventPlayer.getAbilityCharge(Button.ABILITY_2)
    eventPlayer.switch_hero_ana = true

  
    eventPlayer.startForcingHero(Hero.ANA)
    eventPlayer.stopForcingCurrentHero()


# Player is Ana here - no @Hero filter
rule "[brigitte/rally.opy]: Swap back to Brigitte and start OW1 Rally":
    @Event eachPlayer
    @Condition eventPlayer.switch_hero_ana == true

    eventPlayer.switch_hero_ana = false
    eventPlayer.startForcingHero(Hero.BRIGITTE)
    eventPlayer.stopForcingCurrentHero()
    #wait(0.064)

    eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, eventPlayer.shield_bash_cd)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.whipshot_cd)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.repair_pack_cd)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, eventPlayer.repair_pack_charges)
    eventPlayer.setMoveSpeed(130)
    eventPlayer.setUltEnabled(false)

    for eventPlayer.rally_i in range(len(eventPlayer.rally_armor_ids)):
        removeHealthPool(eventPlayer.rally_armor_ids[eventPlayer.rally_i])
    eventPlayer.rally_armor_ids = []

    eventPlayer.start_rally = true
    eventPlayer.rally_timer = OW1_BRIGITTE_RALLY_DURATION
    chase(eventPlayer.rally_timer, 0, duration=OW1_BRIGITTE_RALLY_DURATION, ChaseReeval.NONE)

    progressBarHud(
        eventPlayer,
        roundedPercent(eventPlayer.rally_timer / OW1_BRIGITTE_RALLY_DURATION),
        "Rally",
        HudPosition.TOP,
        1,
        Color.YELLOW,
        Color.YELLOW,
        ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR,
        SpecVisibility.DEFAULT
    )
    eventPlayer.rally_bar_id = getLastCreatedText()

    createEffect(
        getAllPlayers(),
        Effect.RING,
        Color.ORANGE,
        eventPlayer,
        OW2_BRIGITTE_RALLY_RADIUS,
        EffectReeval.VISIBILITY_POSITION_AND_RADIUS
    )
    eventPlayer.rally_ring_id = getLastCreatedEntity()

    wait(OW1_BRIGITTE_RALLY_DURATION)

    eventPlayer.start_rally = false
    stopChasingVariable(eventPlayer.rally_timer)
    destroyProgressBarHud(eventPlayer.rally_bar_id)
    destroyEffect(eventPlayer.rally_ring_id)
    eventPlayer.rally_bar_id = null
    eventPlayer.rally_ring_id = null
    eventPlayer.rally_timer = 0
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setUltEnabled(true)

    wait(OW1_BRIGITTE_RALLY_ARMOR_DURATION)

    for eventPlayer.rally_i in range(len(eventPlayer.rally_armor_ids)):
        removeHealthPool(eventPlayer.rally_armor_ids[eventPlayer.rally_i])
    eventPlayer.rally_armor_ids = []



rule "[brigitte/rally.opy]: Recreate OW1 Rally Armor for self":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.start_rally == true
    @Condition getExtraArmor() < OW1_BRIGITTE_RALLY_ARMOR_MAX

    while RULE_CONDITION:
        eventPlayer.addHealthPool(Health.ARMOR, min(OW1_BRIGITTE_RALLY_ARMOR, (OW1_BRIGITTE_RALLY_ARMOR_MAX - getExtraArmor())), false, false)
        eventPlayer.rally_armor_ids.append(getLastCreatedHealthPool())
        wait(1/OW1_BRIGITTE_RALLY_POLLING_FREQ, Wait.ABORT_WHEN_FALSE)


# Remove ally armor after Rally duration expires
rule "[brigitte/rally.opy]: Remove ally armor after Rally duration":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition not eventPlayer._friendly_brigitte_player.start_rally
    @Condition eventPlayer._rally_armor_added > 0

    wait(OW1_BRIGITTE_RALLY_ARMOR_DURATION)
    if eventPlayer._rally_armor_added > 0:
        removeHealthPool(eventPlayer._rally_pool_id)
    eventPlayer._rally_armor_added = 0
    eventPlayer._rally_pool_id = 0


# Runs from Brigitte's side - team cached once per tick, allies processed
# sequentially to avoid getLastCreatedHealthPool() race conditions.
rule "[brigitte/rally.opy]: OW1 Rally Armor for allies":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.start_rally == true

    do:
        eventPlayer.rally_team_cache = getPlayers(eventPlayer.getTeam())
        for eventPlayer.rally_ally_i in range(len(eventPlayer.rally_team_cache)):
            eventPlayer.rally_ally_ref = eventPlayer.rally_team_cache[eventPlayer.rally_ally_i]

            if eventPlayer.rally_ally_ref == eventPlayer: continue
            if distance(eventPlayer.rally_ally_ref, eventPlayer) >= OW2_BRIGITTE_RALLY_RADIUS: continue
            if not isInLoS(eventPlayer.rally_ally_ref, eventPlayer, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS): continue

            if eventPlayer.rally_ally_ref._rally_armor_added > 0:
                removeHealthPool(eventPlayer.rally_ally_ref._rally_pool_id)

            if eventPlayer.rally_ally_ref._rally_armor_added < OW1_BRIGITTE_RALLY_ARMOR_MAX:
                eventPlayer.rally_armor_amount = min(OW1_BRIGITTE_RALLY_ARMOR, OW1_BRIGITTE_RALLY_ARMOR_MAX - eventPlayer.rally_ally_ref._rally_armor_added)
                eventPlayer.rally_ally_ref._rally_armor_added += eventPlayer.rally_armor_amount

            eventPlayer.rally_ally_ref.addHealthPool(Health.ARMOR, eventPlayer.rally_ally_ref._rally_armor_added, false, false)
            eventPlayer.rally_ally_ref._rally_pool_id = getLastCreatedHealthPool()

        wait(1/OW1_BRIGITTE_RALLY_POLLING_FREQ, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION


rule "[brigitte/bash.opy]: Reduce shield bash distance":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isFiringPrimaryFire()
    #@Condition not eventPlayer.isUsingUltimate()

    eventPlayer.setMoveSpeed(77.8) # arbitrarily decided based on trial and error
    waitUntil(eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE) > 0, Math.INFINITY)
    if eventPlayer.start_rally == true:
        eventPlayer.setMoveSpeed(130)
    else:
        eventPlayer.setMoveSpeed(100)