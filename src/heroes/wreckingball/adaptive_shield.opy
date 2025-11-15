#!mainFile "../../dev_main.opy"

#playervar adaptive_shield_pvar
##!define _ow2_adaptive_shield_n adaptive_shield_pvar[0]
##!define _ow1_adaptive_shield_n adaptive_shield_pvar[1]

#macro getOW1AdaptiveShields(n):
 #   OW1_WRECKING_BALL_ADAPTIVE_SHIELD_PER_TARGET*n + OW1_WRECKING_BALL_ADAPTIVE_SHIELD_BASE
#macro getOW2AdaptiveShields(n):
 #   OW2_WRECKING_BALL_ADAPTIVE_SHIELD_PER_TARGET*n + OW2_WRECKING_BALL_ADAPTIVE_SHIELD_BASE

#rule "[wreckingball/adaptive_shield.opy]: OW1 Adaptive Shields":
    #@Event eachPlayer
    #@Hero hammond
    #@Condition eventPlayer.isUsingAbility2()

    #eventPlayer._ow2_adaptive_shield_n = \
       # len(getPlayersInRadius(
       #         eventPlayer.getEyePosition(), 
       #         OW2_WRECKING_BALL_ADAPTIVE_SHIELD_RADIUS, 
      #           LosCheck.SURFACES_AND_ALL_BARRIERS))
    #eventPlayer._ow1_adaptive_shield_n = \
      #  len(getPlayersInRadius(
      #          eventPlayer.getEyePosition(), 
      #          OW1_WRECKING_BALL_ADAPTIVE_SHIELD_RADIUS, 
     #           getOppositeTeam(eventPlayer.getTeam()), 
     #           LosCheck.SURFACES_AND_ALL_BARRIERS))


    #if eventPlayer._ow1_adaptive_shield_n == 0:

    #else:
    #    eventPlayer.addHealthPool(Health.NORMAL, 25 * eventPlayer._ow1_adaptive_shield_n, false, false)
   # wait(7)
   # damage(eventPlayer, null, 
    
#     damage(eventPlayer, null, getOW2AdaptiveShields(eventPlayer._ow2_adaptive_shield_n) - getOW1AdaptiveShields(eventPlayer._ow1_adaptive_shield_n))

rule "[adaptive_shield.opy]: I want to off myself because of this code":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.B = len(getRealPlayersInRadius(eventPlayer.getEyePosition(),OW1_WRECKING_BALL_ADAPTIVE_SHIELD_RADIUS,getOppositeTeam(eventPlayer.getTeam()),LosCheck.SURFACES_AND_ALL_BARRIERS))
    if eventPlayer.B == 0:

    else:
        eventPlayer.addHealthPool(Health.NORMAL, 25 * eventPlayer.B, false, false)
        wait(7)
        damage(eventPlayer, null, getLastCreatedHealthPool())



rule "[wreckingball/adaptive_shield.opy]: Disable OW2 shield transfer":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.disallowButton(Button.ABILITY_2)
    wait(OW2_WRECKING_BALL_ADAPTIVE_SHIELD_DURATION)
    eventPlayer.allowButton(Button.ABILITY_2)
