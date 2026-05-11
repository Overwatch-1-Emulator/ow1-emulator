#!mainFile "../../main.opy"

#!include "regen_burst.opy"
# !include "lamp.opy"


def initBaptiste():
    @Name "[baptiste/init.opy]: initBaptiste()"

    setCustomHp(OW1_BAPTISTE_HEALTH, 0, 0)
    setUltCost(OW1_BAPTISTE_ULT_COST)

    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)
    eventPlayer.startScalingSize(MODEL_SIZE_PRE_SEASON_9, true)

    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)

rule "[baptiste/init.opy]: Compensate Bap global damage reduction":
    @Event playerDealtDamage
    @Hero baptiste
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

