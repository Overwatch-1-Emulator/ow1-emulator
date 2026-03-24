#!mainFile "../../main.opy"


# ─────────────────────────────────────────────
#  Variable
# ─────────────────────────────────────────────

playervar rally_pvar
#!defineMember _hp_before_rally rally_pvar[0]
playervar rally_i
playervar rally_armor_ids


# ─────────────────────────────────────────────
#  Macros
# ─────────────────────────────────────────────

# How much HP the player is currently missing
#!define getMissingHp() (eventPlayer.getMaxHealth() - eventPlayer.getHealth())

# How much of the player's armor is their natural (base) armor pool,
# accounting for any HP they have lost. Clamped to 0.
#!define getNaturalArmor() max(0, (eventPlayer.getMaxHealthOfType(Health.ARMOR) - getMissingHp()))

# How much armor has been added ON TOP of the player's natural armor (i.e. from Rally).
# Clamped to 0 for safety.
#!define getExtraArmor() max(0, eventPlayer.getHealthOfType(Health.ARMOR) - getNaturalArmor())


# ─────────────────────────────────────────────
#  Rule 1 – Brigitte self: remove OW2 Rally, apply OW1 speed & HP
# ─────────────────────────────────────────────

rule "[brigitte/rally.opy]: OW1 Rally – self setup":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    # OW2 Rally instantly grants armor. Reset HP pools back to correct OW1
    # values. Save current HP first so we can restore it after the pool reset.
    eventPlayer._hp_before_rally = eventPlayer.getHealth()
    setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    eventPlayer.setHealth(eventPlayer._hp_before_rally)

    # OW2 Rally speed buff is 15%, OW1 is 30%. Scale to the correct ratio.
    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF / OW2_BRIGITTE_RALLY_SPEED_BUFF))

    # Wait for ult to end, then restore move speed
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setMoveSpeed(100)

    # Armor pools built up during the ult persist for OW1_BRIGITTE_RALLY_ARMOR_DURATION
    # seconds after the ult ends, matching OW1 behaviour
    wait(OW1_BRIGITTE_RALLY_ARMOR_DURATION)

    for eventPlayer.rally_i in range(len(eventPlayer.rally_armor_ids)):
        removeHealthPool(eventPlayer.rally_armor_ids[eventPlayer.rally_i])
    eventPlayer.rally_armor_ids = []


# ─────────────────────────────────────────────
#  Rule 2 – Brigitte self: tick armor up to cap during Rally
# ─────────────────────────────────────────────

rule "[brigitte/rally.opy]: OW1 Rally – add armor to self":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()
    @Condition getExtraArmor() < OW1_BRIGITTE_RALLY_ARMOR_MAX

    do:
        eventPlayer.addHealthPool(
            Health.ARMOR,
            min(OW1_BRIGITTE_RALLY_ARMOR, OW1_BRIGITTE_RALLY_ARMOR_MAX - getExtraArmor()),
            false,
            false
        )
        eventPlayer.rally_armor_ids.append(getLastCreatedHealthPool())
        wait(OW1_BRIGITTE_RALLY_ARMOR_PERIOD, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION


# ─────────────────────────────────────────────
#  Rule 3 – Allies: remove OW2 Rally overhealth
#
#  OW2 Rally grants 15 overhealth to nearby allies continuously.
#  We clamp allies back to their pre-ult HP every tick using setHealth(),
#  which is more reliable than damage() as it bypasses damage scalars,
#  armor mitigation and on-hit effects.
#
#  The wait(0.064) at the top of the loop gives OW2 one tick to apply
#  its overhealth before we strip it, without needing any code before
#  the do/while (which OverPy does not allow).
# ─────────────────────────────────────────────

rule "[brigitte/rally.opy]: OW1 Rally – remove OW2 overhealth from allies":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition eventPlayer._friendly_brigitte_player.isUsingUltimate()
    @Condition distance(eventPlayer, eventPlayer._friendly_brigitte_player) < OW2_BRIGITTE_RALLY_RADIUS
    @Condition isInLoS(eventPlayer, eventPlayer._friendly_brigitte_player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)

    # Wait one tick for OW2 to finish applying overhealth
    wait(0.064)

    # Save HP before we damage, then punch through all HP to reach the
    # overhealth layer (overhealth is consumed last), then heal back.
    # UNKILLABLE prevents the damage from killing the ally in the one
    # frame before the heal lands.
    eventPlayer._hp_before_rally = eventPlayer.getHealth()
    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, 0.5)
    damage(eventPlayer, null, eventPlayer._hp_before_rally + OW2_BRIGITTE_RALLY_OVERHEALTH)
    heal(eventPlayer, null, eventPlayer._hp_before_rally)


# ─────────────────────────────────────────────
#  Rule 4 – Allies: add OW1 Rally armor within radius + LoS
# ─────────────────────────────────────────────

rule "[brigitte/rally.opy]: OW1 Rally – add armor to allies":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition eventPlayer._friendly_brigitte_player.isUsingUltimate()
    @Condition distance(eventPlayer, eventPlayer._friendly_brigitte_player) < OW2_BRIGITTE_RALLY_RADIUS
    @Condition isInLoS(eventPlayer, eventPlayer._friendly_brigitte_player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)
    @Condition getExtraArmor() < OW1_BRIGITTE_RALLY_ARMOR_MAX

    do:
        eventPlayer.addHealthPool(
            Health.ARMOR,
            min(OW1_BRIGITTE_RALLY_ARMOR, OW1_BRIGITTE_RALLY_ARMOR_MAX - getExtraArmor()),
            false,
            false
        )
        # Store the pool ID on Brigitte so Rule 1 cleans up after the duration expires
        eventPlayer._friendly_brigitte_player.rally_armor_ids.append(getLastCreatedHealthPool())
        wait(OW1_BRIGITTE_RALLY_ARMOR_PERIOD, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION


