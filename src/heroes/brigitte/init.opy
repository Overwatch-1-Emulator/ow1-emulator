#!mainFile "../../main.opy"

#!include "bash.opy"
#!include "rally.opy"
# !include "whipshot.opy"
#!include "flail.opy"
#!include "inspire.opy"
# !include "pack.opy"


def initBrigitte():
    @Name "[brigitte/init.opy]: initBrigitte()"

    setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    setUltCost(OW1_BRIGITTE_ULT_COST)

    #setBaseDamage(eventPlayer, OW1_BRIGITTE_FLAIL_DAMAGE/OW2_BRIGITTE_FLAIL_DAMAGE)
    setBaseDamage(eventPlayer, OW1_BRIGITTE_SHIELD_BASH_DAMAGE/OW2_BRIGITTE_SHIELD_BASH_DAMAGE)
    # eventPlayer.setDamageReceived(percent((50+OW2_BRIGITTE_HEALTH)/(OW1_BRIGITTE_ARMOR+OW1_BRIGITTE_HEALTH)))
    # eventPlayer.setHealingReceived(percent((50+OW2_BRIGITTE_HEALTH)/(OW1_BRIGITTE_HEALTH)))
    #setBaseHealing(eventPlayer, 0.1)


    getPlayers(eventPlayer.getTeam())._friendly_brigitte_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_brigitte_player = eventPlayer

    #removeSelfHealing()


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