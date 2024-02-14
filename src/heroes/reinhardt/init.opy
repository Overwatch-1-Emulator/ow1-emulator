#!mainFile "../../main.opy"

#!include "heroes/reinhardt/firestrike.opy"
#!include "heroes/reinhardt/charge.opy"
#!include "heroes/reinhardt/shatter.opy"


rule "[reinhardt/init.opy]: Detect switch to Reinhardt":
    @Event eachPlayer
    @Hero reinhardt

    eventPlayer.call_init = true


rule "[reinhardt/init.opy]: Initialize Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.call_init

    newHero(OW1_REINHARDT_HEALTH, OW1_REINHARDT_ARMOR, 0)
    setUltCost(OW1_REINHARDT_ULT_COST)
    setBaseDamage(eventPlayer, OW1_REINHARDT_HAMMER_DAMAGE/OW2_REINHARDT_HAMMER_DAMAGE)

    removeSelfHealing()

    eventPlayer.call_init = false


rule "[reinhardt/init.opy]: Compensate Reinhardt global damage reduction":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility in [Button.ABILITY_2]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
