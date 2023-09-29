#!mainFile "../../../main.opy"


rule "[sojourn/railgun.opy]: apply Sojourn primary fire damage":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(victim, null, eventDamage)
    damage(victim, attacker, (OW1_SOJOURN_PRIMARY_FIRE_DAMAGE*OW1_SOJOURN_CRITICAL_MULTIPLIER)*OW1_SOJOURN_SAFETY_NET \
                             if eventWasCriticalHit \
                             else OW1_SOJOURN_PRIMARY_FIRE_DAMAGE*OW1_SOJOURN_SAFETY_NET)


rule "[sojourn/railgun.opy]: apply Sojourn secondary fire damage":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition eventAbility == Button.SECONDARY_FIRE

    heal(victim, null, eventDamage)
    damage(victim, attacker, (OW1_SOJOURN_SECONDARY_FIRE_DAMAGE*OW1_SOJOURN_CRITICAL_MULTIPLIER)*OW1_SOJOURN_SAFETY_NET \
                             if eventWasCriticalHit \
                             else OW1_SOJOURN_SECONDARY_FIRE_DAMAGE*OW1_SOJOURN_SAFETY_NET)
