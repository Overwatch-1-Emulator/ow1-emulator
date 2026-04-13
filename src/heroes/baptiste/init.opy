#!mainFile "../../main.opy"

#!include "regen_burst.opy"
# !include "lamp.opy"


def initBaptiste():
    @Name "[baptiste/init.opy]: initBaptiste()"

    setCustomHp(OW1_BAPTISTE_HEALTH, 0, 0)
    setUltCost(OW1_BAPTISTE_ULT_COST)

    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)

    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)

rule "[baptiste/init.opy]: Compensate Bap global damage reduction":
    @Event playerDealtDamage
    @Hero baptiste
    @Condition eventAbility == Button.PRIMARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)


