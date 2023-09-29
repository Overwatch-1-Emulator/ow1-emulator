#!mainFile "../../../main.opy"


rule "[sojourn/init.opy]: Initialize Sojourn":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.call_init

    resetHero()
    eventPlayer.setDamageDealt(OW1_SOJOURN_SAFETY_NET)
    eventPlayer.call_init = false


rule "[sojourn.opy]: apply Sojourn primary fire damage":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(victim, null, eventDamage)
    damage(victim, attacker, (OW1_SOJOURN_PRIMARY_FIRE_DAMAGE*OW1_SOJOURN_SAFETY_NET) if eventWasCriticalHit != true else ((OW1_SOJOURN_PRIMARY_FIRE_DAMAGE*OW1_SOJOURN_CRITICAL_MULTIPLIER)*OW1_SOJOURN_SAFETY_NET))


rule "[sojourn/railgun_primary.opy]: apply Sojourn secondary fire damage":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition eventAbility == Button.SECONDARY_FIRE

    heal(victim, null, eventDamage)
    damage(victim, attacker, (OW1_SOJOURN_SECONDARY_FIRE_DAMAGE*OW1_SOJOURN_SAFETY_NET) if eventWasCriticalHit != true else ((OW1_SOJOURN_SECONDARY_FIRE_DAMAGE*OW1_SOJOURN_CRITICAL_MULTIPLIER)*OW1_SOJOURN_SAFETY_NET))