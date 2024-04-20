#!mainFile "../../dev_main.opy"

playervar ow2_adaptive_shield_n
playervar ow1_adaptive_shield_n

#!define OW2_WRECKING_BALL_ADAPTIVE_SHIELD_BASE 100
#!define OW2_WRECKING_BALL_ADAPTIVE_SHIELD_DURATION 7
#!define OW2_WRECKING_BALL_ADAPTIVE_SHIELD_RADIUS 10
#!define OW2_WRECKING_BALL_SHIELD_PER_TARGET 100

#!define getOW1AdaptiveShields(n) (OW1_WRECKING_BALL_SHIELD_PER_TARGET*n + OW1_WRECKING_BALL_ADAPTIVE_SHIELD_BASE)
#!define getOW2AdaptiveShields(n) (OW2_WRECKING_BALL_SHIELD_PER_TARGET*n + OW2_WRECKING_BALL_ADAPTIVE_SHIELD_BASE)

rule "[wreckingball/shields.opy]: OW1 Adaptive Shields":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.ow2_adaptive_shield_n = len(getPlayersInRadius(eventPlayer.getEyePosition(), 
                                                               OW2_WRECKING_BALL_ADAPTIVE_SHIELD_RADIUS, 
                                                               getOppositeTeam(eventPlayer.getTeam()), 
                                                               LosCheck.SURFACES_AND_ALL_BARRIERS))
    eventPlayer.ow1_adaptive_shield_n = len(getPlayersInRadius(eventPlayer.getEyePosition(), 
                                                               OW1_WRECKING_BALL_ADAPTIVE_SHIELD_RADIUS, 
                                                               getOppositeTeam(eventPlayer.getTeam()), 
                                                               LosCheck.SURFACES_AND_ALL_BARRIERS))

    damage(eventPlayer, null, getOW2AdaptiveShields(eventPlayer.ow2_adaptive_shield_n) - getOW1AdaptiveShields(eventPlayer.ow1_adaptive_shield_n))


rule "[wreckingball/shields.opy]: Disable OW2 shield transfer":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.ABILITY_2)
    wait(OW2_WRECKING_BALL_ADAPTIVE_SHIELD_DURATION)
    eventPlayer.allowButton(Button.ABILITY_2)
