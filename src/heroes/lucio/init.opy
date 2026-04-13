#!mainFile "../../main.opy"


def initLucio():
    @Name "[lucio/init.opy]: initLucio()"

    setCustomHp(OW1_LUCIO_HEALTH, 0, 0)
    setUltCost(OW1_LUCIO_ULT_COST)

    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)
    setBaseHealing(eventPlayer, OW1_LUCIO_ALLY_HEALING/OW2_LUCIO_ALLY_HEALING)
    eventPlayer.setKnockbackDealt(percent(OW1_LUCIO_SOUNDWAVE_KNOCKBACK/OW2_LUCIO_SOUNDWAVE_KNOCKBACK))


rule "[lucio/init.opy]: OW1 Lucio gun damage":
    @Event playerDealtDamage
    @Hero lucio
    @Condition eventAbility == Button.PRIMARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_LUCIO_SOUND_GUN_DAMAGE_VS_ARMOR/OW2_LUCIO_SOUND_GUN_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_LUCIO_SOUND_GUN_DAMAGE/OW2_LUCIO_SOUND_GUN_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)


rule "[lucio/init.opy]: OW1 Soundwave Damage":
    @Event playerDealtDamage
    @Hero lucio
    @Condition eventAbility == Button.SECONDARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_LUCIO_SOUNDWAVE_DAMAGE_VS_ARMOR/OW2_LUCIO_SOUNDWAVE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_LUCIO_SOUNDWAVE_DAMAGE/OW2_LUCIO_SOUNDWAVE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)