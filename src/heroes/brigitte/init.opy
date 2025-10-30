#!mainFile "../../dev_main.opy"

#!include "bash.opy"
# !include "whipshot.opy"
#!include "rally.opy"
# !include "inspire.opy"
# !include "pack.opy"


def initBrigitte():
    @Name "[brigitte/init.opy]: initBrigitte()"
    
    #setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    setUltCost(OW1_BRIGITTE_ULT_COST)

    setBaseDamage(eventPlayer, OW1_BRIGITTE_FLAIL_DAMAGE/OW2_BRIGITTE_FLAIL_DAMAGE)
    #setBaseHealing(eventPlayer, 0.1)


    #removeSelfHealing()


rule "[brigitte/init.opy]: Compensate Brigitte global damage reduction":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility in [Button.ABILITY_1]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[brigitte/init.opy]: Compensate Brigitte 200hp":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) < 200
    #@Condition eventPlayer.isUsingUltimate() == false

    eventPlayer.setDamageReceived(percent(OW2_BRIGITTE_HEALTH/OW1_BRIGITTE_HEALTH))

    waitUntil(eventPlayer.getHealthOfType(Health.NORMAL) > 200)
    eventPlayer.setDamageReceived(100)


