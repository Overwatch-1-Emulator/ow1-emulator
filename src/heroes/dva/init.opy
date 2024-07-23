#!mainFile "../../dev_main.opy"

#!include "heroes/dva/hp.opy"
#!include "heroes/dva/gun.opy"
#!include "heroes/dva/booster.opy"
#!include "heroes/dva/micro_missiles.opy"
#!include "heroes/dva/bomb.opy"


def initDva():
    @Name "[dva/init.opy]: initDva()"
    
    setUltCost(OW1_DVA_ULT_COST)
    removeTankPassive()
    removeSelfHealing()

    # setBaseDamage(eventPlayer, OW1_DVA_MICRO_MISSILES_DAMAGE/OW2_DVA_MICRO_MISSILES_DAMAGE)


# rule "[dva/init.opy]: Compensate D.Va global damage reduction":
#     @Event playerDealtDamage
#     @Hero dva
#     @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ULTIMATE]

#     damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
