#!mainFile "../../main.opy"

#!include "pulse_pistol.opy"


def initTracer():
    @Name "[tracer/init.opy]: initTracer()"

    setCustomHp(OW1_TRACER_HEALTH, 0, 0)
    setUltCost(OW1_TRACER_ULT_COST)
    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)
    



    #removeSelfHealing()

rule "[tracer/init.opy]: Compensate Damage Reduction":
    @Event playerDealtDamage
    @Hero tracer
    @Condition eventAbility in [Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)