#!mainFile "../../main.opy"

#!include "bash.opy"
#!include "rally.opy"
#!include "flail.opy"
#!include "inspire.opy"
#!include "repair_pack.opy"


def initBrigitte():
    @Name "[brigitte/init.opy]: initBrigitte()"

    setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    setUltCost(OW1_BRIGITTE_ULT_COST)

    setBaseDamage(eventPlayer, OW1_BRIGITTE_SHIELD_BASH_DAMAGE/OW2_BRIGITTE_SHIELD_BASH_DAMAGE)
    setBaseHealing(eventPlayer, 0/OW2_BRIGITTE_REPAIR_PACK_HEALING)

    getPlayers(eventPlayer.getTeam())._friendly_brigitte_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_brigitte_player = eventPlayer



rule "[brigitte/init.opy]: Compensate Brigitte global damage reduction":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.ABILITY_1

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)\


rule "[brigitte/init.opy]: Clean up brigitte":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BRIGITTE

    waitUntil(eventPlayer.getCurrentHero() != Hero.BRIGITTE, Math.INFINITY)
    endRally()
