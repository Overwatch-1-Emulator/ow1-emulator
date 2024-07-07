#!mainFile "../../dev_main.opy"

#!include "heroes/torbjorn/overload.opy"


def initTorbjorn():
    @Name "[torbjorn/init.opy]: initTorbjorn()"

    setCustomHp(OW1_TORBJORN_HEALTH, OW1_TORBJORN_ARMOR, 0)
    setUltCost(OW1_TORBJORN_ULT_COST)
    removeSelfHealing()

    setBaseDamage(eventPlayer, OW1_TORBJORN_TURRET_DAMAGE/OW2_TORBJORN_TURRET_DAMAGE)





rule "[torbjorn/init.opy]: Correct Rivet Gun, Hammer, and ultimate damage":
    @Event playerDealtDamage
    @Hero torbjorn
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
