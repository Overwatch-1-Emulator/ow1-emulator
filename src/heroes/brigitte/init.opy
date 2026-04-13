#!mainFile "../../main.opy"

#!include "bash.opy"
#!include "rally.opy"
#!include "flail.opy"
#!include "inspire.opy"


def initBrigitte():
    @Name "[brigitte/init.opy]: initBrigitte()"

    setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    setUltCost(OW1_BRIGITTE_ULT_COST)

    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)

    getPlayers(eventPlayer.getTeam())._friendly_brigitte_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_brigitte_player = eventPlayer



rule "[brigitte/init.opy]: Compensate Brigitte global damage reduction":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.ABILITY_1

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)


rule "[brigitte/init.opy]: Clean up brigitte":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BRIGITTE

    waitUntil(eventPlayer.getCurrentHero() != Hero.BRIGITTE, Math.INFINITY)
    endRally()
