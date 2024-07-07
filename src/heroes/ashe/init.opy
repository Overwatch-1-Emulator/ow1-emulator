#!mainFile "../../dev_main.opy"

#!include "heroes/ashe/bob.opy"


def initAshe():
    @Name "[ashe/init.opy]: initAshe()"
    
    setCustomHp(OW1_ASHE_HEALTH, 0, 0)
    setUltCost(OW1_ASHE_ULT_COST)
    setBaseDamage(eventPlayer, OW1_ASHE_BOB_DAMAGE/OW2_ASHE_BOB_DAMAGE)

    removeSelfHealing()


rule "[ashe/init.opy]: Compensate Ashe global damage reduction":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.ABILITY_2]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
