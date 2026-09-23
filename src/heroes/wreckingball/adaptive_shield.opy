#!mainFile "../../main.opy"

playervar adaptive_pre_beat_shield_health
#!define _ow2_adaptive_shield_n adaptive_pre_beat_shield_health[0]
#!define _ow1_adaptive_shield_n adaptive_pre_beat_shield_health[1]
#!define _expected_adapt_shields adaptive_pre_beat_shield_health[2]
#!define _actual_adapt_shields adaptive_pre_beat_shield_health[3]


macro getOW1AdaptiveShields(n):
    OW1_WRECKING_BALL_ADAPTIVE_SHIELD_PER_TARGET*n + OW1_WRECKING_BALL_ADAPTIVE_SHIELD_BASE
macro getOW2AdaptiveShields(n):
    OW2_WRECKING_BALL_ADAPTIVE_SHIELD_PER_TARGET*n + OW2_WRECKING_BALL_ADAPTIVE_SHIELD_BASE

rule "[wreckingball/adaptive_shield.opy]: OW1 Adaptive Shields":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer._ow2_adaptive_shield_n = \
        len(getPlayersInRadius(
                eventPlayer.getEyePosition(),
                OW2_WRECKING_BALL_ADAPTIVE_SHIELD_RADIUS,
                getOppositeTeam(eventPlayer.getTeam()),
                LosCheck.SURFACES_AND_ALL_BARRIERS))
    eventPlayer._ow1_adaptive_shield_n = \
        len(getPlayersInRadius(
                eventPlayer.getEyePosition(),
                OW1_WRECKING_BALL_ADAPTIVE_SHIELD_RADIUS,
                getOppositeTeam(eventPlayer.getTeam()),
                LosCheck.SURFACES_AND_ALL_BARRIERS))

    eventPlayer._expected_adapt_shields = getOW1AdaptiveShields(eventPlayer._ow1_adaptive_shield_n)
    eventPlayer._actual_adapt_shields = getOW2AdaptiveShields(eventPlayer._ow2_adaptive_shield_n)

    if eventPlayer.sound_barrier_pool_id != null or eventPlayer.rally_armor_ids != null:
        removeTrackedPools(eventPlayer)

    eventPlayer.setHealth(eventPlayer.getHealth() - (eventPlayer._actual_adapt_shields-TICK_DURATION))

    addTrackedPools(eventPlayer)
    eventPlayer.addHealthPool(Health.SHIELDS, (eventPlayer._expected_adapt_shields-TICK_DURATION), false, false)
    eventPlayer._adaptive_shield_hp_id = getLastCreatedHealthPool()
    eventPlayer.adaptive_shield_amount = eventPlayer._expected_adapt_shields - TICK_DURATION
    wait(OW1_WRECKING_BALL_ADAPTIVE_SHIELD_DURATION)
    removeHealthPool(eventPlayer._adaptive_shield_hp_id)
    eventPlayer._adaptive_shield_hp_id = null
    eventPlayer.adaptive_shield_amount = 0


rule "[wreckingball/adaptive_shield.opy]: Disable OW2 shield transfer":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.ABILITY_2)
    wait(OW2_WRECKING_BALL_ADAPTIVE_SHIELD_DURATION)
    eventPlayer.allowButton(Button.ABILITY_2)
