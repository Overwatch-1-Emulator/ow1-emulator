#!mainFile "../../main.opy"

#!include "hammer.opy"
#!include "firestrike.opy"
#!include "charge.opy"
#!include "shatter.opy"
# !include "barrier.opy"


def initReinhardt():
    @Name "[reinhardt/init.opy]: initReinhardt()"

    setCustomHp(OW1_REINHARDT_HEALTH, OW1_REINHARDT_ARMOR, 0)
    setUltCost(OW1_REINHARDT_ULT_COST)
    setBaseDamage(eventPlayer, 1/OW2_REINHARDT_CHARGE_PIN_DAMAGE)

    #removeSelfHealing()
    # eventPlayer.setKnockbackReceived(percent((100 - OW1_REINHARDT_STEADFAST_KNOCKBACK_REDUCTION_PERCENT)/(100 - OW2_TANK_KNOCKBACK_REDUCTION_PERCENT)))
    # eventPlayer.disallowButton(Button.SECONDARY_FIRE)

rule "[reinhardt/init.opy]: Compensate Damage Reduction":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility == Button.ULTIMATE
    @Condition not eventWasCriticalHit

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)