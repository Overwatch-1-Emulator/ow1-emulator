#!mainFile "../../main.opy"

#!include "flashbang.opy"
#!include "roll.opy"
#!include "deadeye.opy"
#!include "peacekeeper.opy"


def initCassidy():
    @Name "[cassidy/init.opy]: initCassidy()"

    setCustomHp(OW1_CASSIDY_HEALTH, 0, 0)
    setUltCost(OW1_CASSIDY_ULT_COST)
    setBaseDamage(eventPlayer, OW1_CASSIDY_FLASHBANG_DAMAGE/OW2_CASSIDY_FLASHBANG_DAMAGE)


rule "[cassidy/flashbang.opy]: Compensate Cassidy global damage reduction":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
