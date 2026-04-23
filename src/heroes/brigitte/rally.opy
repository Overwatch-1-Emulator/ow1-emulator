#!mainFile "../../main.opy"

playervar rally_pvar
#!defineMember _rally_armor_added   rally_pvar[0]
#!defineMember _rally_pool_id       rally_pvar[1]
#!defineMember rally_ally_ref       rally_pvar[2]
#!defineMember rally_team_cache     rally_pvar[3]
#!defineMember rally_armor_amount   rally_pvar[4]
#!defineMember rally_armor_ids      rally_pvar[5]
#!defineMember is_exiting_rally     rally_pvar[6]
#!defineMember start_rally          rally_pvar[7]
#!defineMember rally_bar_id         rally_pvar[8]
#!defineMember rally_ring_id        rally_pvar[9]
#!defineMember rally_text_id        rally_pvar[10]
#!defineMember shield_bash_cd       rally_pvar[11]
#!defineMember whipshot_cd          rally_pvar[12]
#!defineMember repair_pack_charges  rally_pvar[13]
#!defineMember repair_pack_cd       rally_pvar[14]
#!defineMember brig_hp              rally_pvar[15]
playervar rally_i
playervar rally_ally_i
playervar rally_timer

macro getMissingHp():
    (eventPlayer.getMaxHealth() - eventPlayer.getHealth())
macro getNaturalArmor():
    ((eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR)) - eventPlayer.getHealthOfType(Health.NORMAL) - getMissingHp())
macro getExtraArmor():
    max(0, eventPlayer.getHealthOfType(Health.ARMOR) - getNaturalArmor())

macro hideRallyProgressbar():
    destroyProgressBarHud(eventPlayer.rally_bar_id)
    eventPlayer.rally_bar_id = null
    stopChasingVariable(eventPlayer.rally_timer)

macro hideRallyRingEffect():
    destroyEffect(eventPlayer.rally_ring_id)
    eventPlayer.rally_ring_id = null

macro hideRallyTextHUD():
    destroyHudText(eventPlayer.rally_text_id)
    eventPlayer.rally_text_id = null

def endRally():
    @Name "[brigitte/rally.opy]: endRally()"

    eventPlayer.start_rally = false

    hideRallyProgressbar()
    hideRallyRingEffect()
    hideRallyTextHUD()
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setUltEnabled(true)

# Switch to Ana temporarily to apply custom Rally
def cancelRally():
    @Name "[brigitte/rally.opy]: cancelRally()"

    eventPlayer.setHealth(eventPlayer.getHealth() - OW2_BRIGITTE_RALLY_INSTANT_ARMOR) # Remove rally instant armour
    wait(0.46) # Rally voiceline, dont remove this wait

    # Save Brigitte state
    eventPlayer.brig_hp = eventPlayer.getHealth()
    eventPlayer.shield_bash_cd = eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE)
    eventPlayer.whipshot_cd = eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    eventPlayer.repair_pack_cd = eventPlayer.getAbilityCooldown(Button.ABILITY_2)
    eventPlayer.repair_pack_charges = eventPlayer.getAbilityCharge(Button.ABILITY_2)

    eventPlayer.is_exiting_rally = true
    eventPlayer.startForcingHero(Hero.ANA)


# Switch back to brigitte after entering ana
rule "[brigitte/rally.opy]: Swap back to Brigitte":
    @Event eachPlayer
    @Condition eventPlayer.is_exiting_rally == true

    eventPlayer.startForcingHero(Hero.BRIGITTE)
    eventPlayer.stopForcingCurrentHero()

    # Restore brigitte state & setup for ult
    eventPlayer.setHealth(eventPlayer.brig_hp)
    eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, eventPlayer.shield_bash_cd)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.whipshot_cd)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.repair_pack_cd)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, eventPlayer.repair_pack_charges)
    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF)) # 30% move increase in rally
    eventPlayer.setUltEnabled(false) # Cant gain ult charge during rally

    eventPlayer.is_exiting_rally = false
    eventPlayer.start_rally = true

rule "[brigitte/rally.opy]: Cancel OW2 Rally when starting Rally":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    cancelRally()

rule "[brigitte/rally.opy]: Swap back to Brigitte and start OW1 Rally + vfx":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.start_rally == true

    for eventPlayer.rally_i in range(len(eventPlayer.rally_armor_ids)):
        removeHealthPool(eventPlayer.rally_armor_ids[eventPlayer.rally_i])
    eventPlayer.rally_armor_ids = []

    eventPlayer.rally_timer = OW1_BRIGITTE_RALLY_DURATION
    chase(eventPlayer.rally_timer, 0, duration=OW1_BRIGITTE_RALLY_DURATION, ChaseReeval.NONE)

    # Rally progress bar hud vfx
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

    # Rally timer text hud vfx
    hudSubheader(
        eventPlayer,
        "{}"
        .format(ceil(eventPlayer.rally_timer)),
        HudPosition.TOP,
        2, # Nearby players crosshair
        Color.WHITE,
        HudReeval.VISIBILITY_AND_STRING
    )
    eventPlayer.rally_text_id = getLastCreatedText()

    # Rally ring effect vfx
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

    endRally()

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


rule "[brigitte/rally.opy]: Remove ally armor after Rally ended":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition not eventPlayer._friendly_brigitte_player.start_rally
    @Condition eventPlayer._rally_armor_added > 0

    wait(OW1_BRIGITTE_RALLY_ARMOR_DURATION)
    if eventPlayer._rally_armor_added > 0:
        removeHealthPool(eventPlayer._rally_pool_id)
    eventPlayer._rally_armor_added = 0
    eventPlayer._rally_pool_id = 0


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
