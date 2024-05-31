#!mainFile "../../dev_main.opy"

#!include "heroes/ashe/coach_gun.opy"
#!include "heroes/ashe/bob.opy"


rule "[ashe/init.opy]: Initialize Ashe":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.ASHE
    @Condition eventPlayer._call_init
    
    setCustomHp(OW1_ASHE_HEALTH, 0, 0)
    setUltCost(OW1_ASHE_ULT_COST)
    setBaseDamage(eventPlayer, OW1_ASHE_BOB_DAMAGE/OW2_ASHE_BOB_DAMAGE)

    removeSelfHealing()

    eventPlayer._call_init = false


rule "[ashe/init.opy]: Compensate Ashe global damage reduction":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.ABILITY_2]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
