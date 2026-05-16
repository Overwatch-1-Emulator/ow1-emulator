#!mainFile "../../main.opy"

#!include "flashbang.opy"
#!include "roll.opy"
#!include "deadeye.opy"
#!include "peacekeeper.opy"


def initMccree():
    @Name "[mccree/init.opy]: initMccree()"

    setCustomHp(OW1_MCCREE_HEALTH, 0, 0)
    setUltCost(OW1_MCCREE_ULT_COST)
    setBaseDamage(eventPlayer, OW1_MCCREE_FLASHBANG_DAMAGE/OW2_MCCREE_FLASHBANG_DAMAGE)


rule "[mccree/flashbang.opy]: Compensate McCree global damage reduction":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
