#!mainFile "../../main.opy"

playervar rally_pvar
#!defineMember _hp_before_rally     rally_pvar[0]
#!defineMember _rally_stored_armor  rally_pvar[1]
#!defineMember _rally_armor_added   rally_pvar[2]
#!defineMember _rally_pool_id       rally_pvar[3]
playervar rally_i
playervar rally_ally_i
playervar rally_ally_ref
playervar rally_team_cache
playervar rally_armor_amount
playervar rally_armor_ids
playervar brig_self_armor_id
playervar shield_bash_cd
playervar switchheroana
playervar startrally
playervar rally_timer
playervar rally_bar_id
playervar rally_ring_id

#!define getMissingHp() (eventPlayer.getMaxHealth() - eventPlayer.getHealth())
#!define getNaturalArmor() ((eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR)) - eventPlayer.getHealthOfType(Health.NORMAL) - getMissingHp())
#!define getExtraArmor() max(0, eventPlayer.getHealthOfType(Health.ARMOR) - getNaturalArmor())
#!define getExtraArmorOf(p) max(0, p.getHealthOfType(Health.ARMOR) - max(0, (p.getMaxHealthOfType(Health.NORMAL) + p.getMaxHealthOfType(Health.ARMOR)) - p.getHealthOfType(Health.NORMAL) - (p.getMaxHealth() - p.getHealth())))
#!define rallyHealthCeiling(p) (p.getMaxHealthOfType(Health.NORMAL) + p.getMaxHealthOfType(Health.ARMOR) + p.getMaxHealthOfType(Health.SHIELDS))

subroutine rally_strip_and_restore

def rally_strip_and_restore():
    @Name "[brigitte/rally.opy]: rally_strip_and_restore()"
    if eventPlayer._rally_armor_added > 0:
        removeHealthPool(eventPlayer._rally_pool_id)
    eventPlayer.setHealth(min(eventPlayer.getHealth(), rallyHealthCeiling(eventPlayer)))
    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer._rally_armor_added, false, false)
    eventPlayer._rally_pool_id = getLastCreatedHealthPool()


# Swap to Ana to cancel OW2 Rally before it applies overhealth to allies
rule "[brigitte/rally.opy]: Cancel OW2 Rally via hero swap":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    
    eventPlayer.switchheroana = true
    eventPlayer.startForcingHero(Hero.ANA)


# Player is Ana here - no @Hero filter
rule "[brigitte/rally.opy]: Swap back to Brigitte and start OW1 Rally":
    @Event eachPlayer
    @Condition eventPlayer.switchheroana == true

    eventPlayer.switchheroana = false
    eventPlayer.startForcingHero(Hero.BRIGITTE)
    wait(0.064) # Wait for hero swap to complete

    eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, eventPlayer.shield_bash_cd)
    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF))
    eventPlayer.startScalingBarriers(1, true)
    eventPlayer.setUltEnabled(false) # Disable ult so player can't re-trigger

    for eventPlayer.rally_i in range(len(eventPlayer.rally_armor_ids)):
        removeHealthPool(eventPlayer.rally_armor_ids[eventPlayer.rally_i])
    eventPlayer.rally_armor_ids = []

    eventPlayer.startrally = true
    eventPlayer.rally_timer = OW1_BRIGITTE_RALLY_DURATION
    chase(eventPlayer.rally_timer, 0, duration=OW1_BRIGITTE_RALLY_DURATION, ChaseReeval.NONE)

    # Progress bar showing rally duration
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

    # Ring showing rally radius - visible to all players, follows Brigitte
    createEffect(
        getAllPlayers(),
        Effect.RING,
        Color.TURQUOISE,
        eventPlayer,
        OW2_BRIGITTE_RALLY_RADIUS,
        EffectReeval.VISIBILITY_POSITION_AND_RADIUS
    )
    eventPlayer.rally_ring_id = getLastCreatedEntity()

    wait(OW1_BRIGITTE_RALLY_DURATION)

    eventPlayer.startrally = false
    stopChasingVariable(eventPlayer.rally_timer)
    destroyAllProgressBarHuds()
    destroyEffect(eventPlayer.rally_ring_id)
    eventPlayer.rally_bar_id = null
    eventPlayer.rally_ring_id = null
    eventPlayer.rally_timer = 0
    eventPlayer.setMoveSpeed(100)
    eventPlayer.stopScalingBarriers()
    eventPlayer.setUltEnabled(true) # Re-enable ult after rally ends

    # Store armor gained, reset HP cleanly, re-add as temp pool
    eventPlayer._rally_stored_armor = getExtraArmor()
    clearCustomHp()
    setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    if eventPlayer._rally_stored_armor > 0:
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer._rally_stored_armor, false, false)
        eventPlayer.rally_armor_ids.append(getLastCreatedHealthPool())

    wait(OW1_BRIGITTE_RALLY_ARMOR_DURATION)

    for eventPlayer.rally_i in range(len(eventPlayer.rally_armor_ids)):
        removeHealthPool(eventPlayer.rally_armor_ids[eventPlayer.rally_i])
    eventPlayer.rally_armor_ids = []


