#!mainFile "../../main.opy"

#!include "hp.opy"
#!include "gun.opy"
#!include "booster.opy"
#!include "micro_missiles.opy"
#!include "bomb.opy"


def initDva():
    @Name "[dva/init.opy]: initDva()"


    setUltCost(OW1_DVA_ULT_COST)
    setCustomHp(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)

    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)


rule "[dva/init.opy]: Compensate DVa global damage reduction":
    @Event playerDealtDamage
    @Hero dva
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ULTIMATE]

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
