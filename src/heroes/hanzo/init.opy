#!mainFile "../../main.opy"

#!include "storm.opy"


def initHanzo():
    @Name "[hanzo/init.opy]: initHanzo()"

    setCustomHp(OW1_HANZO_HEALTH, 0, 0)
    setUltCost(OW1_HANZO_ULT_COST)
    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)

rule "[hanzo/storm.opy]: Compensate Hanzo global damage reduction":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ULTIMATE]

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
