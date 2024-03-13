#!mainFile "../../main.opy"

#!include "heroes/winston/leap.opy"
#!include "heroes/winston/primal.opy"


rule "[winston/init.opy]: Detect switch to Winston":
    @Event eachPlayer
    @Hero winston

    eventPlayer.call_init = true


rule "[winston/init.opy]: Initialize Winston":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.call_init

    newHero(OW1_WINSTON_HEALTH, OW1_WINSTON_ARMOR, 0)
    setUltCost(OW1_WINSTON_ULT_COST)

    setBaseDamage(eventPlayer, OW1_WINSTON_TESLA_DAMAGE/OW2_WINSTON_TESLA_DAMAGE)

    removeTankPassive()
    removePassiveHealing()

    eventPlayer.setSecondaryFireEnabled(false) # disable sniper monkey

    eventPlayer.call_init = false


rule "[winston/init.opy]: Compensate Winston global damage reduction":
    @Event playerDealtDamage
    @Hero winston
    @Condition eventAbility in [Button.ABILITY_1]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
