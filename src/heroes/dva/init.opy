#!mainFile "../../dev_main.opy"

#!include "hp.opy"
#!include "gun.opy"
#!include "booster.opy"
#!include "micro_missiles.opy"
#!include "bomb.opy"


def initDva():
    @Name "[dva/init.opy]: initDva()"
    
    setUltCost(OW1_DVA_ULT_COST)
    # removeTankPassive()
    removeSelfHealing()

    waitUntil(not eventPlayer.isInAlternateForm(), Math.INFINITY)
    setCustomHp(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)

    # setBaseDamage(eventPlayer, OW1_DVA_MICRO_MISSILES_DAMAGE/OW2_DVA_MICRO_MISSILES_DAMAGE)


# rule "[dva/init.opy]: Compensate D.Va global damage reduction":
#     @Event playerDealtDamage
#     @Hero dva
#     @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ULTIMATE]

#     damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
