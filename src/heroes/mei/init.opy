#!mainFile "../../main.opy"

#!include "blaster.opy"
#!include "cryo_freeze.opy"


def initMei():
    @Name "[mei/init.opy]: initMei()"

    setCustomHp(OW1_MEI_HEALTH, 0, 0)
    setUltCost(OW1_MEI_ULT_COST)

    setBaseDamage(eventPlayer, OW1_MEI_BLASTER_DAMAGE_RATE/OW2_MEI_BLASTER_DAMAGE_RATE)

    eventPlayer.setAmmo(0, OW1_MEI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MEI_CLIP_SIZE)

rule "[mei/init.opy]: Mei OW1 Icicle damage":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventAbility == Button.SECONDARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_MEI_ICICLE_DAMAGE_VS_ARMOR/OW2_MEI_ICICLE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_MEI_ICICLE_DAMAGE/OW2_MEI_ICICLE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)

rule "[mei/init.opy]: Compensate Damage Reduction":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventAbility == Button.ULTIMATE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)