#!mainFile "../../../main.opy"


rule "[reinhardt/charge.opy]: Set default charge cooldown":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1()
    
    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_REINHARDT_CHARGE_COOLDOWN_TIME)


rule "[reinhardt/charge.opy]: Increase charge damage":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventDamage > (OW2_REINHARDT_CHARGE_BUMP_DAMAGE + 1) # Checks for pin vs boop damage (+ 1 because apparently 50.0 > 50 == true for whatever reason)

    damage(victim, attacker, eventDamage*(OW1_REINHARDT_CHARGE_PIN_DAMAGE/OW2_REINHARDT_CHARGE_PIN_DAMAGE)-eventDamage)