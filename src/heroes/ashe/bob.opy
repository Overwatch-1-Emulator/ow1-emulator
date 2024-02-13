#!mainFile "../../main.opy"

playervar ult_point_while_ult_active
playervar start_time_ult


rule "[ashe/bob.opy]: Add ultimate charge while using BOB":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.isUsingUltimate() 

    eventPlayer.ult_point_while_ult_active = 0
    eventPlayer.start_time_ult = getTotalTimeElapsed()

    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    # Check if the user did not switch hero after using B.O.B to add the ult charge
    if eventPlayer.getCurrentHero() == Hero.ASHE :
        # Add charge for passive generation and then the ult charge generated from the damage made by Ashe
        eventPlayer._missing_ult_points = ULT_CHARGE_PER_SECOND * (getTotalTimeElapsed() - eventPlayer.start_time_ult) + eventPlayer.ult_point_while_ult_active
 


rule "[ashe/bob.opy]: Calcul of the damage made while BOB is active":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventPlayer.isUsingUltimate()
    @Condition victim != attacker

    if victim.getCurrentHero() in getTankHeroes() :
        eventPlayer.ult_point_while_ult_active += (1 + OW2_TANK_ULT_NEGATION) * eventDamage 
    else :
        eventPlayer.ult_point_while_ult_active += eventDamage
