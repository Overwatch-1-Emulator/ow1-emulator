#!mainFile "../../main.opy"

#!include "bash.opy"
#!include "rally.opy"
#!include "flail.opy"
#!include "inspire.opy"


def initBrigitte():
    @Name "[brigitte/init.opy]: initBrigitte()"

    setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    setUltCost(OW1_BRIGITTE_ULT_COST)

    setBaseDamage(eventPlayer, OW1_BRIGITTE_SHIELD_BASH_DAMAGE/OW2_BRIGITTE_SHIELD_BASH_DAMAGE)


    getPlayers(eventPlayer.getTeam())._friendly_brigitte_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_brigitte_player = eventPlayer



rule "[brigitte/init.opy]: Compensate Brigitte global damage reduction":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.ABILITY_1

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)\




