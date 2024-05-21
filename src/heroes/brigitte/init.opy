#!mainFile "../../dev_main.opy"

#!include "heroes/brigitte/bash.opy"
##!include "heroes/brigitte/whipshot.opy"
#!include "heroes/brigitte/rally.opy"
#!include "heroes/brigitte/inspire.opy"


rule "[brigitte/init.opy]: Initialize Brigitte":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.BRIGITTE
    @Condition eventPlayer._call_init

    setBaseHp(eventPlayer, OW1_BRIGITTE_BARRIER_HEALTH/OW2_BRIGITTE_BARRIER_HEALTH) # for barrier hp
    setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    setUltCost(OW1_BRIGITTE_ULT_COST)

    setBaseDamage(eventPlayer, OW1_BRIGITTE_FLAIL_DAMAGE/OW2_BRIGITTE_FLAIL_DAMAGE)

    removeSelfHealing()

    getPlayers(eventPlayer.getTeam())._friendly_brigitte_player = eventPlayer

    eventPlayer._call_init = false


rule "[brigitte/init.opy]: Compensate Brigitte global damage reduction":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility in [Button.ABILITY_1]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
