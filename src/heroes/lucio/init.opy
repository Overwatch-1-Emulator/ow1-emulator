#!mainFile "../../main.opy"

#!include "crossfade.opy"
#!include "barrier.opy"

playervar test

def initLucio():
    @Name "[lucio/init.opy]: initLucio()"

    setCustomHp(OW1_LUCIO_HEALTH, 0, 0)
    setUltCost(OW1_LUCIO_ULT_COST)

    setBaseDamage(eventPlayer, OW1_LUCIO_SOUNDWAVE_DAMAGE/OW2_LUCIO_SOUNDWAVE_DAMAGE)
    setBaseHealing(eventPlayer, OW1_LUCIO_ALLY_HEALING/OW2_LUCIO_ALLY_HEALING) #IDK if this has the penalty healing i like dont know how to track it
    eventPlayer.setKnockbackDealt(percent(OW1_LUCIO_SOUNDWAVE_KNOCKBACK/OW2_LUCIO_SOUNDWAVE_KNOCKBACK))
    eventPlayer.addHealthPool(Health.SHIELDS, 100, false, false)
    eventPlayer.addHealthPool(Health.ARMOR, 100, false, false)
    eventPlayer.test = getLastCreatedHealthPool()
    print(getTempArmor(eventPlayer))
    print(getTempShields(eventPlayer))


rule "[lucio/init.opy]: OW1 Lucio gun damage":
    @Event playerDealtDamage
    @Hero lucio
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_LUCIO_SOUND_GUN_DAMAGE/OW2_LUCIO_SOUND_GUN_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)

#rule "[lucio/init.opy]: OW1 Soundwave Damage":
#    @Event playerDealtDamage
#    @Hero lucio
#    @Condition eventAbility == Button.SECONDARY_FIRE

#    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_LUCIO_SOUNDWAVE_DAMAGE/OW2_LUCIO_SOUNDWAVE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)

rule "test":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()

    wait(10)
    removeHealthPool(eventPlayer.test)
    print(eventPlayer.getMaxHealth())