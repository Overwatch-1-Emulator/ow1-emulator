#!mainFile "../../main.opy"


rule "[reinhardt/firestrike.opy]: Force single firestrike":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility2()

    #waitUntil(not eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 0) # Every time rein uses firestrike, reset the resource to 0
    wait(OW1_REINHARDT_FIRESTRIKE_COOLDOWN_TIME)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)

rule "[reinhardt/firestrike.opy]: OW1 Firestrike Damage":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.ABILITY_2

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_REINHARDT_FIRESTRIKE_DAMAGE_VS_ARMOR/OW2_REINHARDT_FIRESTRIKE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_REINHARDT_FIRESTRIKE_DAMAGE/OW2_REINHARDT_FIRESTRIKE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)