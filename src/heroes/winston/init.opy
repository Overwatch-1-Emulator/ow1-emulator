#!mainFile "../../dev_main.opy"

#!include "heroes/winston/leap.opy"
#!include "heroes/winston/primal.opy"


def initWinston():
    @Name "[winston/init.opy]: initWinston()"

    setCustomHp(OW1_WINSTON_HEALTH  - (OW2_WINSTON_PRIMAL_HEALTH_BONUS * (OW1_WINSTON_BARRIER_HEALTH/OW2_WINSTON_BARRIER_HEALTH) - OW1_WINSTON_PRIMAL_HEALTH_BONUS), OW1_WINSTON_ARMOR, 0)
    eventPlayer.addHealthPool(Health.NORMAL, (OW2_WINSTON_PRIMAL_HEALTH_BONUS * (OW1_WINSTON_BARRIER_HEALTH/OW2_WINSTON_BARRIER_HEALTH) - OW1_WINSTON_PRIMAL_HEALTH_BONUS), true, true)
    eventPlayer._primal_hp_id = getLastCreatedHealthPool()
    setUltCost(OW1_WINSTON_ULT_COST)

    setBaseDamage(eventPlayer, OW1_WINSTON_TESLA_DAMAGE/OW2_WINSTON_TESLA_DAMAGE)

    removeTankPassive()
    removeSelfHealing()

    eventPlayer.setSecondaryFireEnabled(false) # disable sniper monkey


rule "[winston/init.opy]: Compensate Winston global damage reduction":
    @Event playerDealtDamage
    @Hero winston
    @Condition eventAbility in [Button.ABILITY_1]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
