#!mainFile "../../dev_main.opy"

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
        eventPlayer.ult_point_while_ult_active += (1 + unpercent(OW2_TANK_ULT_NEGATION_PERCENT)) * eventDamage 
    else :
        eventPlayer.ult_point_while_ult_active += eventDamage


# rule "[ashe/bob.opy]: OW1 Bob health":
#     @Event eachPlayer
#     @Hero ashe
#     @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
#     @Condition eventPlayer.getAbilityCooldown(Button.ULTIMATE) <= 0

#     eventPlayer.setMaxHealth(percent(OW1_ASHE_BOB_HEALTH/OW2_ASHE_BOB_HEALTH))
#     eventPlayer.allowButton(Button.ULTIMATE)
#     eventPlayer.forceButtonPress(Button.ULTIMATE)
#     eventPlayer.disallowButton(Button.ULTIMATE)
#     waitUntil(eventPlayer.isUsingUltimate(), 1)
#     eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))
