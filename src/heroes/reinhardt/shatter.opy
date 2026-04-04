#!mainFile "../../main.opy"

playervar shatter_distance

rule "[reinhardt/shatter.opy]: OW1 one shot earthshatter":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventWasCriticalHit

    damage(
        victim,
        attacker,
        ((eventDamage/eventPlayer._base_damage_scalar) * ((OW1_REINHARDT_EARTHSHATTER_BASE_DAMAGE + OW1_REINHARDT_EARTHSHATTER_BONUS_DAMAGE)
            / (OW2_REINHARDT_EARTHSHATTER_BASE_DAMAGE + OW2_REINHARDT_EARTHSHATTER_BONUS_DAMAGE))
            - eventDamage)/eventPlayer._base_damage_scalar)


rule "[reinhardt/shatter.opy]: OW1 earthshatter knock down duration":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition victim.hasStatusEffect(Status.KNOCKED_DOWN)

    wait(OW1_REINHARDT_EARTHSHATTER_KNOCK_DOWN_DURATION)
    victim.clearStatusEffect(Status.KNOCKED_DOWN)

rule "[reinhardt/shatter.opy]: Get Ow1 earthshatter distance":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.shatter_distance = eventPlayer.getPosition()

rule "[reinhardt/shatter.opy]: OW1 earthshatter range":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventPlayer.isUsingUltimate()
    @Condition distance(eventPlayer.shatter_distance, victim) > OW1_REINHARDT_EARTHSHATTER_MAX_RANGE

   heal(victim, null, eventDamage)
   victim.clearStatusEffect(Status.KNOCKED_DOWN)