rule "[brigitte/rally.opy]: Doesnt reset bash on ult":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.shield_bash_cd = OW1_BRIGITTE_SHIELD_BASH_COOLDOWN
    chase(eventPlayer.shield_bash_cd, 0, rate=1, ChaseReeval.NONE)


rule "[brigitte/rally.opy]: Recreate OW1 Rally Armor for self":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.startrally == true
    @Condition getExtraArmor() < OW1_BRIGITTE_RALLY_ARMOR_MAX

    while RULE_CONDITION:
        eventPlayer.addHealthPool(Health.ARMOR, min(OW1_BRIGITTE_RALLY_ARMOR, (OW1_BRIGITTE_RALLY_ARMOR_MAX - getExtraArmor())), false, false)
        eventPlayer.rally_armor_ids.append(getLastCreatedHealthPool())
        wait(OW1_BRIGITTE_RALLY_ARMOR_PERIOD, Wait.ABORT_WHEN_FALSE)


rule "[brigitte/rally.opy]: Reset ally tracker when Rally ends":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition not eventPlayer._friendly_brigitte_player.startrally
    @Condition eventPlayer._rally_armor_added > 0

    rally_strip_and_restore()

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
    @Condition eventPlayer.startrally == true

    do:
        eventPlayer.rally_team_cache = getPlayers(eventPlayer.getTeam())
        for eventPlayer.rally_ally_i in range(len(eventPlayer.rally_team_cache)):
            eventPlayer.rally_ally_ref = eventPlayer.rally_team_cache[eventPlayer.rally_ally_i]

            if eventPlayer.rally_ally_ref == eventPlayer: continue
            if distance(eventPlayer.rally_ally_ref, eventPlayer) >= OW2_BRIGITTE_RALLY_RADIUS: continue
            if not isInLoS(eventPlayer.rally_ally_ref, eventPlayer, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS): continue

            if eventPlayer.rally_ally_ref._rally_armor_added > 0:
                removeHealthPool(eventPlayer.rally_ally_ref._rally_pool_id)

            eventPlayer.rally_ally_ref.setHealth(min(
                eventPlayer.rally_ally_ref.getHealth(),
                rallyHealthCeiling(eventPlayer.rally_ally_ref)
            ))

            if eventPlayer.rally_ally_ref._rally_armor_added < OW1_BRIGITTE_RALLY_ARMOR_MAX:
                eventPlayer.rally_armor_amount = min(OW1_BRIGITTE_RALLY_ARMOR, OW1_BRIGITTE_RALLY_ARMOR_MAX - eventPlayer.rally_ally_ref._rally_armor_added)
                eventPlayer.rally_ally_ref._rally_armor_added += eventPlayer.rally_armor_amount

            eventPlayer.rally_ally_ref.addHealthPool(Health.ARMOR, eventPlayer.rally_ally_ref._rally_armor_added, false, false)
            eventPlayer.rally_ally_ref._rally_pool_id = getLastCreatedHealthPool()

        wait(OW1_BRIGITTE_RALLY_ARMOR_PERIOD, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION


#rule "[brigitte/rally.opy]: Final overhealth check on leaving radius":
#    @Event eachPlayer
#    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
#    @Condition eventPlayer._friendly_brigitte_player.startrally
#    @Condition distance(eventPlayer, eventPlayer._friendly_brigitte_player) >= OW2_BRIGITTE_RALLY_RADIUS or not isInLoS(eventPlayer, eventPlayer._friendly_brigitte_player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)
#    @Condition eventPlayer._rally_armor_added > 0
#
#    rally_strip_and_restore()


#IDK IF THESE ARE NEEDED I HAD THEM IN THE OTHER CODE

#rule "[brigitte/rally.opy]: Overhealth check on re-entering radius":
#    @Event eachPlayer
#    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
#    @Condition eventPlayer._friendly_brigitte_player.startrally
#    @Condition distance(eventPlayer, eventPlayer._friendly_brigitte_player) < OW2_BRIGITTE_RALLY_RADIUS
#    @Condition isInLoS(eventPlayer, eventPlayer._friendly_brigitte_player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)
#    @Condition eventPlayer._rally_armor_added > 0

#    wait(0.064)
#    if not eventPlayer._friendly_brigitte_player.startrally: return
#    rally_strip_and_restore()
