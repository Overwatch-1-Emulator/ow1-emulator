#!mainFile "../../main.opy"

#!include "heroes/ashe/bob.opy"

rule "[ashe/init.opy]: Detect switch to Ashe":
    @Event eachPlayer
    @Hero ashe

    eventPlayer.call_init = true


rule "[ashe/init.opy]: Initialize Ashe":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.call_init == true
    
    newHero(OW1_ASHE_HEALTH, 0, 0)
    setUltCost(OW1_ASHE_ULT_COST)
    setBaseDamage(eventPlayer, OW1_ASHE_BOB_DAMAGE/OW2_ASHE_BOB_DAMAGE)

    removeSelfHealing()

    eventPlayer.call_init = false


rule "[ashe/init.opy]: Compensate Ashe global damage reduction":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility in [Button.MELEE, Button.PRIMARY_FIRE, Button.ABILITY_1, Button.ABILITY_2]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
