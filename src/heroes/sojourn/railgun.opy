#!mainFile "../../dev_main.opy"

# Converts ow2 railgun alt damage to ow1 railgun alt damage
# Assume damage scales linearly with rail charge, then use the line from 2 points formula (y-y1) = (y2-y1)/(x2-x1)*(x-x1)
#!define getRailgunAltDamage(d) \
((OW1_SOJOURN_RAILGUN_ALT_DAMAGE_MAX-OW1_SOJOURN_RAILGUN_ALT_DAMAGE_MIN) \
 / (OW2_SOJOURN_RAILGUN_ALT_DAMAGE_MAX-OW2_SOJOURN_RAILGUN_ALT_DAMAGE_MIN) \
 * (d-OW2_SOJOURN_RAILGUN_ALT_DAMAGE_MIN) + OW1_SOJOURN_RAILGUN_ALT_DAMAGE_MIN)


# corrects railgun total bodyshot damage to range [ow1_min, ow1_max]
rule "[sojourn/railgun.opy]: OW1 Railgun alt fire bodyshot damage":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ULTIMATE]
    @Condition not eventWasCriticalHit

    damage(victim, attacker, (getRailgunAltDamage(eventDamage/OW1_SOJOURN_GLOBAL_DAMAGE) - eventDamage)/OW1_SOJOURN_GLOBAL_DAMAGE)
    if (getRailgunAltDamage(eventDamage/OW1_SOJOURN_GLOBAL_DAMAGE) - eventDamage)/OW1_SOJOURN_GLOBAL_DAMAGE < 1:
        heal(victim, null, (eventDamage - getRailgunAltDamage(eventDamage/OW1_SOJOURN_GLOBAL_DAMAGE))/OW1_SOJOURN_GLOBAL_DAMAGE)


# corrects total headshot damage to range [2*ow1_min, 2*ow1_max]
rule "[sojourn/railgun.opy]: OW1 Railgun alt fire headshot damage":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ULTIMATE]
    @Condition eventWasCriticalHit

    damage(victim, attacker, (OW1_SOJOURN_RAILGUN_ALT_HEADSHOT_MULTIPLIER * \
                                getRailgunAltDamage((eventDamage/OW2_SOJOURN_RAILGUN_ALT_HEADSHOT_MULTIPLIER)/OW1_SOJOURN_GLOBAL_DAMAGE)\
                                - eventDamage)/OW1_SOJOURN_GLOBAL_DAMAGE)
    if (OW1_SOJOURN_RAILGUN_ALT_HEADSHOT_MULTIPLIER * \
        getRailgunAltDamage((eventDamage/OW2_SOJOURN_RAILGUN_ALT_HEADSHOT_MULTIPLIER)/OW1_SOJOURN_GLOBAL_DAMAGE)\
        - eventDamage)/OW1_SOJOURN_GLOBAL_DAMAGE < 1:
        heal(victim, null, (eventDamage - OW1_SOJOURN_RAILGUN_ALT_HEADSHOT_MULTIPLIER * \
                            getRailgunAltDamage((eventDamage/OW2_SOJOURN_RAILGUN_ALT_HEADSHOT_MULTIPLIER)/OW1_SOJOURN_GLOBAL_DAMAGE))/OW1_SOJOURN_GLOBAL_DAMAGE)
