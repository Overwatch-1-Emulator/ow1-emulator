#!mainFile "../../dev_main.opy"


# corrects total headshot damage to range [2*ow1_min, 2*ow1_max]
rule "[sojourn/railgun.opy]: OW1 Railgun alt fire headshot damage":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ULTIMATE]
    @Condition eventWasCriticalHit

    damage(victim, attacker, ((eventDamage/eventPlayer._base_damage_scalar)*(OW1_SOJOURN_RAILGUN_ALT_HEADSHOT_MULTIPLIER/OW2_SOJOURN_RAILGUN_ALT_HEADSHOT_MULTIPLIER) - eventDamage)/eventPlayer._base_damage_scalar)
