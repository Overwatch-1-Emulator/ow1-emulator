#!mainFile "../../dev_main.opy"

playervar adaptive_shield_pvar
#!define _ow2_adaptive_shield_n adaptive_shield_pvar[0]
#!define _ow1_adaptive_shield_n adaptive_shield_pvar[1]

#!define getOW1AdaptiveShields(n) (OW1_WRECKING_BALL_SHIELD_PER_TARGET*n + OW1_WRECKING_BALL_ADAPTIVE_SHIELD_BASE)
#!define getOW2AdaptiveShields(n) (OW2_WRECKING_BALL_SHIELD_PER_TARGET*n + OW2_WRECKING_BALL_ADAPTIVE_SHIELD_BASE)


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

    damage(eventPlayer, null, getOW2AdaptiveShields(eventPlayer._ow2_adaptive_shield_n) - getOW1AdaptiveShields(eventPlayer._ow1_adaptive_shield_n))


rule "[wreckingball/adaptive_shield.opy]: Disable OW2 shield transfer":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.ABILITY_2)
    wait(OW2_WRECKING_BALL_ADAPTIVE_SHIELD_DURATION)
    eventPlayer.allowButton(Button.ABILITY_2)
