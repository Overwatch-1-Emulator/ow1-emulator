#!mainFile "../../main.opy"

rule "[reinhardt.opy]: Initialize Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    while (eventPlayer.getMaxHealth() != OW1_REINHARDT_HEALTH + OW1_REINHARDT_ARMOR):
        clearCustomHealth()
        setCustomHealth(OW1_REINHARDT_HEALTH, OW1_REINHARDT_ARMOR, 0)
        wait()


rule "[reinhardt.opy]: Set default charge cooldown":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1()
    
    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_REINHARDT_CHARGE_COOLDOWN_TIME)


rule "[reinhardt.opy]: Force single firestrike":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility2() == true

    waitUntil(not eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 0) # Every time rein uses firestrike, reset the resource to 0
    wait(OW1_REINHARDT_FIRE_STRIKE_COOLDOWN_TIME)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)


rule "[reinhardt.opy]: Increase charge damage":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventDamage > (OW2_REINHARDT_CHARGE_BUMP_DAMAGE + 1) # Checks for pin vs boop damage (+ 1 because apparently 50.0 > 50 == true for whatever reason)

    damage(victim, attacker, eventDamage*(OW1_REINHARDT_CHARGE_PIN_DAMAGE/OW2_REINHARDT_CHARGE_PIN_DAMAGE)-eventDamage)


rule "[reinhardt.opy]: OW1 one shot earthshatter":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > (OW2_REINHARDT_EARTHSHATTER_BASE_DAMAGE + OW2_REINHARDT_EARTHSHATTER_BONUS_DAMAGE)/2
    
    damage(victim, attacker, eventDamage * \
                             ((OW1_REINHARDT_EARTHSHATTER_BASE_DAMAGE + OW1_REINHARDT_EARTHSHATTER_BONUS_DAMAGE) / \
                              (OW2_REINHARDT_EARTHSHATTER_BASE_DAMAGE + OW2_REINHARDT_EARTHSHATTER_BONUS_DAMAGE)) - eventDamage)
