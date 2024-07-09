#!mainFile "../../dev_main.opy"

#!include "heroes/junkrat/trap.opy"


def initJunkrat():
    @Name "[junkrat/init.opy]: initJunkrat()"

    wait() # without this delay, junkrat never gets extra health???
    eventPlayer.addHealthPool(
        Health.NORMAL, 
        OW1_JUNKRAT_HEALTH - (OW1_JUNKRAT_HEALTH-OW1_JUNKRAT_TIRE_HEALTH)/(OW2_JUNKRAT_HEALTH-OW2_JUNKRAT_TIRE_HEALTH)*OW2_JUNKRAT_HEALTH, 
        true, 
        false)
    setUltCost(OW1_JUNKRAT_ULT_COST)
    removeSelfHealing()

    setBaseDamage(eventPlayer, OW1_JUNKRAT_FRAG_DAMAGE/OW2_JUNKRAT_FRAG_DAMAGE)


rule "[junkrat/init.opy]: Correct Mine, Tire damage":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility in [Button.ABILITY_1, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
