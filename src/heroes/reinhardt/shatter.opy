#!mainFile "../../main.opy"

playervar shatter_origin

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

# playerTookDamage, not playerDealtDamage: this rule waits, and a rule can only run once
# at a time per event player. Keyed on Reinhardt, only one of the knocked down players
# would get their knockdown shortened; keyed on the victim, every one of them does.
rule "[reinhardt/shatter.opy]: OW1 earthshatter knock down duration":
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() == Hero.REINHARDT
    @Condition eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN)

    wait(OW1_REINHARDT_EARTHSHATTER_KNOCK_DOWN_DURATION)
    eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)

rule "[reinhardt/shatter.opy]: Get Ow1 earthshatter distance":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingUltimate()

    waitUntil(eventPlayer.isUsingUltimate())
    eventPlayer.shatter_origin = eventPlayer.getPosition()

rule "[reinhardt/shatter.opy]: OW1 earthshatter range":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.ULTIMATE
    @Condition distance(attacker.shatter_origin, victim) > OW1_REINHARDT_EARTHSHATTER_MAX_RANGE

   heal(victim, null, eventDamage)
   victim.clearStatusEffect(Status.KNOCKED_DOWN)