#!mainFile "../../main.opy"

#!include "blade.opy"

def initGenji():
    @Name "[genji/init.opy]: initGenji()"

    setCustomHp(OW1_GENJI_HEALTH, 0, 0)
    setUltCost(OW1_GENJI_ULT_COST)
    eventPlayer.setAmmo(0, OW1_GENJI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_GENJI_CLIP_SIZE)
    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)
    eventPlayer.setProjectileSpeed(percent(OW1_GENJI_PROJECTILE_SPEED/OW2_GENJI_PROJECTILE_SPEED))


rule "[genji/init.opy]: Deal OW1 shuriken damage":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]
    @Condition victim.getHealthOfType(Health.ARMOR) == 0

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)


rule "[genji/init.opy]: Deal OW1 shuriken armor damage":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]
    @Condition victim.getHealthOfType(Health.ARMOR) > 0
    @Condition getTempShields(victim) == 0

    damage(victim, attacker, ow2ArmorRawFor(ow1ArmorApplied(OW1_GENJI_SHURIKEN_DAMAGE * ow2ArmorRawFor(eventDamage)/(OW2_GENJI_SHURIKEN_DAMAGE*eventPlayer._base_damage_scalar)) - eventDamage) / eventPlayer._base_damage_scalar)

rule "[genji/blade.opy]: Compensate Genji global damage reduction":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility in [Button.ULTIMATE, Button.ABILITY_1]
    @Condition victim.getHealthOfType(Health.ARMOR) == 0

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[genji/init.opy]: Compensate Genji armor damage reduction":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility in [Button.ULTIMATE, Button.ABILITY_1]
    @Condition victim.getHealthOfType(Health.ARMOR) > 0
    @Condition getTempShields(victim) == 0

    damage(victim, attacker, ow2ArmorRawFor(ow1ArmorApplied(ow2ArmorRawFor(eventDamage)/eventPlayer._base_damage_scalar) - eventDamage)/eventPlayer._base_damage_scalar)
