#!mainFile "../../dev_main.opy"

playervar adaptive_shield_pvar
#!define _ow2_adaptive_shield_n adaptive_shield_pvar[0]
#!define _ow1_adaptive_shield_n adaptive_shield_pvar[1]
#!define _expected_adapt_shields adaptive_shield_pvar[2]
#!define _actual_adapt_shields adaptive_shield_pvar[3]
#!define _adaptive_shield_hp_id adaptive_shield_pvar[4]

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

    if eventPlayer._expected_adapt_shields > eventPlayer._actual_adapt_shields:
        eventPlayer.addHealthPool(Health.NORMAL, eventPlayer._expected_adapt_shields - eventPlayer._actual_adapt_shields, false, false)
        eventPlayer._adaptive_shield_hp_id = getLastCreatedHealthPool()
        wait(OW1_WRECKING_BALL_ADAPTIVE_SHIELD_DURATION)
        removeHealthPool(eventPlayer._adaptive_shield_hp_id)
    elif eventPlayer._expected_adapt_shields < eventPlayer._actual_adapt_shields:
        damage(eventPlayer, null, eventPlayer._actual_adapt_shields - eventPlayer._expected_adapt_shields)


rule "[wreckingball/adaptive_shield.opy]: Disable OW2 shield transfer":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.ABILITY_2)
    wait(OW2_WRECKING_BALL_ADAPTIVE_SHIELD_DURATION)
    eventPlayer.allowButton(Button.ABILITY_2)
