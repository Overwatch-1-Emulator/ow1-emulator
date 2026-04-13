#!mainFile "../../main.opy"

#!include "blade.opy"

def initGenji():
    @Name "[genji/init.opy]: initGenji()"

    setCustomHp(OW1_GENJI_HEALTH, 0, 0)
    setUltCost(OW1_GENJI_ULT_COST)
    eventPlayer.setAmmo(0, OW1_GENJI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_GENJI_CLIP_SIZE)
    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)


rule "[genji/init.opy]: Deal OW1 shuriken damage":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_GENJI_SHURIKEN_DAMAGE_VS_ARMOR/OW2_GENJI_SHURIKEN_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)

rule "[genji/blade.opy]: Compensate Genji global damage reduction":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility in [Button.ULTIMATE, Button.ABILITY_1]

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)