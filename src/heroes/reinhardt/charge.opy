#!mainFile "../../dev_main.opy"


rule "[reinhardt/charge.opy]: Increase charge damage":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.ABILITY_1
    
    if eventDamage > (OW2_REINHARDT_CHARGE_BUMP_DAMAGE + 1): # Checks for pin vs boop damage (+ 1 because apparently 50.0 > 50 == true for whatever reason)
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_REINHARDT_CHARGE_PIN_DAMAGE/OW2_REINHARDT_CHARGE_PIN_DAMAGE)-eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)


rule "[reinhardt/charge.opy]: Reduce charge radius":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.startForcingThrottle(0, 1/OW2_REINHARDT_TURN_BONUS, 0, 1/OW2_REINHARDT_TURN_BONUS, 0, 1/OW2_REINHARDT_TURN_BONUS)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.stopForcingThrottle()
